import 'package:flutter/widgets.dart';
import 'package:transcript_app/model/transcript.dart';
import 'package:transcript_app/service/gemini_service.dart';
import 'package:transcript_app/utils/utils.dart';

// todo-03-controller-01: create a controller
class GeminiController extends ChangeNotifier {
  // todo-03-controller-02: setup a property and constructor
  final GeminiService service;

  GeminiController(this.service);

  // todo-03-controller-03: make a transcript and loading state
  Transcript? _transcript;

  Transcript? get transcript => _transcript;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // todo-03-controller-04: create a function to get a transcript
  Future<void> generateTranscript() async {
    _transcript = null;
    _isLoading = true;
    notifyListeners();

    final file = await getFileFromAssets("softskill_podcast.mp3");
    final response = await service.generateTranscript(file);

    _transcript = Transcript.fromJson(response);
    _isLoading = false;
    notifyListeners();
  }
}
