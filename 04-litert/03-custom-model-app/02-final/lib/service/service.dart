import 'dart:developer';

import 'package:tflite_flutter/tflite_flutter.dart';

// todo-02-service-01: add service
class LiteRtService {
  // todo-02-service-02: setup static value and variable
  final modelPath = 'assets/house_price_prediction.tflite';

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
    // Get tensor output shape [1, 1]
    final outputTensor = interpreter.getOutputTensors().first;

    _setupFormatShape(outputTensor);
    log('Interpreter loaded successfully');
  }

  void _setupFormatShape(Tensor outputTensor) {
    final outputShape = outputTensor.shape;

    // create a list [1, 1]
    outputFormat = List.generate(
      outputShape.first,
      (_) => List.generate(outputShape.last, (_) => 0.0),
    );
    log('outputFormat: $outputFormat');
  }

  // todo-02-service-03: setup inference and close function
  double inference(List<double> number) {
    // Get tensor input shape [1, 4, 1]
    final inputTensor = interpreter.getInputTensors().first;
    final inputShape = inputTensor.shape;
    // Create a list [1, 4, 1]
    inputFormat = List.generate(
      inputShape.first,
      (_) => List.generate(
        inputShape[1],
        (i) => List.generate(inputShape.last, (_) => number[i]),
      ),
    );
    log('inputFormat: $inputFormat');

    interpreter.run(inputFormat, outputFormat);

    final result = outputFormat.first.first;
    return result;
  }

  void close() {
    interpreter.close();
  }
}
