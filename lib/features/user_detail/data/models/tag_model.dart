import 'package:mind_lab_app/features/user_detail/domain/entities/tag_entity.dart';

class TagModel extends TagEntity {
  TagModel({
    required super.hours,
    required super.tagName,
  });

  factory TagModel.fromJson(Map<String, dynamic> json) {
    try {
      return TagModel(
        hours:
            json["hours"] as int? ?? 0, // Handle potential null with default 0
        tagName: json["tag_name"]?.toString() ??
            '', // Convert to String and handle null
      );
    } catch (e) {
      print('Error parsing TagModel: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
        "hours": hours,
        "tag_name": tagName,
      };
}
