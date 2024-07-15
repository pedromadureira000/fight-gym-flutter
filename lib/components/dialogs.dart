import "package:easy_localization/easy_localization.dart";
import "package:fight_gym/config/app_routes.dart";
import "package:fight_gym/page/facade.dart";
import "package:flutter/material.dart";
import "package:fight_gym/styles/app_colors.dart";
import "package:fight_gym/styles/app_text.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";


showDeleteDialog(BuildContext context, WidgetRef ref, record, provider, menuRoute){
    CustomDarkThemeStyles customDarkThemeStyles = CustomDarkThemeStyles(Theme.of(context).brightness);
    return showDialog<String>(
        context: context,
        builder: (BuildContext context) => Dialog(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        SizedBox(
                            width: 300,
                            child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                    children: [
                                        Text(tr("Are you sure you want to delete it? ")),
                                        const SizedBox(height: 15),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                                ElevatedButton(
                                                    onPressed: () {
                                                        handlePopNavigation(context, menuRoute);
                                                    },
                                                    style: customDarkThemeStyles.elevatedBtnStyleCancelDeletion,
                                                    child: Text(tr("Close"), style: AppText.normalText),
                                                ),
                                                ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        backgroundColor: Colors.red[900],
                                                        foregroundColor: AppColors.lightBackground,
                                                    ),
                                                    onPressed: () {
                                                        deleteRecord(ref, context, record, provider, menuRoute);
                                                    },
                                                    child: Text(tr("Delete"), style: AppText.normalText)
                                                ),
                                            ],
                                        ),
                                    ]
                                )
                            ),
                        ),
                    ],
                ),
            ),
        ),
    );
}
