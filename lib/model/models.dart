import 'package:easy_localization/easy_localization.dart';
import 'package:fight_gym/components/dropdown.dart';
import 'package:fight_gym/config/app_config.dart';
import 'package:fight_gym/constants/constants.dart';
import 'package:fight_gym/provider/modules/class_provider.dart';
import 'package:fight_gym/provider/modules/customer_provider.dart';
import 'package:fight_gym/provider/modules/modality_provider.dart';
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

    getControllerFields(context) {
        try {
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
        } catch (err, stack) {
            AppConfig.logger.d("Unknown Error: $err");
            AppConfig.logger.d("Unknown Error: stack $stack");
            rethrow;
        }
    }

    setControllersData(ref, controllerFields, record) async {
        try {
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
            setDateTimeControllersInitialValue(
                ref,
                record.birthday,
                controllerFields["birthdayController"],
                controllerFields["dateISOStringController"],
            );
            controllerFields["selectedPlan"].value = "${record.enrollment['plan']}";
        } catch (err, stack) {
            AppConfig.logger.d("Unknown Error: $err");
            AppConfig.logger.d("Unknown Error: stack $stack");
            rethrow;
        }
    }

    getListOfFieldWidgets(context, ref, customDarkThemeStyles, controllerFields) {
        try {
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
                        selectAndSetDateTimeToControlers(
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
        } catch (err, stack) {
            AppConfig.logger.d("Unknown Error: $err");
            AppConfig.logger.d("Unknown Error: stack $stack");
            rethrow;
        }
    }

    getInstanceFromControllers(ref, controllerFields) async {
        try {
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
        } catch (err, stack) {
            AppConfig.logger.d("Unknown Error: $err");
            AppConfig.logger.d("Unknown Error: stack $stack");
            rethrow;
        }
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

    getControllerFields(context) {
        try {
            Map controllerFieldsList = {
                "planNameController": useTextEditingController(),
                "priceController": useTextEditingController(),
                "descriptionController":  useTextEditingController(),
            };
            return controllerFieldsList;
        } catch (err, stack) {
            AppConfig.logger.d("Unknown Error: $err");
            AppConfig.logger.d("Unknown Error: stack $stack");
            rethrow;
        }
    }

    setControllersData(ref, controllerFields, record) async {
        try {
            record = await record;
            controllerFields["planNameController"].text = record.plan_name;
            controllerFields["priceController"].text = record.price;
            controllerFields["descriptionController"].text = record.description;
        } catch (err, stack) {
            AppConfig.logger.d("Unknown Error: $err");
            AppConfig.logger.d("Unknown Error: stack $stack");
            rethrow;
        }
    }

    getListOfFieldWidgets(context, ref, customDarkThemeStyles, controllerFields) {
        try {
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
        } catch (err, stack) {
            AppConfig.logger.d("Unknown Error: $err");
            AppConfig.logger.d("Unknown Error: stack $stack");
            rethrow;
        }
    }

    getInstanceFromControllers(ref, controllerFields) async {
        try {
            return Plan(
                plan_name: controllerFields["planNameController"].text.trim(),
                price: controllerFields["priceController"].text.trim(),
                description: controllerFields["descriptionController"].text.trim(),
            );
        } catch (err, stack) {
            AppConfig.logger.d("Unknown Error: $err");
            AppConfig.logger.d("Unknown Error: stack $stack");
            rethrow;
        }
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

    getControllerFields(context) {
        try {
            Map controllerFieldsList = {
                "nameController": useTextEditingController(),
                "descriptionController": useTextEditingController(),
            };
            return controllerFieldsList;
        } catch (err, stack) {
            AppConfig.logger.d("Unknown Error: $err");
            AppConfig.logger.d("Unknown Error: stack $stack");
            rethrow;
        }
    }

    setControllersData(ref, controllerFields, record) async {
        try {
            record = await record;
            controllerFields["nameController"].text = record.name;
            controllerFields["descriptionController"].text = record.description;
        } catch (err, stack) {
            AppConfig.logger.d("Unknown Error: $err");
            AppConfig.logger.d("Unknown Error: stack $stack");
            rethrow;
        }
    }

    getListOfFieldWidgets(context, ref, customDarkThemeStyles, controllerFields) {
        try {
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
        } catch (err, stack) {
            AppConfig.logger.d("Unknown Error: $err");
            AppConfig.logger.d("Unknown Error: stack $stack");
            rethrow;
        }
    }

    getInstanceFromControllers(ref, controllerFields) async {
        try {
            return Modality(
                name: controllerFields["nameController"].text.trim(),
                description: controllerFields["descriptionController"].text.trim(),
            );
        } catch (err, stack) {
            AppConfig.logger.d("Unknown Error: $err");
            AppConfig.logger.d("Unknown Error: stack $stack");
            rethrow;
        }
    }
}

@unfreezed
class Class with _$Class {
    const Class._(); // ADD THIS LINE TO ADD NEW METHODS LIKE getNameField

    factory Class({
        int? id,
        required Map modality,
        required String start_time,
        required String end_time,
        required int max_participants,
    }) = _Class;

    factory Class.fromJson(Map<String, dynamic> json) => _$ClassFromJson(json);

    String getNameField() => "${modality['name']}   -   ${start_time.substring(0, start_time.length - 3)}";

    getControllerFields(context) {
        try {
            Map controllerFieldsList = {
                "selectedModality":  useState(""),
                "startDateController": useTextEditingController(),
                "startDateAPIformatedDateController": useTextEditingController(),
                "endDateController": useTextEditingController(),
                "endDateAPIformatedDateController": useTextEditingController(),
                "maxParticipantsController": useTextEditingController(),
            };
            return controllerFieldsList;
        } catch (err, stack) {
            AppConfig.logger.d("Unknown Error: $err");
            AppConfig.logger.d("Unknown Error: stack $stack");
            rethrow;
        }
    }

    setControllersData(ref, controllerFields, record) async {
        try {
            record = await record;
            controllerFields["selectedModality"].value = "${record.modality['id']}";
            setTimeControllersInitialValue(
                record.start_time,
                controllerFields["startDateController"],
                controllerFields["startDateAPIformatedDateController"],
            );
            setTimeControllersInitialValue(
                record.end_time,
                controllerFields["endDateController"],
                controllerFields["endDateAPIformatedDateController"],
            );
            controllerFields["maxParticipantsController"].text = "${record.max_participants}";
        } catch (err, stack) {
            AppConfig.logger.d("Unknown Error: $err");
            AppConfig.logger.d("Unknown Error: stack $stack");
            rethrow;
        }
    }

    getListOfFieldWidgets(context, ref, customDarkThemeStyles, controllerFields) {
        try {
            var widgetList = [
                SelectValueFromProviderListDropdown(
                    "Modality",
                    controllerFields["selectedModality"],
                    asyncModalityProvider,
                ),
                const SizedBox(height: 16.0),
                TextField(
                    controller: controllerFields["startDateController"],
                    readOnly: true,
                    onTap:(){
                        selectAndSetTimeToControllers(
                            context,
                            controllerFields["startDateController"],
                            controllerFields["startDateAPIformatedDateController"],
                        );
                    },
                    style: kIsWeb ? Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 19) :
                        Theme.of(context).textTheme.titleMedium,
                    decoration: InputDecoration(
                        labelText: tr("Start date"),
                        prefixIcon: const Icon(Icons.calendar_today),
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12))
                        ),
                        filled: true,
                        fillColor: customDarkThemeStyles.inputDecorationFillcolor.withOpacity(0.5),
                        suffixIcon: IconButton(
                            onPressed: (){
                                controllerFields["startDateController"].clear();
                                controllerFields["startDateAPIformatedDateController"].clear();
                            },
                            icon: const Icon(Icons.clear),
                        ),
                    ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                    controller: controllerFields["endDateController"],
                    readOnly: true,
                    onTap:(){
                        selectAndSetTimeToControllers(
                            context,
                            controllerFields["endDateController"],
                            controllerFields["endDateAPIformatedDateController"],
                        );
                    },
                    style: kIsWeb ? Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 19) :
                        Theme.of(context).textTheme.titleMedium,
                    decoration: InputDecoration(
                        labelText: tr("End date"),
                        prefixIcon: const Icon(Icons.calendar_today),
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12))
                        ),
                        filled: true,
                        fillColor: customDarkThemeStyles.inputDecorationFillcolor.withOpacity(0.5),
                        suffixIcon: IconButton(
                            onPressed: (){
                                controllerFields["endDateController"].clear();
                                controllerFields["endDateAPIformatedDateController"].clear();
                            },
                            icon: const Icon(Icons.clear),
                        ),
                    ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                    minLines: 1,
                    maxLines: null,
                    controller: controllerFields["maxParticipantsController"],
                    style: kIsWeb ? Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 19) :
                        Theme.of(context).textTheme.titleMedium,
                    decoration: InputDecoration(
                        labelText: tr("Max Participants"),
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12))
                        ),
                        filled: true,
                        fillColor: customDarkThemeStyles.inputDecorationFillcolor.withOpacity(0.5),
                    ),
                ),
            ];
            return widgetList;
        } catch (err, stack) {
            AppConfig.logger.d("Unknown Error: $err");
            AppConfig.logger.d("Unknown Error: stack $stack");
            rethrow;
        }
    }

    getInstanceFromControllers(ref, controllerFields) async {
        try {
            var modalityId = int.parse(controllerFields["selectedModality"].value);
            var modalities = await ref.read(asyncModalityProvider); // TODO FIXME pagination problem Should make getInstanceRequest
            var modality = modalities.value["listRecords"].firstWhere((el)=> el.id == modalityId);
            return Class(
                modality: {
                    "id": int.parse(controllerFields["selectedModality"].value),
                    "name": modality.name
                },
                start_time: controllerFields["startDateAPIformatedDateController"].text,
                end_time: controllerFields["endDateAPIformatedDateController"].text,
                max_participants: int.parse(controllerFields["maxParticipantsController"].text.trim()),
            );
        } catch (err, stack) {
            AppConfig.logger.d("Unknown Error: $err");
            AppConfig.logger.d("Unknown Error: stack $stack");
            rethrow;
        }
    }
}


