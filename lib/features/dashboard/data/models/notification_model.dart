import 'package:mind_lab_app/features/dashboard/domain/entities/notification_entity.dart';

import 'user_model.dart';

class NotificationModel extends NotificationEntity {
  // final UserModel? senderDetails; // Optional sender details
  NotificationModel({
    required super.id,
    required super.recipientId,
    required super.notificationType,
    required super.message,
    required super.status,
    required super.createdAt,
    super.senderId,
    super.data,
    super.senderDetails,
  });

  NotificationModel copyWith({
    int? id,
    String? recipientId,
    String? senderId,
    String? notificationType,
    String? message,
    String? status,
    String? data,
    String? createdAt,
    UserModel? senderDetails,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      recipientId: recipientId ?? this.recipientId,
      notificationType: notificationType ?? this.notificationType,
      message: message ?? this.message,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      data: data ?? this.data,
      senderId: senderId ?? this.senderId,
      senderDetails: senderDetails ?? this.senderDetails,
    );
  }

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
      senderDetails: json['sender_details'] != null
          ? UserModel.fromJson(json['sender_details'])
          : null, // Parse sender details if available
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
      'sender_details': senderDetails != null
          ? (senderDetails as UserModel).toJson()
          : null, // Convert only if senderDetails is UserModel
    };
  }
}
