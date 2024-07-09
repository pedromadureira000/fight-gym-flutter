import 'package:logger/logger.dart';


class AppConfig {
    static const String scheme = String.fromEnvironment('SCHEME');
    static const String backendIp = String.fromEnvironment('BACKEND_IP');
    static const String backUrl = '$scheme://$backendIp/api';
    static const String paymentLink = String.fromEnvironment('PAYMENT_LINK');
    static const String paymentLinkBR = String.fromEnvironment('PAYMENT_LINK_BR');
    static const String customerPortalLink = String.fromEnvironment('CUSTOMER_PORTAL_LINK'); 
    static final logger = Logger();
    static const String googleWebOAuthclientIdWeb = String.fromEnvironment('GOOGLE_CLIENT_ID_WEB');
    static const String googleWebOAuthclientIdAndroid = String.fromEnvironment('GOOGLE_CLIENT_ID_ANDROID');
    static const String apkDownloadLink = "https://petersoftwarehouse.com/download_apk";
    static String? fcmToken;
}


