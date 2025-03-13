import 'package:mind_lab_app/features/user_detail/domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  NotificationModel({
    required super.id,
    required super.recipientId,
    required super.notificationType,
    required super.message,
    required super.status,
    required super.createdAt,
    super.senderId,
    super.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      recipientId: json['recipient_id'],
      notificationType: json['notification_type'],
      message: json['message'],
      status: json['status'],
      createdAt: json['created_at'],
      senderId: json['sender_id'] ?? "",
      data: json['data'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'recipient_id': recipientId,
      'sender_id': senderId,
      'notification_type': notificationType,
      'message': message,
      'status': status,
      'data': data,
      'created_at': createdAt,
    };
  }
}
