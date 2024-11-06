import 'package:mind_lab_app/features/user_detail/domain/entities/register_player_entity.dart';

class RegisterPlayerModel extends RegisterPlayerEntity {
  RegisterPlayerModel({
    required super.userId,
    required super.playerId,
    required super.city,
    required super.country,
  });

  RegisterPlayerModel copyWith({
    String? userId,
    String? playerId,
    String? city,
    String? country,
  }) {
    return RegisterPlayerModel(
      userId: userId ?? this.userId,
      playerId: playerId ?? this.playerId,
      city: city ?? this.city,
      country: country ?? this.country,
    );
  }

  factory RegisterPlayerModel.fromJson(Map<String, dynamic> json) {
    return RegisterPlayerModel(
      userId: json["user_id"],
      playerId: json['player_id'],
      city: json["city"],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "user_id": userId,
      "player_id": playerId,
      "city": city,
      "country": country,
    };
  }
}
