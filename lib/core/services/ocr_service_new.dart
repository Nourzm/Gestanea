import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrService {
  final TextRecognizer _textRecognizer = TextRecognizer();

  // Extract text from image (for display only)
  Future<String> extractText(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final recognizedText = await _textRecognizer.processImage(inputImage);
      return recognizedText.text;
    } catch (e) {
      throw Exception('OCR failed: $e');
    }
  }

  // Parse lab results using bounding boxes (ROW-BASED parsing)
  Future<Map<String, dynamic>> parseLabResultsWithBoxes(File imageFile) async {
    final results = <String, dynamic>{};
    
    print('=== Row-Based Parsing ===');
    
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final recognizedText = await _textRecognizer.processImage(inputImage);
      
      // Collect all text elements with bounding boxes
      final elements = <Map<String, dynamic>>[];
      
      for (final block in recognizedText.blocks) {
        for (final line in block.lines) {
          for (final element in line.elements) {
            if (element.boundingBox != null) {
              elements.add({
                'text': element.text,
                'x': element.boundingBox!.left.toDouble(),
                'y': element.boundingBox!.top.toDouble(),
                'width': element.boundingBox!.width.toDouble(),
                'height': element.boundingBox!.height.toDouble(),
              });
            }
          }
        }
      }
      
      print('Found ${elements.length} elements');
      
      // Cluster by Y-coordinate (rows)
      final rows = _clusterByY(elements, threshold: 15);
      print('Clustered into ${rows.length} rows');
      
      // Process each row
      for (int i = 0; i < rows.length; i++) {
        final row = rows[i];
        
        // Sort row items by X (left to right)
        row.sort((a, b) => (a['x'] as double).compareTo(b['x'] as double));
        
        // Extract row text
        final rowText = row.map((e) => e['text'] as String).join(' ');
        
        print('Row $i: $rowText');
        
        // Skip headers and metadata
        if (rowText.toLowerCase().contains('methodology') ||
            rowText.toLowerCase().contains('test description') ||
            rowText.toLowerCase().contains('laboratory') ||
            rowText.toLowerCase().contains('member') ||
            rowText.toLowerCase().contains('reference range') ||
            rowText.toLowerCase().contains('result') ||
            rowText.toLowerCase().contains('units') ||
            rowText.contains('***')) {
          continue;
        }
        
        // Parse row: [Test Name] [Value] [Unit] [Range]
        final parsed = _parseRow(rowText);
        
        if (parsed != null) {
          final testName = parsed['testName']!.toUpperCase();
          results[testName] = parsed;
          print('✓ $testName = ${parsed['value']} ${parsed['unit']} [${parsed['interpretation']}]');
        }
      }
      
    } catch (e) {
      print('Parsing error: $e');
    }
    
    print('Total: ${results.length} results');
    print('=== End ===');
    
    return results;
  }

  // Cluster elements by Y-coordinate (rows)
  List<List<Map<String, dynamic>>> _clusterByY(List<Map<String, dynamic>> elements, {double threshold = 15}) {
    final rows = <List<Map<String, dynamic>>>[];
    
    // Sort by Y first
    final sorted = List<Map<String, dynamic>>.from(elements);
    sorted.sort((a, b) => (a['y'] as double).compareTo(b['y'] as double));
    
    List<Map<String, dynamic>> currentRow = [];
    double? lastY;
    
    for (final element in sorted) {
      final y = element['y'] as double;
      
      if (lastY == null || (y - lastY).abs() < threshold) {
        // Same row
        currentRow.add(element);
      } else {
        // New row
        if (currentRow.isNotEmpty) {
          rows.add(currentRow);
        }
        currentRow = [element];
      }
      
      lastY = y;
    }
    
    if (currentRow.isNotEmpty) {
      rows.add(currentRow);
    }
    
    return rows;
  }

  // Parse a single row
  Map<String, dynamic>? _parseRow(String rowText) {
    // Pattern: Test name followed by value, unit, and range
    // Example: "Hemoglobin 14.20 g/dL 13.5-17.5"
    final pattern = RegExp(
      r'^([A-Za-z][A-Za-z\s\(\)]+?)\s+(\d+\.?\d*)\s*([a-zA-Z/\^0-9*%]+)?\s*(\d+\.?\d*)\s*[-–—]\s*(\d+\.?\d*)',
      caseSensitive: false,
    );
    
    final match = pattern.firstMatch(rowText);
    
    if (match != null) {
      final testName = match.group(1)?.trim();
      final value = double.tryParse(match.group(2) ?? '');
      final unit = match.group(3)?.trim();
      final minRange = double.tryParse(match.group(4) ?? '');
      final maxRange = double.tryParse(match.group(5) ?? '');
      
      if (testName != null && value != null && minRange != null && maxRange != null && minRange < maxRange) {
        // Determine interpretation
        String interpretation;
        if (value < minRange) {
          interpretation = 'Low';
        } else if (value > maxRange) {
          interpretation = 'High';
        } else {
          interpretation = 'Normal';
        }
        
        return {
          'testName': testName.trim(),
          'value': value,
          'unit': unit,
          'normalRangeMin': minRange,
          'normalRangeMax': maxRange,
          'interpretation': interpretation,
        };
      }
    }
    
    return null;
  }

  void dispose() {
    _textRecognizer.close();
  }
}
