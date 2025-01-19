import 'package:face_detection_app/controller/camera_provider.dart';
import 'package:face_detection_app/utils/face_detector_painter.dart';
import 'package:face_detection_app/widget/camera_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Face Detection App'),
      ),
      // todo-03-ui-01: consume the CameraView with Consumer
      // make the CameraView as a child and return the builder with child
      body: Consumer<CameraProvider>(
        builder: (context, value, child) {
          // todo-04-painter-06: use FaceDetectorPainter as CustomPaint widget
          final faces = value.faces;
          final inputImage = value.inputImage;
          final cameraLensDirection = value.cameraLensDirection;

          return CustomPaint(
            foregroundPainter: FaceDetectorPainter(
              faces,
              frameSize: inputImage?.metadata?.size,
              rotation: inputImage?.metadata?.rotation,
              cameraLensDirection: cameraLensDirection,
            ),
            child: child,
          );
        },
        child: CameraView(
          // todo-03-ui-02: add onImage callback and run the face detection system
          onImage: (inputImage) async {
            final cameraProvider = context.read<CameraProvider>();
            await cameraProvider.detectingFacesStream(inputImage);
          },
          // todo-03-ui-03: update the camera lens direction state
          onCameraLensDirectionChanged: (direction) {
            final cameraProvider = context.read<CameraProvider>();
            cameraProvider.cameraLensDirection = direction;
          },
        ),
      ),
    );
  }
}
