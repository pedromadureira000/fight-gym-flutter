import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fight_gym/model/models.dart';
import 'package:fight_gym/provider/base_async_notifier.dart';

class AsyncAttendance extends BaseAsyncNotifier<Attendance> {
    AsyncAttendance(): super(
        'list_attendance_view',
        'attendance_view',
        (json) => Attendance.fromJson(json),
    );

    @override
    addRecordLocaly(newRecordObj, recordMap) {
        newRecordObj.id = recordMap["id"];
        newRecordObj.customer = {
            "id": recordMap["customer"]["id"],
            "name": recordMap["customer"]["name"],
        };
        newRecordObj.class_instance = {
            "id": recordMap["class_instance"]["id"],
            "name": recordMap["class_instance"]["modality_name"],
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
            newRecordObj.customer = {
                "id": oldRecordOjb.customer["id"],
                "name": oldRecordOjb.customer["name"],
            };
            newRecordObj.class_instance = {
                "id": oldRecordOjb.class_instance["id"],
                "modality_name": oldRecordOjb.class_instance["modality_name"],
            };
            state.value!["listRecords"].insert(elIndex, newRecordObj);
            state = state;
        }
    }
}

final asyncAttendanceProvider = AsyncNotifierProvider<AsyncAttendance, Map<String, dynamic>>(() {
    return AsyncAttendance();
});
