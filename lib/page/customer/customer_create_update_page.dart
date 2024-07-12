import "package:easy_localization/easy_localization.dart";
import "package:fight_gym/config/app_config.dart";
import "package:fight_gym/config/app_routes.dart";
import "package:fight_gym/provider/customer_provider.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:fight_gym/model/models.dart";
import "package:fight_gym/provider/plan_provider.dart";
import "package:fight_gym/styles/app_colors.dart";
import "package:fight_gym/styles/app_text.dart";
import "package:fight_gym/utils/snackbar.dart";
import "package:fight_gym/utils/user_auth_middleware.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import 'package:flutter/foundation.dart' show kIsWeb;
import "package:dropdown_button2/dropdown_button2.dart";


class CustomerCreateOrUpdatePage extends HookConsumerWidget {
    CustomerCreateOrUpdatePage({super.key, this.params = const {}});
    dynamic params;

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
        //like `http://localhost:33885/customer_update?record_id=1`
        Map? queryParameters = params.runtimeType == Map ? params["queryParameters"] : null;
        var recordIdQueryParameter = queryParameters?["record_id"];
        if (kIsWeb && ModalRoute.of(context)!.settings.name!.contains("/customer_update")){
            if (recordIdQueryParameter == null && record == null){
                // is updated But there is no record_id query parameter for some reason
                // and there is no record from arguments too
                // AppConfig.logger.d('Update page without record id. Redirecting to menu.');
                handlePopNavigation(context, AppRoutes.menu);
            }
            if (record == null){
                // AppConfig.logger.d('record is null. Will get it notifier.getSingleRecord(recordIdQueryParameter); //return future. Requires await');
                var notifier = ref.read(asyncCustomersProvider.notifier);
                record = notifier.getSingleRecord(recordIdQueryParameter); //return future. Requires await
            }
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
                                                            Customer newRecord = Customer(
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
                                                                updateRecord(ref, newRecord, context, record, asyncCustomersProvider);
                                                            }
                                                            else {
                                                                addRecord(ref, newRecord, context, asyncCustomersProvider);
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

setControllersData(ref, nameController, emailController, selectedPlan, record) async{
    // if (record.runtimeType == Future<Customer>){ // Don't work anymore with new model constructor workaround 
    // to use custom methods. Like this: [const Plan._(); // ADD THIS LINE TO ADD NEW METHODS LIKE getNameField]
    // runtimeType will be _$CustomerImpl or a _Future<Customer>, 
    //this new _Future was hard to check type so I just await both, since it don't raise error.
    record = await record;
    nameController.text = record.name;
    emailController.text = record.email;
    selectedPlan.value = "${record.enrollment['plan']}";
}


class SelectValueFromProviderListDropdown extends HookConsumerWidget {
    SelectValueFromProviderListDropdown(this.selectedValue, this.providerClass, {Key? key}) : super(key: key);
    ValueNotifier selectedValue;
    AsyncNotifierProvider providerClass;

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        final asyncValue = ref.watch(providerClass);
        // this leads to the same errror as commented bellow

        // Initialize selectedValue.value once when the widget is first built
        // useEffect(() {
          // if (selectedValue.value.isEmpty && asyncValue is AsyncData) {
            // final records = asyncValue.value;
            // if (records.isNotEmpty) {
                // WidgetsBinding.instance.addPostFrameCallback((_) {
                    // selectedValue.value = "${records[0].id}";
                // });
            // }
          // }
          // return null; // No cleanup function needed
        // }, [asyncValue]);

        switch (asyncValue) {
            case AsyncData(): 
                final records = asyncValue.value;
                if (selectedValue.value.isEmpty) {
                    final records = asyncValue.value;
                    if (records.isNotEmpty) {
                        // WidgetsBinding.instance.addPostFrameCallback((_) {
                            // selectedValue.value = "${records[0].id}";
                        // });
                        // code above leads to error on line: map<DropdownMenuItem<String>>((item) => DropdownMenuItem<String>
                        // it gets empty string and it should receive a id that matches the records list
                        // without it, I get this error:
                        // ``The following assertion was thrown while dispatching notifications for ValueNotifier<dynamic>:
                        // setState() or markNeedsBuild() called during build.``
                        selectedValue.value = "${records[0].id}";
                    }
                }
                return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                        Text(
                            tr("Value"),
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).brightness == Brightness.light ? Colors.black : AppColors.lightBackground,
                            ),
                        ),
                        DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                                isExpanded: true,
                                hint: Text(
                                    tr("Select Value"),
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context).hintColor,
                                    ),
                                ),
                                items: records
                                    .map<DropdownMenuItem<String>>((item) => DropdownMenuItem<String>( // This line throws the error
                                        value: "${item.id}",
                                        child: Text(
                                            item.getNameField(),
                                            style: const TextStyle(
                                                fontSize: 14,
                                            ),
                                        ),
                                    ))
                                    .toList(),
                                value: selectedValue.value,
                                onChanged: (String? value) {
                                    selectedValue.value = value!;
                                },
                                buttonStyleData: const ButtonStyleData(
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    height: 40,
                                    width: kIsWeb? 140 : 120,
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                    height: 40,
                                ),
                            ),
                        ),
                    ],
                );
            case AsyncError():
                return Text(
                    tr("Something went wrong"),
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                );
            default: 
                return const Center(child: CircularProgressIndicator());
        }
    }
}

showDeleteDialog(BuildContext context, WidgetRef ref, record){
    CustomDarkThemeStyles customDarkThemeStyles = CustomDarkThemeStyles(Theme.of(context).brightness);
    return showDialog<String>(
        context: context,
        builder: (BuildContext context) => Dialog(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        SizedBox(
                            width: 300,
                            child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                    children: [
                                        Text(tr("Are you sure you want to delete it? ")),
                                        const SizedBox(height: 15),
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
                                                    style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.red[900],
                                                        foregroundColor: AppColors.lightBackground,
                                                    ),
                                                    onPressed: () {
                                                        deleteRecord(ref, context, record, asyncCustomersProvider);
                                                    },
                                                    child: Text(tr("Delete"), style: AppText.normalText)
                                                ),
                                            ],
                                        ),
                                    ]
                                )
                            ),
                        ),
                    ],
                ),
            ),
        ),
    );
}


addRecord (ref, newRecord, context, providerClass) async {
    try {
        var notifier = ref.read(providerClass.notifier);
        var (result, recordMap) = await notifier.addRecord(newRecord);
        if (result == "success"){
            notifier.addRecordLocaly(newRecord, recordMap);
            handlePopNavigation(context, AppRoutes.menu);
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

updateRecord (ref, newRecord, context, record, providerClass) async {
    try {
        record = await record;
        var providerObj = ref.read(providerClass.notifier);
        String result = await providerObj.updateRecord(record.id, newRecord);
        if (result == "success"){
            providerObj.updateRecordLocaly(newRecord, record);
            handlePopNavigation(context, AppRoutes.menu);
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

deleteRecord(ref, context, record, providerClass) async {
    try {
        var provider = ref.read(providerClass.notifier);
        String result = await provider.removeRecord(record.id);
        if (result == "success"){
            provider.deleteRecordLocaly(record);
            handlePopNavigation(context, AppRoutes.menu); // close dialog
            handlePopNavigation(context, AppRoutes.menu); // close createUpdateWidget
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
