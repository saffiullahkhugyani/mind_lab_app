import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mind_lab_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:mind_lab_app/core/common/widgets/loader.dart';
import 'package:mind_lab_app/core/constants/routes.dart';
import 'package:mind_lab_app/core/utils/show_snackbar.dart';
import 'package:mind_lab_app/core/widgets/app_upgrader_dialog.dart';
import 'package:mind_lab_app/features/dashboard/presentation/bloc/notificaions_bloc/notifications_bloc.dart';
import 'package:mind_lab_app/features/dashboard/presentation/bloc/project_bloc/project_bloc.dart';
import 'package:mind_lab_app/features/dashboard/presentation/widgets/card_item.dart';
import 'package:mind_lab_app/features/project_list/presentation/pages/project_list_page.dart';
import 'package:mind_lab_app/features/user_detail/presentation/pages/user_detail_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/common/cubits/app_student/app_student_cubit.dart';
import '../../../../core/widgets/show_dialog.dart';
import '../../domain/entities/notification_entity.dart';

final listProjectImages = [
  {"id": 1, "image_asset": 'lib/assets/images/rashid_rover.png'},
  {"id": 2, "image_asset": 'lib/assets/images/modish.png'},
  {"id": 3, "image_asset": 'lib/assets/images/mecanum_car.png'},
  {"id": 4, "image_asset": 'lib/assets/images/battle_bot.png'},
  {"id": 5, "image_asset": 'lib/assets/images/airplane.png'},
  {"id": 6, "image_asset": 'lib/assets/images/rocket.png'},
  {"id": 7, "image_asset": 'lib/assets/icons/car.png'},
];

final listProjectIcons = [
  {"id": 1, "image_asset": 'lib/assets/icons/moon-rover.png'},
  {"id": 2, "image_asset": 'lib/assets/icons/robot.png'},
  {"id": 3, "image_asset": 'lib/assets/icons/car.png'},
  {"id": 4, "image_asset": 'lib/assets/icons/bot.png'},
  {"id": 5, "image_asset": 'lib/assets/icons/aircraft.png'},
  {"id": 6, "image_asset": 'lib/assets/images/rocket.png'},
];

class ProjectPage extends StatefulWidget {
  const ProjectPage({super.key});

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  int? roleId;
  List<NotificationEntity>? notifications;
  String? profileId;
  String? studentId;

  final _upgrader = AppUpgrader(
    debugLogging: true,
    durationUntilAlertAgain: const Duration(
      hours: 3,
    ),
  );

  Future<void> _siOutDialog(BuildContext context) async {
    final action = await Dialogs.yesAbortDialog(
      context,
      "Sign out",
      "Are you sure you want to Sign out you account?",
      abortBtnText: "Cancel",
      yesButtonText: "Sign out",
      icon: Icons.logout,
    );
    if (context.mounted) {
      _signOut(action);
    }
  }

  Future<void> _allowParentAccessDialog(
      BuildContext context, NotificationEntity entity) async {
    final action = await Dialogs.yesAbortDialog(
      context,
      "Guardian request access",
      "Do you want to allow ${entity.senderDetails?.name} for parent access.",
      abortBtnText: "Decline",
      yesButtonText: "Approve",
      icon: Icons.notifications_active,
    );
    if (context.mounted) {
      _handleAllowRequest(context, action, entity);
    }
  }

  void _handleAllowRequest(
      BuildContext context, DialogAction action, NotificationEntity entity) {
    if (action == DialogAction.yes) {
      context.read<NotificationsBloc>().add(
            AllowParentAccess(
              entity.id,
              entity.senderId!,
              studentId!,
              profileId!,
            ),
          );
    }

    if (action == DialogAction.abort) {
      context
          .read<NotificationsBloc>()
          .add(ReadNotificationEvent(entity.id, profileId!));
    }
  }

