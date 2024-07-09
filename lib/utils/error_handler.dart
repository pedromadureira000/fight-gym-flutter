import 'dart:convert';
import 'package:fight_gym/config/app_config.dart';
import 'package:http/http.dart';


String getErrorMsg(Response response, String defaultErrorMsg) {
  try {
    // Parse the JSON body
    Map<String, dynamic> responseBody = json.decode(response.body);
    int statusCode = response.statusCode;

    if (statusCode == 500){
        return "Server error";
    }

    // Check for common error keys
    if (responseBody.containsKey('detail')) {
      return responseBody['detail'];
    } else if (responseBody.containsKey('error')) {
      return responseBody['error'];
    } else if (responseBody.containsKey('non_field_errors')) {
      return responseBody['non_field_errors'][0];
    } else if (responseBody.containsKey('user_blocked_error')) {
        if (responseBody['user_blocked_error'] == 'trial_ended'){
            return "Your trial period has ended. Please upgrade to continue using our services.";
        }
        if (responseBody['user_blocked_error'] == 'subscription_unpaid'){
            return "Your subscription payment is overdue. Please update your payment information to continue using our services.";
        }
        if (responseBody['user_blocked_error'] == 'subscription_canceled') {
            return "Your subscription has been canceled. Please renew your subscription to regain access.";
        }
    } else {
      // Check for specific field errors
      for (String key in responseBody.keys) {
        if (responseBody[key] is List && responseBody[key].isNotEmpty) {
          return "$key: ${responseBody[key][0]}";
        }
      }
    }
    return defaultErrorMsg;
  } catch (e) {
    AppConfig.logger.e('Error inside "getErrorMsg". catched error: $e ; response.body: ${response.body};');
    return 'An unknown error occurred';
  }
}


String parseErrorMsg(String errorMsg) {
    if (errorMsg.startsWith("Exception: ")){
        return errorMsg.substring("Exception: ".length);
    }
    return errorMsg;
}


// Example usage:
// void main() {
  // Response response = Response(
    // json.encode({
      // "term": ["This field may not be blank."]
        // "detail": "Method \"PUT\" not allowed.",
        // "error": "Something went wrong. It seems.",
        // "non_field_errors": [
            // "The password is wrong"
        // ],
        // "current_password": [
            // "This field is required."
        // ],
        // "term": [
            // "Not a valid string."
        // ]
        // "nested_field": {
            // "non_field_errors": [ // TODO implemente
                // "Invalid data. Expected a dictionary, but got list."
            // ]
        // },
        // "nested_field": {
            // "test_field_n": [
                // "This is an error for the purpose of testing."
            // ]
        // }
    // }),
    // 400,
  // );
  // String errorMessage = getErrorMsg(response, "default-msg");
  // print('$errorMessage');
// }
