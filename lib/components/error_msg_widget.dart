import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:fight_gym/constants/constants.dart";
import "package:fight_gym/styles/app_text.dart";
import "package:fight_gym/utils/subscription_pending.dart";
import "package:fight_gym/utils/utils.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class ErrorMessageWidget extends HookConsumerWidget {
  const ErrorMessageWidget({Key? key, required this.message, this.provider, required this.error}) : super(key: key);
  final String message;
  final AsyncNotifierProvider? provider;
  final Object error;

  @override
    Widget build(BuildContext context, WidgetRef ref) {
        Map? blockUserErrorMsgs = Constants.blockUserErrors["$error"];
        bool isConnectivityError = "$error" == "Exception: ConnectivityError";
        print('isConnectivityError : $isConnectivityError');
        print('error : $error');

        useEffect(() {
            if (blockUserErrorMsgs != null){
                WidgetsBinding.instance.addPostFrameCallback((_) {
                    showSubscriptionPaymentPendingDialog(context, ref, blockUserErrorMsgs);
                });
            }
            if (isConnectivityError){
                WidgetsBinding.instance.addPostFrameCallback((_) {
                    showConnectivityErrorDialog(context, ref, blockUserErrorMsgs);
                });
            }
            return null;
        }, const []);

        return Center(
            child: Column(
                children: [
                    Text(
                        message,
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                        onPressed: () {
                            if (provider != null) {
                                ref.refresh(provider!.future);
                            }
                            goToMenu(context);
                        },
                        child: Text(tr("Refresh"), style: AppText.normalText),
                    ),
                ]
            ),
        );
  }
}
