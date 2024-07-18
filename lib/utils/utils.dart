import 'package:easy_localization/easy_localization.dart';
import 'package:fight_gym/config/app_config.dart';
import 'package:fight_gym/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fight_gym/config/app_routes.dart';
import 'package:fight_gym/constants/constants.dart';
import 'package:fight_gym/provider/configurations_provider.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

String getStatusLabel(int status) {
    switch (status) {
        case 1:
          return "Postponed";
        case 2:
          return "Pendent";
        case 3:
          return "Doing";
        case 4:
          return "Done";
        default:
          return "Unknown"; // or whatever default value you want
    }
}

Color getStatusColor(int status) {
  switch (status) {
    case 1:
      return Colors.grey[600] ?? Colors.grey; // Postponed color
    case 2:
      return Colors.yellow[900] ?? Colors.yellowAccent; // Pendent color
    case 3:
      return Colors.red[800] ?? Colors.red; // Doing color
    case 4:
      // return Colors.green; // Done color
      return Colors.lightGreen[600] ?? Colors.lightGreen; // Done color
    default:
      return Colors.grey; // Default color for unknown status
  }
}

String getPriorityLabel(int status) {
    switch (status) {
        case 1:
          return "Urgent";
        case 2:
          return "High";
        case 3:
          return "Normal";
        case 4:
          return "Low";
        default:
          return "Unknown"; // or whatever default value you want
    }
}

Color getPriorityColor(int status) {
  switch (status) {
    case 1:
      return Colors.red[800] ?? Colors.red;
    case 2:
      return Colors.yellow[900] ?? Colors.yellowAccent;
    case 3:
      return Colors.blue[800] ?? Colors.blue;
    case 4:
      return Colors.grey[600] ?? Colors.grey;
    default:
      return Colors.grey;
  }
}

String parseTxt(String txt, {endIndex}) {
    String parsedTxt = txt;
    if (endIndex != null){
        int txtlength = txt.length;
        bool txtNeedToBeTruncated = txtlength > endIndex;
        endIndex = txtNeedToBeTruncated ? endIndex : txtlength;
        parsedTxt = txt.substring(0, endIndex);
        if (txtNeedToBeTruncated){
            parsedTxt += "......";
        }
    }
    return parsedTxt;
}

goToMenu(context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(
            context,
            AppRoutes.menu
        );
    });
}

bool isWebBrowserOnMobile(context) {
    var width = MediaQuery. of(context).size.width;
    return width <= 550;
}

setDateTimeControllersInitialValue(ref, dateField, dateController, dateISOStringController) {
    bool hasDateField = dateField.runtimeType == DateTime;
    dateController.text = hasDateField ? parseDateTimeToLocalizedString(ref, dateField) : "";
    dateISOStringController.text = hasDateField ? dateField!.toIso8601String() : "";
}

Future<void> selectAndSetDateTimeToControlers(context, ref, dateController, dateISOStringController) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
        TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
        );

        if (pickedTime != null) {
            DateTime combinedDateTime = DateTime(
                pickedDate.year,
                pickedDate.month,
                pickedDate.day,
                pickedTime.hour,
                pickedTime.minute,
            );
            dateController.text = parseDateTimeToLocalizedString(ref, combinedDateTime);
            dateISOStringController.text = combinedDateTime.toIso8601String();
        }
    }
}

String parseDateTimeToLocalizedString(ref, DateTime date) {
    var notifier = ref.read(asyncConfigsProvider.notifier);
    String currentLocale = notifier.getLocale!().toString();
    String dateFormat = currentLocale == "pt" ? Constants.dateFormatPT : Constants.dateFormatEn;
    return DateFormat(dateFormat).format(date.toLocal());
}

setDateControllersInitialValue(ref, dateString, dateController, dateISOStringController) {
    DateTime dateField = DateTime.parse(dateString);
    var localizedDateString = parseDateTimeToLocalizedString(ref, dateField);
    dateController.text = localizedDateString.split(' - ')[0];
    var localizedApiFormatedDateString = dateField.toIso8601String().split('T')[0];
    dateISOStringController.text = localizedApiFormatedDateString;
}

Future<void> selectAndSetDateToControlers(context, ref, dateController, dateISOStringController) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2024, 7, 01),
        lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
        DateTime combinedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
        );
        var localizedDateString = parseDateTimeToLocalizedString(ref, combinedDateTime);
        // "07/16/2024 - 12:00 AM"
        dateController.text = localizedDateString.split(' - ')[0];
        // "2024-07-16T00:00:00.000"
        var localizedApiFormatedDateString = combinedDateTime.toIso8601String().split('T')[0];
        dateISOStringController.text = localizedApiFormatedDateString;
    }
}


