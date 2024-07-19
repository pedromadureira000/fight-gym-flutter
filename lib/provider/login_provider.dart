import 'dart:convert';
import 'package:fight_gym/data/local_storage/secure_storage.dart';
import 'package:fight_gym/utils/error_handler.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:fight_gym/config/app_config.dart';
import 'package:fight_gym/constants/constants.dart';
import 'package:fight_gym/model/models.dart';
import 'package:fight_gym/utils/google_sign_in_helper.dart';

part 'login_provider.g.dart';

// @riverpod // with AutoDispose
@Riverpod(keepAlive: true) // without AutoDispose
class AsyncUser extends _$AsyncUser {
    @override
    FutureOr<User> build() async {
        return _fetchData();
    }

    Future<User> _fetchData() async {
        try {
            // NOTE this does not work out of android
            SecureStorage secureStorage = SecureStorage();
            var token = await secureStorage.readSecureData('token');
            if (token.isEmpty){
                throw Exception("The user's token is missing");
            }

            final response = await http.get(
                Uri.parse('${AppConfig.backUrl}/user/user_view'),
                headers: Constants.httpRequestHeaders(token),
            );

            if (response.statusCode == 401){ //unauthorized
                await deleteToken();
                throw Exception('unauthorized. Token is wrong');
            }
            if (response.statusCode != 200){
                throw Exception(Constants.defaultErrorMsg);
            }
            dynamic userMap = jsonDecode(utf8.decode(response.bodyBytes));
            User user = User.fromJson(userMap);
            return user;
        } catch (err, stack) {
            AppConfig.logger.d("err $err");
            AppConfig.logger.d("stack $stack");
            rethrow;
        }
    }
    
    Future<String> login(String email, String password) async {
        var jsonBody = json.encode({
            "email": email,
            "password": password,
            "fcmToken": AppConfig.fcmToken ?? "",
        });
        try {
            final response = await http.post(
                Uri.parse('${AppConfig.backUrl}/user/gettoken'),
                headers: {"Content-Type": "application/json"},
                body: jsonBody 
            );
            final jsonResponse = jsonDecode(response.body);
            if (response.statusCode != 200){
                return getErrorMsg(response, Constants.defaultErrorMsg);
            }
            else {
                final token = jsonResponse["token"];
                SecureStorage().writeSecureData('token', token);
                User user = await _fetchData();
                // if (ref.exists(asyncTodoGroupsProvider)){
                    // ref.invalidate(asyncTodoGroupsProvider);
                // }
                state = AsyncValue.data(user);
                return "success";
            }
        } catch (err, stack) {
            // AppConfig.logger.d("err $err");
            // AppConfig.logger.d("stack $stack");
            return Constants.defaultErrorMsg;
        }
    }

    Future<void> deleteToken() async {
        await SecureStorage().deleteSecureData('token');
    }

    Future<String> updatePassword(Map data) async {
        try{
            var jsonBody = json.encode(data);

            var token = await SecureStorage().readSecureData('token');
            final response = await http.post(
                Uri.parse('${AppConfig.backUrl}/user/change_password'),
                headers: Constants.httpRequestHeadersWithJsonBody(token),
                body:jsonBody 
            );
            if (response.statusCode != 200){
                return getErrorMsg(response, Constants.defaultErrorMsg);
            }
            await deleteToken();
            return "success";
        } catch (err, stack) {
            return Constants.defaultErrorMsg;
        }
    }

    LoginWithGoogle googleSignInModule = LoginWithGoogle();

    getGoogleSignInModule () {
        // GAMBIARRA DO !)$#%%$)
        googleSignInModule.signUpOrSignFunction = signUpOrSignInWithGoogle;
        return googleSignInModule;
    }

    Future<void> signUpOrSignInWithGoogle(Map userData) async {
        try {
            Map userDataMap = {
                "displayName": userData["user"].displayName,
                "email": userData["user"].email,
                "fcmToken": AppConfig.fcmToken ?? "",
                "idToken": userData["idToken"],
                "accessToken": userData["accessToken"]
            };

            var jsonBody = json.encode(userDataMap);

            final response = await http.post(
                Uri.parse('${AppConfig.backUrl}/user/get_or_create_account_with_google'),
                headers: {"Content-Type": "application/json"},
                body: jsonBody 
            );
            final jsonResponse = jsonDecode(response.body);
            bool googleAccoutJustCreated = jsonResponse['created'];
            if (response.statusCode != 200){
                var errMsg = getErrorMsg(response, Constants.defaultErrorMsg);
                throw Exception(errMsg);
            }
            else {
                final token = jsonResponse["token"];
                SecureStorage secureStorage = SecureStorage();
                await secureStorage.writeSecureData('token', token);
                await secureStorage.writeSecureData('is_google_signin_account', 'true');
                if (googleAccoutJustCreated == true){
                    await secureStorage.writeSecureData('googleAccoutJustCreated', 'googleAccoutJustCreated');
                }
                // if (ref.exists(asyncTodoGroupsProvider)){
                    // ref.invalidate(asyncTodoGroupsProvider);
                // }
                User user = await _fetchData();
                state = AsyncValue.data(user);
            }
        } catch (err, stack) {
            AppConfig.logger.d('err $err');
            AppConfig.logger.d('stack $stack');
            throw Exception(err);
        }
    }

    Future<String> updateProfile(Map data) async {
        try{
            var jsonBody = json.encode(data);

            var token = await SecureStorage().readSecureData('token');
            final response = await http.put(
                Uri.parse('${AppConfig.backUrl}/user/user_view'),
                headers: Constants.httpRequestHeadersWithJsonBody(token),
                body: jsonBody,
            );
            if (response.statusCode != 200) {
                return getErrorMsg(response, Constants.defaultErrorMsg);
            }
            return "success";
        } catch (err, stack) {
            return Constants.defaultErrorMsg;
        }
    }

    Future<String> getCountry() async {
        try{
            var token = await SecureStorage().readSecureData('token');
            final response = await http.get(
                Uri.parse('${AppConfig.backUrl}/user/get_country'),
                headers: Constants.httpRequestHeaders(token),
            );
            if (response.statusCode != 200) {
                throw Exception(Constants.defaultErrorMsg);
            }
            final jsonResponse = jsonDecode(response.body);
            return jsonResponse["country_code"];
        } catch (err, stack) {
            throw Exception(Constants.defaultErrorMsg);
        }
    }
}
