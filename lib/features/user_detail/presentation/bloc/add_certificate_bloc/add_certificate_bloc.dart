import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_lab_app/core/usecase/usecase.dart';
import 'package:mind_lab_app/features/user_detail/domain/usecases/get_skill_categories.dart';
import 'package:mind_lab_app/features/user_detail/domain/usecases/get_skill_hashtags.dart';
import 'package:mind_lab_app/features/user_detail/domain/usecases/get_skills.dart';
import 'package:mind_lab_app/features/user_detail/domain/usecases/upload_certificate.dart';
import 'package:mind_lab_app/features/user_detail/presentation/bloc/add_certificate_bloc/add_certificate_event.dart';
import 'package:mind_lab_app/features/user_detail/presentation/bloc/add_certificate_bloc/add_certificate_state.dart';

class AddCertificateBloc
    extends Bloc<AddCertificateEvent, AddCertificateState> {
  final GetSkills _getSkills;
  final GetSkillHashtags _getSkillHashtags;
  final GetSkillCategories _getSkillCategories;
  final UploadCertificate _uploadCertificate;

  AddCertificateBloc({
    required GetSkills getSKills,
    required GetSkillHashtags getSkillHashtags,
    required GetSkillCategories getSkillCategories,
    required UploadCertificate uploadCertificate,
  })  : _getSkills = getSKills,
        _getSkillHashtags = getSkillHashtags,
        _getSkillCategories = getSkillCategories,
        _uploadCertificate = uploadCertificate,
        super(InitialState()) {
    on<AddCertificateEvent>(
      (event, emit) => emit(
        SkillDataLoading(),
      ),
    );
    on<FetchSkillData>(_onFetchSkillData);
    on<UploadCertificateEvent>(_onUploadCertificate);
  }

  void _onFetchSkillData(
    FetchSkillData event,
    Emitter<AddCertificateState> emit,
  ) async {
    final skills = await _getSkills(NoParams());
    final skillHashtags = await _getSkillHashtags(NoParams());
    final skillCategories = await _getSkillCategories(NoParams());

    skills.fold(
      (failure) => emit(SkillDataFailure(failure.errorMessage)),
      (skills) => skillHashtags.fold(
        (failure) => emit(SkillDataFailure(failure.errorMessage)),
        (skillHashtags) => skillCategories.fold(
          (failure) => emit(SkillDataFailure(failure.errorMessage)),
          (categories) => emit(
            SkillDataSuccess(
              skills: skills,
              skillHashtags: skillHashtags,
              skillCategories: categories,
            ),
          ),
        ),
      ),
    );
  }

  void _onUploadCertificate(
      UploadCertificateEvent event, Emitter<AddCertificateState> emit) async {
    final res = await _uploadCertificate(
      UploadCertificateParms(
        userId: event.userId,
        skillId: event.skillId,
        image: event.image,
      ),
    );

    res.fold((failure) => emit(SkillDataFailure(failure.errorMessage)),
        (success) => emit(UploadCertificateSuccess()));
  }
}
