import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/database/models/lab_result_model.dart';
import '../../../../core/services/image_storage_service.dart';
import '../../logic/bloc/lab_results_bloc.dart';
import '../../logic/bloc/lab_results_event.dart';
import 'package:gestanea/core/theme/theme_cubit.dart';

class EditLabResultPage extends StatefulWidget {
  final LabResultModel result;

  const EditLabResultPage({
    super.key,
    required this.result,
  });

  @override
  State<EditLabResultPage> createState() => _EditLabResultPageState();
}

class _EditLabResultPageState extends State<EditLabResultPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _testNameController;
  late TextEditingController _valueController;
  late TextEditingController _unitController;
  late TextEditingController _minRangeController;
  late TextEditingController _maxRangeController;
  bool _isSaving = false;
  bool _showImage = true;

  @override
  void initState() {
    super.initState();
    _testNameController = TextEditingController(text: widget.result.testName);
    _valueController = TextEditingController(
      text: widget.result.value?.toString() ?? '',
    );
    _unitController = TextEditingController(text: widget.result.unit ?? '');
    _minRangeController = TextEditingController(
      text: widget.result.normalRangeMin?.toString() ?? '',
    );
    _maxRangeController = TextEditingController(
      text: widget.result.normalRangeMax?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _testNameController.dispose();
    _valueController.dispose();
    _unitController.dispose();
    _minRangeController.dispose();
    _maxRangeController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      final updatedResult = LabResultModel(
        id: widget.result.id,
        userId: widget.result.userId,
        testName: _testNameController.text.trim(),
        value: double.tryParse(_valueController.text.trim()),
        unit: _unitController.text.trim().isNotEmpty
            ? _unitController.text.trim()
            : null,
        normalRangeMin: double.tryParse(_minRangeController.text.trim()),
        normalRangeMax: double.tryParse(_maxRangeController.text.trim()),
        labDate: widget.result.labDate,
        reportImageUrl: widget.result.reportImageUrl,
        createdAt: widget.result.createdAt,
        extractedByOcr: widget.result.extractedByOcr,
      );

      if (mounted) {
        context.read<LabResultsBloc>().add(UpdateLabResult(updatedResult));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.labResultUpdatedSuccessfully)),
        );

        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.errorUpdatingResult(e.toString()))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = context.watch<ThemeCubit>().currentTheme;
    final imagePath = widget.result.reportImageUrl;
    final isRemoteUrl = imagePath != null && (imagePath.startsWith('http://') || imagePath.startsWith('https://'));

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.editLabResult),
        backgroundColor: themeData.primaryColor,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (imagePath != null && imagePath.isNotEmpty)
            IconButton(
              icon: Icon(
                _showImage ? Icons.visibility : Icons.visibility_off,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() => _showImage = !_showImage);
              },
              tooltip: _showImage ? 'Hide Image' : 'Show Image',
            ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Image preview
                  if (_showImage && imagePath != null && imagePath.isNotEmpty) ...[
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: InteractiveViewer(
                          minScale: 0.5,
                          maxScale: 4.0,
                          child: isRemoteUrl
                              ? Image.network(
                                  imagePath,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 200,
                                      color: Colors.grey.shade300,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.broken_image, size: 64, color: Colors.grey),
                                          SizedBox(height: 8),
                                          Text(AppLocalizations.of(context)!.imageNotAvailable),
                                        ],
                                      ),
                                    );
                                  },
                                )
                              : FutureBuilder<File?>(
                                  future: ImageStorageService().getImageAsync(imagePath),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData && snapshot.data != null) {
                                      return Image.file(
                                        snapshot.data!,
                                        fit: BoxFit.contain,
                                      );
                                    }
                                    return Container(
                                      height: 200,
                                      color: Colors.grey.shade300,
                                      child: const Center(child: CircularProgressIndicator()),
                                    );
                                  },
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Form fields
                  Text(
                    'Test Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: themeData.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Test Name
                  TextFormField(
                    controller: _testNameController,
                    decoration: InputDecoration(
                      labelText: 'Test Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.science),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Test name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Value and Unit
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _valueController,
                          decoration: InputDecoration(
                            labelText: 'Value',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: const Icon(Icons.numbers),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Value required';
                            }
                            if (double.tryParse(value.trim()) == null) {
                              return 'Invalid number';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _unitController,
                          decoration: InputDecoration(
                            labelText: 'Unit',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Normal Range
                  Text(
                    'Normal Range',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: themeData.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _minRangeController,
                          decoration: InputDecoration(
                            labelText: 'Min',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: (value) {
                            if (value != null && value.trim().isNotEmpty) {
                              if (double.tryParse(value.trim()) == null) {
                                return 'Invalid';
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        '-',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _maxRangeController,
                          decoration: InputDecoration(
                            labelText: 'Max',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: (value) {
                            if (value != null && value.trim().isNotEmpty) {
                              if (double.tryParse(value.trim()) == null) {
                                return 'Invalid';
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Status preview
                  _buildStatusPreview(),

                  const SizedBox(height: 24),

                  // Save button
                  ElevatedButton(
                    onPressed: _isSaving ? null : _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeData.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Save Changes',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPreview() {
    final value = double.tryParse(_valueController.text.trim());
    final minRange = double.tryParse(_minRangeController.text.trim());
    final maxRange = double.tryParse(_maxRangeController.text.trim());

    String status = 'N/A';
    Color statusColor = Colors.grey.shade300;

    if (value != null && minRange != null && maxRange != null) {
      if (value < minRange) {
        status = 'Low';
        statusColor = const Color(0xFFFFE0B2);
      } else if (value > maxRange) {
        status = 'High';
        statusColor = const Color(0xFFFFB8B8);
      } else {
        status = 'Normal';
        statusColor = const Color(0xFFB8E6B8);
      }
    }

    return Card(
      color: statusColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Status:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              status,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
