import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';
part 'models.g.dart';


@freezed
class User with _$User {
  factory User({
    int? id,
    String? token,
    required String name,
    required String phone,
    required String email,
    int? subscription_status,
    DateTime? subscription_started_at,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@freezed
class Configs with _$Configs {
  factory Configs({
    required String theme,
  }) = _Configs;

  factory Configs.fromJson(Map<String, dynamic> json) => _$ConfigsFromJson(json);
}
