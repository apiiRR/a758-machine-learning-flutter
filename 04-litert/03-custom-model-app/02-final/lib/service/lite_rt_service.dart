import 'dart:developer';

import 'package:tflite_flutter/tflite_flutter.dart';

// todo-02-service-02: add service
class LiteRtService {
  // todo-02-service-03: setup static value and variable
  final modelPath = 'assets/house_price_prediction.tflite';

  late final Interpreter interpreter;
  late final List<String> labels;
  late List inputFormat;
  late List outputFormat;

  // todo-02-service-04: setup model
  Future<void> initModel() async {
    final options = InterpreterOptions()
      ..useNnApiForAndroid = true
      ..useMetalDelegateForIOS = true;

    // Load model from assets
    interpreter = await Interpreter.fromAsset(modelPath, options: options);
    // Get tensor output shape [1, 1]
    final outputTensor = interpreter.getOutputTensors().first;
    final outputShape = outputTensor.shape;
    log('outputShape: $outputShape');
    // Create a list [1, 1]
    outputFormat = List.generate(
      outputShape.first,
      (_) => List.generate(outputShape.last, (_) => 0.0),
    );
    log('outputFormat: $outputFormat');

    log('Interpreter loaded successfully');
  }

  // todo-02-service-05: setup inference and close function
  double inference(List<double> number) {
    // Get tensor input shape [1, 4, 1]
    final inputTensor = interpreter.getInputTensors().first;
    final inputShape = inputTensor.shape;
    log('inputShape: $inputShape');
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
    log('outputFormat: $outputFormat (after)');
    return result;
  }

  void close() {
    interpreter.close();
  }
}
