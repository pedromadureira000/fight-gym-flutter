import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:fight_gym/config/app_icons.dart';
import 'package:fight_gym/styles/app_colors.dart';

// import 'stub.dart';


/// Renders a SIGN IN button that calls `handleSignIn` onclick.
// Widget buildSignInButton({HandleSignInFn? onPressed, loginWithGoogle}) {
Widget buildSignInButton({loginWithGoogle, brightness}) {
    CustomDarkThemeStyles customDarkThemeStyles = CustomDarkThemeStyles(brightness);
    return SizedBox(
      height: 48,
      width: kIsWeb ? 450.0 : null,
      child: ElevatedButton(
        onPressed: () {
            loginWithGoogle.handleSignIn();
        },
        style: customDarkThemeStyles.googleBtnOnMobileStyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppIcons.icGoogle,
              width: 22,
              height: 22,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(tr("Continue with Google")),
          ],
        ),
      ),
    );
}
