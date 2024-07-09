import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:fight_gym/config/app_config.dart";
import "package:fight_gym/config/app_routes.dart";
import "package:fight_gym/constants/constants.dart";
import "package:fight_gym/page/login/login_page.dart";
import "package:fight_gym/provider/login_provider.dart";
import "package:fight_gym/styles/app_colors.dart";
import "package:fight_gym/styles/app_text.dart";
import "package:fight_gym/utils/error_handler.dart";
import "package:fight_gym/utils/google_sign_in_helper.dart";
import "package:fight_gym/utils/snackbar.dart";
import "package:fight_gym/utils/utils.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:flutter/foundation.dart" show kIsWeb;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fight_gym/page/login/google_sig_in_btn.dart';


class SignUpPage extends HookConsumerWidget {
    const SignUpPage({super.key});

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        if (kIsWeb && isWebBrowserOnMobile(context)){
            return MobileBrowserAlert();
        }

        final asyncUser = ref.watch(asyncUserProvider);
        switch (asyncUser) {
            case AsyncData():
                // XXX NOTE: For some reason when click on oneTapGoogleDialog on signUp page, addPostFrameCallback don't work. Becouse of that I had to sue future delay
                // WidgetsBinding.instance.addPostFrameCallback((_) {...});
                Navigator.of(context).popUntil((route) => route.isFirst);
                Future.delayed(const Duration(milliseconds: 100), (){
                    Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.menu
                    );
                });
                return const Center(child: CircularProgressIndicator());
            case AsyncError():
                var error = asyncUser.error;
                // WORKAROUND - Logout
                if (error.toString() == "Exception: The user's token is missing"){
                    return const _SignUpPage();
                }
                if (error.toString() == "Exception: unauthorized. Token is wrong"){
                    return const _SignUpPage();
                }
                AppConfig.logger.d('error.toString() ${error.toString()}');
                return const _SignUpPage();
            default:
                return const Center(child: CircularProgressIndicator());
        }
    }
}

class _SignUpPage extends HookConsumerWidget {
    const _SignUpPage({super.key});

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        final phoneController = useTextEditingController();
        final nameController = useTextEditingController();
        final emailController = useTextEditingController();
        final passwordController = useTextEditingController();
        final confirmPasswordController = useTextEditingController();

        CustomDarkThemeStyles customDarkThemeStyles = CustomDarkThemeStyles(Theme.of(context).brightness);

        var userProv = ref.read(asyncUserProvider.notifier);
        final LoginWithGoogle loginWithGoogle = userProv.getGoogleSignInModule();

        return Scaffold(
            appBar: AppBar(
                title: Text(tr("Sign up")),
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                        Future.delayed(const Duration(milliseconds: 1), (){
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                Navigator.pushReplacementNamed(
                                    context,
                                    AppRoutes.login
                                );
                            });
                        });
                    },
                ),
            ),
            body: SingleChildScrollView(
                child: SizedBox(
                    width: kIsWeb ? MediaQuery.of(context).size.width : null,
                    child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                                Text(
                                    tr("Sign up with Google"),
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                buildSignInButton(loginWithGoogle: loginWithGoogle, brightness: Theme.of(context).brightness),
                                const SizedBox(
                                  height: 25,
                                ),
                                Text(
                                    tr("Sign up form"),
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                    width: kIsWeb ? 400 : null,
                                    child: TextFormField(
                                        controller: nameController,
                                        maxLength: 45,
                                        decoration: InputDecoration(labelText: tr("Name")),
                                    )
                                ),
                                SizedBox(
                                    width: kIsWeb ? 400 : null,
                                    child: TextFormField(
                                        maxLength: 60,
                                        controller: emailController,
                                        decoration: const InputDecoration(labelText: "Email"),
                                    )
                                ),
                                SizedBox(
                                    width: kIsWeb ? 400 : null,
                                    child: TextFormField(
                                        maxLength: 45,
                                        controller: phoneController,
                                        decoration: InputDecoration(labelText: tr("Phone (Optional)")),
                                    )
                                ),
                                SizedBox(
                                    width: kIsWeb ? 400 : null,
                                    child: TextFormField(
                                        maxLength: 45,
                                        controller: passwordController,
                                        decoration: InputDecoration(labelText: tr("Password")),
                                        obscureText: true,
                                    )
                                ),
                                SizedBox(
                                    width: kIsWeb ? 400 : null,
                                    child: TextFormField(
                                        maxLength: 45,
                                        controller: confirmPasswordController,
                                        decoration: InputDecoration(labelText: tr("Confirm Password")),
                                        obscureText: true,
                                    )
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                    height: 48,
                                    width: 400,
                                    child: ElevatedButton(
                                        onPressed: () {
                                            if (emailController.text.isEmpty){
                                                showSnackBar(
                                                    context, "The Email can't be empty.",
                                                    "warning"
                                                );
                                                return;
                                            }
                                            if (passwordController.text.isEmpty){
                                                showSnackBar(
                                                    context, "The Password can't be empty.",
                                                    "warning"
                                                );
                                                return;
                                            }
                                            if (passwordController.text != confirmPasswordController.text){
                                                showSnackBar(
                                                    context, "The Password and the Confirmation Password didn't match.",
                                                    "warning"
                                                );
                                                return;
                                            }
                                            Map data = {
                                                "name": nameController.text.trim(),
                                                "email": emailController.text.trim(),
                                                "phone": phoneController.text.trim(),
                                                "password": passwordController.text.trim(),
                                                "confirm_password": confirmPasswordController.text.trim(),
                                            };
                                            createAccount(ref, context, data);
                                        },
                                        style: customDarkThemeStyles.elevatedBtnStyle,
                                        child: Text(tr("Create account"), style: AppText.normalText),
                                    ),
                                ),
                            ],
                        ),
                    )
                )
            )
        );
    }
}

createAccount (ref, context, Map data) async{
    try {
        var jsonBody = json.encode(data);
        final response = await http.post(
            Uri.parse('${AppConfig.backUrl}/user/sign_up'),
            headers: Constants.httpRequestHeadersWithJsonBodyWithoutToken(),
            body:jsonBody 
        );
        if (response.statusCode != 200){
            var errMsg = getErrorMsg(response, Constants.defaultErrorMsg);
            showSnackBar(context, errMsg, "error");
        }
        else {
            showSnackBar(context, "Account created. Please verify via email.", "success");
        }
    } catch (err, stack) {
        AppConfig.logger.d('err: --> : $err');
        showSnackBar(context, Constants.defaultErrorMsg, "error");
    }
}
