import 'dart:io' as dartIO;
import 'package:fight_gym/config/app_routes.dart';
import 'package:fight_gym/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import "package:easy_localization/easy_localization.dart";
// import 'package:fight_gym/components/qrcode/fodder.dart' if (dart.library.html) 'dart:html' as html;
// import 'dart:html' as html;
import 'package:fight_gym/components/qrcode/save_file.dart';


class CreateCustomerQrCodeBtn extends HookConsumerWidget {
    CreateCustomerQrCodeBtn({
        super.key,
        this.record
    });
    dynamic record;

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        CustomDarkThemeStyles customDarkThemeStyles = CustomDarkThemeStyles(Theme.of(context).brightness);
        return ElevatedButton(
            onPressed: () {
                saveFile(record);
            },
            style: customDarkThemeStyles.elevatedBtnStyleInsideContainer,
            child: RichText(
                text: TextSpan(
                    children: [
                        const WidgetSpan(
                            child: Icon(Icons.qr_code, size: 19),
                        ),
                        TextSpan(
                            text: tr("Generate QR code"),
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).brightness == Brightness.light
                                  ? AppColors.lightBackground
                                  : Colors.black,
                            ),
                        ),
                    ],
                ),
            ),
        );
    }
}

class GoToScanCustomerQrCodeBtn extends HookConsumerWidget {
    GoToScanCustomerQrCodeBtn({
        super.key,
        this.record
    });
    dynamic record;

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        CustomDarkThemeStyles customDarkThemeStyles = CustomDarkThemeStyles(Theme.of(context).brightness);
        return ElevatedButton(
            onPressed: () {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushNamed(
                        context,
                        AppRoutes.scanCustomerQrCode,
                        arguments: {
                            "record": record
                        }
                    );
                });
            },
            style: customDarkThemeStyles.elevatedBtnStyleInsideContainer,
            child: RichText(
                text: TextSpan(
                    children: [
                        const WidgetSpan(
                            child: Icon(Icons.qr_code, size: 19),
                        ),
                        TextSpan(
                            text: tr("Register attendance by QR code"),
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).brightness == Brightness.light
                                  ? AppColors.lightBackground
                                  : Colors.black,
                            ),
                        ),
                    ],
                ),
            ),
        );
    }
}
