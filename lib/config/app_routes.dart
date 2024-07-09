import 'package:flutter/material.dart';
import 'package:fight_gym/page/menu.dart';
import 'package:fight_gym/page/login/login_page.dart';
import 'package:fight_gym/page/profile/profile.dart';
import 'package:fight_gym/page/profile/reset_password.dart';
import 'package:fight_gym/page/profile/sign_up.dart';
// import 'package:fight_gym/page/todo/todo_create_update_page.dart';

class AppRoutes {
  static final pages = {
    login: (params) => const LoginPage(),
    profile: (params) => const ProfilePage(),
    sendResetPasswordEmail: (params) => const SendResetPasswordEmail(),
    signUp: (params) => const SignUpPage(),
    menu: (params) => const MenuPage(),
    // todoCreate: (params) => TodoCreateOrUpdatePage(params: params),
    // todoUpdate: (params) => TodoCreateOrUpdatePage(params: params),
  };

  static const login = '/login';
  static const profile = '/profile';
  static const sendResetPasswordEmail = '/reset_password_email';
  static const signUp = '/sign_up';
  static const menu = '/menu';
  // static const todoCreate = '/task_create';
  // static const todoUpdate = '/task_update';
}

Route<dynamic> getRoute(RouteSettings settings) {
    var uriData = Uri.parse(settings.name!);
    //uriData.path will be your path and uriData.queryParameters will hold query-params values
    var path = uriData.path;
    var queryParameters = uriData.queryParameters;
    // var pathWithQueryParameters = settings.name;
    // var settingsArguments = settings.arguments;
    // AppConfig.logger.d("path $path");
    // AppConfig.logger.d("queryParameters $queryParameters");
    final builder = AppRoutes.pages[path];
    if (builder != null) {
        return _buildRoute(settings, builder, queryParameters);
    }
    return MaterialPageRoute(
        builder: (context) => AppRoutes.pages[AppRoutes.login]!({})
    );
}

MaterialPageRoute _buildRoute(RouteSettings settings, builder, queryParameters) { 
    return MaterialPageRoute(
        settings: settings,
        builder: (ctx) => builder({"queryParameters": queryParameters}),
    );
}
