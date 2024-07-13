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

        // int totalRecords = group.totalRecords ?? 0;
        // int recordsLength = group.records != null ? group.records!.length : 0;
        // final showLoadMoreBtn = recordsLength < totalRecords;
        // int indexOfLastEl = group.records != null ? group.records!.length : 0;
        // int masonItemCount = group.records != null ? group.records!.length : 0;
        // if (showLoadMoreBtn){
            // masonItemCount += 1;
        // }
        // MasonryGridView.count(
            // itemCount: masonItemCount,
            // itemBuilder: (context, index) {
                // if (showLoadMoreBtn && index == indexOfLastEl){
                    // return Column(
                        // children: <Widget>[
                            // Text(tr("Load more")),
                            // IconButton(
                                // highlightColor: Colors.transparent,
                                // splashColor: Colors.transparent,
                                // hoverColor: Colors.transparent,
                                // icon: const Icon(Icons.sync),
                                // onPressed: () {
                                    // fetchRecordsByGroup(
                                        // ref,
                                        // context,
                                        // group.id,
                                        // loadMore: true,
                                    // );
                                // },
                            // )
                        // ],
                    // );
                // }
                // else {
                    // return NoteItemTile(
                        // context: context,
                        // ref: ref,
                        // record: group.records![index],
                        // customDarkThemeStyles: customDarkThemeStyles,
                    // );
                // }
            // },
        // );

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
                            ListOfRecords(value, updateRecordNamedRoute)
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
    }
}


class ListOfRecords extends HookConsumerWidget {
    ListOfRecords(this.response, this.updateRecordNamedRoute, {super.key});

    final dynamic response;
    final dynamic updateRecordNamedRoute;

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: response["listRecords"].length,
            itemBuilder: (context, index) {
                final record = response["listRecords"][index];
                return ListTile(
                    title: Text(record.name),
                    onTap: () {
                        goToUpdatePage(context, ref, record, updateRecordNamedRoute);
                    },
                );
            },
        );
    }
}
