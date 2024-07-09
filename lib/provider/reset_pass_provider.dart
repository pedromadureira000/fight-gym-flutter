import 'dart:convert';
import 'package:fight_gym/utils/error_handler.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fight_gym/config/app_config.dart';
import 'package:fight_gym/constants/constants.dart';
import 'package:fight_gym/model/models.dart';

part 'reset_pass_provider.g.dart';

@riverpod // with AutoDispose
class AsyncResetPassword extends _$AsyncResetPassword {
    @override
    FutureOr<User> build() async {
        return _fetchData();
    }

    Future<User> _fetchData() async {
        User fodderUser = User(name: 'initialPage', phone: '', email: ''); // Workaround
        return fodderUser;
    }

    Future<void> sendEmailToResetPassword(Map data) async {
        state = const AsyncValue.loading();

        var jsonBody = json.encode(data);
        state = await AsyncValue.guard(() async {
            final response = await http.post(
                Uri.parse('${AppConfig.backUrl}/user/reset_password_email'),
                headers: Constants.httpRequestHeadersWithJsonBodyWithoutToken(),
                body:jsonBody
            );
            if (response.statusCode != 200){
                var errMsg = getErrorMsg(response, Constants.defaultErrorMsg);
                throw Exception(errMsg);
            }
            User fodderUser = User(name: 'successAtReset', phone: '', email: ''); // Workaround
            state = AsyncValue.data(fodderUser);
            return fodderUser;
        });
    }
}
