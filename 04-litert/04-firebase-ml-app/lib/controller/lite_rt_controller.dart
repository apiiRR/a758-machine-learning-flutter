import 'package:house_price_predictor_app/model/house_detail.dart';
import 'package:house_price_predictor_app/service/lite_rt_service.dart';
import 'package:flutter/widgets.dart';

class LiteRtController extends ChangeNotifier {
  final LiteRtService service;

  LiteRtController(this.service);

  double _number = 0;

  double get number => _number;

  void runInference(HouseDetail value) {
    _number = service.inference(value.values);
    notifyListeners();
  }

  void close() => service.close();
}
