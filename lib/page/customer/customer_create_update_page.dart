import "package:easy_localization/easy_localization.dart";
import "package:fight_gym/components/dialogs.dart";
import "package:fight_gym/components/dropdown.dart";
import "package:fight_gym/config/app_routes.dart";
import "package:fight_gym/page/facade.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:fight_gym/provider/plan_provider.dart";
import "package:fight_gym/styles/app_colors.dart";
import "package:fight_gym/styles/app_text.dart";
import "package:fight_gym/utils/user_auth_middleware.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import 'package:flutter/foundation.dart' show kIsWeb;


class CustomerCreateOrUpdatePage extends HookConsumerWidget {
    CustomerCreateOrUpdatePage(
        {
            super.key,
            this.params = const {},
            required this.updateUrl,
            required this.provider,
            required this.instanceModel,
        }
    );
    dynamic params;
    final String updateUrl;
    // final AsyncNotifierProvider provider;
    final dynamic provider;
    final dynamic instanceModel;

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        //Fields
        Map fields = {
            "selectedPlan":  useState(""),
            "nameController": useTextEditingController(),
            "emailController": useTextEditingController(),
        };
        var record = null;
        setControllersData(
            ref,
            fields,
            record
        );


        List<Widget> widgetFields = [
            TextField(
                minLines: 1,
                maxLines: null,
                controller: nameController,
                style: kIsWeb ? Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 19) :
                    Theme.of(context).textTheme.titleMedium,
                decoration: InputDecoration(
                    labelText: tr("Name"),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))
                    ),
                    filled: true,
                    fillColor: customDarkThemeStyles.inputDecorationFillcolor.withOpacity(0.5),
                ),
            ),
            const SizedBox(height: 16.0),
            TextField(
                minLines: 1,
                maxLines: null,
                controller: emailController,
                decoration: InputDecoration(
                    labelText: tr("Email"),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))
                    ),
                    filled: true,
                    fillColor: customDarkThemeStyles.inputDecorationFillcolor.withOpacity(0.5),
                ),
            ),
            const SizedBox(height: 16.0),
            SelectValueFromProviderListDropdown(
                selectedPlan,
                asyncPlansProvider,
            ),
            const SizedBox(height: 20.0),
        ];
    }
}
