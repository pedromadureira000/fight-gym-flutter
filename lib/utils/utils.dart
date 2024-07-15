import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fight_gym/config/app_routes.dart';
import 'package:fight_gym/constants/constants.dart';
import 'package:fight_gym/provider/configurations_provider.dart';

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


setDateControllersInitialValue(ref, dateField, dateController, dateISOStringController) {
    bool hasDateField = dateField.runtimeType == DateTime;
    dateController.text = hasDateField ? parseDateTimeToLocalizedString(ref, dateField) : "";
    dateISOStringController.text = hasDateField ? dateField!.toIso8601String() : "";
}

Future<void> selectAndSetDateToControlers(context, ref, dateController, dateISOStringController) async {
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
