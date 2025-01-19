import 'package:camera/camera.dart';
import 'package:face_detection_app/service/face_detection_service.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

// todo-02-viewmodel-01: create a viewmodel class
class CameraProvider extends ChangeNotifier {
  // todo-02-viewmodel-02: add property and constructor
  final FaceDetectionService _service;

  CameraProvider(this._service);

  // todo-02-viewmodel-03: setup a states
  List<Face> _faces = [];
  List<Face> get faces => _faces;

  InputImage? _inputImage;
  InputImage? get inputImage => _inputImage;

  CameraLensDirection? _cameraLensDirection;
  CameraLensDirection? get cameraLensDirection => _cameraLensDirection;
  set cameraLensDirection(CameraLensDirection? value) {
    _cameraLensDirection = value;
    notifyListeners();
  }

  // todo-02-viewmodel-04: detecting the faces
  Future<void> detectingFacesStream(InputImage inputImage) async {
    _inputImage = inputImage;

    _faces = await _service.runDetectingFaces(_inputImage!);
    notifyListeners();

    debugPrint("face count: ${_faces.length}");
  }
}
