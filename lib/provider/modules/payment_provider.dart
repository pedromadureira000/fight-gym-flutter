import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fight_gym/model/models.dart';
import 'package:fight_gym/provider/base_async_notifier.dart';

class AsyncPayment extends BaseAsyncNotifier<Payment> {
    AsyncPayment(): super(
        'list_payment_view',
        'payment_view',
        (json) => Payment.fromJson(json),
    );

    @override
    addRecordLocaly(newRecordObj, recordMap) {
        newRecordObj.id = recordMap["id"];
        newRecordObj.enrollment = {
            "id": recordMap["enrollment"]["id"],
            "customer_id": recordMap["enrollment"]["customer_id"],
            "customer_name": recordMap["enrollment"]["customer_name"],
            "plan_name": recordMap["enrollment"]["plan_name"],
        };
        if (state.value != null){ // XXX avoid to update localy if it has not been fetched yet
            state.value!["listRecords"]!.insert(0, newRecordObj);
            state.value!["totalRecords"] = (state.value!["totalRecords"] ?? 1) + 1;
        }
        state = state;
    }

    @override
    updateRecordLocaly(newRecordObj, oldRecordOjb) {
        if (state.value != null){ // XXX avoid to update localy if it has not been fetched yet
            var elIndex = state.value!["listRecords"].indexWhere((el) => el.id == oldRecordOjb.id);
            state.value!["listRecords"].removeAt(elIndex);
            newRecordObj.id = oldRecordOjb.id;
            newRecordObj.enrollment = {
                "id": oldRecordOjb.enrollment["id"],
                "customer_id": oldRecordOjb.enrollment["customer_id"],
                "customer_name": oldRecordOjb.enrollment["customer_name"],
                "plan_name": oldRecordOjb.enrollment["plan_name"],
            };
            state.value!["listRecords"].insert(elIndex, newRecordObj);
            state = state;
        }
    }
}

final asyncPaymentProvider = AsyncNotifierProvider<AsyncPayment, Map<String, dynamic>>(() {
    return AsyncPayment();
});
