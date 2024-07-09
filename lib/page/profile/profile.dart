import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:fight_gym/components/dropdown.dart" show SelectLanguage;
import "package:fight_gym/config/app_config.dart";
import "package:fight_gym/config/app_routes.dart";
import "package:fight_gym/constants/constants.dart";
import "package:fight_gym/data/local_storage/secure_storage.dart";
import "package:fight_gym/model/models.dart";
import "package:fight_gym/provider/configurations_provider.dart";
import "package:fight_gym/provider/login_provider.dart";
import "package:fight_gym/styles/app_colors.dart";
import "package:fight_gym/styles/app_text.dart";
import "package:fight_gym/utils/lunch_url.dart";
import "package:fight_gym/utils/snackbar.dart";
import "package:fight_gym/utils/user_auth_middleware.dart";
import "package:fight_gym/utils/utils.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:flutter/foundation.dart" show kIsWeb;


class ProfilePage extends HookConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
        userAuthMiddleware(context);
        return null;
    }, const []);

    final asyncUser = ref.watch(asyncUserProvider);

    switch (asyncUser) {
        case AsyncData():
            return _ProfileBody(asyncUser.value);
        case AsyncError():
            var error = asyncUser.error;
            // WORKAROUND - Logout
            if (error.toString() == "Exception: The user's token is missing"){
                Navigator.of(context).popUntil((route) => route.isFirst);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.login
                    );
                });
                return const Center(child: CircularProgressIndicator());
            }
            if (error.toString() == "Exception: unauthorized. Token is wrong"){
                Navigator.of(context).popUntil((route) => route.isFirst);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.login
                    );
                });
                return const Center(child: CircularProgressIndicator());
            }
            AppConfig.logger.d('Unexpected error | error.toString(): --> : ${error.toString()}');
            User fodderUser = User(name: "", phone: "", email: ""); // Workaround
            return _ProfileBody(fodderUser);
        default:
            return const Center(child: CircularProgressIndicator());
    }
  }
}

class _ProfileBody extends HookConsumerWidget {
    final User user;
    const _ProfileBody(this.user);

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        final currentPasswordController = useTextEditingController();
        final newPasswordController = useTextEditingController();
        final confirmPasswordController = useTextEditingController();
        final nameController = useTextEditingController();
        final phoneController = useTextEditingController();

        useEffect(() {
            nameController.text = user.name;
            phoneController.text = user.phone;
            return null;
        }, const []);

        String lightThemeStr = tr("Light theme");
        String darkThemeStr = tr("Dark theme");

        CustomDarkThemeStyles customDarkThemeStyles = CustomDarkThemeStyles(Theme.of(context).brightness);

        CustomContainer userInfoContainer = CustomContainer(
            customDarkThemeStyles,
            containerChildren: [
                // User Information
                Text(
                    tr("User Information"),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SizedBox(
                    width: kIsWeb ? 300.0 : null,
                    child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(labelText: tr("Name")),
                    ),
                ),
                SizedBox(
                    width: kIsWeb ? 300.0 : null,
                    child: TextFormField(
                        initialValue: user.email,
                        decoration: const InputDecoration(labelText: "email"),
                        enabled: false,
                    ),
                ),
                SizedBox(
                    width: kIsWeb ? 300.0 : null,
                    child: TextFormField(
                        controller: phoneController,
                        decoration: const InputDecoration(labelText: "Phone"),
                    ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                    onPressed: () {
                        Map data = {
                            "name": nameController.text.trim(),
                            "phone": phoneController.text.trim(),
                        };
                        updateProfile(ref, data, context);
                    },
                    style: customDarkThemeStyles.elevatedBtnStyleInsideContainer,
                    child: Text(tr("Update Profile"), style: AppText.normalText),
                ),
            ]
        );

        CustomContainer passwordUpdateContainer = CustomContainer(
            customDarkThemeStyles,
            containerChildren: [
                // kIsWeb ? const Spacer(): const SizedBox(height: 20),
                Text(
                    tr("Change Password"),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SizedBox(
                    width: kIsWeb ? 300.0 : null,
                    child: TextFormField(
                        controller: currentPasswordController,
                        decoration: InputDecoration(labelText: tr("Current Password")),
                        obscureText: true,
                    ),
                ),
                SizedBox(
                    width: kIsWeb ? 300.0 : null,
                    child: TextFormField(
                        controller: newPasswordController,
                        decoration: InputDecoration(labelText: tr("New Password")),
                        obscureText: true,
                    ),
                ),
                SizedBox(
                    width: kIsWeb ? 300.0 : null,
                    child: TextFormField(
                        controller: confirmPasswordController,
                        decoration: InputDecoration(labelText: tr("Confirm Password")),
                        obscureText: true,
                    ),
                ),
                const SizedBox(height: 10),
                Text(
                    tr("After changing the password you will have to log in again"),
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w300),
                ),
                ElevatedButton(
                    onPressed: () {
                        if (newPasswordController.text == confirmPasswordController.text){
                            Map data = {
                                "new_password": newPasswordController.text.trim(),
                                "current_password": currentPasswordController.text.trim()
                            };
                            changePasswordAndpushToLoginPage(ref, context, data);
                        }
                        else {
                            showSnackBar(
                                context, "Passwords do not match",
                                "warning"
                            );
                        }
                    },
                    style: customDarkThemeStyles.elevatedBtnStyleInsideContainer,
                    child: Text(tr("Change Password"), style: AppText.normalText),
                ),
            ]
        );
        CustomContainer otherOptions = CustomContainer(
            customDarkThemeStyles,
            containerChildren: [
                Text(
                    tr("Other Options"),
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Text(
                            Theme.of(context).brightness == Brightness.light ? lightThemeStr : darkThemeStr,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                        ),
                        const SwitchTheme(),
                    ]
                ), 
                const SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Text(
                            tr("Language"),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                        ),
                        const SelectLanguage(),
                    ]
                ), 
                const SizedBox(height: 10),
                Constants.trialStatus.contains(user.subscription_status) ? ElevatedButton(
                    style: customDarkThemeStyles.elevatedBtnStyle,
                    onPressed: () async {
                        String currentCountry = await ref.read(asyncUserProvider.notifier).getCountry();
                        if (currentCountry == "BR"){
                            launchURL(AppConfig.paymentLinkBR);
                        }
                        else {
                            launchURL(AppConfig.paymentLink);
                        }
                    },
                    child: Text(
                        tr("Subscribe"),
                        style: AppText.normalText
                    ),
                ) :
                ElevatedButton(
                    style: customDarkThemeStyles.elevatedBtnStyle,
                    onPressed: () {
                        launchURL(AppConfig.customerPortalLink);
                    },
                    child: Text(
                        tr("Customer portal link"),
                        style: AppText.normalText
                    ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                    onPressed: () {
                        deleteTokenAndInvalidateProvider(ref, context);
                    },
                    style: customDarkThemeStyles.elevatedBtnStyleInsideContainer,
                    child: const Text("Logout", style: AppText.normalText),
                ),
            ]
        );

        return Scaffold(
            appBar: AppBar(
                title: Text(tr("Profile")),
                leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: customDarkThemeStyles.arrowBackColor),
                    onPressed: () {
                        Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.menu
                        );
                    },
                ),
            ),
            body: SingleChildScrollView(
                child: SizedBox(
                    height: kIsWeb ? MediaQuery.of(context).size.height : null,
                    width: kIsWeb ? MediaQuery.of(context).size.width : null,
                    child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                            crossAxisAlignment: kIsWeb ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                            children: kIsWeb ? [
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                        userInfoContainer,
                                        passwordUpdateContainer,
                                        otherOptions
                                    ],
                                )
                            ] : [
                                    userInfoContainer,
                                    const SizedBox(height: 8),
                                    passwordUpdateContainer,
                                    const SizedBox(height: 8),
                                    otherOptions,
                                ],
                        ),
                    )
                )
            )
        );
    }
}

