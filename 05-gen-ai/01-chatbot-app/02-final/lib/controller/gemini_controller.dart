import 'package:chatbot_app/model/chat.dart';
import 'package:chatbot_app/service/gemini_service.dart';
import 'package:flutter/widgets.dart';

// todo-03-controller-01: create a controller to handle the service
class GeminiController extends ChangeNotifier {
  final GeminiService service;

  GeminiController(this.service);

  // todo-03-controller-02: set the state
  final List<Chat> _historyChats = [];

  List<Chat> get historyChats => _historyChats.reversed.toList();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // todo-03-controller-03: send the message
  Future<void> sendMessage(String message, [List<String>? paths]) async {
    _historyChats.add(Chat(text: message, isMyChat: true, paths: paths));
    _isLoading = true;
    notifyListeners();

    final response = await service.sendMessage(message, _historyChats, paths);

    _historyChats.add(Chat(text: response, isMyChat: false));
    _isLoading = false;
    notifyListeners();
  }
}
