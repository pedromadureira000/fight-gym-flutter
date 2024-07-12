import "package:fight_gym/config/app_config.dart";
import "package:fight_gym/config/app_routes.dart";
import 'package:fight_gym/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import "package:easy_localization/easy_localization.dart";
import "package:fight_gym/components/error_msg_widget.dart";
import "package:fight_gym/model/models.dart";
import "package:fight_gym/provider/customer_provider.dart";
import "package:fight_gym/utils/snackbar.dart";
import 'package:flutter/foundation.dart' show kIsWeb;


class CustomerWidget extends HookConsumerWidget {
  const CustomerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(asyncCustomersProvider);
    CustomDarkThemeStyles customDarkThemeStyles = CustomDarkThemeStyles(Theme.of(context).brightness);

    return asyncValue.when(
      data: (records) => RefreshIndicator(
        onRefresh: () async {
          ref.refresh(asyncCustomersProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to Create Customer page
                      goToCustomerCreatePage(context, ref);
                    },
                    style: customDarkThemeStyles.elevatedBtnStyleInsideContainer,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const WidgetSpan(
                            child: Icon(Icons.add, size: 19),
                          ),
                          TextSpan(
                            text: tr("Create Customer"),
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).brightness == Brightness.light
                                  ? AppColors.lightBackground
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: records.length,
                itemBuilder: (context, index) {
                  final record = records[index];
                  return ListTile(
                    title: Text(record.name), // Adjust to your record model
                    onTap: () {
                      // Navigate to Update Customer page
                      goToCustomerUpdatePage(context, ref, record);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      error: (error, stack) => ErrorMessageWidget(
        message: tr("Something went wrong while trying to get records"),
        provider: asyncCustomersProvider,
        error: error,
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

void goToCustomerCreatePage(context, ref){
    Navigator.pushNamed(context, AppRoutes.customerCreate, arguments: {"test": "fon"});
}

void goToCustomerUpdatePage(BuildContext context, WidgetRef ref, Customer record) {
    var url = "${AppRoutes.customerUpdate}?record_id=${record.id}";
    Navigator.pushNamed(context, url, arguments: {"record": record});
}
