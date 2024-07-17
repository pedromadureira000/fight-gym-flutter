import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fight_gym/model/models.dart';
import 'package:fight_gym/provider/base_async_notifier.dart';

class AsyncClass extends BaseAsyncNotifier<Class> {
    AsyncClass(): super(
        'list_class_view',
        'class_view',
        (json) => Class.fromJson(json),
    );
}

final asyncClassProvider = AsyncNotifierProvider<AsyncClass, Map<String, dynamic>>(() {
    return AsyncClass();
});
