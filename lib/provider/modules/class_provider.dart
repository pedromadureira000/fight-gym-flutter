import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fight_gym/model/models.dart';
import 'package:fight_gym/provider/base_async_notifier.dart';

class AsyncClass extends BaseAsyncNotifier<Class> {
    AsyncClass(): super(
        'list_class_view',
        'class_view',
        (json) => Class.fromJson(json),
    );

    @override
    addRecordLocaly(newRecordObj, recordMap) {
        newRecordObj.id = recordMap["id"];
        newRecordObj.modality = {
            "id": recordMap["modality"]["id"],
            "name": recordMap["modality"]["name"],
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
            newRecordObj.modality = {
                "id": oldRecordOjb.modality["id"],
                "name": oldRecordOjb.modality["name"],
            };
            state.value!["listRecords"].insert(elIndex, newRecordObj);
            state = state;
        }
    }
}

final asyncClassProvider = AsyncNotifierProvider<AsyncClass, Map<String, dynamic>>(() {
    return AsyncClass();
});
