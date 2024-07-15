import 'package:fight_gym/model/models.dart';
import "package:fight_gym/provider/modules/customer_provider.dart";
import 'package:fight_gym/provider/modules/plan_provider.dart';
import 'package:flutter/material.dart';
import 'package:fight_gym/page/menu.dart';
import 'package:fight_gym/page/login/login_page.dart';
import 'package:fight_gym/page/profile/profile.dart';
import 'package:fight_gym/page/profile/reset_password.dart';
import 'package:fight_gym/page/profile/sign_up.dart';
import 'package:fight_gym/page/create_update_page.dart';

class AppRoutes {
  static final pages = {
    login: (params) => const LoginPage(),
    profile: (params) => const ProfilePage(),
    sendResetPasswordEmail: (params) => const SendResetPasswordEmail(),
    signUp: (params) => const SignUpPage(),
    menu: (params) => const MenuPage(),
    customerCreate: (params) => CreateOrUpdatePage(
        params: params,
        updateUrl: "/customer_update",
        provider: asyncCustomersProvider,
        fodderRecordObj: Customer(name: "fodderRecordObj", enrollment: {}),
        // fodderRecordObjCauseFlutterCantPassClsAsParam: Customer(name: "fodderRecordObjCauseFlutterCantPassClsAsParam", enrollment: {}),
    ),
    customerUpdate: (params) => CreateOrUpdatePage(
        params: params,
        updateUrl: "/customer_update",
        provider: asyncCustomersProvider,
        fodderRecordObj: Customer(name: "fodderRecordObj", enrollment: {}),
    ),
    planCreate: (params) => CreateOrUpdatePage(
        params: params,
        updateUrl: "/plan_update",
        provider: asyncPlansProvider,
        fodderRecordObj: Plan(plan_name: "fodderRecordObj", price: 99),
    ),
    planUpdate: (params) => CreateOrUpdatePage(
        params: params,
        updateUrl: "/plan_update",
        provider: asyncPlansProvider,
        fodderRecordObj: Plan(plan_name: "fodderRecordObj", price: 99),
    ),
  };

  static const login = '/login';
  static const profile = '/profile';
  static const sendResetPasswordEmail = '/reset_password_email';
  static const signUp = '/sign_up';
  static const menu = '/menu';
  static const customerCreate = '/customer_create';
  static const customerUpdate = '/customer_update';
  static const planCreate = '/plan_create';
  static const planUpdate = '/plan_update';
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
