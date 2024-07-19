import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:fight_gym/provider/configurations_provider.dart";
import "package:fight_gym/styles/app_colors.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:dropdown_button2/dropdown_button2.dart";
import "package:flutter/foundation.dart" show kIsWeb;

const List<String> list = <String>["Português", "English"];

class SelectLanguage extends HookConsumerWidget {
    const SelectLanguage({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        var notifier = ref.read(asyncConfigsProvider.notifier);
        String currentLocale = notifier.getLocale!().toString();
        final selectedLanguage = useState(currentLocale == "pt" ? "Português" : "English");
        selectedLanguage.value;

        return DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
                isExpanded: true,
                hint: Text(
                    tr("Select language"),
                    style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).hintColor,
                    ),
                ),
                items: list
                    .map((String item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                            item,
                            style: const TextStyle(
                                fontSize: 14,
                            ),
                        ),
                    ))
                    .toList(),
                value: selectedLanguage.value,
                onChanged: (String? value) {
                    selectedLanguage.value = value!; // TODO does it makes any diffirence? like . value is just a pass by value (not by ref)
                    notifier.setLocale!(value == "Português" ? "pt" : "en");
                },
                buttonStyleData: const ButtonStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    height: 40,
                    width: kIsWeb? 140 : 120,
                ),
                menuItemStyleData: const MenuItemStyleData(
                    height: 40,
                ),
            ),
        );
    }
}

class SelectDropdown extends HookConsumerWidget {
    SelectDropdown(
        this.selectedValue, this.valueOptions, this.label, {Key? key}
    ) : super(key: key);
    ValueNotifier selectedValue;
    List<Map> valueOptions;
    String label;

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
                if (label.isNotEmpty) Text(
                    tr(label),
                    style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).brightness == Brightness.light ? Colors.black : AppColors.lightBackground,
                    ),
                ),
                DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: Text(
                            tr("Select status"),
                            style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).hintColor,
                            ),
                        ),
                        items: valueOptions
                            .map<DropdownMenuItem<String>>((item) => DropdownMenuItem<String>(
                                value: "${item['id']}",
                                child: Text(
                                    tr(item["label"]),
                                    style: const TextStyle(
                                        fontSize: 14,
                                    ),
                                ),
                            ))
                            .toList(),
                        value: "${selectedValue.value}",
                        onChanged: (String? value) {
                            selectedValue.value = value!;
                        },
                        buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            height: 40,
                            width: kIsWeb? 140 : 125,
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                        ),
                    ),
                ),
            ],
        );
    }
}

class SelectValueFromProviderListDropdown extends HookConsumerWidget {
    SelectValueFromProviderListDropdown(this.fieldLabel, this.selectedValue, this.providerClass, {Key? key}) : super(key: key);
    String fieldLabel;
    ValueNotifier selectedValue;
    AsyncNotifierProvider providerClass;

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        final asyncValue = ref.watch(providerClass);
        // this leads to the same errror as commented bellow

        // Initialize selectedValue.value once when the widget is first built
        // useEffect(() {
          // if (selectedValue.value.isEmpty && asyncValue is AsyncData) {
            // final records = asyncValue.value;
            // if (records.isNotEmpty) {
                // WidgetsBinding.instance.addPostFrameCallback((_) {
                    // selectedValue.value = "${records[0].id}";
                // });
            // }
          // }
          // return null; // No cleanup function needed
        // }, [asyncValue]);

        switch (asyncValue) {
            case AsyncData(): 
                final records = asyncValue.value["listRecords"];
                if (selectedValue.value.isEmpty) {
                    if (records.isNotEmpty) {
                        // WidgetsBinding.instance.addPostFrameCallback((_) {
                            // selectedValue.value = "${records[0].id}";
                        // });
                        // code above leads to error on line: map<DropdownMenuItem<String>>((item) => DropdownMenuItem<String>
                        // it gets empty string and it should receive a id that matches the records list
                        // without it, I get this error:
                        // ``The following assertion was thrown while dispatching notifications for ValueNotifier<dynamic>:
                        // setState() or markNeedsBuild() called during build.``
                        selectedValue.value = "${records[0].id}";
                    }
                }
                return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                        Text(
                            tr(fieldLabel),
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).brightness == Brightness.light ? Colors.black : AppColors.lightBackground,
                            ),
                        ),
                        DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                                isExpanded: true,
                                hint: Text(
                                    tr("Select Value"),
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context).hintColor,
                                    ),
                                ),
                                items: records
                                    .map<DropdownMenuItem<String>>((item) => DropdownMenuItem<String>(
                                        value: "${item.id}",
                                        child: Text(
                                            item.getNameField(),
                                            style: const TextStyle(
                                                fontSize: 14,
                                            ),
                                        ),
                                    ))
                                    .toList(),
                                value: selectedValue.value,
                                onChanged: (String? value) {
                                    selectedValue.value = value!;
                                },
                                buttonStyleData: const ButtonStyleData(
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    height: 40,
                                    width: kIsWeb? 140 : 120,
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                    height: 40,
                                ),
                            ),
                        ),
                    ],
                );
            case AsyncError():
                return Text(
                    tr("Something went wrong"),
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                );
            default: 
                return const Center(child: CircularProgressIndicator());
        }
    }
}


