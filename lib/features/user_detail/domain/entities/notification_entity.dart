class NotificationEntity {
  final String id;
  final String recipientId;
  final String? senderId;
  final String notificationType;
  final String message;
  final String status;
  final Map<String, dynamic>? data;
  final DateTime createdAt;

  NotificationEntity({
    required this.id,
    required this.recipientId,
    this.senderId,
    required this.notificationType,
    required this.message,
    required this.status,
    this.data,
    required this.createdAt,
  });
}
