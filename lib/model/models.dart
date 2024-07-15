import 'package:easy_localization/easy_localization.dart';
import 'package:fight_gym/components/dropdown.dart';
import 'package:fight_gym/provider/modules/plan_provider.dart';
import 'package:fight_gym/utils/utils.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
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

    String getNameField() => name;

    // 💀💀💀 For some crazy reason if I define the controllerFields parameter like this:
    // ```getInstanceFromControllers({required Map<String, dynamic> controllerFields}) {```
    // and call it like this:
    // ```// var newRecord = fodderRecordObj.getInstanceFromControllers(controllerFields);```
    // it throws `NoSuchMethodError: 'getInstanceFromControllers' instead of something else`

    getInstanceFromControllers(controllerFields) {
        return Customer(
            name: controllerFields["nameController"].text.trim(),
            email: controllerFields["emailController"].text.trim(),
            phone: controllerFields["phoneController"].text.trim(),
            family_phone: controllerFields["familyPhoneController"].text.trim(),
            address: controllerFields["addressController"].text.trim(),
            birthday: controllerFields["dateISOStringController"].text.isNotEmpty ? DateTime.parse(controllerFields["dateISOStringController"].text) : null,
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
            "phoneController": useTextEditingController(),
            "familyPhoneController": useTextEditingController(),
            "addressController": useTextEditingController(),
            "birthdayController": useTextEditingController(),
            "dateISOStringController": useTextEditingController(),
            "selectedPlan":  useState(""),
        };
        return controllerFieldsList;
    }

    getListOfFieldWidgets(context, ref, customDarkThemeStyles, controllerFields) {
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
                style: kIsWeb ? Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 19) :
                    Theme.of(context).textTheme.titleMedium,
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
            TextField(
                minLines: 1,
                maxLines: null,
                controller: controllerFields["phoneController"],
                style: kIsWeb ? Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 19) :
                    Theme.of(context).textTheme.titleMedium,
                decoration: InputDecoration(
                    labelText: tr("Phone"),
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
                controller: controllerFields["familyPhoneController"],
                style: kIsWeb ? Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 19) :
                    Theme.of(context).textTheme.titleMedium,
                decoration: InputDecoration(
                    labelText: tr("Family Phone"),
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
                controller: controllerFields["addressController"],
                style: kIsWeb ? Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 19) :
                    Theme.of(context).textTheme.titleMedium,
                decoration: InputDecoration(
                    labelText: tr("Address"),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))
                    ),
                    filled: true,
                    fillColor: customDarkThemeStyles.inputDecorationFillcolor.withOpacity(0.5),
                ),
            ),
            const SizedBox(height: 16.0),
            TextField(
                controller: controllerFields["birthdayController"],
                readOnly: true,
                onTap:(){
                    selectAndSetDateToControlers(
                        context,
                        ref,
                        controllerFields["birthdayController"],
                        controllerFields["dateISOStringController"]
                    );
                },
                style: kIsWeb ? Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 19) :
                    Theme.of(context).textTheme.titleMedium,
                decoration: InputDecoration(
                    labelText: tr("Birthday"),
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))
                    ),
                    filled: true,
                    fillColor: customDarkThemeStyles.inputDecorationFillcolor.withOpacity(0.5),
                    suffixIcon: IconButton(
                        onPressed: (){
                            controllerFields["birthdayController"].clear();
                            controllerFields["dateISOStringController"].clear();
                        },
                        icon: const Icon(Icons.clear),
                    ),
                ),
            ),
            const SizedBox(height: 16.0),
            SelectValueFromProviderListDropdown(
                "Plan",
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
        controllerFields["phoneController"].text = record.phone;
        controllerFields["familyPhoneController"].text = record.family_phone;
        controllerFields["addressController"].text = record.address;
        setDateControllersInitialValue(
            ref,
            record.birthday,
            controllerFields["birthdayController"],
            controllerFields["dateISOStringController"],
        );
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

    String getNameField() => plan_name;

    getInstanceFromControllers(controllerFields) {
        return Plan(
            plan_name: controllerFields["planNameController"].text.trim(),
            price: controllerFields["priceController"].text.trim(),
            description: controllerFields["descriptionController"].text.trim(),
        );
    }

    getControllerFields(context) {
        Map controllerFieldsList = {
            "planNameController": useTextEditingController(),
            "priceController": useTextEditingController(),
            "descriptionController":  useTextEditingController(),
        };
        return controllerFieldsList;
    }

    getListOfFieldWidgets(context, ref, customDarkThemeStyles, controllerFields) {
        var widgetList = [
            TextField(
                minLines: 1,
                maxLines: null,
                controller: controllerFields["planNameController"],
                style: kIsWeb ? Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 19) :
                    Theme.of(context).textTheme.titleMedium,
                decoration: InputDecoration(
                    labelText: tr("Plan name"),
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
                controller: controllerFields["priceController"],
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                // inputFormatters: [
                    // WhitelistingTextInputFormatter.digitsOnly,
                    // CurrencyInputFormatter()
                // ],
                style: kIsWeb ? Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 19) :
                    Theme.of(context).textTheme.titleMedium,
                decoration: InputDecoration(
                    labelText: tr("Price"),
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
                controller: controllerFields["descriptionController"],
                style: kIsWeb ? Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 19) :
                    Theme.of(context).textTheme.titleMedium,
                decoration: InputDecoration(
                    labelText: tr("Description"),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))
                    ),
                    filled: true,
                    fillColor: customDarkThemeStyles.inputDecorationFillcolor.withOpacity(0.5),
                ),
            ),
            const SizedBox(height: 20.0),
        ];

        return widgetList;
    }

    setControllersData(ref, controllerFields, record) async {
        record = await record;
        controllerFields["planNameController"].text = record.plan_name;
        controllerFields["priceController"].text = record.price;
        controllerFields["descriptionController"].text = record.description;
    }
}

@unfreezed
class Modality with _$Modality {
    const Modality._(); // ADD THIS LINE TO ADD NEW METHODS LIKE getNameField

    factory Modality({
        int? id,
        required String name,
        String? description,
    }) = _Modality;

    factory Modality.fromJson(Map<String, dynamic> json) => _$ModalityFromJson(json);

    String getNameField() => name;

    getInstanceFromControllers(controllerFields) {
        return Modality(
            name: controllerFields["nameController"].text.trim(),
            description: controllerFields["descriptionController"].text.trim(),
        );
    }

    getControllerFields(context) {
        Map controllerFieldsList = {
            "nameController": useTextEditingController(),
            "descriptionController":  useTextEditingController(),
        };
        return controllerFieldsList;
    }

    getListOfFieldWidgets(context, ref, customDarkThemeStyles, controllerFields) {
        var widgetList = [
            TextField(
                minLines: 1,
                maxLines: null,
                controller: controllerFields["nameController"],
                style: kIsWeb ? Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 19) :
                    Theme.of(context).textTheme.titleMedium,
                decoration: InputDecoration(
                    labelText: tr("Modality name"),
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
                controller: controllerFields["descriptionController"],
                style: kIsWeb ? Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 19) :
                    Theme.of(context).textTheme.titleMedium,
                decoration: InputDecoration(
                    labelText: tr("Description"),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))
                    ),
                    filled: true,
                    fillColor: customDarkThemeStyles.inputDecorationFillcolor.withOpacity(0.5),
                ),
            ),
            const SizedBox(height: 20.0),
        ];

        return widgetList;
    }

    setControllersData(ref, controllerFields, record) async {
        record = await record;
        controllerFields["nameController"].text = record.name;
        controllerFields["descriptionController"].text = record.description;
    }
}