class FilterProviderDropdown extends StatefulHookConsumerWidget {
    FilterProviderDropdown({
        required this.queryParams,
        required this.fieldLabel,
        required this.providerForFilterOptions,
        required this.providerToBeFiltered,
        required this.filterKeyIdentifier,
        this.pickIdFromOtherRecordsProperty,
        super.key
    });
    final dynamic queryParams;
    String fieldLabel;
    dynamic providerForFilterOptions;
    dynamic providerToBeFiltered;
    String filterKeyIdentifier;
    String? pickIdFromOtherRecordsProperty;
    ValueNotifier selectedValue = useState("99999999"); 
    // put the ValueNotifier here on StatefulHookConsumerWidget, 
    //otherwise it throw error

    @override
    _FilterProviderDropdown createState() => _FilterProviderDropdown();
}

class _FilterProviderDropdown extends ConsumerState<FilterProviderDropdown> {
    _FilterProviderDropdown();

    List<Map<String, dynamic>> filterOptions = [{"label": "Todos", "id": 99999999}];

    @override
    initState() {
        super.initState();

        WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.selectedValue.addListener(() {
                var notifier = ref.read(widget.providerToBeFiltered.notifier);
                if (widget.selectedValue.value == "99999999"){
                    if (widget.queryParams.value["filterBy"] != null){
                        widget.queryParams.value["filterBy"].remove(widget.filterKeyIdentifier);
                    }
                    notifier.fetchRecords(queryParams: widget.queryParams.value);
                }
                else {
                    if (widget.queryParams.value["filterBy"] != null){
                        widget.queryParams.value["filterBy"][widget.filterKeyIdentifier] = widget.selectedValue.value;
                    }
                    else {
                        widget.queryParams.value["filterBy"] = {
                            widget.filterKeyIdentifier: widget.selectedValue.value,
                        };
                    }
                    notifier.fetchRecords(queryParams: widget.queryParams.value);
                }
            });
        });
    }

    void _incrementarContador() {
        setState(() {
        });
    }

    // Widget build(BuildContext context, WidgetRef ref) {  XXX why this is not necessary to access ref? here? wtf
    @override
    Widget build(BuildContext context) {
        final asyncValue = ref.watch(widget.providerForFilterOptions);

        switch (asyncValue) {
            case AsyncData(): 
                final records = asyncValue.value["listRecords"];
                if (filterOptions.length == 1){
                    // XXX NOTE: Map function must expecify the type to avoid errors
                    var recordOptions = records.map<Map<String, dynamic>>((el) {
                        if (widget.pickIdFromOtherRecordsProperty != null){
                            Map mapEl = el.toJson();
                            return {
                                "label": el.getNameField(),
                                "id": mapEl[widget.pickIdFromOtherRecordsProperty]["id"]
                            };
                        }
                        else {
                            return {
                                "label": el.getNameField(),
                                "id": el.id
                            };
                        }
                    }).toList();
                    filterOptions.addAll(recordOptions);
                }

                return Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                        Text(
                            tr(widget.fieldLabel),
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).brightness == Brightness.light ? Colors.black : AppColors.lightBackground,
                            ),
                        ),
                        DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                                isExpanded: true,
                                hint: Text(
                                    tr("Select Value"),
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context).hintColor,
                                    ),
                                ),
                                items: filterOptions
                                    .map<DropdownMenuItem<String>>((item) => DropdownMenuItem<String>(
                                        value: "${item['id']}",
                                        child: Text(
                                            item['label'],
                                            style: const TextStyle(
                                                fontSize: 14,
                                            ),
                                        ),
                                    ))
                                    .toList(),
                                value: widget.selectedValue.value,
                                onChanged: (String? value) {
                                    widget.selectedValue.value = value!;
                                },
                                buttonStyleData: const ButtonStyleData(
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                    height: 40,
                                    width: kIsWeb? 140 : 120,
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                    height: 40,
                                ),
                            ),
                        ),
                    ],
                );
            case AsyncError():
                return Text(
                    tr("Something went wrong"),
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                );
            default: 
                return const Center(child: CircularProgressIndicator());
        }
    }
}
