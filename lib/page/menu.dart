import "package:easy_localization/easy_localization.dart";
import "package:fight_gym/page/customer/customer.dart";
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

        final ValueNotifier selectedIndex = useState(0);

        const List<Widget> widgetOptions = <Widget>[
            CustomerWidget(),
            Text(
                'Index 1: MembershipPlan',
            ),
            Text(
                'Index 2: Modality',
            ),
            Text(
                'Index 3: Attendance',
            ),
            Text(
                'Index 4: Payment',
            ),
        ];

        void onItemTapped(int index) {
            selectedIndex.value = index;
        }

        return Scaffold(
            appBar: CustomMenuAppBar(),
            drawer: Drawer(
                child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                        const DrawerHeader(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                          ),
                          child: Text(
                            'Menu',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        ListTile(
                            selected: selectedIndex.value == 0,
                            leading: const Icon(Icons.person),
                            title: Text(tr("Customer")),
                            onTap: () {
                                onItemTapped(0);
                                Navigator.pop(context);
                            },
                        ),
                        ListTile(
                            selected: selectedIndex.value == 1,
                            leading: const Icon(Icons.card_membership),
                            title: Text(tr("Membership Plan")),
                            onTap: () {
                                onItemTapped(1);
                                Navigator.pop(context);
                                // Navigator.pop(context); // Close the drawer
                                // Navigator.pushReplacementNamed(
                                    // context,
                                    // AppRoutes.profile
                                // );
                            },
                        ),
                        ListTile(
                            selected: selectedIndex.value == 2,
                            leading: const Icon(Icons.fitness_center),
                            title: Text(tr("Modality")),
                            onTap: () {
                                onItemTapped(2);
                                Navigator.pop(context);
                            },
                        ),
                        ListTile(
                            selected: selectedIndex.value == 3,
                            leading: const Icon(Icons.check_circle),
                            title: Text(tr("Attendance")),
                            onTap: () {
                                onItemTapped(3);
                                Navigator.pop(context);
                            },
                        ),
                        ListTile(
                            selected: selectedIndex.value == 4,
                            leading: const Icon(Icons.payment),
                            title: Text(tr("Payment")),
                            onTap: () {
                                onItemTapped(4);
                                Navigator.pop(context);
                            },
                        )
                    ],
                ),
            ),
            body: SizedBox(
                width: kIsWeb ? MediaQuery.of(context).size.width : null,
                child: Padding(
                  padding: const EdgeInsets.all(kIsWeb ? 15 : 1),
                  child: SizedBox(
                    width: kIsWeb ? MediaQuery.of(context).size.width : null,
                    child: Center(
                        child: widgetOptions[selectedIndex.value],
                    ),
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
