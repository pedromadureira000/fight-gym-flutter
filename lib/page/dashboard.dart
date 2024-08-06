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
                                  border: TableBorder.all(
                                    width: 0.5,
                                    color: Colors.black,
                                  ),
                                  columnWidths: const {
                                    0: FixedColumnWidth(250.0),
                                    1: FixedColumnWidth(250.0),
                                    2: FixedColumnWidth(250.0),
                                    3: FixedColumnWidth(250.0),
                                  },
                                  children: [
                                    // Header Row
                                    TableRow(
                                      decoration: BoxDecoration(
                                        // color: Colors.green[100] ?? Colors.green,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                      children: [
                                        TableCell(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8),
                                            child: Text(
                                                tr('Customer Name'),
                                                style: TextStyle(
                                                    color: Colors.grey[100],
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8),
                                            child: Text(
                                              tr('Plan'),
                                              style: TextStyle(
                                                color: Colors.grey[100],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8),
                                            child: Text(
                                              tr('Last Payment Date'),
                                              style: TextStyle(
                                                color: Colors.grey[100],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8),
                                            child: Text(
                                              tr('Days Overdue'),
                                              style:  TextStyle(
                                                color: Colors.grey[100],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Data Rows
                                    ...((value['records'] as List<dynamic>).map((record) {
                                      final lastPaymentDate = DateTime.parse(record['last_payment_date']);
                                      final currentDate = DateTime.now();
                                      final difference = currentDate.difference(lastPaymentDate).inDays - 31;

                                      return TableRow(
                                        decoration: BoxDecoration(
                                            color: (value['records'].indexOf(record) % 2 == 0) ? Colors.white : Colors.green[100],
                                            // color: Theme.of(context).colorScheme.primary,
                                        ),
                                        children: [
                                          TableCell(
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8),
                                              child: Text(record['customer_name'], style: const TextStyle(fontSize: 16.0)),
                                            ),
                                          ),
                                          TableCell(
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8),
                                              child: Text(record['plan_name'], style: const TextStyle(fontSize: 16.0)),
                                            ),
                                          ),
                                          TableCell(
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8),
                                              child: Text(parseDateTimeToLocalizedString(ref, lastPaymentDate), style: const TextStyle(fontSize: 16.0)),
                                            ),
                                          ),
                                          TableCell(
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8),
                                              child: Text(difference.toString(), style: const TextStyle(fontSize: 16.0)),
                                            ),
                                          ),
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
