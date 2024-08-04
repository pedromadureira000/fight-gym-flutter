import 'dart:convert';
import 'dart:async';
import 'package:fight_gym/data/local_storage/secure_storage.dart';
import 'package:fight_gym/utils/error_handler.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fight_gym/config/app_config.dart';
import 'package:fight_gym/constants/constants.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

part 'dashboard_provider.g.dart';


@riverpod // with AutoDispose
class AsyncDashboard extends _$AsyncDashboard {
    @override
    Future<Map<String, dynamic>> build() async {
        return _fetchData();
    }

    Future<Map<String, dynamic>> _fetchData() async {
        var token = await SecureStorage().readSecureData("token");
        if (token.isEmpty) {
            throw Exception("The user's token is missing");
        }

        final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
        if (connectivityResult.contains(ConnectivityResult.none)) {
            throw Exception("ConnectivityError");
        }

        try {
            final response = await http.get(
                Uri.parse("${AppConfig.backUrl}/dashboard"),
                headers: Constants.httpRequestHeaders(token),
            );
            if (response.statusCode == 200) {
                dynamic decodedJsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
                final records = (decodedJsonResponse as List<dynamic>).cast<Map<String, dynamic>>();
                return {
                  "records": records,
                };
            }
            throw getErrorMsg(response, Constants.defaultErrorMsg);
        } catch (err, stack) {
            AppConfig.logger.d("Unknown Error: $err");
            AppConfig.logger.d("Unknown Error: stack $stack");
            throw Exception("Unknown Error");
        }
    }
}
