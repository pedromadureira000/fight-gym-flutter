import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fight_gym/model/models.dart';
import 'package:fight_gym/provider/base_async_notifier.dart';

class AsyncAttendance extends BaseAsyncNotifier<Attendance> {
    AsyncAttendance(): super(
        'list_attendance_view',
        'attendance_view',
        (json) => Attendance.fromJson(json),
    );
}

final asyncAttendanceProvider = AsyncNotifierProvider<AsyncAttendance, Map<String, dynamic>>(() {
    return AsyncAttendance();
});
