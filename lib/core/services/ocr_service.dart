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
        var rowText = row.map((e) => e['text'] as String).join(' ');
        
        print('Row $i: $rowText');
        
        // Skip pure header/methodology rows
        if (rowText.toLowerCase().startsWith('methodology') ||
            rowText.toLowerCase().contains('test description') ||
            rowText.toLowerCase().contains('laboratory') ||
            rowText.toLowerCase().contains('member') ||
            rowText.toLowerCase().contains('reference range') ||
            rowText.toLowerCase().contains('result') ||
            rowText.toLowerCase().contains('units') ||
            rowText.contains('***')) {
          continue;
        }
        
        // Clean row text: Remove "Methodology:" and following words (technique names)
        rowText = rowText.replaceAll(RegExp(r'Methodology:\s*[A-Za-z\s]+?(technique|impedence|calculated|Method)\s*', caseSensitive: false), ' ');
        rowText = rowText.replaceAll(RegExp(r'\s+'), ' ').trim();
        
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
    print('  Parsing row: "$rowText"');
    
    // Try multiple patterns to handle different formats
    
    // Pattern 1: Test name, value, unit (complex with x10^), min-max range
    // Example: "Total WBC Count 4.1 x10^9/L 4.0-11.0"
    // Example: "Platelet 239 x10^9/L 150-450"
    var pattern = RegExp(
      r'^([A-Za-z0-9][A-Za-z0-9\s\(\)\/\-]+?)\s+(\d+\.?\d*)\s+(x10\^\d+\/L|[a-zA-Z/\^0-9*%]+)\s+(\d+\.?\d*)\s*[-–—]\s*(\d+\.?\d*)(?:\s|$)',
      caseSensitive: false,
    );
    
    var match = pattern.firstMatch(rowText);
    
    if (match != null) {
      final testName = match.group(1)?.trim();
      final value = double.tryParse(match.group(2) ?? '');
      final unit = match.group(3)?.trim();
      final minRange = double.tryParse(match.group(4) ?? '');
      final maxRange = double.tryParse(match.group(5) ?? '');
      
      print('    Pattern 1 matched: name="$testName", value=$value, unit="$unit", range=$minRange-$maxRange');
      
      if (testName != null && value != null && minRange != null && maxRange != null && minRange < maxRange) {
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
    
    // Pattern 2: Test name, value, unit (simple), min-max range
    // Example: "Hemoglobin 14.20 g/dL 13.5-17.5"
    // Example: "Neutrophils 26.4 % 35-66"
    if (match == null) {
      pattern = RegExp(
        r'^([A-Za-z0-9][A-Za-z0-9\s\(\)\/\-]+?)\s+(\d+\.?\d*)\s+([a-zA-Z/\^0-9*%]+)\s+(\d+\.?\d*)\s*[-–—]\s*(\d+\.?\d*)(?:\s|$)',
        caseSensitive: false,
      );
      
      match = pattern.firstMatch(rowText);
      
      if (match != null) {
        final testName = match.group(1)?.trim();
        final value = double.tryParse(match.group(2) ?? '');
        final unit = match.group(3)?.trim();
        final minRange = double.tryParse(match.group(4) ?? '');
        final maxRange = double.tryParse(match.group(5) ?? '');
        
        print('    Pattern 2 matched: name="$testName", value=$value, unit="$unit", range=$minRange-$maxRange');
        
        if (testName != null && value != null && minRange != null && maxRange != null && minRange < maxRange) {
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
    }
    
    // Pattern 3: Test name, value, min-max range (no unit)
    // Example: "MCHC 32 32-36"
    // Example: "Hematocrit 44 36-46"
    if (match == null) {
      pattern = RegExp(
        r'^([A-Za-z0-9][A-Za-z0-9\s\(\)\/\-]+?)\s+(\d+\.?\d*)\s+(\d+\.?\d*)\s*[-–—]\s*(\d+\.?\d*)(?:\s|$)',
        caseSensitive: false,
      );
      match = pattern.firstMatch(rowText);
      
      if (match != null) {
        final testName = match.group(1)?.trim();
        final value = double.tryParse(match.group(2) ?? '');
        final minRange = double.tryParse(match.group(3) ?? '');
        final maxRange = double.tryParse(match.group(4) ?? '');
        
        print('    Pattern 3 matched: name="$testName", value=$value, range=$minRange-$maxRange');
        
        // Validate range makes sense (min < max)
        // Exception: if max is single digit and min is double digit, might be OCR truncation (e.g., "32-3" for "32-36")
        if (testName != null && value != null && minRange != null && maxRange != null) {
          double actualMin = minRange;
          double actualMax = maxRange;
          
          // Fix truncated ranges like "32-3" → "32-36"
          if (minRange > maxRange && maxRange < 10 && minRange >= 10) {
            // Likely truncated: append first digit of min to max
            final minStr = minRange.toInt().toString();
            final maxStr = maxRange.toInt().toString();
            actualMax = double.parse(minStr[0] + maxStr);
            print('    Range corrected: $minRange-$maxRange → $actualMin-$actualMax');
          }
          
          if (actualMin < actualMax) {
            String interpretation;
            if (value < actualMin) {
              interpretation = 'Low';
            } else if (value > actualMax) {
              interpretation = 'High';
            } else {
              interpretation = 'Normal';
            }
            
            return {
              'testName': testName.trim(),
              'value': value,
              'unit': null,
              'normalRangeMin': actualMin,
              'normalRangeMax': actualMax,
              'interpretation': interpretation,
            };
          }
        }
      }
    }
    
    print('    No pattern matched');
    return null;
  }

  void dispose() {
    _textRecognizer.close();
  }
}