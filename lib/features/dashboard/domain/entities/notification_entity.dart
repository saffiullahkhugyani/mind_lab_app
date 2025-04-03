import 'package:mind_lab_app/core/common/entities/user.dart';

class NotificationEntity {
  final int id;
  final String recipientId;
  final String? senderId;
  final String notificationType;
  final String message;
  final String status;
  final String? data;
  final String createdAt;
  final User? senderDetails;

  NotificationEntity(
      {required this.id,
      required this.recipientId,
      this.senderId,
      required this.notificationType,
      required this.message,
      required this.status,
      this.data,
      required this.createdAt,
      this.senderDetails});
}
