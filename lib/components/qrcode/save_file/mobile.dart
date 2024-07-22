import 'dart:io' show File;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fight_gym/config/app_config.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'dart:convert';
import 'package:share_plus/share_plus.dart';


Future<void> saveFile(record) async {
    try {
        record = await record;
        var qrData = {
          "customer_id": record.id,
        };

        int qrImageSize = 300;
        double padding = 360; // Gap between the QR code and the limits of the image
        int textGap = 120; // Gap between the text and the QR code

        final qrCode = QrCode.fromData(
          data: json.encode(qrData),
          errorCorrectLevel: QrErrorCorrectLevel.H,
        );
        final qrImage = QrImage(qrCode);
        final qrImageBytes = await qrImage.toImageAsBytes(
          size: qrImageSize,
          format: ImageByteFormat.png,
          decoration: const PrettyQrDecoration(
            background: Colors.white,
          ),
        );

        // Convert ByteData to Uint8List
        final buffer = qrImageBytes!.buffer;
        final qrImageUint8List = buffer.asUint8List(qrImageBytes.offsetInBytes, qrImageBytes.lengthInBytes);

        // Create an Image object from the QR code bytes
        var codec = await instantiateImageCodec(qrImageUint8List);
        FrameInfo frameInfo = await codec.getNextFrame();
        var imgObj = frameInfo.image;

        // Create an image with the text above the QR code
        final recorder = PictureRecorder();
        final canvas = Canvas(recorder);

        // Define the text style
        const textStyle = TextStyle(
          color: Color(0xFF000000),
          fontSize: 44,
        );

        // Create a text painter to measure and draw the text
        final textPainter = TextPainter(
          text: TextSpan(
            text: "Aluno: ${record.name}",
            style: textStyle,
          ),
          textDirection: TextDirection.ltr,
        );

        textPainter.layout();

        // Draw a white background
        final paintBackground = Paint()..color = Colors.white;
        canvas.drawRect(
          Rect.fromLTWH(0, 0, qrImageSize + padding * 2, qrImageSize + padding * 2 + textPainter.height + textGap),
          paintBackground,
        );

        // Draw the text on the canvas
        var horizontal = (qrImageSize + padding * 2 - textPainter.width) / 2;
        final textOffset = Offset(
          horizontal,
          padding,
        );

        textPainter.paint(canvas, textOffset);

        // Draw the QR code below the text with padding
        final imageOffset = Offset(
          padding,
          padding + textPainter.height + textGap,
        );

        final paint = Paint();
        canvas.drawImage(imgObj, imageOffset, paint);

        // Calculate the final image size
        int finalImageWidth = qrImageSize + padding.round() * 2;
        int finalImageHeight = qrImageSize + padding.round() * 2 + textPainter.height.toInt() + textGap;

        // Get the combined image as bytes
        final combinedImage = await recorder.endRecording().toImage(finalImageWidth, finalImageHeight);
        final byteData = await combinedImage.toByteData(format: ImageByteFormat.png);
        final combinedImageBytes = byteData!.buffer.asUint8List();

        // Get the directory to save the file
        final directory = await getApplicationDocumentsDirectory();
        final path = '${directory.path}/qr_code.png';
        // Write the file
        final file = File(path);
        await file.writeAsBytes(combinedImageBytes);
        Share.shareXFiles([XFile(path)], text: 'Check out this file!');
    } catch (err, stack) {
        AppConfig.logger.d("err $err");
        AppConfig.logger.d("stack $stack");
    }
}
