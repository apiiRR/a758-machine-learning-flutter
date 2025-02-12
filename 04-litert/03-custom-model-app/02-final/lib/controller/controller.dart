import 'package:firebase_ml_app/service/service.dart';
import 'package:flutter/widgets.dart';

// todo-03-controller-01: create a class
class LiteRtController extends ChangeNotifier {
  // todo-03-controller-02: add a property and constructor
  final LiteRtService service;

  LiteRtController(this.service);

  // todo-03-controller-03: add state alse create a runInference and close method
  double _number = 0;

  double get number => _number;

  void runInference(double value) {
    _number = service.inference(value);
    notifyListeners();
  }

  void close() => service.close();
}
