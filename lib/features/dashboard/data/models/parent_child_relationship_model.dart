import '../../domain/entities/parent_child_relationship_entity.dart';

class ParentChildRelationshipModel extends ParentChildRelationshipEntity {
  ParentChildRelationshipModel({
    required super.parentId,
    required super.childId,
    required super.isParentRequestApproved,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'parent_id': parentId,
      'child_id': childId,
      'is_parent_request_apprved': isParentRequestApproved,
    };
  }

  factory ParentChildRelationshipModel.fromJson(Map<String, dynamic> json) {
    return ParentChildRelationshipModel(
      parentId: json['parent_id'] ?? '',
      childId: json['child_id'] ?? '',
      isParentRequestApproved: json['is_parent_request_approved'] ?? '',
    );
  }
}