@unfreezed
class Attendance with _$Attendance {
    const Attendance._(); // ADD THIS LINE TO ADD NEW METHODS LIKE getNameField

    factory Attendance({
        int? id,
        required Map customer,
        required Map class_instance,
        required String date,
    }) = _Attendance;

    factory Attendance.fromJson(Map<String, dynamic> json) => _$AttendanceFromJson(json);

    String getNameField() {
        DateTime dateTime = DateTime.parse(date);
        String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
        String modalityName = class_instance['modality_name'];
        String startTime = class_instance['start_time'].substring(0, class_instance['start_time'].length - 3);
        String customerName = customer['name'];
        return "Treino: $modalityName ($startTime); Aluno: $customerName; Data: $formattedDate";
    }

    getControllerFields(context) {
        try {
            Map controllerFieldsList = {
                "selectedCustomer":  useState(""),
                "selectedClass":  useState(""),
                "dateController": useTextEditingController(),
                "dateISOStringController": useTextEditingController(),
            };
            return controllerFieldsList;
        } catch (err, stack) {
            AppConfig.logger.d("Unknown Error: $err");
            AppConfig.logger.d("Unknown Error: stack $stack");
            rethrow;
        }
    }

    setControllersData(ref, controllerFields, record) async {
        try {
            record = await record;
            controllerFields["selectedCustomer"].value = "${record.customer['id']}";
            controllerFields["selectedClass"].value = "${record.class_instance['id']}";
            setDateControllersInitialValue(
                ref,
                record.date,
                controllerFields["dateController"],
                controllerFields["dateISOStringController"],
            );
        } catch (err, stack) {
            AppConfig.logger.d("Unknown Error: $err");
            AppConfig.logger.d("Unknown Error: stack $stack");
            rethrow;
        }
    }

