import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fight_gym/config/app_config.dart';
import 'package:fight_gym/config/app_routes.dart';
import 'package:fight_gym/firebasestuff/firebase_message_provider.dart';
import 'package:fight_gym/provider/configurations_provider.dart';
import 'package:fight_gym/styles/app_colors.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fight_gym/firebase_options.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:async';


void main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();
    usePathUrlStrategy();

    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
    );

    if (!kIsWeb){
        final fcmToken = await FirebaseMessaging.instance.getToken(vapidKey: "BKagOny0KF_2pCJQ3m....moL0ewzQ8rZu");
        AppConfig.fcmToken = fcmToken;
        AppConfig.logger.d('fcmToken $fcmToken');

        FirebaseMessaging messaging = FirebaseMessaging.instance;

        NotificationSettings settings = await messaging.requestPermission(
            alert: true,
            announcement: false,
            badge: true,
            carPlay: false,
            criticalAlert: false,
            provisional: false,
            sound: true,
        );
        AppConfig.logger.d('User granted permission: ${settings.authorizationStatus}');
    }

    await SentryFlutter.init(
        (options) {
            options.dsn = const String.fromEnvironment('SENTRY_DNS');
            options.tracesSampleRate = 1.0;
            options.profilesSampleRate = 1.0;
        },
    );

    runApp(
        EasyLocalization(
            startLocale: const Locale('pt'),
            supportedLocales: const [Locale('en'), Locale('pt')],
            path: 'assets/translations',
            fallbackLocale: const Locale('pt'),
            child: const ProviderScope(
                child: MyApp(),
            ),
        ) 
    );
  }, (exception, stackTrace) async {
    await Sentry.captureException(exception, stackTrace: stackTrace);
  });
}

class MyApp extends HookConsumerWidget {
    const MyApp({super.key});
    static GlobalKey<NavigatorState> navKey = GlobalKey();

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        useEffect(() {
            var notifier = ref.read(asyncConfigsProvider.notifier);
            if (notifier.setLocale == null){
                var setLocale = (languageCode) => context.setLocale(Locale(languageCode));
                var getLocale = () => context.locale.toString();
                notifier.setsetLocale(setLocale);
                notifier.setgetLocale(getLocale);
            }
            NotificationListenerProvider().getMessage(context);
            return null;
        }, const []);
        var configs = ref.watch(asyncConfigsProvider);

        switch (configs) {
            case AsyncData():
                String theme = configs.value.theme;
                return MaterialApp(
                    navigatorKey: navKey,
                    title: 'Mind Organizer',
                    theme: lightTheme,
                    darkTheme: darkTheme,
                    themeMode: theme == "light" ? ThemeMode.light : ThemeMode.dark,
                    initialRoute: AppRoutes.login,
                    routes: AppRoutes.pages,
                    localizationsDelegates: context.localizationDelegates,
                    supportedLocales: context.supportedLocales,
                    locale: context.locale,
                    onGenerateRoute: getRoute,
                    onGenerateInitialRoutes: (initialRoute) =>
                        [getRoute(RouteSettings(name: initialRoute))],
                );
            case AsyncError():
                var error = configs.error;
                AppConfig.logger.d('Something wrong happened while loading configsProvider || error: --> : ${error.toString()}');
                return MaterialApp(
                    navigatorKey: navKey,
                    title: 'Mind Organizer',
                    theme: lightTheme,
                    darkTheme: darkTheme,
                    themeMode: ThemeMode.dark,
                    initialRoute: AppRoutes.login,
                    routes: AppRoutes.pages,
                    localizationsDelegates: context.localizationDelegates,
                    supportedLocales: context.supportedLocales,
                    locale: context.locale,
                    onGenerateRoute: getRoute,
                );
            default:
                return const Center(child: CircularProgressIndicator());
        }
    }
}
