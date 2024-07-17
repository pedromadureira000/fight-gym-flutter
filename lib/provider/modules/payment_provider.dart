import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fight_gym/model/models.dart';
import 'package:fight_gym/provider/base_async_notifier.dart';

class AsyncPayment extends BaseAsyncNotifier<Payment> {
    AsyncPayment(): super(
        'list_payment_view',
        'payment_view',
        (json) => Payment.fromJson(json),
    );
}

final asyncPaymentProvider = AsyncNotifierProvider<AsyncPayment, Map<String, dynamic>>(() {
    return AsyncPayment();
});
