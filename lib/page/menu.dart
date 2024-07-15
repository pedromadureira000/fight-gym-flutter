import "package:easy_localization/easy_localization.dart";
import "package:fight_gym/config/app_config.dart";
import "package:fight_gym/page/facade.dart";
import "package:fight_gym/page/record_list_page.dart";
import "package:fight_gym/provider/modules/customer_provider.dart";
import "package:fight_gym/provider/modules/plan_provider.dart";
import "package:fight_gym/styles/app_colors.dart";
import "package:flutter/material.dart";
import "package:fight_gym/config/app_routes.dart";
import "package:fight_gym/data/local_storage/secure_storage.dart";
import "package:fight_gym/utils/snackbar.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:fight_gym/utils/user_auth_middleware.dart";
import "package:flutter/foundation.dart" show kIsWeb;


class MenuPage extends HookConsumerWidget {
    const MenuPage({super.key});

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        useEffect(() {
            userAuthMiddleware(context);
            checkIfgoogleAccoutJustCreated(context);
            return null;
        }, const []);

        var route = ModalRoute.of(context)!.settings.name;
        AppConfig.logger.d('route $route');
        if (route == "/menu"){ // sometimes I need goToMenu
            route = "/customer";
        }

        final ValueNotifier selectedMenu = useState(route != null ? route.substring(1) : "customer");

        Map<String, dynamic> widgetOptions = {
            "customer": {
                "widget": ListPage(
                    provider: asyncCustomersProvider,
                    createRecordNamedRoute: AppRoutes.customerCreate,
                    updateRecordNamedRoute: AppRoutes.customerUpdate,
                    addInstanceLabel: "Add Customer",
                ),
                "addInstanceRoute": AppRoutes.customerCreate,
            },
            "plan": {
                "widget": ListPage(
                    provider: asyncPlansProvider,
                    createRecordNamedRoute: AppRoutes.planCreate,
                    updateRecordNamedRoute: AppRoutes.planUpdate,
                    addInstanceLabel: "Add Plan",
                ),
                "addInstanceRoute": AppRoutes.planCreate,
            },
            "modality": {
                "widget": const Text('3'),
                "addInstanceRoute": AppRoutes.customerCreate,
            },
            "attendance": {
                "widget": const Text('4'),
                "addInstanceRoute": AppRoutes.customerCreate,
            },
            "payment": {
                "widget": const Text('5'),
                "addInstanceRoute": AppRoutes.customerCreate,
            }, 
        };

        void floatingActionButtonAddMethod() {
           goToCreatePage(context, ref, widgetOptions[selectedMenu.value]["addInstanceRoute"]);
        }

        CustomDarkThemeStyles customDarkThemeStyles = CustomDarkThemeStyles(Theme.of(context).brightness);

        return Scaffold(
            appBar: CustomMenuAppBar(),
            drawer: Drawer(
                // backgroundColor: Colors.pink,
                child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                        DrawerHeader(
                          decoration: BoxDecoration(
                            color: customDarkThemeStyles.getPrimaryColor,
                          ),
                          child: Text(
                            'Menu',
                            style: TextStyle(
                              color: customDarkThemeStyles.getSecundaryColor,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        ListTile(
                            selected: selectedMenu.value == "customer",
                            leading: const Icon(Icons.person),
                            title: Text(tr("Customer")),
                            onTap: () {
                                Navigator.pushNamed(context, AppRoutes.customer);
                            },
                        ),
                        ListTile(
                            selected: selectedMenu.value == "plan",
                            leading: const Icon(Icons.card_membership),
                            title: Text(tr("Membership Plan")),
                            onTap: () {
                                // selectedMenu.value = "plan"; //this was before specific menu routes
                                // Navigator.pop(context);
                                Navigator.pushNamed(context, AppRoutes.plan);
                            },
                        ),
                        ListTile(
                            selected: selectedMenu.value == "modality",
                            leading: const Icon(Icons.fitness_center),
                            title: Text(tr("Modality")),
                            onTap: () {
                                selectedMenu.value = "modality";
                                Navigator.pop(context);
                            },
                        ),
                        ListTile(
                            selected: selectedMenu.value == "attendance",
                            leading: const Icon(Icons.check_circle),
                            title: Text(tr("Attendance")),
                            onTap: () {
                                selectedMenu.value = "attendance";
                                Navigator.pop(context);
                            },
                        ),
                        ListTile(
                            selected: selectedMenu.value == "payment",
                            leading: const Icon(Icons.payment),
                            title: Text(tr("Payment")),
                            onTap: () {
                                selectedMenu.value = "payment";
                                Navigator.pop(context);
                            },
                        )
                    ],
                ),
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: floatingActionButtonAddMethod,
                backgroundColor: customDarkThemeStyles.getPrimaryColor,
                foregroundColor: customDarkThemeStyles.getSecundaryColor,
                child: const Icon(Icons.add),
            ),
            body: SizedBox(
                width: kIsWeb ? MediaQuery.of(context).size.width : null,
                child: Padding(
                  padding: const EdgeInsets.all(kIsWeb ? 15 : 1),
                  child: SizedBox(
                    width: kIsWeb ? MediaQuery.of(context).size.width : null,
                    child: widgetOptions[selectedMenu.value]["widget"],
                  ),
                ),
            ),
        );
    }
}

class CustomMenuAppBar extends ConsumerWidget implements PreferredSizeWidget {
    @override
    Size get preferredSize => const Size.fromHeight(kToolbarHeight);

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        return AppBar(
            actions: <Widget>[
                IconButton(
                    icon: const Icon(Icons.person),
                    tooltip: tr("Profile"),
                    onPressed: () {
                        Navigator.pushNamed(
                            context,
                            AppRoutes.profile
                        );
                    }
                )
            ],
        );
    }
}

checkIfgoogleAccoutJustCreated (context) async {
    // TODO FIXME terrible workaround
    SecureStorage secureStorage = SecureStorage();
    var googleAccoutJustCreated = await SecureStorage().readSecureData("googleAccoutJustCreated");
    if (googleAccoutJustCreated.isNotEmpty){
        showSnackBar(context, "Account created successfully.", "success");
    }
    await secureStorage.deleteSecureData("googleAccoutJustCreated");
}
