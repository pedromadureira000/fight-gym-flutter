import "package:easy_localization/easy_localization.dart";
import "package:fight_gym/components/error_msg_widget.dart";
import "package:fight_gym/provider/dashboard_provider.dart";
import "package:fight_gym/provider/modules/customer_provider.dart";
import "package:fight_gym/utils/utils.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:fight_gym/utils/user_auth_middleware.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";

class Dashboard extends HookConsumerWidget {
  Dashboard({
    super.key,
    this.params = const {},
  });
  dynamic params;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(asyncDashboardProvider);

    useEffect(() {
      userAuthMiddleware(context);
      return null;
    }, const []);

    return switch (asyncValue) {
      AsyncData(:final value) => RefreshIndicator(
        onRefresh: () async {
          ref.refresh(asyncCustomersProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(tr("Overdue Payments"), style: Theme.of(context).textTheme.headline6),
              if (value is Map<String, dynamic> && value.containsKey('records') && (value['records'] as List<dynamic>).isNotEmpty)
                Table(
                  border: TableBorder.all(),
                  columnWidths: const {
                    0: FixedColumnWidth(150.0),
                    1: FixedColumnWidth(150.0),
                    2: FixedColumnWidth(200.0),
                    3: FixedColumnWidth(150.0),
                  },
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      children: [
                        TableCell(child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(tr('Customer Name'), style: const TextStyle(color: Colors.white)),
                        )),
                        TableCell(child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(tr('Plan'), style: const TextStyle(color: Colors.white)),
                        )),
                        TableCell(child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(tr('Last Payment Date'), style: const TextStyle(color: Colors.white)),
                        )),
                        TableCell(child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(tr('Days Overdue'), style: const TextStyle(color: Colors.white)),
                        )),
                      ],
                    ),
                    ...((value['records'] as List<dynamic>).map((record) {
                      final lastPaymentDate = DateTime.parse(record['last_payment_date']);
                      final currentDate = DateTime.now();
                      final difference = currentDate.difference(lastPaymentDate).inDays - 31;
                      return TableRow(
                        children: [
                          TableCell(child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(record['customer_name']),
                          )),
                          TableCell(child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(record['plan_name']),
                          )),
                          TableCell(child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(parseDateTimeToLocalizedString(ref, lastPaymentDate)),
                          )),
                          TableCell(child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(difference.toString()),
                          )),
                        ],
                      );
                    })),
                  ],
                ),
              if (value is Map<String, dynamic> && value.containsKey('records') && (value['records'] as List<dynamic>).isEmpty)
                Text(tr("No overdue payments found.")),
            ],
          ),
        ),
      ),
      AsyncError(:final error) => ErrorMessageWidget(
        message: tr("Something went wrong while trying to get records"),
        provider: asyncCustomersProvider,
        error: error,
      ),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}
