import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<BitmapDescriptor> createCustomMarkerIcon(
    String text, Color bgColor) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);

  final width = 40.0 + text.length * 9.0;
  const height = 45.0;

  final paint = Paint()
    ..color = bgColor
    ..style = PaintingStyle.fill;

  final rect = Rect.fromLTRB(0, 0, width, height);
  canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(20)), paint);

  final textPainter = TextPainter(
    text: TextSpan(
      text: text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textDirection: TextDirection.ltr,
  );

  textPainter.layout(minWidth: 0, maxWidth: width);

  textPainter.paint(
    canvas,
    Offset((width - textPainter.width) / 2, (height - textPainter.height) / 2),
  );

  final picture = recorder.endRecording();
  final img = await picture.toImage(width.toInt(), height.toInt());
  final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

  final Uint8List byteList = byteData!.buffer.asUint8List();
  return BitmapDescriptor.fromBytes(byteList);
}
