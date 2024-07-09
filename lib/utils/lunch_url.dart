import 'package:url_launcher/url_launcher.dart';

launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    // AppConfig.logger.d('uri: --> : $uri');
    // if (await canLaunchUrl(uri)){
        // await launchUrl(uri);
    // } else {
        // throw Exception('Could not launch $url');
    // }
    try {
        await launchUrl(uri);
    } catch (err, stack) {
        // AppConfig.logger.d('err $err');
        // AppConfig.logger.d('stack $stack');
        // throw Exception(err);
    }
}