// THis causes the widget to re-build (2 times I think)
deleteTokenAndInvalidateProvider (ref, context) async {
    var notifier = ref.read(asyncUserProvider.notifier);
    var isGoogleSigninAccount = await SecureStorage().readSecureData("is_google_signin_account");
    if (isGoogleSigninAccount.isNotEmpty){
        var loginWithGoogle = notifier.getGoogleSignInModule();
        await loginWithGoogle.signOut();
    }
    ref.invalidate(asyncUserProvider);
    notifier.deleteToken();
}

changePasswordAndpushToLoginPage (ref, context, data) async{
    var notifier = ref.read(asyncUserProvider.notifier);
    var result = await notifier.updatePassword(data);
    if (result == "success"){
        var isGoogleSigninAccount = await SecureStorage().readSecureData("is_google_signin_account");
        if (isGoogleSigninAccount.isNotEmpty){
            var loginWithGoogle = notifier.getGoogleSignInModule();
            await loginWithGoogle.signOut();
            showSnackBar(context, "Password updated successfully", "success");
            FocusManager.instance.primaryFocus?.unfocus();
        }
        ref.invalidate(asyncUserProvider);
    }
    else {
        showSnackBar(context, result, "error");
    }
}

updateProfile (ref, data, context) async{
    var notifier = ref.read(asyncUserProvider.notifier);
    var result = await notifier.updateProfile(data);
    if (result == "success"){
            showSnackBar(context, "Profile updated successfully", "success");
            FocusManager.instance.primaryFocus?.unfocus();
            ref.refresh(asyncUserProvider.future);
    }
    else {
        showSnackBar(context, result, "error");
    }
}


class CustomContainer extends StatelessWidget {
    const CustomContainer(this.customDarkThemeStyles, {super.key, this.containerChildren = const []});
    final List<Widget> containerChildren;
    final CustomDarkThemeStyles customDarkThemeStyles;

    @override
    Widget build(BuildContext context) {
        return Container(
            decoration: BoxDecoration(
                // color: customDarkThemeStyles.containerColor, // it's transparent now. To look like google
                borderRadius: BorderRadius.circular(14),
                border: Border.all(width: 1.0, color: Colors.grey),
            ),
            width: kIsWeb ? 300 : MediaQuery.of(context).size.width,
            height: kIsWeb ? 320 : null,
            margin: const EdgeInsets.only(bottom: 5),
            padding: const EdgeInsets.all(15),
            child: Column(
                children: containerChildren
            ), 
        );
    }
}

class SwitchTheme extends HookConsumerWidget {
    const SwitchTheme({super.key});

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        var configs = ref.watch(asyncConfigsProvider);
        String theme = configs.value!.theme;
        final switchValue = useState(theme == "light" ? true : false);

        return Switch(
            // This bool value toggles the switch.
            value: switchValue.value,
            activeColor: Colors.grey,
            activeTrackColor: Colors.grey[350],
            onChanged: (bool value) {
                // This is called when the user toggles the switch.
                switchValue.value = value;
                changeTheme(context, ref);
            },
        );
    }
}

changeTheme(context, ref) async {
    SecureStorage secureStorage = SecureStorage();
    String currentTheme = await secureStorage.readSecureData("themeMode");
    await secureStorage.writeSecureData("themeMode", currentTheme == "dark" ? "light" : "dark");
    ref.invalidate(asyncConfigsProvider);
}
