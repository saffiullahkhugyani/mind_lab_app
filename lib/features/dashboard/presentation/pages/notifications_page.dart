import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_lab_app/core/common/cubits/app_student/app_student_cubit.dart';
import 'package:mind_lab_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:mind_lab_app/core/common/widgets/loader.dart';
import 'package:mind_lab_app/core/utils/show_snackbar.dart';
import 'package:mind_lab_app/features/dashboard/presentation/bloc/notificaions_bloc/notifications_bloc.dart';

import '../../../../core/widgets/show_dialog.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  String? studentId;
  String? studentProfileId;

  void handleOnTapNotification(NotificationEntity notificationEntity) {
    switch (notificationEntity.notificationType) {
      case "parent_request":
        allowAccess(context, notificationEntity);
        break;
      case "event_update":
        log('event update');
        break;
      case "system_alert":
        log('system alert');
        break;
    }
  }

  Future<void> allowAccess(
      BuildContext context, NotificationEntity entity) async {
    final action = await Dialogs.yesAbortDialog(
      context,
      "Parent request access",
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
              studentProfileId!,
            ),
          );
    }
  }

  @override
  void initState() {
    super.initState();
    // student id
    studentId = (context.read<AppStudentCubit>().state as AppStudentSelected)
        .student
        .id;

    // student profile id
    studentProfileId =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
  }

  @override
  Widget build(BuildContext context) {
    final List<NotificationEntity> notificationsList = ModalRoute.of(context)!
            .settings
            .arguments as List<NotificationEntity>? ??
        [];

    // Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text("Notifications"),
        ),
        body: BlocConsumer<NotificationsBloc, NotificationsState>(
          listener: (context, state) {
            if (state is NotificationsFailure) {
              showFlashBar(
                context,
                state.error,
                FlashBarAction.info,
              );
            }

            if (state is ParentChildAccessSuccess) {
              showFlashBar(
                context,
                'Access Granted',
                FlashBarAction.success,
              );
            }
          },
          builder: (context, state) {
            if (state is NotificationsLoading) {
              return const Loader();
            }

            if (notificationsList.isEmpty) {
              return Center(
                child: Text(
                  'No notificaions.',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              );
            }
            return ListView.builder(
              padding: EdgeInsets.all(5),
              itemCount: notificationsList.length,
              itemBuilder: (context, index) {
                final notification = notificationsList[index];
                return Card(
                  color: (notification.status == "read" ||
                          notification.status == "accepted" ||
                          notification.status == "rejected")
                      ? Colors.white
                      : Colors.grey[200],
                  child: ListTile(
                    contentPadding: EdgeInsets.all(4),
                    trailing: Icon(Icons.arrow_forward_ios),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue[400],
                      child: Icon(
                        color: Colors.white,
                        Icons.notifications,
                        size: 20,
                      ),
                    ),
                    title: notification.notificationType == "parent_request"
                        ? Text(
                            'Parent access request',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          )
                        : Text(
                            "General notificaiton",
                          ),
                    subtitle: notification.notificationType == "parent_request"
                        ? Text(
                            '${notification.senderDetails!.name} requested to add you as their child',
                          )
                        : Text(
                            '${notification.senderDetails!.name} accepted your access request'),
                    onTap: () {
                      handleOnTapNotification(notification);
                    },
                  ),
                );
              },
            );
          },
        ));
  }
}
