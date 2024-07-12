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


@freezed
class Customer with _$Customer {
  factory Customer({
    int? id,
    required String name,
    String? email,
    String? phone,
    String? family_phone,
    String? address,
    DateTime? birthday,
    required Map enrollment,
  }) = _Customer;

  factory Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);
}


@freezed
class Plan with _$Plan {
  factory Plan({
    int? id,
    required String plan_name,
    required dynamic price,
    String? description,
  }) = _Plan;

  const Plan._(); // ADD THIS LINE TO ADD NEW METHODS LIKE getNameField
  String getNameField() => plan_name;  // Used on SelectValueFromProviderListDropdown

  factory Plan.fromJson(Map<String, dynamic> json) => _$PlanFromJson(json);
}
