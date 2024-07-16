import 'package:fight_gym/model/models.dart';
import 'package:fight_gym/provider/modules/class_provider.dart';
import "package:fight_gym/provider/modules/customer_provider.dart";
import 'package:fight_gym/provider/modules/payment_provider.dart';
import 'package:fight_gym/provider/modules/plan_provider.dart';
import 'package:fight_gym/provider/modules/modality_provider.dart';
import 'package:fight_gym/provider/modules/attendance_provider.dart';
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

    customer: (params) => const MenuPage(),
    plan: (params) => const MenuPage(),
    modality: (params) => const MenuPage(),
    classMenuRoute: (params) => const MenuPage(),
    attendance: (params) => const MenuPage(),
    payment: (params) => const MenuPage(),

    customerCreate: (params) => CreateOrUpdatePage(
        params: params,
        menuRoute: customer,
        updateUrl: customerUpdate, // NOTE: THIS IS UPDATE. Don't put create ❗
        provider: asyncCustomersProvider,
        fodderRecordObj: Customer(name: "fodderRecordObj", enrollment: {}),
        addRecordLabel: "Add Customer",
        updateRecordLabel: "Update Customer",
    ),
    customerUpdate: (params) => CreateOrUpdatePage(
        params: params,
        menuRoute: customer,
        updateUrl: customerUpdate, // NOTE: THIS IS UPDATE. Don't put create ❗
        provider: asyncCustomersProvider,
        fodderRecordObj: Customer(name: "fodderRecordObj", enrollment: {}),
        addRecordLabel: "Add Customer",
        updateRecordLabel: "Update Customer",
    ),
    planCreate: (params) => CreateOrUpdatePage(
        params: params,
        menuRoute: plan,
        updateUrl: planUpdate, // NOTE: THIS IS UPDATE. Don't put create ❗
        provider: asyncPlansProvider,
        fodderRecordObj: Plan(plan_name: "fodderRecordObj", price: 99),
        addRecordLabel: "Add Plan",
        updateRecordLabel: "Update Plan",
    ),
    planUpdate: (params) => CreateOrUpdatePage(
        params: params,
        menuRoute: plan,
        updateUrl: planUpdate, // NOTE: THIS IS UPDATE. Don't put create ❗
        provider: asyncPlansProvider,
        fodderRecordObj: Plan(plan_name: "fodderRecordObj", price: 99),
        addRecordLabel: "Add Plan",
        updateRecordLabel: "Update Plan",
    ),
    modalityCreate: (params) => CreateOrUpdatePage(
        params: params,
        menuRoute: modality,
        updateUrl: modalityUpdate, // NOTE: THIS IS UPDATE. Don't put create ❗
        provider: asyncModalityProvider,
        fodderRecordObj: Modality(name: "fodderRecordObj"),
        addRecordLabel: "Add Modality",
        updateRecordLabel: "Update Modality",
    ),
    modalityUpdate: (params) => CreateOrUpdatePage(
        params: params,
        menuRoute: modality,
        updateUrl: modalityUpdate, // NOTE: THIS IS UPDATE. Don't put create ❗
        provider: asyncModalityProvider,
        fodderRecordObj: Modality(name: "fodderRecordObj"),
        addRecordLabel: "Add Modality",
        updateRecordLabel: "Update Modality",
    ),
    classCreate: (params) => CreateOrUpdatePage(
        params: params,
        menuRoute: classMenuRoute,
        updateUrl: classUpdate, // NOTE: THIS IS UPDATE. Don't put create ❗
        provider: asyncClassProvider,
        fodderRecordObj: Class(
            modality: {},
            start_time: "14:30:00",
            end_time: "14:30:00",
            max_participants: 99
        ),
        addRecordLabel: "Add Class",
        updateRecordLabel: "Update Class",
    ),
    classUpdate: (params) => CreateOrUpdatePage(
        params: params,
        menuRoute: classMenuRoute,
        updateUrl: classUpdate, // NOTE: THIS IS UPDATE. Don't put create ❗
        provider: asyncClassProvider,
        fodderRecordObj: Class(
            modality: {},
            start_time: "14:30:00",
            end_time: "14:30:00",
            max_participants: 99
        ),
        addRecordLabel: "Add Class",
        updateRecordLabel: "Update Class",
    ),
    attendanceCreate: (params) => CreateOrUpdatePage(
        params: params,
        menuRoute: attendance,
        updateUrl: attendanceUpdate, // NOTE: THIS IS UPDATE. Don't put create ❗
        provider: asyncAttendanceProvider,
        fodderRecordObj: Attendance(customer: {}, class_instance: {}, date: "2024-10-10"),
        addRecordLabel: "Add Attendance",
        updateRecordLabel: "Update Attendance",
    ),
    attendanceUpdate: (params) => CreateOrUpdatePage(
        params: params,
        menuRoute: attendance,
        updateUrl: attendanceUpdate, // NOTE: THIS IS UPDATE. Don't put create ❗
        provider: asyncAttendanceProvider,
        fodderRecordObj: Attendance(customer: {}, class_instance: {}, date: "2024-10-10"),
        addRecordLabel: "Add Attendance",
        updateRecordLabel: "Update Attendance",
    ),
    paymentCreate: (params) => CreateOrUpdatePage(
        params: params,
        menuRoute: payment,
        updateUrl: paymentUpdate, // NOTE: THIS IS UPDATE. Don't put create ❗
        provider: asyncPaymentProvider,
        fodderRecordObj: Payment(
            enrollment: {}, payment_date: DateTime.now(), amount: 99.99, payment_method: 1, transaction_id: null
        ),
        addRecordLabel: "Add Payment",
        updateRecordLabel: "Update Payment",
    ),
    paymentUpdate: (params) => CreateOrUpdatePage(
        params: params,
        menuRoute: payment,
        updateUrl: paymentUpdate, // NOTE: THIS IS UPDATE. Don't put create ❗
        provider: asyncPaymentProvider,
        fodderRecordObj: Payment(
            enrollment: {}, payment_date: DateTime.now(), amount: 99.99, payment_method: 1, transaction_id: null
        ),
        addRecordLabel: "Add Payment",
        updateRecordLabel: "Update Payment",
    ),
  };

  static const login = '/login';
  static const profile = '/profile';
  static const sendResetPasswordEmail = '/reset_password_email';
  static const signUp = '/sign_up';
  static const menu = '/menu';

  static const customer = '/customer';
  static const plan = '/plan';
  static const modality = '/modality';
  static const classMenuRoute = '/class';
  static const attendance = '/attendance';
  static const payment = '/payment';

  static const customerCreate = '/customer_create';
  static const customerUpdate = '/customer_update';
  static const planCreate = '/plan_create';
  static const planUpdate = '/plan_update';
  static const modalityCreate = '/modality_create';
  static const modalityUpdate = '/modality_update';
  static const classCreate = '/class_create';
  static const classUpdate = '/class_update';
  static const attendanceCreate = '/attendance_create';
  static const attendanceUpdate = '/attendance_update';
  static const paymentCreate = '/payment_create';
  static const paymentUpdate = '/payment_update';
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
