import 'dart:ui';
import 'package:fight_gym/config/app_config.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'dart:convert';
import 'dart:html' as html;


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
        // ignore: undefined_prefixed_name
        final blob = html.Blob([qrImageUint8List]);
        // ignore: undefined_prefixed_name
        final url = html.Url.createObjectUrlFromBlob(blob);
        // ignore: undefined_prefixed_name
        final anchor = html.AnchorElement(href: url)
        // ignore: undefined_prefixed_name
        ..setAttribute("download", "qr_code.png")
        // ignore: undefined_prefixed_name
        ..click();
        // ignore: undefined_prefixed_name
        html.Url.revokeObjectUrl(url);
    } catch (err, stack) {
        AppConfig.logger.d("err $err");
        AppConfig.logger.d("stack $stack");
    }
}
