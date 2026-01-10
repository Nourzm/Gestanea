import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/database/models/lab_result_model.dart';
import 'package:gestanea/core/session/session_manager.dart';
import 'package:gestanea/core/theme/theme_cubit.dart';
import 'package:gestanea/core/services/image_storage_service.dart';
import 'package:uuid/uuid.dart';
import '../../logic/bloc/lab_results_bloc.dart';
import '../../logic/bloc/lab_results_event.dart';

class ReviewOcrResultsPage extends StatefulWidget {
  final List<Map<String, dynamic>> extractedResults;
  final String? imagePath;

  const ReviewOcrResultsPage({
    super.key,
    required this.extractedResults,
    this.imagePath,
  });

  @override
  State<ReviewOcrResultsPage> createState() => _ReviewOcrResultsPageState();
}

class _ReviewOcrResultsPageState extends State<ReviewOcrResultsPage> {
  late List<Map<String, dynamic>> _editableResults;
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;
  bool _showImage = true;

  @override
  void initState() {
    super.initState();
    // Create a deep copy of the results for editing
    _editableResults = widget.extractedResults
        .map((result) => Map<String, dynamic>.from(result))
        .toList();
  }

  Future<void> _saveResults() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      // Get user ID
      final sessionManager = SessionManager();
      var userId = await sessionManager.getCurrentUserId();
      if (userId == null || userId.isEmpty) {
        userId = 'test_user_id';
        await sessionManager.saveCurrentUserId(userId);
      }

      // Save each result
      for (final result in _editableResults) {
        final labResult = LabResultModel(
          id: const Uuid().v4(),
          userId: userId,
          testName: result['testName'] as String,
          value: result['value'] as double?,
          unit: result['unit'] as String?,
          normalRangeMin: result['normalRangeMin'] as double?,
          normalRangeMax: result['normalRangeMax'] as double?,
          interpretation: result['interpretation'] as String?,
          labDate: DateTime.now(),
          reportImageUrl: widget.imagePath,
          extractedByOcr: true,
          createdAt: DateTime.now(),
        );

        context.read<LabResultsBloc>().add(AddLabResult(labResult));
      }

      if (mounted) {
        Navigator.pop(context); // Close review page
        Navigator.pop(context); // Close OCR page
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lab results saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save results: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _deleteResult(int index) {
    setState(() {
      _editableResults.removeAt(index);
    });

    if (_editableResults.isEmpty) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No results to save')),
      );
    }
  }

  void _addNewTest() {
    setState(() {
      _editableResults.add({
        'testName': '',
        'value': null,
        'unit': '',
        'normalRangeMin': null,
        'normalRangeMax': null,
        'interpretation': null,
      });
    });
    
    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Auto-scroll would go here if we had a ScrollController
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeData = context.watch<ThemeCubit>().currentTheme;
    final isRemoteUrl = widget.imagePath != null && (widget.imagePath!.startsWith('http://') || widget.imagePath!.startsWith('https://'));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review & Edit Lab Results'),
        backgroundColor: themeData.primaryColor,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (widget.imagePath != null)
            IconButton(
              icon: Icon(
                _showImage ? Icons.visibility : Icons.visibility_off,
                color: Colors.white,
              ),
              onPressed: () => setState(() => _showImage = !_showImage),
              tooltip: _showImage ? 'Hide Image' : 'Show Image',
            ),
          if (!_isSaving)
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: _addNewTest,
              tooltip: 'Add Test',
            ),
        ],
      ),
      body: _isSaving
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Lab image preview (always visible by default)
                if (_showImage && widget.imagePath != null)
                  Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade300, width: 2),
                      ),
                    ),
                    child: Stack(
                      children: [
                        InteractiveViewer(
                          minScale: 0.5,
                          maxScale: 4.0,
                          child: Center(
                            child: isRemoteUrl
                                ? Image.network(
                                    widget.imagePath!,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey.shade300,
                                        child: const Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.broken_image, size: 64, color: Colors.grey),
                                            SizedBox(height: 8),
                                            Text('Image not available'),
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                : FutureBuilder<File?>(
                                    future: ImageStorageService().getImageAsync(widget.imagePath!),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData && snapshot.data != null) {
                                        return Image.file(
                                          snapshot.data!,
                                          fit: BoxFit.contain,
                                        );
                                      }
                                      return Container(
                                        color: Colors.grey.shade300,
                                        child: const Center(child: CircularProgressIndicator()),
                                      );
                                    },
                                  ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Pinch to zoom',
                              style: TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                
                // Help text
                Container(
                  padding: const EdgeInsets.all(12),
                  color: Colors.blue.shade50,
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, size: 20, color: Colors.blue.shade700),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'View the image above and enter each test result. Tap + to add more tests.',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Form
                Expanded(
                  child: _editableResults.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.science_outlined, size: 64, color: Colors.grey),
                              const SizedBox(height: 16),
                              const Text(
                                'No tests added yet',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Tap + to add your first test',
                                style: TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton.icon(
                                onPressed: _addNewTest,
                                icon: const Icon(Icons.add),
                                label: const Text('Add Test'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: themeData.primaryColor,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Form(
                          key: _formKey,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _editableResults.length,
                            itemBuilder: (context, index) {
                              return _buildResultCard(index, themeData);
                            },
                          ),
                        ),
                ),
              ],
            ),
      floatingActionButton: _isSaving || _editableResults.isEmpty
          ? null
          : null, // We have the bottom bar instead
      bottomNavigationBar: _isSaving
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _addNewTest,
                        icon: const Icon(Icons.add),
                        label: const Text('Add Test'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: themeData.primaryColor),
                          foregroundColor: themeData.primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: _editableResults.isEmpty ? null : _saveResults,
                        icon: const Icon(Icons.check),
                        label: Text('Save ${_editableResults.length} Result(s)'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: themeData.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildResultCard(int index, dynamic themeData) {
    final result = _editableResults[index];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Test ${index + 1}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: themeData.primaryColor,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteResult(index),
                  tooltip: 'Delete',
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Test Name
            TextFormField(
              initialValue: result['testName'] as String? ?? '',
              decoration: const InputDecoration(
                labelText: 'Test Name *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.science),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Test name is required';
                }
                return null;
              },
              onChanged: (value) {
                result['testName'] = value;
              },
            ),
            const SizedBox(height: 12),
            
            // Value and Unit in a row
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    initialValue: result['value']?.toString() ?? '',
                    decoration: const InputDecoration(
                      labelText: 'Value',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.numbers),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) {
                      result['value'] = double.tryParse(value);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    initialValue: result['unit'] as String? ?? '',
                    decoration: const InputDecoration(
                      labelText: 'Unit',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      result['unit'] = value;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Normal Range
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: result['normalRangeMin']?.toString() ?? '',
                    decoration: const InputDecoration(
                      labelText: 'Min (Normal)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.arrow_downward),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) {
                      result['normalRangeMin'] = double.tryParse(value);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    initialValue: result['normalRangeMax']?.toString() ?? '',
                    decoration: const InputDecoration(
                      labelText: 'Max (Normal)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.arrow_upward),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) {
                      result['normalRangeMax'] = double.tryParse(value);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Interpretation
            TextFormField(
              initialValue: result['interpretation'] as String? ?? '',
              decoration: const InputDecoration(
                labelText: 'Interpretation (Optional)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.note),
                hintText: 'e.g., Normal, High, Low',
              ),
              onChanged: (value) {
                result['interpretation'] = value.isEmpty ? null : value;
              },
            ),
          ],
        ),
      ),
    );
  }
}
