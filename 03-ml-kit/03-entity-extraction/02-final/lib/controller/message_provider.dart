import 'package:entity_extraction_app/service/entity_extraction_service.dart';
import 'package:flutter/widgets.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

// todo-02-controller-01: create a controller class
class MessageProvider extends ChangeNotifier {
  // todo-02-controller-02: inject the service
  final EntityExtractionService _service;

  MessageProvider(this._service);

  // todo-02-controller-03: setup the state
  bool _isExtracting = false;
  bool get isExtracting => _isExtracting;
  List<EntityAnnotation> listOfEntityAnnotation = [];

  // todo-02-controller-04: add a function to run the service
  void extractText(String text) async {
    _isExtracting = true;
    listOfEntityAnnotation = [];
    notifyListeners();

    listOfEntityAnnotation = await _service.extractEntity(text);
    _isExtracting = false;
    notifyListeners();
    print(listOfEntityAnnotation);
    
    _close();
  }

  void _close() async => await _service.close();
}
