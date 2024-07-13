import 'package:easy_localization/easy_localization.dart';
import 'package:fight_gym/components/dropdown.dart';
import 'package:fight_gym/config/app_config.dart';
import 'package:fight_gym/provider/plan_provider.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import "package:flutter/material.dart";
import 'package:flutter/foundation.dart' show kIsWeb;

part 'models.freezed.dart';
part 'models.g.dart';


@unfreezed
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


@unfreezed
class Customer with _$Customer {
    const Customer._(); // ADD THIS LINE TO ADD NEW METHODS (only work for instance, and you can't pass class as parameter to a function btw.)

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

    getInstanceFromControllers({required Map<String, dynamic> controllerFields}) {
        AppConfig.logger.d("getInstanceFromControllers lajdflajslkdfjalksdfjadf $controllerFields");
        return Customer(
            name: controllerFields["nameController"].text.trim(),
            email: controllerFields["emailController"].text.trim(),
            phone: "phone",
            family_phone: "family_phone",
            address: "address",
            birthday: DateTime.now(),
            enrollment: {
                "plan": int.parse(controllerFields["selectedPlan"].value),
                "subscription_status": 1
            }
        );
    }

    getControllerFields(context) {
        Map controllerFieldsList = {
            "nameController": useTextEditingController(),
            "emailController": useTextEditingController(),
            "selectedPlan":  useState(""),
        };
        return controllerFieldsList;
    }

    getListOfFieldWidgets(context, customDarkThemeStyles, controllerFields) {
        var widgetList = [
            TextField(
                minLines: 1,
                maxLines: null,
                controller: controllerFields["nameController"],
                style: kIsWeb ? Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 19) :
                    Theme.of(context).textTheme.titleMedium,
                decoration: InputDecoration(
                    labelText: tr("Name"),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))
                    ),
                    filled: true,
                    fillColor: customDarkThemeStyles.inputDecorationFillcolor.withOpacity(0.5),
                ),
            ),
            const SizedBox(height: 16.0),
            TextField(
                minLines: 1,
                maxLines: null,
                controller: controllerFields["emailController"],
                decoration: InputDecoration(
                    labelText: tr("Email"),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))
                    ),
                    filled: true,
                    fillColor: customDarkThemeStyles.inputDecorationFillcolor.withOpacity(0.5),
                ),
            ),
            const SizedBox(height: 16.0),
            SelectValueFromProviderListDropdown(
                controllerFields["selectedPlan"],
                asyncPlansProvider,
            ),
            const SizedBox(height: 20.0),
        ];

        return widgetList;
    }

    setControllersData(ref, controllerFields, record) async {
        // if (record.runtimeType == Future<Customer>) // Don't work anymore with new model constructor workaround 
        // to use custom methods. Like this: [const Plan._(); // ADD THIS LINE TO ADD NEW METHODS LIKE getNameField]
        // runtimeType will be _$CustomerImpl or a _Future<Customer>, 
        //this new _Future was hard to check type so I just await both, since it don't raise error.
        record = await record;
        controllerFields["nameController"].text = record.name;
        controllerFields["emailController"].text = record.email;
        controllerFields["selectedPlan"].value = "${record.enrollment['plan']}";
    }
}


@unfreezed
class Plan with _$Plan {
  const Plan._(); // ADD THIS LINE TO ADD NEW METHODS LIKE getNameField

  factory Plan({
    int? id,
    required String plan_name,
    required dynamic price,
    String? description,
  }) = _Plan;

  factory Plan.fromJson(Map<String, dynamic> json) => _$PlanFromJson(json);

  String getNameField() => plan_name;  // Used on SelectValueFromProviderListDropdown
}
