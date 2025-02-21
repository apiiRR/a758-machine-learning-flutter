import 'package:house_price_predictor_app/service/service.dart';
import 'package:flutter/widgets.dart';

class LiteRtController extends ChangeNotifier {
  final LiteRtService service;

  LiteRtController(this.service);

  double _number = 0;

  double get number => _number;

  void runInference(double value) {
    _number = service.inference(value);
    notifyListeners();
  }

  void close() => service.close();
}