void setTimeControllersInitialValue(
    String timeString,
    TextEditingController timeController, 
    TextEditingController timeISOStringController, 
) {
    DateFormat timeFormat = DateFormat.Hms();
    DateTime time = timeFormat.parse(timeString);
    
    String formattedTimeToShow = DateFormat('HH:mm').format(time);
    String formattedTimeToSendOnAPI = DateFormat('HH:mm:ss').format(time);

    timeController.text = formattedTimeToShow;
    timeISOStringController.text = formattedTimeToSendOnAPI;
}


Future<void> selectAndSetTimeToControllers(
    BuildContext context, 
    TextEditingController timeController, 
    TextEditingController timeISOStringController
) async {
    TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
        DateTime now = DateTime.now();
        DateTime selectedTime = DateTime(
            now.year, 
            now.month, 
            now.day, 
            pickedTime.hour, 
            pickedTime.minute
        );

        String formattedTimeToShow = DateFormat('HH:mm').format(selectedTime);
        String formattedTimeToSendOnAPI = DateFormat('HH:mm:ss').format(selectedTime);

        timeController.text = formattedTimeToShow;
        timeISOStringController.text = formattedTimeToSendOnAPI;
    }
}


class FilterDate extends HookConsumerWidget {
    final dynamic queryParams;
    final dynamic providerToBeFiltered;
    final String dateField;

    const FilterDate({
        required this.queryParams,
        required this.providerToBeFiltered,
        required this.dateField,
        super.key
    });

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        final TextEditingController initialDateController = useTextEditingController();
        final TextEditingController initialDateISOStringController = useTextEditingController();
        final TextEditingController finalDateController = useTextEditingController();
        final TextEditingController finalDateISOStringController = useTextEditingController();

        CustomDarkThemeStyles customDarkThemeStyles = CustomDarkThemeStyles(Theme.of(context).brightness);

        return Row(
            children: [
                Expanded(
                      child: TextField(
                            controller: initialDateController,
                            readOnly: true,
                            onTap: () {
                                selectAndSetDateToControlers(
                                    context,
                                    ref,
                                    initialDateController,
                                    initialDateISOStringController,
                                );
                            },
                            style: kIsWeb ? Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 19) :
                                Theme.of(context).textTheme.titleMedium,
                            decoration: InputDecoration(
                                  labelText: tr('Initial date'),
                                  prefixIcon: const Icon(Icons.calendar_today),
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12)),
                                  ),
                                  filled: true,
                                  fillColor: customDarkThemeStyles.inputDecorationFillcolor.withOpacity(0.5),
                                  suffixIcon: IconButton(
                                        onPressed: () {
                                            initialDateController.clear();
                                            initialDateISOStringController.clear();
                                            if (queryParams.value["filterBy"] != null){
                                                queryParams.value["filterBy"].remove("initial_$dateField");
                                            }
                                        },
                                        icon: const Icon(Icons.clear),
                                  ),
                            ),
                      ),
                ),
                const SizedBox(width: 16),
                Expanded(
                    child: TextField(
                        controller: finalDateController,
                        readOnly: true,
                        onTap: () {
                            selectAndSetDateToControlers(
                                context,
                                ref,
                                finalDateController,
                                finalDateISOStringController,
                            );
                        },
                        decoration: InputDecoration(
                          labelText: tr('Final date'),
                          prefixIcon: const Icon(Icons.calendar_today),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          filled: true,
                          fillColor: customDarkThemeStyles.inputDecorationFillcolor.withOpacity(0.5),
                          suffixIcon: IconButton(
                            onPressed: () {
                                finalDateController.clear();
                                finalDateISOStringController.clear();
                                if (queryParams.value["filterBy"] != null){
                                    queryParams.value["filterBy"].remove("final_$dateField");
                                }
                            },
                            icon: const Icon(Icons.clear),
                          ),
                        ),
                    ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    var notifier = ref.read(providerToBeFiltered.notifier);
                    var initialDate = initialDateISOStringController.text;
                    var finalDate = finalDateISOStringController.text;
                    if (initialDate.isNotEmpty){
                        if (queryParams.value["filterBy"] != null){
                            queryParams.value["filterBy"]["initial_$dateField"] = initialDate;
                        }
                        else {
                            queryParams.value["filterBy"] = {
                                "initial_$dateField": initialDateISOStringController.text,
                            };
                        }
                    }
                    else {
                        if (queryParams.value["filterBy"] != null){
                            queryParams.value["filterBy"].remove("initial_$dateField");
                        }
                    }

                    if (finalDate.isNotEmpty){
                        if (queryParams.value["filterBy"] != null){
                            queryParams.value["filterBy"]["final_$dateField"] = finalDate;
                        }
                        else {
                            queryParams.value["filterBy"] = {
                                "final_$dateField": finalDateISOStringController.text,
                            };
                        }
                    }
                    else {
                        if (queryParams.value["filterBy"] != null){
                            queryParams.value["filterBy"].remove("final_$dateField");
                        }
                    }

                    notifier.fetchRecords(queryParams: queryParams.value);
                },
                  child: Text(tr('Search')),
                ),
            ],
        );
    }
}
