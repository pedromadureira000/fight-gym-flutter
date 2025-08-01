import 'package:easy_localization/easy_localization.dart';
import 'package:fight_gym/config/app_config.dart';
import "package:fight_gym/config/app_routes.dart";
import 'package:fight_gym/utils/snackbar.dart';
import 'package:flutter/material.dart';


void goToCreatePage(context, ref, namedRoute){
    Navigator.pushNamed(context, namedRoute, arguments: {"test": "fon"});
}
void goToUpdatePage(context, ref, record, namedRoute) {
    var url = "$namedRoute?record_id=${record.id}";
    Navigator.pushNamed(context, url, arguments: {"record": record});
}

addRecord (ref, newRecord, context, providerClass, menuRoute) async {
    try {
        var notifier = await ref.read(providerClass.notifier);
        var (result, recordMap) = await notifier.addRecord(newRecord);
        if (result == "success"){
            notifier.addRecordLocaly(recordMap);
            handlePopNavigation(context, menuRoute);
        }
        else {
            showSnackBar(context, result, "error");
        }
    } catch (err, stack) {
        AppConfig.logger.d("Unknown Error: $err");
        AppConfig.logger.d("Unknown Error: stack $stack");
        showSnackBar(context, tr("An unknown error has occurred"), "error");
    }
}

updateRecord (ref, newRecord, context, record, providerClass, menuRoute) async {
    try {
        record = await record;
        var providerObj = await ref.read(providerClass.notifier);
        String result = await providerObj.updateRecord(record.id, newRecord);
        if (result == "success"){
            providerObj.updateRecordLocaly(newRecord, record);
            handlePopNavigation(context, menuRoute);
        }
        else {
            showSnackBar(context, result, "error");
        }
    } catch (err, stack) {
        AppConfig.logger.d("Unknown Error: $err");
        AppConfig.logger.d("Unknown Error: stack $stack");
        showSnackBar(context, tr("An unknown error has occurred"), "error");
    }
}

deleteRecord(ref, context, record, providerClass, menuRoute) async {
    try {
        var provider = await ref.read(providerClass.notifier);
        String result = await provider.removeRecord(record.id);
        if (result == "success"){
            provider.deleteRecordLocaly(record);
            handlePopNavigation(context, menuRoute); // close dialog
            handlePopNavigation(context, menuRoute); // close createUpdateWidget
        }
        else {
            showSnackBar(context, result, "error");
        }
    } catch (err, stack) {
        AppConfig.logger.d("Unknown Error: $err");
        AppConfig.logger.d("Unknown Error: stack $stack");
        showSnackBar(context, tr("An unknown error has occurred"), "error");
    }
}

void handlePopNavigation(BuildContext context, namedRoute) {
    if (Navigator.canPop(context)) {
        Navigator.pop(context);
    } else {
        Navigator.pushNamed(
            context,
            namedRoute
        );
    }
}
