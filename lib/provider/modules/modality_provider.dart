import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fight_gym/model/models.dart';
import 'package:fight_gym/provider/base_async_notifier.dart';

class AsyncModality extends BaseAsyncNotifier<Modality> {
    AsyncModality(): super(
        'list_modality_view',
        'modality_view',
        (json) => Modality.fromJson(json),
    );
}

final asyncModalityProvider = AsyncNotifierProvider<AsyncModality, Map<String, dynamic>>(() {
    return AsyncModality();
});
