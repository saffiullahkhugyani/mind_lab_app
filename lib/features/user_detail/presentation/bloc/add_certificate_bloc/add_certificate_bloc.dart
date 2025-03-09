import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_lab_app/core/usecase/usecase.dart';
import 'package:mind_lab_app/features/user_detail/domain/usecases/get_skill_categories.dart';
import 'package:mind_lab_app/features/user_detail/domain/usecases/get_skill_tags.dart';
import 'package:mind_lab_app/features/user_detail/domain/usecases/get_skills.dart';
import 'package:mind_lab_app/features/user_detail/domain/usecases/upload_certificate.dart';
import 'package:mind_lab_app/features/user_detail/presentation/bloc/add_certificate_bloc/add_certificate_event.dart';
import 'package:mind_lab_app/features/user_detail/presentation/bloc/add_certificate_bloc/add_certificate_state.dart';

class AddCertificateBloc
    extends Bloc<AddCertificateEvent, AddCertificateState> {
  final GetSkills _getSkillTypes;
  final GetSkillHashtags _getSkillTags;
  final GetSkillCategories _getSkillCategories;
  final UploadCertificate _uploadCertificate;

  AddCertificateBloc({
    required GetSkills getSKillTypes,
    required GetSkillHashtags getSkillTags,
    required GetSkillCategories getSkillCategories,
    required UploadCertificate uploadCertificate,
  })  : _getSkillTypes = getSKillTypes,
        _getSkillTags = getSkillTags,
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
    final skillTypes = await _getSkillTypes(NoParams());
    final skillCategories = await _getSkillCategories(NoParams());
    final skillTags = await _getSkillTags(NoParams());

    skillTypes.fold(
      (failure) => emit(SkillDataFailure(failure.errorMessage)),
      (skillTypes) => skillCategories.fold(
        (failure) => emit(SkillDataFailure(failure.errorMessage)),
        (skillCategories) => skillTags.fold(
          (failure) => emit(SkillDataFailure(failure.errorMessage)),
          (skillTags) => emit(
            SkillDataSuccess(
              skillTypes: skillTypes,
              skillCategories: skillCategories,
              skillTags: skillTags,
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
        studentId: event.studentId,
        image: event.image,
        certificateName: event.certificateName,
        skillType: event.skillType,
        skillCategory: event.skillCategory,
        skillTag: event.skillTag,
      ),
    );

    res.fold((failure) => emit(SkillDataFailure(failure.errorMessage)),
        (success) => emit(UploadCertificateSuccess()));
  }
}
