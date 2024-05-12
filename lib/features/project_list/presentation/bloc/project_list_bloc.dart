import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mind_lab_app/core/usecase/usecase.dart';
import 'package:mind_lab_app/features/project_list/domain/entities/projet_list_entity.dart';
import 'package:mind_lab_app/features/project_list/domain/usecases/get_available_project_list.dart';
import 'package:mind_lab_app/features/project_list/domain/usecases/subscription_request.dart';

part 'project_list_event.dart';
part 'project_list_state.dart';

class ProjectListBloc extends Bloc<ProjectListEvent, ProjectListState> {
  final GetAvailableProjectList _getAvailableProjectList;
  final SubscriptionRequest _subscriptionRequest;
  ProjectListBloc(
      {required GetAvailableProjectList getAvailableProjectList,
      required SubscriptionRequest subscriptionRequest})
      : _getAvailableProjectList = getAvailableProjectList,
        _subscriptionRequest = subscriptionRequest,
        super(ProjectListInitial()) {
    on<ProjectListEvent>((event, emit) => emit(ProjectListLoading()));
    on<ProjectListFetechAllAvailableProjects>(_onFetchAvailablrProjects);
    on<SubscriptionRequestEvent>(_onSubscriptionRequestEvent);
  }

  void _onSubscriptionRequestEvent(
      SubscriptionRequestEvent event, Emitter<ProjectListState> emit) async {
    final res = await _subscriptionRequest(SubscriptionRequestParams(
      userId: event.userId,
      projectId: event.projectId,
      subscriptionStatus: event.subscriptionStatus,
    ));

    res.fold(
      (failure) => emit(ProjectListFailure(failure.errorMessage)),
      (requestSuccess) => emit(ProjectSubscriptionSuccess()),
    );
  }

  void _onFetchAvailablrProjects(ProjectListFetechAllAvailableProjects event,
      Emitter<ProjectListState> emit) async {
    final res = await _getAvailableProjectList(NoParams());

    res.fold(
      (failure) => emit(ProjectListFailure(failure.errorMessage)),
      (availableProjects) => emit(ProjectListDisplaySuccess(availableProjects)),
    );
  }
}
