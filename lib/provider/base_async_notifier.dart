import 'dart:convert';
import 'dart:async';
import 'package:fight_gym/utils/error_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fight_gym/data/local_storage/secure_storage.dart';
import 'package:fight_gym/config/app_config.dart';
import 'package:fight_gym/constants/constants.dart';

abstract class BaseAsyncNotifier<T> extends AsyncNotifier<Map<String, dynamic>> {
    final String listUrl;
    final String createUrl;
    final T Function(Map<String, dynamic>) fromJson;

    BaseAsyncNotifier(this.listUrl, this.createUrl, this.fromJson);

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
                Uri.parse("${AppConfig.backUrl}/$listUrl"),
                headers: Constants.httpRequestHeaders(token),
            );
            if (response.statusCode == 200) {
                dynamic decodedJsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
                int totalRecords = decodedJsonResponse["totalRecords"];
                final records = (decodedJsonResponse["result"] as List<dynamic>).cast<Map<String, dynamic>>();
                var listRecords = records.map(fromJson).toList();
                return {
                  "totalRecords": totalRecords,
                  "listRecords": listRecords
                };
            }
            throw getErrorMsg(response, Constants.defaultErrorMsg);
        } catch (err, stack) {
            AppConfig.logger.d("Unknown Error: $err");
            AppConfig.logger.d("Unknown Error: stack $stack");
            throw Exception("Unknown Error");
        }
    }

    Future<(String, dynamic)> addRecord(T record) async {
        try {
            Map recordMap = (record as dynamic).toJson(); // Ensure your model has a toJson() method
            var jsonBody = json.encode(recordMap);
            var token = await SecureStorage().readSecureData("token");
            final response = await http.post(
                Uri.parse("${AppConfig.backUrl}/$createUrl"),
                headers: Constants.httpRequestHeadersWithJsonBody(token),
                body: jsonBody,
            );
            if (response.statusCode != 200) {
                return (getErrorMsg(response, Constants.defaultErrorMsg), null);
            }
            Map responseMap = jsonDecode(response.body);
            return ("success", responseMap);
        } catch (err, stack) {
            return (Constants.defaultErrorMsg, null);
        }
    }

    Future<T> getSingleRecord(String? recordId) async {
        try{
            var token = await SecureStorage().readSecureData("token");
            String url = "${AppConfig.backUrl}/customer_view/$recordId";
            final response = await http.get(
                Uri.parse(url),
                headers: Constants.httpRequestHeaders(token),
            );
            if (response.statusCode != 200){
                throw Exception("Error while trying to get record");
            }
            dynamic decodedJsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
            final record = fromJson(decodedJsonResponse);
            return record;
        } catch (err, stack) {
            throw Exception(Constants.defaultErrorMsg);
        }
    }

    Future<String> updateRecord(int? recordId, T newRecordData) async {
        try{
            var token = await SecureStorage().readSecureData("token");
            // Map recordMap = newRecordData?.toJson();  :TypeError T is type 'unknow' and don't have 'toJson'
            Map recordMap = (newRecordData as dynamic).toJson();
            recordMap['id'] = recordId;
            var jsonBody = json.encode(recordMap);
            final response = await http.put(
                Uri.parse("${AppConfig.backUrl}/customer_view/$recordId"),
                headers: Constants.httpRequestHeadersWithJsonBody(token),
                body: jsonBody,
            );
            var requestError = response.statusCode != 200;
            if (requestError) {
                return getErrorMsg(response, Constants.defaultErrorMsg);
            }
            return "success";
        } catch (err, stack) {
            return Constants.defaultErrorMsg;
        }
    }

    Future<String> removeRecord(int recordId) async {
        try{
            var token = await SecureStorage().readSecureData("token");
            var jsonBody = json.encode(<String, dynamic>{
                "id": recordId,
            });
            final response = await http.delete(
                Uri.parse("${AppConfig.backUrl}/customer_view/$recordId"),
                headers: Constants.httpRequestHeadersWithJsonBody(token),
                body:jsonBody 
            );
            var requestError = response.statusCode != 200;
            if (requestError) {
                return getErrorMsg(response, Constants.defaultErrorMsg);
            }
            return "success";
        } catch (err, stack) {
            return Constants.defaultErrorMsg;
        }
    }

    Future<void> fetchMoreRecords(recordsLength) async {
        var token = await SecureStorage().readSecureData("token");
        String url = "${AppConfig.backUrl}/list_customers_view?startingIndex=$recordsLength";
        final response = await http.get(
            Uri.parse(url),
            headers: Constants.httpRequestHeaders(token),
        );
        if (response.statusCode != 200){
            throw Exception("Error while trying to get records");
        }
        dynamic decodedJsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        int totalRecords = decodedJsonResponse["totalRecords"];
        final records = (decodedJsonResponse["result"] as List<dynamic>).cast<Map<String, dynamic>>();
        var listRecords = records.map(fromJson).toList();
        state.value!["totalRecords"] = totalRecords;
        state.value!["listRecords"].addAll(listRecords);
        state = state; // to refresh page
    }

    addRecordLocaly(newRecordObj, recordMap) {
        newRecordObj.id = recordMap["id"];
        if (state.value != null){ // XXX avoid to update localy if it has not been fetched yet
            state.value!["listRecords"]!.insert(0, newRecordObj);
            state.value!["totalRecords"] = (state.value!["totalRecords"] ?? 1) + 1;
        }
        state = state;
    }

    updateRecordLocaly(newRecordObj, oldRecordOjb) {
        if (state.value != null){ // XXX avoid to update localy if it has not been fetched yet
            var elIndex = state.value!["listRecords"].indexWhere((el) => el.id == oldRecordOjb.id);
            state.value!["listRecords"].removeAt(elIndex);
            newRecordObj.id = oldRecordOjb.id;
            state.value!["listRecords"].insert(elIndex, newRecordObj);
            state = state;
        }
    }

    deleteRecordLocaly(record) {
        if (state.value != null){ // XXX avoid to update localy if it has not been fetched yet
            state.value!["listRecords"].removeWhere((el) => el.id == record.id);
            state.value!["totalRecords"] = (state.value!["totalRecords"] ?? 1) - 1;
            state = state;
        }
    }

    offlineRefresh() {
        state = state;
    }
}
