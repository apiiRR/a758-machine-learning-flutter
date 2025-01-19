import 'package:camera/camera.dart';
import 'package:face_detection_app/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

// todo-04-painter-01: create a Custom Painter class and include two function
class FaceDetectorPainter extends CustomPainter {
  // todo-04-painter-02: add properties and constructor class
  FaceDetectorPainter(
    this.faces, {
    this.frameSize,
    this.rotation,
    this.cameraLensDirection,
  });

  final List<Face> faces;
  final Size? frameSize;
  final InputImageRotation? rotation;
  final CameraLensDirection? cameraLensDirection;

  @override
  void paint(Canvas canvas, Size size) {
    // todo-04-painter-03: check that state is null or empty
    final imageSize = frameSize;
    if (imageSize == null || faces.isEmpty) return;

    // todo-04-painter-04: setup paint color with stroke
    final Paint paint1 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..color = Colors.red;

    // todo-04-painter-05: loop the bounding box
    // you can use translateX and translateY to get a ratio of image on app.
    for (var face in faces) {
      final rect = face.boundingBox;
      final left =
          translateX(rect.left, size, imageSize, rotation, cameraLensDirection);
      final top =
          translateY(rect.top, size, imageSize, rotation, cameraLensDirection);
      final right = translateX(
          rect.right, size, imageSize, rotation, cameraLensDirection);
      final bottom = translateY(
          rect.bottom, size, imageSize, rotation, cameraLensDirection);

      canvas.drawRect(
        Rect.fromLTRB(left, top, right, bottom),
        paint1,
      );
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.faces != faces;
  }
}
