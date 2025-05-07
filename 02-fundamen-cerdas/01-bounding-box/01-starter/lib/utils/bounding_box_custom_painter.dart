import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../model/detected_object.dart';

class BoundingBoxCustomPainter extends CustomPainter {
  final List<DetectedObject> detectedObjects;

  const BoundingBoxCustomPainter({required this.detectedObjects});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint myPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 3;

    for (var detectedObject in detectedObjects) {
      canvas.drawRect(
          detectedObject.rect, myPaint..style = PaintingStyle.stroke);

      int roundedPercentage = (detectedObject.confidenceScore * 100).round();
      final text = "${detectedObject.text} $roundedPercentage%";

      final paragraphStyle = ui.ParagraphStyle(
        textAlign: TextAlign.left,
        textDirection: ui.TextDirection.ltr,
      );

      final textStyle = ui.TextStyle(
          color: Colors.white,
          background: myPaint..style = PaintingStyle.fill,
          fontSize: 12);

      final paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
        ..pushStyle(textStyle)
        ..addText(text);
      final paragraphConstraints = ui.ParagraphConstraints(width: size.width);
      final paragraph = paragraphBuilder.build()..layout(paragraphConstraints);

      canvas.drawParagraph(
          paragraph, Offset(detectedObject.rect.left, detectedObject.rect.top));
    }
  }

  @override
  bool shouldRepaint(covariant BoundingBoxCustomPainter oldDelegate) {
    return detectedObjects != oldDelegate.detectedObjects;
  }
}
