class ParentChildRelationshipEntity {
  final String parentId;
  final String childId;
  final bool isParentRequestApproved;

  ParentChildRelationshipEntity({
    required this.parentId,
    required this.childId,
    required this.isParentRequestApproved,
  });
}
