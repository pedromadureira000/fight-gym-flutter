import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:fight_gym/config/app_routes.dart";
import "package:fight_gym/data/local_storage/secure_storage.dart";
import "package:fight_gym/styles/app_colors.dart";
import "package:fight_gym/styles/app_text.dart";
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

        return DefaultTabController(
            initialIndex: 1,
            length: 4,
            child: Scaffold(
                appBar: MenuAppBar(),
                body: SizedBox(
                    width: kIsWeb ? MediaQuery.of(context).size.width : null,
                    child: Padding(
                        padding: const EdgeInsets.all(kIsWeb ? 15 : 1),
                        child: SizedBox(
                            width: kIsWeb ? MediaQuery.of(context).size.width : null,
                            child:  const TabBarView(
                                children: <Widget>[
                                    Text("asdf"),
                                    Text("asdf"),
                                    Text("asdf"),
                                    Text("asdf"),
                                ],
                            ),
                        )
                    )
                ),
            )
        );
    }
}

class MenuAppBar extends ConsumerWidget implements PreferredSizeWidget {
    MenuAppBar({Key? key}) : super(key: key);
    final SecureStorage secureStorage = SecureStorage();

    @override
    Size get preferredSize => const Size.fromHeight(100);

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        // Brightness brightness = Theme.of(context).brightness;
        Text webTabTitleTask = Text(tr("Tasks"), style: AppText.bigerText);
        Text androidTabTitleTask = Text(tr("Tasks"), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold));
        Text webTabTitleNotes = Text(tr("Notes"), style: AppText.bigerText);
        Text androidTabTitleNotes = Text(tr("Notes"), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold));
        Text webTabTitleJournal = Text(tr("Journal"), style: AppText.bigerText);
        Text androidTabTitleJournal = Text(tr("Journal"), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold));
        Text webTabTitleGlossary = Text(tr("Glossary"), style: AppText.bigerText);
        Text androidTabTitleGlossary = Text(tr("Glossary"), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold));
        return AppBar(
            automaticallyImplyLeading: false,
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
            )],
            bottom: TabBar(
                labelColor: AppColors.lightBackground,
                unselectedLabelColor: AppColors.contrastColorForDarkMode,
                indicatorColor: AppColors.lightBackground,
                onTap: (index) {
                },
                tabs: <Widget>[
                    Padding(
                        padding: kIsWeb ? const EdgeInsets.all(15) : const EdgeInsets.fromLTRB(0,15,0,15),
                        child: kIsWeb ? webTabTitleTask : androidTabTitleTask 
                    ),
                    Padding(
                        padding: kIsWeb ? const EdgeInsets.all(15) : const EdgeInsets.fromLTRB(0,15,0,15),
                        child: kIsWeb ? webTabTitleNotes : androidTabTitleNotes
                    ),
                    Padding(
                        padding: kIsWeb ? const EdgeInsets.all(15) : const EdgeInsets.fromLTRB(0,15,0,15),
                        child: kIsWeb ? webTabTitleJournal : androidTabTitleJournal
                    ),
                    Padding(
                        padding: kIsWeb ? const EdgeInsets.all(15) : const EdgeInsets.fromLTRB(0,15,0,15),
                        child: kIsWeb ? webTabTitleGlossary : androidTabTitleGlossary
                    ),
                ],
            ),
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
