import 'package:mind_lab_app/features/user_detail/domain/entities/register_player_entity.dart';

class RegisterPlayerModel extends RegisterPlayerEntity {
  RegisterPlayerModel({
    required super.childId,
    required super.playerId,
    required super.city,
    required super.country,
  });

  RegisterPlayerModel copyWith({
    int? childId,
    String? playerId,
    String? city,
    String? country,
  }) {
    return RegisterPlayerModel(
      childId: childId ?? this.childId,
      playerId: playerId ?? this.playerId,
      city: city ?? this.city,
      country: country ?? this.country,
    );
  }

  factory RegisterPlayerModel.fromJson(Map<String, dynamic> json) {
    return RegisterPlayerModel(
      childId: json["student_id"],
      playerId: json['player_id'],
      city: json["city"],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "student_id": childId,
      "player_id": playerId,
      "city": city,
      "country": country,
    };
  }
}
