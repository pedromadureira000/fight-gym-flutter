import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:fight_gym/config/app_config.dart";
import "package:fight_gym/config/app_routes.dart";
import "package:fight_gym/constants/constants.dart";
import "package:fight_gym/provider/reset_pass_provider.dart";
import "package:fight_gym/styles/app_colors.dart";
import "package:fight_gym/styles/app_text.dart";
import "package:fight_gym/utils/error_handler.dart";
import "package:fight_gym/utils/snackbar.dart";
import "package:fight_gym/utils/user_auth_middleware.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:flutter/foundation.dart" show kIsWeb;
import 'dart:convert';
import 'package:http/http.dart' as http;


class SendResetPasswordEmail extends HookConsumerWidget {
    const SendResetPasswordEmail({super.key});

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        useEffect(() {
            userAuthMiddleware(context, mustBeLoggedOut: true);
            return null;
        }, const []);

        final emailController = useTextEditingController();
        CustomDarkThemeStyles customDarkThemeStyles = CustomDarkThemeStyles(Theme.of(context).brightness);

        return Scaffold(
            appBar: AppBar(
                title: Text(tr("Sign up")),
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                        ref.invalidate(asyncResetPasswordProvider);
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
                                    tr("Reset your password"),
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                    tr("An email to reset your password will be sent to you"),
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                    width: kIsWeb ? 400 : null,
                                    child: TextFormField(
                                        maxLength: 60,
                                        controller: emailController,
                                        decoration: const InputDecoration(labelText: "Email"),
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
                                                    context, "The email can't be empty.",
                                                    "warning"
                                                );
                                                return;
                                            }
                                            Map data = {
                                                "email": emailController.text.trim(),
                                            };
                                            sendEmailToResetPassword(context, data);
                                        },
                                        style: customDarkThemeStyles.elevatedBtnStyle,
                                        child: Text(tr("Reset"), style: AppText.normalText),
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

sendEmailToResetPassword (context, Map data) async{
    try {
        var jsonBody = json.encode(data);
        final response = await http.post(
            Uri.parse('${AppConfig.backUrl}/user/reset_password_email'),
            headers: Constants.httpRequestHeadersWithJsonBodyWithoutToken(),
            body:jsonBody
        );
        if (response.statusCode != 200){
            var errMsg = getErrorMsg(response, Constants.defaultErrorMsg);
            showSnackBar(context, errMsg, "error");
        }
        else {
            showSnackBar(context, "An email to reset your password has been sent to you", "success");
        }
    } catch (err, stack) {
        AppConfig.logger.d('err: --> : $err');
        showSnackBar(context, Constants.defaultErrorMsg, "error");
    }
}
