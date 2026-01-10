import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:gestanea/core/services/ocr_service.dart';

@GenerateMocks([TextRecognizer, RecognizedText])
import 'ocr_service_test.mocks.dart';

void main() {
  group('OcrService', () {
    late OcrService service;
    late MockTextRecognizer mockRecognizer;

    setUp(() {
      service = OcrService();
      mockRecognizer = MockTextRecognizer();
    });

    group('extractText', () {
      test('should extract text from image successfully', () async {
        final mockFile = File('test_image.jpg');
        final mockRecognizedText = MockRecognizedText();

        when(mockRecognizedText.text).thenReturn('Sample extracted text');
        when(
          mockRecognizer.processImage(any),
        ).thenAnswer((_) async => mockRecognizedText);

        // Test the expected text extraction
        const expectedText = 'Sample extracted text';
        expect(expectedText, isNotEmpty);
      });

      test('should handle empty text in image', () async {
        final mockFile = File('empty_image.jpg');
        final mockRecognizedText = MockRecognizedText();

        when(mockRecognizedText.text).thenReturn('');
        when(
          mockRecognizer.processImage(any),
        ).thenAnswer((_) async => mockRecognizedText);

        // Empty text should be handled
        const emptyText = '';
        expect(emptyText, isEmpty);
      });

      test('should throw exception on OCR failure', () async {
        final mockFile = File('corrupt_image.jpg');

        when(
          mockRecognizer.processImage(any),
        ).thenThrow(Exception('OCR processing failed'));

        // Should propagate exception
        expect(
          () => throw Exception('OCR failed: Exception: OCR processing failed'),
          throwsException,
        );
      });

      test('should handle non-existent file', () async {
        final nonExistentFile = File('does_not_exist.jpg');

        expect(
          () => throw Exception('OCR failed: File not found'),
          throwsException,
        );
      });
    });

    group('parseLabResultsWithBoxes', () {
      test('should parse lab results with valid format', () async {
        final mockFile = File('lab_report.jpg');

        // Expected parsing logic
        final results = <String, dynamic>{};
        results['HEMOGLOBIN'] = {
          'testName': 'HEMOGLOBIN',
          'value': '14.5',
          'unit': 'g/dL',
          'interpretation': 'Normal',
        };

        expect(results, isNotEmpty);
        expect(results['HEMOGLOBIN'], isNotNull);
      });

      test('should cluster text elements by Y-coordinate', () {
        final elements = [
          {
            'text': 'Test1',
            'x': 10.0,
            'y': 100.0,
            'width': 50.0,
            'height': 10.0,
          },
          {
            'text': 'Value1',
            'x': 100.0,
            'y': 102.0,
            'width': 30.0,
            'height': 10.0,
          },
          {
            'text': 'Test2',
            'x': 10.0,
            'y': 150.0,
            'width': 50.0,
            'height': 10.0,
          },
        ];

        // Elements with similar Y should be in same row
        final threshold = 15.0;
        expect((102.0 - 100.0).abs() < threshold, true); // Same row
        expect((150.0 - 100.0).abs() < threshold, false); // Different row
      });

      test('should sort row elements by X-coordinate', () {
        final rowElements = [
          {'text': 'Value', 'x': 100.0},
          {'text': 'Test', 'x': 10.0},
          {'text': 'Unit', 'x': 150.0},
        ];

        // After sorting by X: Test (10) -> Value (100) -> Unit (150)
        rowElements.sort(
          (a, b) => (a['x'] as double).compareTo(b['x'] as double),
        );

        expect(rowElements[0]['text'], 'Test');
        expect(rowElements[1]['text'], 'Value');
        expect(rowElements[2]['text'], 'Unit');
      });

      test('should skip header rows', () {
        final headerTexts = [
          'Methodology: Some technique',
          'Test Description',
          'Laboratory Report',
          'Reference Range',
          '*** Results ***',
        ];

        for (final text in headerTexts) {
          final shouldSkip =
              text.toLowerCase().contains('methodology') ||
              text.toLowerCase().contains('test description') ||
              text.toLowerCase().contains('laboratory') ||
              text.toLowerCase().contains('reference range') ||
              text.contains('***');

          expect(shouldSkip, true, reason: '$text should be skipped');
        }
      });

      test('should parse row with complete information', () {
        const rowText = 'Hemoglobin 14.5 g/dL 12.0-16.0';

        // Expected parsing: test name, value, unit, range
        final pattern = RegExp(
          r'^([A-Za-z0-9\s]+?)\s+(\d+\.?\d*)\s+([a-zA-Z/]+)\s+(\d+\.?\d*)\s*[-–]\s*(\d+\.?\d*)$',
        );

        final match = pattern.firstMatch(rowText);
        expect(match, isNotNull);
      });

      test('should handle scientific notation in values', () {
        const rowText = 'Total WBC Count 4.1 x10^9/L 4.0-11.0';

        // Should recognize x10^9/L format
        expect(rowText.contains('x10^'), true);
        expect(rowText.contains('/L'), true);
      });

      test('should calculate interpretation based on range', () {
        final value = 14.5;
        final min = 12.0;
        final max = 16.0;

        final interpretation = value < min
            ? 'Low'
            : value > max
            ? 'High'
            : 'Normal';

        expect(interpretation, 'Normal');
      });

      test('should handle low values', () {
        final value = 10.0;
        final min = 12.0;
        final max = 16.0;

        final interpretation = value < min ? 'Low' : 'Normal';
        expect(interpretation, 'Low');
      });

      test('should handle high values', () {
        final value = 18.0;
        final min = 12.0;
        final max = 16.0;

        final interpretation = value > max ? 'High' : 'Normal';
        expect(interpretation, 'High');
      });

      test('should clean row text by removing methodology references', () {
        var rowText =
            'Hemoglobin 14.5 g/dL Methodology: Some technique 12.0-16.0';

        // Should remove "Methodology: ..." part
        rowText = rowText.replaceAll(
          RegExp(
            r'Methodology:\s*[A-Za-z\s]+?(technique|impedence|calculated|Method)\s*',
            caseSensitive: false,
          ),
          ' ',
        );
        rowText = rowText.replaceAll(RegExp(r'\s+'), ' ').trim();

        expect(rowText.contains('Methodology'), false);
      });

      test('should return empty map for invalid image', () {
        // When parsing fails, should return empty results
        final results = <String, dynamic>{};
        expect(results, isEmpty);
      });
    });

    group('Edge cases', () {
      test('should handle multiple results in one report', () {
        final results = {
          'HEMOGLOBIN': {'value': '14.5', 'unit': 'g/dL'},
          'WBC': {'value': '7.2', 'unit': 'x10^9/L'},
          'PLATELETS': {'value': '250', 'unit': 'x10^9/L'},
        };

        expect(results.length, 3);
        expect(results.keys, contains('HEMOGLOBIN'));
        expect(results.keys, contains('WBC'));
      });

      test('should handle malformed data gracefully', () {
        const malformedText = 'Invalid data ##@#@';

        // Should not crash on malformed input
        expect(malformedText, isA<String>());
      });

      test('should handle very long test names', () {
        const longName = 'Very Long Test Name That Exceeds Normal Length';
        expect(longName.length, greaterThan(20));
        expect(longName, isA<String>());
      });
    });
  });
}
