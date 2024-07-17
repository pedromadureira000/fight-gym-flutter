import 'package:fight_gym/config/app_config.dart';
import 'package:fight_gym/config/app_routes.dart';
import 'package:fight_gym/model/models.dart';
import 'package:fight_gym/provider/modules/attendance_provider.dart';
import 'package:fight_gym/styles/app_colors.dart';
import 'package:fight_gym/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import "package:hooks_riverpod/hooks_riverpod.dart";
import 'dart:convert';



class ScanCustomerCodePage extends HookConsumerWidget {
    const ScanCustomerCodePage({super.key});

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        CustomDarkThemeStyles customDarkThemeStyles = CustomDarkThemeStyles(Theme.of(context).brightness);
        final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
        var record = arguments["record"];
        AppConfig.logger.d('record $record');
        // record Class(id: 15, modality: {id: 13, name: tttta}, start_time: 21:15:00, end_time: 21:15:00, max_participants: 123)

        return Scaffold(
            appBar: AppBar(
                title: const Text('Scan QR Code'),
                leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: customDarkThemeStyles.arrowBackColor),
                    onPressed: () {
                        Navigator.pop(context);
                    },
                ),
                // actions: [
                      // IconButton(
                        // onPressed: () {
                          // Navigator.popAndPushNamed(context, "/generate");
                        // },
                        // icon: const Icon(
                          // Icons.qr_code,
                        // ),
                      // ),
                // ],
            ),
            body: MobileScanner(
                controller: MobileScannerController(
                    detectionSpeed: DetectionSpeed.noDuplicates,
                    returnImage: false,
                ),
                onDetect: (capture) async {
                    final List<Barcode> barcodes = capture.barcodes;
                    for (final barcode in barcodes) {
                        AppConfig.logger.d("Barcode found! ${barcode.rawValue}");
                        if (barcode.rawValue.runtimeType == String){
                            try {
                                AppConfig.logger.d("lets go");
                                dynamic qrcodeMap = jsonDecode(barcode.rawValue ?? "");
                                var notifier = ref.read(asyncAttendanceProvider.notifier);
                                Attendance attendance = Attendance(
                                    customer: {
                                        "id": qrcodeMap["customer_id"],
                                        "name": "fodder-read-only"
                                    },
                                    class_instance: {
                                        "id": record.id,
                                        "modality_name": "fodder-read-only"
                                    },
                                    date: DateTime.now().toIso8601String().split('T')[0],
                                );
                                var (result, recordMap) = await notifier.addRecord(attendance);
                                AppConfig.logger.d("result $result");
                                AppConfig.logger.d("recordMap $recordMap");
                                if (result != "success"){
                                    showSnackBar(context, result, "error");
                                }
                                else {
                                    showSnackBar(context, "Attendance added with success", "success");
                                    Navigator.pop(context);
                                }
                            } catch (err, stack) {
                                AppConfig.logger.d('err $err');
                                AppConfig.logger.d('stack $stack');
                                showSnackBar(context, "Error while trying to read qr code and create attendance.", "error");
                            }
                        }
                    }
                },
            ),
        );
    }
}
