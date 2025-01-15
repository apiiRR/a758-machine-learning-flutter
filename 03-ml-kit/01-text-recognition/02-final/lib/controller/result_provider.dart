import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:text_recognition_app/service/text_recognition_service.dart';

// todo-04: add controller to handle the state
class ResultProvider extends ChangeNotifier {
  // todo-05: add constructor
  final TextRecognitionService _service;

  ResultProvider([
    TextRecognitionService? service,
  ]) : _service = service ?? TextRecognitionService();

  // todo-06: add state
  String? detectedText;
  bool isProcessing = false;

  // todo-07: create a function to run the process
  void runTextRecognition(String path) async {
    detectedText = null;
    isProcessing = true;
    notifyListeners();

    detectedText = await _service.runRecognizedText(path);
    isProcessing = false;
    notifyListeners();
  }

  // todo-13: create a action to copy
  void copyText(BuildContext context) async {
    if (detectedText == null) return;

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final clipboardData = ClipboardData(text: detectedText!);
    await Clipboard.setData(clipboardData);

    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text('Copied to Clipboard!')),
    );
  }
}
