import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fight_gym/model/models.dart';
import 'package:fight_gym/provider/base_async_notifier.dart';

class AsyncPlans extends BaseAsyncNotifier<Plan> {
    AsyncPlans(): super(
        'list_plan_view',
        'plan_view',
        (json) => Plan.fromJson(json),
    );
}

final asyncPlansProvider = AsyncNotifierProvider<AsyncPlans, Map<String, dynamic>>(() {
    return AsyncPlans();
});
