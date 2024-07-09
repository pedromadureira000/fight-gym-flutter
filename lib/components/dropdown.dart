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

class SelectGroupDropdown extends HookConsumerWidget {
    SelectGroupDropdown(this.selectedGroup, this.provider, {Key? key}) : super(key: key);
    ValueNotifier selectedGroup;
    AsyncNotifierProvider provider;

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        final asyncValue = ref.watch(provider);
        switch (asyncValue) {
            case AsyncData(): 
                final records = asyncValue.value;
                return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                        Text(
                            tr("Group"),
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).brightness == Brightness.light ? Colors.black : AppColors.lightBackground,
                            ),
                        ),
                        DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                                isExpanded: true,
                                hint: Text(
                                    tr("Select group"),
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context).hintColor,
                                    ),
                                ),
                                items: records
                                    .map<DropdownMenuItem<String>>((item) => DropdownMenuItem<String>(
                                        value: "${item.id}",
                                        child: Text(
                                            item.name,
                                            style: const TextStyle(
                                                fontSize: 14,
                                            ),
                                        ),
                                    ))
                                    .toList(),
                                value: selectedGroup.value,
                                onChanged: (String? value) {
                                    selectedGroup.value = value!;
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
                    label,
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
