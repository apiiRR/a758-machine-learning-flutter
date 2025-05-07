import 'package:flutter/material.dart';

class DetectedObject {
  final Rect rect;
  final String text;
  final double confidenceScore;

  DetectedObject({
    required this.rect,
    required this.text,
    required this.confidenceScore,
  });
}
