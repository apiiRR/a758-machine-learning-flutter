import 'dart:io';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:mime/mime.dart';
import 'package:transcript_app/env/env.dart';

// todo-02-gemini-01: open Google AI Studio, setup Gemini Parameter
// todo-02-gemini-02: try the model and prompt, and see the result.
// todo-02-gemini-03: create a service class
class GeminiService {
  // todo-02-gemini-04: setup a model variable
  late final GenerativeModel model;

  GeminiService() {
    final apiKey = Env.geminiApiKey;
    model = GenerativeModel(
      model: 'gemini-1.5-pro',
      apiKey: apiKey,
      // todo-02-gemini-05: see the Google AI Studio code and copy the responseMimeType and responseSchema value.
      generationConfig: GenerationConfig(
        temperature: 0,
        responseMimeType: 'application/json',
        responseSchema: Schema(
          SchemaType.object,
          requiredProperties: ["segments"],
          properties: {
            "segments": Schema(
              SchemaType.array,
              items: Schema(
                SchemaType.object,
                requiredProperties: ["speaker", "timecode", "caption"],
                properties: {
                  "speaker": Schema(SchemaType.string),
                  "timecode": Schema(SchemaType.string),
                  "caption": Schema(SchemaType.string),
                },
              ),
            ),
          },
        ),
      ),
    );
  }

  // todo-02-gemini-06: create a generateTranscript based your prompt before.
  Future<String> generateTranscript(File file) async {
    var content = Content.multi([
      TextPart(
        """Transkripsikan wawancara ini dengan format: timecode (HH:MM:SS) yang akurat, nama pembicara (jika diketahui, jika tidak gunakan Pembicara A, Pembicara B, dst.), dan teks percakapan. Pastikan timecode tepat pada setiap pergantian pembicara. Jika ada kesalahan timecode, koreksi secara otomatis.""",
      ),
      DataPart(lookupMimeType(file.path)!, file.readAsBytesSync()),
    ]);
    final response = await model.generateContent([content]);
    print("token: ${response.usageMetadata?.totalTokenCount}");

    final responseText = response.text!;
    print("responseText: $responseText");

    return responseText;
  }
}
