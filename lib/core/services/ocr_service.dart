import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrService {
  final TextRecognizer _textRecognizer = TextRecognizer();

  // Extract text from image
  Future<String> extractText(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final recognizedText = await _textRecognizer.processImage(inputImage);
      return recognizedText.text;
    } catch (e) {
      throw Exception('OCR failed: $e');
    }
  }

  // Parse lab results from extracted text.
  //
  // This is a best-effort on-device heuristic — OCR layouts vary wildly, so it
  // only captures the first number that appears after a known label on the same
  // line (`[^\n\d]*` skips words like "Count" but never crosses a line break or
  // an earlier number). Tests whose value can't be read are dropped rather than
  // surfaced as "null". For robust extraction across messy reports, use the AI
  // analysis path.
  Map<String, dynamic> parseLabResults(String text) {
    final results = <String, dynamic>{};

    // Each label alternation is a NON-capturing group so group(1) is always the
    // numeric value (the previous version's `wbc|white blood cell(...)` matched
    // the bare name and captured nothing → null).
    final patterns = {
      'hemoglobin': RegExp(
        r'h[ae]moglobin[^\n\d]*(\d+\.?\d*)\s*(g/dl|mg/dl|g/l)?',
        caseSensitive: false,
      ),
      'glucose': RegExp(
        r'glucose[^\n\d]*(\d+\.?\d*)\s*(mg/dl|g/l|mmol/l)?',
        caseSensitive: false,
      ),
      'wbc': RegExp(
        r'(?:wbc|white blood cells?)[^\n\d]*(\d+\.?\d*)',
        caseSensitive: false,
      ),
      'rbc': RegExp(
        r'(?:rbc|red blood cells?)[^\n\d]*(\d+\.?\d*)',
        caseSensitive: false,
      ),
      'platelets': RegExp(
        r'platelets?[^\n\d]*(\d+\.?\d*)',
        caseSensitive: false,
      ),
      'hematocrit': RegExp(
        r'(?:h[ae]matocrit|pcv)[^\n\d]*(\d+\.?\d*)\s*(%)?',
        caseSensitive: false,
      ),
    };

    for (final entry in patterns.entries) {
      final match = entry.value.firstMatch(text);
      if (match == null) continue;
      final value = double.tryParse(match.group(1) ?? '');
      if (value == null) continue; // skip name-only matches with no number
      results[entry.key] = {
        'value': value,
        'unit': match.groupCount >= 2 ? match.group(2) : null,
      };
    }

    return results;
  }

  void dispose() {
    _textRecognizer.close();
  }
}