    getListOfFieldWidgets(context, ref, customDarkThemeStyles, controllerFields) {
        try {
            var widgetList = [
                SelectValueFromProviderListDropdown(
                    "Customer",
                    controllerFields["selectedCustomer"],
                    asyncCustomersProvider,
                ),
                const SizedBox(height: 16.0),
                SelectValueFromProviderListDropdown(
                    "Class",
                    controllerFields["selectedClass"],
                    asyncClassProvider,
                ),
                const SizedBox(height: 16.0),
                TextField(
                    controller: controllerFields["dateController"],
                    readOnly: true,
                    onTap:(){
                        selectAndSetDateToControlers(
                            context,
                            ref,
                            controllerFields["dateController"],
                            controllerFields["dateISOStringController"]
                        );
                    },
                    style: kIsWeb ? Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 19) :
                        Theme.of(context).textTheme.titleMedium,
                    decoration: InputDecoration(
                        labelText: tr("Date"),
                        prefixIcon: const Icon(Icons.calendar_today),
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12))
                        ),
                        filled: true,
                        fillColor: customDarkThemeStyles.inputDecorationFillcolor.withOpacity(0.5),
                        suffixIcon: IconButton(
                            onPressed: (){
                                controllerFields["dateController"].clear();
                                controllerFields["dateISOStringController"].clear();
                            },
                            icon: const Icon(Icons.clear),
                        ),
                    ),
                ),
            ];
            return widgetList;
        } catch (err, stack) {
            AppConfig.logger.d("Unknown Error: $err");
            AppConfig.logger.d("Unknown Error: stack $stack");
            rethrow;
        }
    }

    getInstanceFromControllers(ref, controllerFields) async {
        try {
            var customerId = int.parse(controllerFields["selectedCustomer"].value);
            var customers = await ref.read(asyncCustomersProvider); // TODO FIXME pagination problem Should make getInstanceRequest
            var customer = customers.value["listRecords"].firstWhere((el)=> el.id == customerId);

            var classId = int.parse(controllerFields["selectedClass"].value);
            var classes = await ref.read(asyncClassProvider); // TODO FIXME pagination problem Should make getInstanceRequest
            var classInstance = classes.value["listRecords"].firstWhere((el)=> el.id == classId);
            return Attendance(
                customer: {
                    "id": customerId,
                    "name": customer.name,
                },
                class_instance: {
                    "id": classId,
                    "modality_name": classInstance.modality["name"],
                },
                date: controllerFields["dateISOStringController"].text
            );
        } catch (err, stack) {
            AppConfig.logger.d("Unknown Error: $err");
            AppConfig.logger.d("Unknown Error: stack $stack");
            rethrow;
        }
    }
}


