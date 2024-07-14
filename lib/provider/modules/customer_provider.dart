import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fight_gym/model/models.dart';
import 'package:fight_gym/provider/base_async_notifier.dart';

class AsyncCustomers extends BaseAsyncNotifier<Customer> {
    AsyncCustomers(): super(
        'list_customers_view',
        'customer_view',
        (json) => Customer.fromJson(json),
    );
}

final asyncCustomersProvider = AsyncNotifierProvider<AsyncCustomers, Map<String, dynamic>>(() {
    return AsyncCustomers();
});
