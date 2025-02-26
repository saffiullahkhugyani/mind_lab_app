import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mind_lab_app/core/usecase/usecase.dart';
import 'package:mind_lab_app/core/common/entities/child_entity.dart';
import 'package:mind_lab_app/features/parent_child/domain/usecases/add_child_usecase.dart';
import 'package:mind_lab_app/features/parent_child/domain/usecases/get_children_usecase.dart';

part 'parent_child_event.dart';
part 'parent_child_state.dart';

class ParentChildBloc extends Bloc<ParentChildEvent, ParentChildState> {
  // Initializations
  final AddChildUseCase _addChild;
  final GetChildrenUsecase _getChildren;

  // Constructor
  ParentChildBloc(
    AddChildUseCase addChild,
    GetChildrenUsecase getChildren,
  )   : _addChild = addChild,
        _getChildren = getChildren,
        super(ParentChildInitial()) {
    on<ParentChildEvent>((_, emit) => emit(ParentChildLoading()));
    on<AddChildEvent>(_onAddChild);
    on<GetChildrenEvent>(_onGetChildren);
  }

  void _onAddChild(AddChildEvent event, Emitter<ParentChildState> emit) async {
    final response = await _addChild(AddChildParams(
      name: event.name,
      email: event.email,
      ageGroup: event.ageGroup,
      gender: event.gender,
      imageFile: event.imageFile,
      nationality: event.nationality,
    ));

    response.fold(
      (failure) {
        emit(ParentChildFailure(failure.errorMessage));
        emit(ParentChildInitial());
      },
      (children) {
        emit(ParentChildSuccess(List.from([children])));
      },
    );
  }

  void _onGetChildren(
      GetChildrenEvent event, Emitter<ParentChildState> emit) async {
    final response = await _getChildren(NoParams());

    response.fold(
      (failure) => emit(ParentChildFailure(failure.errorMessage)),
      (children) => emit(ParentChildSuccess(children)),
    );
  }
}
