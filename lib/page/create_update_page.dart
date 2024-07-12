import "package:easy_localization/easy_localization.dart";
import "package:fight_gym/components/dialogs.dart";
import "package:fight_gym/components/dropdown.dart";
import "package:fight_gym/config/app_routes.dart";
import "package:fight_gym/page/facade.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:fight_gym/provider/plan_provider.dart";
import "package:fight_gym/styles/app_colors.dart";
import "package:fight_gym/styles/app_text.dart";
import "package:fight_gym/utils/user_auth_middleware.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import 'package:flutter/foundation.dart' show kIsWeb;


class CreateOrUpdatePage extends HookConsumerWidget {
    CreateOrUpdatePage(
        {
            super.key,
            this.params = const {},
            required this.updateUrl,
            required this.provider,
            required this.instanceModel,
        }
    );
    dynamic params;
    final String updateUrl;
    // final AsyncNotifierProvider provider;
    final dynamic provider;
    final dynamic instanceModel;

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        // AppConfig.logger.d('params $params');
        // AppConfig.logger.d('params type ${params.runtimeType}');
        // 👇 Whem receiving queryParameters
        // │ 🐛 params {queryParameters: {}}
        // │ 🐛 params type IdentityMap<String, dynamic>

        // 👇 When don't receiving queryParameters
        // │ 🐛 params Builder
        // │ 🐛 params type StatelessElement

        // Get record from arguments if page was acessed from Navigation.pushNamed
        final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
        var record = arguments["record"];

        // Get record from backend if isUpdate and page was accessed directly from url
        // and therefore ther is no argument passed througth Navigation.pushnamed
        //like `http://localhost:33885/instance_update?record_id=1`
        Map? queryParameters = params.runtimeType == Map ? params["queryParameters"] : null;
        var recordIdQueryParameter = queryParameters?["record_id"];
        bool isRecordUpdatePageOnWebWithoutRecord = kIsWeb && record == null && 
                ModalRoute.of(context)!.settings.name!.contains(updateUrl);
        if (isRecordUpdatePageOnWebWithoutRecord){
            if (recordIdQueryParameter != null){
                // AppConfig.logger.d('record is null. Will get it notifier.getSingleRecord(recordIdQueryParameter);
                //return future. Requires await');
                var notifier = ref.read(provider.notifier);
                record = notifier.getSingleRecord(recordIdQueryParameter); //return future. Requires await
            }
            // is updated But there is no record_id query parameter for some reason
            // and there is no record from arguments too
            // AppConfig.logger.d('Update page without record id. Redirecting to menu.');
            handlePopNavigation(context, AppRoutes.menu);
        }

        //Fields
        final ValueNotifier selectedPlan = useState(""); // could not put it above. got weird error
        final nameController = useTextEditingController();
        final emailController = useTextEditingController();

        useEffect(() {
            userAuthMiddleware(context);
            if (record != null){
                setControllersData(
                    ref,
                    nameController,
                    emailController,
                    selectedPlan,
                    record
                );
            }
            return null;
        }, const []);

        CustomDarkThemeStyles customDarkThemeStyles = CustomDarkThemeStyles(Theme.of(context).brightness);
        Color textStyleColor = Theme.of(context).brightness == Brightness.light ? Colors.black :
                AppColors.lightBackground;

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
                                            TextField(
                                                minLines: 1,
                                                maxLines: null,
                                                controller: nameController,
                                                style: kIsWeb ? Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 19) : Theme.of(context).textTheme.titleMedium,
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
                                                controller: emailController,
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
                                                selectedPlan,
                                                asyncPlansProvider,
                                            ),
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
                                                            var newRecord = instanceModel(
                                                                name: nameController.text.trim(),
                                                                email: emailController.text.trim(),
                                                                phone: "phone",
                                                                family_phone: "family_phone",
                                                                address: "address",
                                                                birthday: DateTime.now(),
                                                                enrollment: {
                                                                    "plan": int.parse(selectedPlan.value),
                                                                    "subscription_status": 1
                                                                }
                                                            );
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
