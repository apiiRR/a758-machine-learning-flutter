import 'dart:developer';
import 'package:tflite_flutter/tflite_flutter.dart';

// todo-02-service-01: add service
class LiteRtService {
  // todo-02-service-02: setup static value and variable
  final modelPath = 'assets/rice_stock.tflite';

  late final Interpreter interpreter;
  late final List<String> labels;
  late List inputFormat;
  late List outputFormat;

  // todo-02-service-03: setup model
  Future<void> initModel() async {
    final options = InterpreterOptions()
      ..useNnApiForAndroid = true
      ..useMetalDelegateForIOS = true;

    // Load model from assets
    interpreter = await Interpreter.fromAsset(modelPath, options: options);
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

  // todo-02-service-03: setup inference and close function
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
