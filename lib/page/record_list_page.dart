import 'package:fight_gym/config/app_config.dart';
import 'package:fight_gym/page/facade.dart';
import 'package:fight_gym/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import "package:easy_localization/easy_localization.dart";
import "package:fight_gym/components/error_msg_widget.dart";


class ListPage extends HookConsumerWidget {
    const ListPage({
        super.key,
        required this.provider,
        required this.createRecordNamedRoute,
        required this.updateRecordNamedRoute,
        required this.addInstanceLabel,
    });

    final dynamic provider;
    final dynamic createRecordNamedRoute;
    final dynamic updateRecordNamedRoute;
    final dynamic addInstanceLabel;

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        final asyncValue = ref.watch(provider);
        CustomDarkThemeStyles customDarkThemeStyles = CustomDarkThemeStyles(Theme.of(context).brightness);

        return switch (asyncValue) {
            AsyncData(:final value) => RefreshIndicator(
                onRefresh: () async {
                  ref.refresh(provider);
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
                                        goToCreatePage(context, ref, createRecordNamedRoute);
                                    },
                                    style: customDarkThemeStyles.elevatedBtnStyleInsideContainer,
                                    child: RichText(
                                        text: TextSpan(
                                            children: [
                                              const WidgetSpan(
                                                child: Icon(Icons.add, size: 19),
                                              ),
                                              TextSpan(
                                                text: tr(addInstanceLabel),
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
                            itemCount: value.length,
                            itemBuilder: (context, index) {
                                final record = value[index];
                                return ListTile(
                                    title: Text(record.name),
                                    onTap: () {
                                        goToUpdatePage(context, ref, record, updateRecordNamedRoute);
                                    },
                                );
                            },
                          ),
                        ],
                    ),
                ),
            ),
            AsyncError(:final error) => ErrorMessageWidget(
                message: tr("Something went wrong while trying to get records"),
                provider: provider,
                error: error,
            ),
            _ => const Center(child: CircularProgressIndicator()),
        };

        // switch (asyncValue) {
            // case AsyncData():
                // var records = asyncValue.value;
                // return RefreshIndicator(
                    // onRefresh: () async {
                      // ref.refresh(provider);
                    // },
                    // child: SingleChildScrollView(
                        // physics: const AlwaysScrollableScrollPhysics(),
                        // child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            // children: [
                              // const SizedBox(height: 10),
                              // Row(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                // children: [
                                    // ElevatedButton(
                                        // onPressed: () {
                                            // goToCreatePage(context, ref, createRecordNamedRoute);
                                        // },
                                        // style: customDarkThemeStyles.elevatedBtnStyleInsideContainer,
                                        // child: RichText(
                                            // text: TextSpan(
                                                // children: [
                                                  // const WidgetSpan(
                                                    // child: Icon(Icons.add, size: 19),
                                                  // ),
                                                  // TextSpan(
                                                    // text: tr(addInstanceLabel),
                                                    // style: TextStyle(
                                                      // fontSize: 16,
                                                      // color: Theme.of(context).brightness == Brightness.light
                                                          // ? AppColors.lightBackground
                                                          // : Colors.black,
                                                    // ),
                                                  // ),
                                                // ],
                                            // ),
                                        // ),
                                    // ),
                                  // const SizedBox(width: 10),
                                // ],
                              // ),
                              // const SizedBox(height: 10),
                              // ListView.builder(
                                // shrinkWrap: true,
                                // physics: const NeverScrollableScrollPhysics(),
                                // itemCount: records.length,
                                // itemBuilder: (context, index) {
                                    // final record = records[index];
                                    // return ListTile(
                                        // title: Text(record.name),
                                        // onTap: () {
                                            // goToUpdatePage(context, ref, record, updateRecordNamedRoute);
                                        // },
                                    // );
                                // },
                              // ),
                            // ],
                        // ),
                    // ),
                // );
            // case AsyncError():
                // var error = asyncValue.error;
                // return ErrorMessageWidget(
                    // message: tr("Something went wrong while trying to get records"),
                    // provider: provider,
                    // error: error,
                // );
            // default:
                // return const Center(child: CircularProgressIndicator());
        // }

    }
}
