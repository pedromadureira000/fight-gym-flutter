import "package:easy_localization/easy_localization.dart";
import "package:fight_gym/components/error_msg_widget.dart";
import "package:fight_gym/provider/modules/customer_provider.dart";
import "package:fight_gym/utils/snackbar.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:fight_gym/styles/app_colors.dart";
import "package:fight_gym/styles/app_text.dart";
import "package:fight_gym/utils/user_auth_middleware.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import 'package:flutter/foundation.dart' show kIsWeb;


class Dashboard extends HookConsumerWidget {
    Dashboard({
        super.key,
        this.params = const {},
    });
    dynamic params;

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        CustomDarkThemeStyles customDarkThemeStyles = CustomDarkThemeStyles(Theme.of(context).brightness);
        Color textStyleColor = Theme.of(context).brightness == Brightness.light ? Colors.black :
                AppColors.lightBackground;
        final asyncValue = ref.watch(asyncCustomersProvider);

        useEffect(() {
            userAuthMiddleware(context);
            return null;
        }, const []);

        return switch (asyncValue) {
            AsyncData(:final value) => RefreshIndicator(
                onRefresh: () async {
                  ref.refresh(asyncCustomersProvider);
                },
                child: const SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        // mainAxisSize : MainAxisSize.min,
                        children: [
                            Text("asdf")
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
