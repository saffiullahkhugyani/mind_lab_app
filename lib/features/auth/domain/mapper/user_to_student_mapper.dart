import 'package:mind_lab_app/core/common/entities/student.dart';

import '../../../../core/common/entities/user.dart';

StudentEntity mapUserToStudent(User user) {
  return StudentEntity(
    id: user.id,
    name: user.name,
    email: user.email,
    gender: user.gender,
    number: user.mobile,
    ageGroup: user.ageGroup,
    nationality: user.nationality,
  );
}