  Future<void> _signOut(DialogAction dialogAction) async {
    if (dialogAction == DialogAction.yes) {
      try {
        final supabase = Supabase.instance.client;
        await supabase.auth.signOut();
        await GoogleSignIn().signOut();
        // showFlashBar(
        //   context,
        //   "Logged out",
        //   FlashBarAction.info,
        // );
      } on AuthException catch (error) {
        showFlashBar(
          context,
          error.message,
          FlashBarAction.error,
        );
      } catch (error) {
        showFlashBar(
          context,
          error.toString(),
          FlashBarAction.error,
        );
      } finally {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed(loginRoute);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    profileId = (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
    studentId = (context.read<AppStudentCubit>().state as AppStudentSelected)
        .student
        .id;
    roleId =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user.roleId;
    context.read<ProjectBloc>().add(ProjectFetchAllProjects());
    context.read<NotificationsBloc>().add(GetNotifications(userId: profileId!));
    log("roleId $roleId");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          if (roleId == 4 || roleId == 1 || roleId == 6)
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, notificationsRoute,
                    arguments: notifications);
              },
              icon: Badge(
                isLabelVisible: true,
                offset: const Offset(8, 8),
                backgroundColor: Theme.of(context).colorScheme.error,
                child: const Icon(
                  Icons.notifications_outlined,
                ),
              ),
            ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const UserDetailPage(),
                ),
              );
            },
            icon: const Icon(
              IconlyLight.profile,
            ),
          ),
          IconButton(
            onPressed: () {
              _siOutDialog(context);
            },
            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          profileId =
              (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
          context.read<ProjectBloc>().add(ProjectFetchAllProjects());
          context
              .read<NotificationsBloc>()
              .add(GetNotifications(userId: profileId!));
        },
        child: AppUpgraderDialog(
          upgrader: _upgrader,
          child: MultiBlocListener(
              listeners: [
                BlocListener<ProjectBloc, ProjectState>(
                  listener: (context, state) {
                    if (state is ProjectFailure) {
                      showFlashBar(
                        context,
                        state.error,
                        FlashBarAction.error,
                      );
                    }
                  },
                ),
                BlocListener<NotificationsBloc, NotificationsState>(
                  listener: (context, state) {
                    log("Notification state: $state");
                    if (state is NotificationsListSuccess) {
                      notifications = state.notifications;

                      final List<NotificationEntity> filteredNotification =
                          notifications!
                              .where((notification) =>
                                  notification.notificationType ==
                                      'parent_request' &&
                                  notification.status == 'pending')
                              .toList();

                      if (filteredNotification.isNotEmpty) {
                        for (var entity in filteredNotification) {
                          _allowParentAccessDialog(context, entity);
                        }
                      }
                    }

                    if (state is ParentChildAccessSuccess) {
                      showFlashBar(
                        context,
                        "Access granted",
                        FlashBarAction.success,
                      );
                    }

                    if (state is NotificationsFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Failed to load notifications"),
                      ));
                    }

                    if (state is ReadNotificationSuccess) {
                      if (state.notification.status == 'read' &&
                          state.notification.notificationType ==
                              'parent_request') {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Parent request has been declined'),
                        ));
                      }
                    }
                  },
                ),
              ],
              child: BlocBuilder<ProjectBloc, ProjectState>(
                builder: (context, state) {
                  if (state is ProjectLoading || state is ProjectInitial) {
                    return const Loader();
                  }

                  if (state is ProjectDisplaySuccess) {
                    return GridView.builder(
                      padding: const EdgeInsets.only(top: 20),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: (MediaQuery.of(context).orientation ==
                                  Orientation.portrait)
                              ? 2
                              : 3),
                      itemCount: state.projectList.length,
                      itemBuilder: (BuildContext context, index) {
                        final project = state.projectList[index];
                        final subscribedProjects = state.subscribedProjectList;
                        final imageAsset = listProjectImages.firstWhere(
                            (element) => element['id'] == project.id);

                        bool isSubscribed = subscribedProjects.any(
                            (subscribedProject) =>
                                subscribedProject.project.id == project.id);

                        if (project.id == 1) {
                          isSubscribed = true;
                        }

                        return CardItem(
                            color: isSubscribed
                                ? Colors.grey.withValues(alpha: 0.3)
                                : Colors.grey.withValues(alpha: 0.1),
                            elevation: isSubscribed ? 2 : 0,
                            text: project.name,
                            image: imageAsset['image_asset'].toString(),
                            onTap: () {
                              if (isSubscribed) {
                                switch (project.id) {
                                  case 1:
                                    Navigator.pushNamed(
                                        context, roverMainPageRoute);
                                    break;
                                  case 7:
                                    Navigator.pushNamed(
                                        context, arcadeGameOneRoute);
                                    break;
                                }
                              } else {
                                // showFlushBar(context, 'Feature Coming soon',
                                //     FlushBarAction.info);
                                showFlashBar(context, "Feature Coming soon",
                                    FlashBarAction.info);
                              }
                            });
                      },
                    );
                  }

                  return const Center(
                    child: Text("To get access, Please subscribe to a project"),
                  );
                },
              )),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
              icon: const Icon(CupertinoIcons.line_horizontal_3),
              heroTag: 'herotag3',
              onPressed: () {
                Navigator.pushNamed(context, myIdRoute);
              },
              label: const Text('My Id')),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton.extended(
              icon: const Icon(CupertinoIcons.add),
              heroTag: 'herotag1',
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ProjectListPage()));
              },
              label: const Text('Request Project')),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton.extended(
              icon: const Icon(CupertinoIcons.doc),
              heroTag: 'herotag2',
              onPressed: () {
                // Navigator.of(context).push(MaterialPageRoute(
                //     builder: (context) => const ProjectListPage()));

                Navigator.pushNamed(context, addCertificateRoute);
              },
              label: const Text('Upload Certificate')),
        ],
      ),
    );
  }
}
