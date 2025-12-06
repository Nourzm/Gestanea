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

  // Parse lab results from extracted text
  Map<String, dynamic> parseLabResults(String text) {
    final results = <String, dynamic>{};
    
    // Common patterns for lab results
    final patterns = {
      'hemoglobin': RegExp(r'h[ae]moglobin[\s:]*(\d+\. ?\d*)\s*(g/dl|mg/dl)? ', caseSensitive: false),
      'glucose': RegExp(r'glucose[\s:]*(\d+\. ?\d*)\s*(mg/dl)? ', caseSensitive: false),
      'wbc': RegExp(r'wbc|white blood cell[\s:]*(\d+\.?\d*)', caseSensitive: false),
      'rbc': RegExp(r'rbc|red blood cell[\s:]*(\d+\.?\d*)', caseSensitive: false),
      'platelets': RegExp(r'platelet[\s:]*(\d+\.?\d*)', caseSensitive: false),
    };

    for (final entry in patterns.entries) {
      final match = entry.value.firstMatch(text);
      if (match != null && match.groupCount >= 1) {
        results[entry. key] = {
          'value': double.tryParse(match.group(1) ?? ''),
          'unit': match.groupCount >= 2 ? match. group(2) : null,
        };
      }
    }

    return results;
  }

  void dispose() {
    _textRecognizer.close();
  }
}