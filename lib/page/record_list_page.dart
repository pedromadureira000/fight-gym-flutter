import 'package:fight_gym/config/app_config.dart';
import 'package:fight_gym/page/facade.dart';
import 'package:fight_gym/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import "package:easy_localization/easy_localization.dart";
import "package:fight_gym/components/error_msg_widget.dart";
import "package:flutter/foundation.dart" show kIsWeb;


class ListPage extends HookConsumerWidget {
    const ListPage({
        super.key,
        required this.queryParams,
        required this.provider,
        required this.createRecordNamedRoute,
        required this.updateRecordNamedRoute,
        required this.addInstanceLabel,
        required this.filterList,
        this.searchBar = false,
        this.filterDate,
    });

    final dynamic queryParams;
    final dynamic provider;
    final dynamic createRecordNamedRoute;
    final dynamic updateRecordNamedRoute;
    final dynamic addInstanceLabel;
    final List<Widget> filterList;
    final bool searchBar;
    final Widget? filterDate;

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        final asyncValue = ref.watch(provider);
        CustomDarkThemeStyles customDarkThemeStyles = CustomDarkThemeStyles(Theme.of(context).brightness);

        final TextEditingController searchTermcontroller = TextEditingController();

        return switch (asyncValue) {
            AsyncData(:final value) => RefreshIndicator(
                onRefresh: () async {
                  ref.refresh(provider);
                },
                child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        // mainAxisSize : MainAxisSize.min,
                        children: [
                            const SizedBox(height: 10),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                    if (kIsWeb && searchBar)  SizedBox(
                                        width: 400.0 ,
                                        child: TextField(
                                            controller: searchTermcontroller,
                                            decoration: InputDecoration(
                                                border: const OutlineInputBorder(),
                                                labelText: tr("Search"),
                                            ),
                                            onSubmitted: (String txt) {
                                                searchTermFunction(queryParams, ref, provider, txt);
                                            },
                                        ),
                                    ),
                                ],
                            ),
                            if (kIsWeb) Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                    ...filterList,
                                    if (filterDate != null) filterDate as Widget,
                                ]
                            ),
                            // show searchBar on mobile
                            if (!kIsWeb && searchBar) const SizedBox(height: 10),
                            if (!kIsWeb && searchBar) SizedBox(
                                width: 280,
                                child: TextField(
                                    controller: searchTermcontroller,
                                    decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        labelText: tr("Search"),
                                    ),
                                    onSubmitted: (String txt) {
                                        searchTermFunction(queryParams, ref, provider, txt);
                                    },
                                ),
                            ),
                            //show filterList on mobile
                            if (!kIsWeb && filterList.isNotEmpty) const SizedBox(height: 10),
                            if (!kIsWeb && filterList.isNotEmpty) Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: filterList,
                            ),
                            // show filter date on mobile
                            if (!kIsWeb) const SizedBox(height: 10),
                            if (!kIsWeb && filterDate != null) filterDate as Widget,
                            const SizedBox(height: 10),
                            ListOfRecords(queryParams, value, updateRecordNamedRoute, provider)
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
    ListOfRecords(this.queryParams, this.response, this.updateRecordNamedRoute, this.provider, {super.key});

    final dynamic queryParams;
    final dynamic response;
    final dynamic updateRecordNamedRoute;
    final dynamic provider;

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        int totalRecords = response["totalRecords"];
        int recordsLength = response["listRecords"].length;
        final showLoadMoreBtn = recordsLength < totalRecords;
        int indexOfLastEl = recordsLength;

        int itemCount = response["listRecords"].length;

        if (showLoadMoreBtn){
            itemCount += 1; // The last element will be the btn
        }

        return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: itemCount,
            itemBuilder: (context, index) {
                if (showLoadMoreBtn && index == indexOfLastEl){
                    return Column(
                        children: <Widget>[
                            Text(tr("Load more")),
                            IconButton(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                icon: const Icon(Icons.sync),
                                onPressed: () {
                                    var notifier = ref.read(provider.notifier);
                                    notifier.fetchRecords(queryParams: queryParams.value, loadMore: true);
                                },
                            )
                        ],
                    );
                }
                else {
                    final record = response["listRecords"][index];
                    return ListTile(
                        title: Text(record.getNameField()),
                        onTap: () {
                            goToUpdatePage(context, ref, record, updateRecordNamedRoute);
                        },
                    );
                }
            },
        );
    }
}

var searchTermFunction = (queryParams, ref, provider, txt){
    var notifier = ref.read(provider.notifier);
    if (txt.isEmpty){
        queryParams.value.remove("searchTerm");
    }
    else {
        queryParams.value["searchTerm"] = txt;
    }
    notifier.fetchRecords(queryParams: queryParams.value);
};
