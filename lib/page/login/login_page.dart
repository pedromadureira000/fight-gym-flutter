import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import "package:fight_gym/components/dropdown.dart" show SelectLanguage;
import 'package:fight_gym/config/app_config.dart';
import 'package:fight_gym/config/app_routes.dart';
import 'package:fight_gym/provider/login_provider.dart';
import 'package:fight_gym/styles/app_colors.dart';
import 'package:fight_gym/styles/app_text.dart';
import 'package:fight_gym/utils/google_sign_in_helper.dart';
import 'package:fight_gym/utils/lunch_url.dart';
import 'package:fight_gym/utils/snackbar.dart';
import 'package:fight_gym/utils/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fight_gym/page/login/google_sig_in_btn.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

//HookConsumerWidget class that combines both HookWidget and ConsumerWidget into a single type.
class LoginPage extends HookConsumerWidget {
    const LoginPage({super.key});

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        var response = ref.watch(asyncUserProvider);

        if (kIsWeb && isWebBrowserOnMobile(context)){
            return MobileBrowserAlert();
        }

        switch (response) {
            case AsyncData():
                WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.menu
                    );
                });
                return const Center(child: CircularProgressIndicator()); // Nonsense line. To avoid error type error.
            case AsyncError():
                var error = response.error;
                // var stackTrace = response.stackTrace; 
                if (error.toString() == "Exception: The user's token is missing"){
                    return const LoginRequired();
                }
                if (error.toString() == "Exception: unauthorized. Token is wrong"){
                    final LoginWithGoogle loginWithGoogle = ref.read(asyncUserProvider.notifier).getGoogleSignInModule();
                    loginWithGoogle.signOut();
                    return const LoginRequired();
                }
                AppConfig.logger.e('Unexpected error | error.toString(): --> : ${error.toString()}'); 
                return const LoginRequired();
            default:
                return const Center(child: CircularProgressIndicator());
        }
    }
}

class LoginRequired extends HookConsumerWidget {
    const LoginRequired({super.key});

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        // Default TextEditingController is a thing that is supposed to be created and closed manually. But when using the hook, it calls dispose() automatically,
        final emailController = useTextEditingController();
        final passwordController = useTextEditingController();

        var userProv = ref.read(asyncUserProvider.notifier);
        final LoginWithGoogle loginWithGoogle = userProv.getGoogleSignInModule();

        // useEffect is the equivalent of initState + didUpdateWidget + dispose.
        // The callback passed to useEffect is executed the first time the hook is
        // invoked, and then whenever the list passed as second parameter changes.
        // Since we pass an empty const list here, that's strictly equivalent to `initState`.
        useEffect(() {
            if (kIsWeb){
                loginWithGoogle.callOneTapUXAndRediredAfterLogin();
            }
            return null;
        }, const []);

        CustomDarkThemeStyles customDarkThemeStyles = CustomDarkThemeStyles(Theme.of(context).brightness);

        return Scaffold(
            // Creates a box in which a single widget can be scrolled
            body: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: kIsWeb ? MediaQuery.of(context).size.width : null,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Spacer creates an adjustable, empty spacer that can be used to tune the spacing between 
                        //.. widgets in a Flex container, like Row or Column.
                        const Spacer(),
                        const Text(
                            "Fight Gym",
                            style: AppText.header1
                        ),
                        Text(
                            tr("System for fight gyms"),
                            style: AppText.header2
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                            tr("Login to continue"),
                            style: AppText.subTitle
                        ),
                        const Spacer(),
                        SizedBox(
                            width: kIsWeb ? 400 : null,
                            child: TextField(
                                controller: emailController,
                                onChanged: (value) {
                                    // context.read<UserProvider>().email = value;
                                },
                                decoration: InputDecoration(
                                    hintText: "Email",
                                    border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(12))
                                    ),
                                    filled: true,
                                    fillColor: customDarkThemeStyles.inputDecorationFillcolor.withOpacity(0.5),
                                ),
                            ),
                        ),
                        const SizedBox(
                            height: 16,
                        ),
                        SizedBox(
                            width: kIsWeb ? 400 : null,
                            child: TextField(
                                onSubmitted: (value){
                                    loginUser(ref, context, emailController, passwordController);
                                },
                                controller: passwordController,
                                obscureText: true,
                                onChanged: (value) {
                                    // context.read<UserProvider>().password = value;
                                },
                                decoration: InputDecoration(
                                    hintText: tr("Password"),
                                    border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(12))),
                                    filled: true,
                                    fillColor: customDarkThemeStyles.inputDecorationFillcolor.withOpacity(0.5),
                                ),
                            ),
                        ),
                        SizedBox(
                            width: kIsWeb ? 400 : null,
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                    style: customDarkThemeStyles.linkStyle,
                                    onPressed: () {
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                            Navigator.pushReplacementNamed(
                                                context,
                                                AppRoutes.sendResetPasswordEmail
                                            );
                                        });
                                    },
                                    child: Text(
                                        tr("Forgot password?"),
                                        style: AppText.subtitleLink3,
                                    ),
                                ),
                            ),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        SizedBox(
                            height: 48,
                            width: 400,
                            child: ElevatedButton(
                                onPressed: () {
                                    loginUser(ref, context, emailController, passwordController);
                                },
                                style: customDarkThemeStyles.elevatedBtnStyle,
                                child: const Text("Login", style: AppText.normalText),
                            ),
                        ),
                        const Spacer(),
                        Text(
                            tr("Or sign in with google"),
                            style: AppText.normalText,
                        ),
                        const SizedBox(
                          height: 16,
                        ),

                        buildSignInButton(loginWithGoogle: loginWithGoogle, brightness: Theme.of(context).brightness),

                        const SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                            width: kIsWeb ? 400 : null,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    Text(
                                        tr("Dont't have account? "),
                                        style: AppText.normalText,
                                    ),
                                    TextButton(
                                        onPressed: () {
                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                                Navigator.pushNamed(
                                                    context,
                                                    AppRoutes.signUp
                                                );
                                            });
                                        },
                                        style: customDarkThemeStyles.linkStyle,
                                        child: Text(
                                            tr("Sign up"),
                                            style: AppText.subtitleLink3,
                                        )),
                                ],
                            ),
                        ),
                        const Spacer(),
                        const SelectLanguage(),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
            ),
        );
    }
}

loginUser(ref, context, emailController, passwordController) async {
    var result = await ref.read(asyncUserProvider.notifier).login(
        emailController.text.trim(),
        passwordController.text.trim(),
    );
    if (result != "success"){
        showSnackBar(context, result, "error");
    }
}


class MobileBrowserAlert extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Text(
                        tr('Please download our app for the best experience on mobile.'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18.0),
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                        onPressed: () {
                            launchURL(AppConfig.apkDownloadLink);
                        },
                        child: Text(tr('Download the App')),
                    ),
                ],
              ),
            ),
          ),
        );
    }
}
