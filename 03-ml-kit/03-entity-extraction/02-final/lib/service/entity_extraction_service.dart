import 'package:google_ml_kit/google_ml_kit.dart';

// todo-01-init-02: create a service
class EntityExtractionService {
  // todo-01-init-03: set the init and static value
  final _modelManager = EntityExtractorModelManager();
  final _entityExtractor = EntityExtractor(
    language: _language,
  );
  static final _language = EntityExtractorLanguage.english;

  // todo-01-init-04: create a constructor to download the model
  EntityExtractionService() {
    downloadModel();
  }

  Future<void> downloadModel() async {
    final isModelDownloaded =
        await _modelManager.isModelDownloaded(_language.name);

    if (!isModelDownloaded) {
      await _modelManager.downloadModel(_language.name);
    }
  }

  // todo-01-init-05: add function to extract the text
  Future<List<EntityAnnotation>> extractEntity(String text) async {
    final annotateText = await _entityExtractor.annotateText(text);
    return annotateText;
  }

  Future<void> close() => _entityExtractor.close();
}