@unfreezed
class Payment with _$Payment {
    const Payment._();

    factory Payment({
        int? id,
        required Map enrollment,
        required DateTime payment_date,
        required dynamic amount,
        required int payment_method,
        String? transaction_id,
    }) = _Payment;

    factory Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);

    String getNameField() {
        String formattedDate = DateFormat('dd/MM/yyyy').format(payment_date);
        return "Aluno(a): ${enrollment['customer_name']}  |  Valor: $amount  |  Data: $formattedDate";
    }

    getControllerFields(context) {
        try {
            Map controllerFieldsList = {
                "selectedCustomer":  useState(""),
                "selectedPaymentMethod":  useState("1"),
                "amountController": useTextEditingController(),
                "paymentDateController": useTextEditingController(),
                "paymentDateISOStringController": useTextEditingController(),
            };
            return controllerFieldsList;
        } catch (err, stack) {
            AppConfig.logger.d("Unknown Error: $err");
            AppConfig.logger.d("Unknown Error: stack $stack");
            rethrow;
        }
    }

    setControllersData(ref, controllerFields, record) async {
        try {
            record = await record;
            controllerFields["selectedCustomer"].value = "${record.enrollment['customer_id']}";
            controllerFields["selectedPaymentMethod"].value = "${record.payment_method}";
            setDateTimeControllersInitialValue(
                ref,
                record.payment_date,
                controllerFields["paymentDateController"],
                controllerFields["paymentDateISOStringController"],
            );
            controllerFields["amountController"].text = record.amount;
        } catch (err, stack) {
            AppConfig.logger.d("Unknown Error: $err");
            AppConfig.logger.d("Unknown Error: stack $stack");
            rethrow;
        }
    }

    getListOfFieldWidgets(context, ref, customDarkThemeStyles, controllerFields) {
        try {
            var widgetList = [
                SelectValueFromProviderListDropdown(
                    "Customer",
                    controllerFields["selectedCustomer"],
                    asyncCustomersProvider,
                ),
                const SizedBox(height: 16.0),
                SelectDropdown(
                    controllerFields["selectedPaymentMethod"],
                    Constants.paymentMethodOptions,
                    "Payment method",
                ),
                const SizedBox(height: 16.0),
                TextField(
                    controller: controllerFields["paymentDateController"],
                    readOnly: true,
                    onTap:(){
                        selectAndSetDateTimeToControlers(
                            context,
                            ref,
                            controllerFields["paymentDateController"],
                            controllerFields["paymentDateISOStringController"]
                        );
                    },
                    style: kIsWeb ? Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 19) :
                        Theme.of(context).textTheme.titleMedium,
                    decoration: InputDecoration(
                        labelText: tr("Payment date"),
                        prefixIcon: const Icon(Icons.calendar_today),
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12))
                        ),
                        filled: true,
                        fillColor: customDarkThemeStyles.inputDecorationFillcolor.withOpacity(0.5),
                        suffixIcon: IconButton(
                            onPressed: (){
                                controllerFields["paymentDateController"].clear();
                                controllerFields["paymentDateISOStringController"].clear();
                            },
                            icon: const Icon(Icons.clear),
                        ),
                    ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                    minLines: 1,
                    maxLines: null,
                    controller: controllerFields["amountController"],
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                    ],
                    style: kIsWeb ? Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 19) :
                        Theme.of(context).textTheme.titleMedium,
                    decoration: InputDecoration(
                        labelText: tr("Value"),
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12))
                        ),
                        filled: true,
                        fillColor: customDarkThemeStyles.inputDecorationFillcolor.withOpacity(0.5),
                    ),
                ),
            ];
            return widgetList;
        } catch (err, stack) {
            AppConfig.logger.d("Unknown Error: $err");
            AppConfig.logger.d("Unknown Error: stack $stack");
            rethrow;
        }
    }

    getInstanceFromControllers(ref, controllerFields) async {
        try {
            var customerId = int.parse(controllerFields["selectedCustomer"].value);
            var customers = await ref.read(asyncCustomersProvider); // TODO FIXME pagination problem Should make getInstanceRequest
            var customer = customers.value["listRecords"].firstWhere((el)=> el.id == customerId);
            return Payment(
                enrollment: {
                    "id": customer.enrollment["id"],
                    "customer_id": customerId,
                    "customer_name": customer.name,
                    "plan_name": customer.enrollment["plan"],
                },
                payment_method: int.parse(controllerFields["selectedPaymentMethod"].value),
                payment_date: DateTime.parse(controllerFields["paymentDateISOStringController"].text),
                amount: controllerFields["amountController"].text.trim(),
            );
        } catch (err, stack) {
            AppConfig.logger.d("Unknown Error: $err");
            AppConfig.logger.d("Unknown Error: stack $stack");
            rethrow;
        }
    }

}
