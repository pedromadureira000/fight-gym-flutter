import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fight_gym/config/app_config.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'dart:convert';
import 'dart:html' as html;


_saveFile(record) async {
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

Future<void> __saveFile(record) async {
  try {
    record = await record;
    var qrData = {
      "customer_id": record.id,
    };

    int qrImageSize = 320;

    final qrCode = QrCode.fromData(
      data: json.encode(qrData),
      errorCorrectLevel: QrErrorCorrectLevel.H,
    );
    final qrImage = QrImage(qrCode);
    final qrImageBytes = await qrImage.toImageAsBytes(
      size: qrImageSize,
      format: ImageByteFormat.png,
      decoration: const PrettyQrDecoration(),
    );

    // Convert ByteData to Uint8List
    final buffer = qrImageBytes!.buffer;
    final qrImageUint8List = buffer.asUint8List(qrImageBytes.offsetInBytes, qrImageBytes.lengthInBytes);

    // try to make it a Image obj
    var codec = await instantiateImageCodec(qrImageUint8List);
    FrameInfo frameInfo = await codec.getNextFrame();
    var imgObjEllegidly = frameInfo.image;

    // Create an image with the text above the QR code
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);

    // Define the text style
    const textStyle = TextStyle(
      color: Color(0xFF000000),
      fontSize: 20,
    );

    // Create a text painter to measure and draw the text
    final textPainter = TextPainter(
      text: const TextSpan(
        text: "This is the user's QR code to scan.",
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    // Draw the text on the canvas
    var horizontal = ((qrImageSize) - (textPainter.width)) / 2;
    final textOffset = Offset(
      horizontal,
      0,
    );

    textPainter.paint(canvas, textOffset);

    // Draw the QR code below the text
    final imageOffset = Offset(
      0,
      textPainter.height + 10, // Add some space between the text and the QR code
    );

    final paint = Paint();
    canvas.drawImage(imgObjEllegidly, imageOffset, paint);

    // Get the combined image as bytes
    final combinedImage = await recorder.endRecording().toImage(qrImageSize, qrImageSize + textPainter.height.toInt() + 10);
    final byteData = await combinedImage.toByteData(format: ImageByteFormat.png);
    final combinedImageBytes = byteData!.buffer.asUint8List();

    // Get the directory to save the file
    final blob = html.Blob([combinedImageBytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "qr_code.png")
      ..click();

    html.Url.revokeObjectUrl(url);
  } catch (err, stack) {
    AppConfig.logger.d("err $err");
    AppConfig.logger.d("stack $stack");
  }
}

Future<void> saveFile(record) async {
  try {
    record = await record;
    var qrData = {
      "customer_id": record.id,
    };

    int qrImageSize = 300;
    int padding = 360; // Gap between the QR code and the limits of the image
    int textGap = 120; // Gap between the text and the QR code

    final qrCode = QrCode.fromData(
      data: json.encode(qrData),
      errorCorrectLevel: QrErrorCorrectLevel.H,
    );
    final qrImage = QrImage(qrCode);
    final qrImageBytes = await qrImage.toImageAsBytes(
      size: qrImageSize,
      format: ImageByteFormat.png,
      decoration: const PrettyQrDecoration(),
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

    // Draw the text on the canvas
    var horizontal = (qrImageSize + padding * 2 - textPainter.width) / 2;
    final textOffset = Offset(
      horizontal,
      padding as double,
    );

    textPainter.paint(canvas, textOffset);

    // Draw the QR code below the text with padding
    final imageOffset = Offset(
      padding as double,
      padding + textPainter.height + textGap,
    );

    final paint = Paint();
    canvas.drawImage(imgObj, imageOffset, paint);

    // Calculate the final image size
    int finalImageWidth = qrImageSize + padding * 2;
    int finalImageHeight = qrImageSize + padding * 2 + textPainter.height.toInt() + textGap;

    // Get the combined image as bytes
    final combinedImage = await recorder.endRecording().toImage(finalImageWidth, finalImageHeight);
    final byteData = await combinedImage.toByteData(format: ImageByteFormat.png);
    final combinedImageBytes = byteData!.buffer.asUint8List();

    // Get the directory to save the file
    final blob = html.Blob([combinedImageBytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "qr_code.png")
      ..click();
    html.Url.revokeObjectUrl(url);
  } catch (err, stack) {
    AppConfig.logger.d("err $err");
    AppConfig.logger.d("stack $stack");
  }
}
