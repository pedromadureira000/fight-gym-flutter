import "package:easy_localization/easy_localization.dart";
import "package:fight_gym/components/dialogs.dart";
import "package:fight_gym/config/app_config.dart";
import "package:fight_gym/config/app_routes.dart";
import "package:fight_gym/page/facade.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:fight_gym/styles/app_colors.dart";
import "package:fight_gym/styles/app_text.dart";
import "package:fight_gym/utils/user_auth_middleware.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import 'package:flutter/foundation.dart' show kIsWeb;


class CreateOrUpdatePage extends HookConsumerWidget {
    CreateOrUpdatePage({
        super.key,
        this.params = const {},
        required this.updateUrl,
        required this.provider,
        required this.fodderRecordObj
    });
    dynamic params;
    final String updateUrl;
    final dynamic provider;
    final dynamic fodderRecordObj;

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        CustomDarkThemeStyles customDarkThemeStyles = CustomDarkThemeStyles(Theme.of(context).brightness);
        Color textStyleColor = Theme.of(context).brightness == Brightness.light ? Colors.black :
                AppColors.lightBackground;
        // Get record from arguments if page was acessed from Navigation.pushNamed
        final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
        var record = arguments["record"];

        // Get record from backend if isUpdate and page was accessed directly from url
        // and therefore ther is no argument passed througth Navigation.pushnamed
        //like `http://localhost:33885/instance_update?record_id=1`
        Map? queryParameters = params is Map ? params["queryParameters"] : null;
        var recordIdQueryParameter = queryParameters?["record_id"];
        bool isRecordUpdatePageOnWebWithoutRecord = kIsWeb && record == null && 
                ModalRoute.of(context)!.settings.name!.contains(updateUrl);
        if (isRecordUpdatePageOnWebWithoutRecord){
            if (recordIdQueryParameter == null){
                // is updated But there is no record_id query parameter for some reason
                // and there is no record from arguments too
                handlePopNavigation(context, AppRoutes.menu);
            }
            else {
                var notifier = ref.read(provider.notifier);
                record = notifier.getSingleRecord(recordIdQueryParameter); //return future. Requires await
            }
        }

        Map controllerFields = fodderRecordObj.getControllerFields(context);
        List<dynamic> listOfFieldWidgets = fodderRecordObj.getListOfFieldWidgets(context, customDarkThemeStyles, controllerFields);

        useEffect(() {
            userAuthMiddleware(context);
            if (record != null){
                fodderRecordObj.setControllersData(
                    ref,
                    controllerFields,
                    record
                );
            }
            return null;
        }, const []);

        return Scaffold(
            appBar: AppBar(
                title: Text(record != null ? tr("Update record") : tr("Add record")),
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                        handlePopNavigation(context, AppRoutes.menu);
                    },
                ),
            ),
            body: SingleChildScrollView(
                child:  SizedBox(
                    width: kIsWeb ? MediaQuery.of(context).size.width : null,
                    child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                                SizedBox(
                                    width: kIsWeb ? 645 : null,
                                    child: Column(
                                        children: [
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                    Text(
                                                        record != null ? tr("Update record") : tr("Add record"),
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color: textStyleColor,
                                                        ),
                                                    ),
                                                    record != null ? IconButton(
                                                        icon: Icon(Icons.delete, color: customDarkThemeStyles.getContrastColor),
                                                        tooltip: tr("Delete"),
                                                        onPressed: () {
                                                            showDeleteDialog(context, ref, record);
                                                        }
                                                    ) : const SizedBox(),
                                                ],
                                            ),
                                            const SizedBox(height: 16.0),
                                            ...listOfFieldWidgets,
                                            const SizedBox(height: 20.0),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                    ElevatedButton(
                                                        onPressed: () {
                                                            handlePopNavigation(context, AppRoutes.menu);
                                                        },
                                                        style: customDarkThemeStyles.elevatedBtnStyleCancelDeletion,
                                                        child: Text(tr("Close"), style: AppText.normalText),
                                                    ),
                                                    ElevatedButton(
                                                        style: customDarkThemeStyles.elevatedBtnStyle,
                                                        onPressed: () {
                                                            var newRecord = fodderRecordObj.getInstanceFromControllers(controllerFields);
                                                            if (record != null){
                                                                updateRecord(ref, newRecord, context, record, provider);
                                                            }
                                                            else {
                                                                addRecord(ref, newRecord, context, provider);
                                                            }
                                                        },
                                                        child: record != null ? Text(tr("Update"), style: AppText.normalText) :
                                                            Text(tr("Add"), style: AppText.normalText),
                                                    ),
                                                ],
                                            ),
                                        ]
                                    ),
                                ),
                            ],
                        ),
                    ),
                ),
            )
        );
    }
}
