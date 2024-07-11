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

final class UploadCertificateEvent extends AddCertificateEvent {
  final String userId;
  final String skillId;
  final File image;

  const UploadCertificateEvent({
    required this.userId,
    required this.skillId,
    required this.image,
  });
}
