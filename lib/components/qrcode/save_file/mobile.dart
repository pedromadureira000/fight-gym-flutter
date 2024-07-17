import 'dart:io' show File;
import 'dart:ui';
import 'package:path_provider/path_provider.dart';
import 'package:fight_gym/config/app_config.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'dart:convert';


saveFile(record) async {
    try {
        record = await record;
        var qrData = {
            "customer_id": record.id,
        };
        // PrettyQrView.data(data: json.encode(qrData));
        final qrCode = QrCode.fromData(
          data: json.encode(qrData),
          errorCorrectLevel: QrErrorCorrectLevel.H,
        );
        final qrImage = QrImage(qrCode);
        final qrImageBytes = await qrImage.toImageAsBytes(
          size: 512,
          format: ImageByteFormat.png,
          decoration: const PrettyQrDecoration(),
        );

        // Convert ByteData to Uint8List
        final buffer = qrImageBytes!.buffer;
        final qrImageUint8List = buffer.asUint8List(qrImageBytes.offsetInBytes, qrImageBytes.lengthInBytes);

        // Get the directory to save the file
        final directory = await getApplicationDocumentsDirectory();
        final path = '${directory.path}/qr_code.png';
        // Write the file
        final file = File(path);
        await file.writeAsBytes(qrImageUint8List);
        // TODO - I don't want just to save it. I want to share it.
        AppConfig.logger.d("QR code saved to $path");
    } catch (err, stack) {
        AppConfig.logger.d("err $err");
        AppConfig.logger.d("stack $stack");
    }
}
