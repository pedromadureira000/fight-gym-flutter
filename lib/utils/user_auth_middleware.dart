import 'package:flutter/material.dart';
import 'package:fight_gym/config/app_routes.dart';
import 'package:fight_gym/data/local_storage/secure_storage.dart';


redirectToMenu(context, {bool mustBeLoggedOut=false}) async {
    Navigator.of(context).popUntil((route) => route.isFirst);
    WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(
            context,
            AppRoutes.menu
        );
    });
}

redirectToLoginPage(context, {bool mustBeLoggedOut=false}) async {
    Navigator.of(context).popUntil((route) => route.isFirst);
    WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(
            context,
            AppRoutes.login
        );
    });
}

userAuthMiddleware(context, {bool mustBeLoggedOut=false}) async {
    var token = await SecureStorage().readSecureData('token');
    if (mustBeLoggedOut && token.isNotEmpty){
        redirectToMenu(context);
    }
    if (token.isEmpty && !mustBeLoggedOut){
        redirectToLoginPage(context);
    }
}
