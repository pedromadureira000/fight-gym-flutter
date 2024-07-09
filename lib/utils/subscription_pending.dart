import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:fight_gym/config/app_config.dart";
import "package:fight_gym/config/app_routes.dart";
import "package:fight_gym/provider/login_provider.dart";
import "package:fight_gym/styles/app_colors.dart";
import "package:fight_gym/utils/lunch_url.dart";
import "dart:ui";

void showSubscriptionPaymentPendingDialog(context, ref, blockUserErrorMsgs) {
    CustomDarkThemeStyles customDarkThemeStyles = CustomDarkThemeStyles(Theme.of(context).brightness);
    showDialog(
        context: context,
        builder: (context) => BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: AlertDialog(
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            content: Container(
              padding: const EdgeInsets.all(20.0), // Add some padding
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0), // Rounded corners
                color: customDarkThemeStyles.inputDecorationFillcolor,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Content won't overflow
                children: [
                  Text(
                    tr(blockUserErrorMsgs["title"]),
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0), // Add some spacing
                  Text(
                    tr(blockUserErrorMsgs["description"]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15.0), // More spacing
                  ElevatedButton(
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
                    child: Text(tr(blockUserErrorMsgs["callToAction"])),
                  ),
                  const SizedBox(height: 15.0), // More spacing
                  ElevatedButton(
                    style: customDarkThemeStyles.elevatedBtnStyle,
                    onPressed: () {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                            Navigator.pushReplacementNamed(
                                context,
                                AppRoutes.profile
                            );
                        });
                    },
                    child: Text(tr("Go to profile page")),
                  ),
                ],
              ),
            ),
          ),
        ),
    );
}

void showConnectivityErrorDialog(context, ref, blockUserErrorMsgs) {
    CustomDarkThemeStyles customDarkThemeStyles = CustomDarkThemeStyles(Theme.of(context).brightness);
    showDialog(
        context: context,
        builder: (context) => BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: AlertDialog(
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            content: Container(
              padding: const EdgeInsets.all(20.0), // Add some padding
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0), // Rounded corners
                color: customDarkThemeStyles.inputDecorationFillcolor,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Content won't overflow
                children: [
                  Text(
                    tr("Connectivity Error"),
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0), // Add some spacing
                  Text(
                    tr("Check your internet connection"),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15.0), // More spacing
                  ElevatedButton(
                    style: customDarkThemeStyles.elevatedBtnStyle,
                    onPressed: () async {
                        Navigator.pop(context);
                    },
                    child: Text(tr("Close")),
                  ),
                ],
              ),
            ),
          ),
        ),
    );
}

