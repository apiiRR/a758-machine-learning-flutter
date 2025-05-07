import 'package:bounding_box_app/utils/bounding_box_custom_painter.dart';
import 'package:flutter/material.dart';

import '../model/detected_object.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  List<DetectedObject> get detectedObjects => [
        DetectedObject(
          text: "laptop",
          confidenceScore: 0.64,
          rect: const Rect.fromLTRB(98, 23, 248, 215),
        ),
        DetectedObject(
          text: "cell phone",
          confidenceScore: 0.57,
          rect: const Rect.fromLTRB(255, 103, 288, 154),
        ),
        DetectedObject(
          text: "Cup",
          confidenceScore: 0.60,
          rect: const Rect.fromLTRB(257, 158, 320, 219),
        ),
        DetectedObject(
          text: "keyboard",
          confidenceScore: 0.48,
          rect: const Rect.fromLTRB(110, 120, 238, 175),
        ),
        DetectedObject(
          text: "note",
          confidenceScore: 0.43,
          rect: const Rect.fromLTRB(5, 114, 100, 210),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomPaint(
              foregroundPainter:
                  BoundingBoxCustomPainter(detectedObjects: detectedObjects),
              child: Image.asset(
                "assets/macbook-air.jpg",
                fit: BoxFit.cover,
                width: 350,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
