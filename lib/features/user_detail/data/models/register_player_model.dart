import 'package:mind_lab_app/features/user_detail/domain/entities/register_player_entity.dart';

class RegisterPlayerModel extends RegisterPlayerEntity {
  RegisterPlayerModel({
    required super.studentId,
    required super.playerId,
    required super.city,
    required super.country,
  });

  RegisterPlayerModel copyWith({
    String? studentId,
    String? playerId,
    String? city,
    String? country,
  }) {
    return RegisterPlayerModel(
      studentId: studentId ?? this.studentId,
      playerId: playerId ?? this.playerId,
      city: city ?? this.city,
      country: country ?? this.country,
    );
  }

  factory RegisterPlayerModel.fromJson(Map<String, dynamic> json) {
    return RegisterPlayerModel(
      studentId: json["student_id"],
      playerId: json['player_id'],
      city: json["city"],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "student_id": studentId,
      "player_id": playerId,
      "city": city,
      "country": country,
    };
  }
}
