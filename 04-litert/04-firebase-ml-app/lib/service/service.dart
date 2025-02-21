import 'dart:developer';
import 'dart:io';
import 'package:house_price_predictor_app/service/firebase_ml_service.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class LiteRtService {
  // todo-04: add new property and constructor to get a firebase ml service
  final FirebaseMlService _mlService;
  LiteRtService(this._mlService);

  late final File modelFile;

  late final Interpreter interpreter;
  late final List<String> labels;
  late List inputFormat;
  late List outputFormat;


  Future<void> initModel() async {
    // todo-05: replace a asset path, use a model file, load a model from file
    modelFile = await _mlService.loadModel();

    final options = InterpreterOptions()
      ..useNnApiForAndroid = true
      ..useMetalDelegateForIOS = true;

    // Load model from assets
    interpreter = Interpreter.fromFile(modelFile, options: options);
    // Get tensor input shape [1, 1]
    final inputTensor = interpreter.getInputTensors().first;
    // Get tensor output shape [1, 1]
    final outputTensor = interpreter.getOutputTensors().first;
    log('inputTensor: $inputTensor, outputTensor: $outputTensor');

    _setupFormatShape(inputTensor, outputTensor);
    log('Interpreter loaded successfully');
  }

  void _setupFormatShape(Tensor inputTensor, Tensor outputTensor) {
    final inputShape = inputTensor.shape;
    final outputShape = outputTensor.shape;

    inputFormat = List.generate(
      inputShape.first,
      (_) => List.generate(inputShape.last, (_) => 0.0),
    );
    outputFormat = List.generate(
      outputShape.first,
      (_) => List.generate(outputShape.last, (_) => 0.0),
    );
    log('inputFormat: $inputFormat, outputFormat: $outputFormat');
  }

  double inference(double number) {
    inputFormat.first.first = number;

    interpreter.run(inputFormat, outputFormat);

    final result = outputFormat.first.first;
    return result;
  }

  void close() {
    interpreter.close();
  }
}
