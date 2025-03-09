import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class AddCertificateEvent extends Equatable {
  const AddCertificateEvent();

  @override
  List<Object> get props => [];
}

class FetchSkillData extends AddCertificateEvent {
  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
final class UploadCertificateEvent extends AddCertificateEvent {
  final String studentId;
  final String certificateName;
  final File image;
  String? skillType;
  String? skillCategory;
  String? skillTag;

  UploadCertificateEvent({
    required this.studentId,
    required this.certificateName,
    required this.image,
    this.skillType,
    this.skillCategory,
    this.skillTag,
  });
}
