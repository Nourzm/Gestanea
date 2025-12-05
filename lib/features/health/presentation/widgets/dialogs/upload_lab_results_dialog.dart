import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import 'package:gestanea/core/widgets/custom_button.dart';

class UploadLabResultsDialog extends StatefulWidget {
  const UploadLabResultsDialog({super.key});

  @override
  State<UploadLabResultsDialog> createState() => _UploadLabResultsDialogState();
}

class _UploadLabResultsDialogState extends State<UploadLabResultsDialog> {
  final _formKey = GlobalKey<FormState>();
  final _testNameController = TextEditingController();
  final _testValueController = TextEditingController();
  final _normalRangeController = TextEditingController();
  final _notesController = TextEditingController();
  final _extractedTextController = TextEditingController();
  
  XFile? _selectedImage;
  bool _isProcessing = false;
  DateTime _selectedDate = DateTime.now();
  final _imagePicker = ImagePicker();

  @override
  void dispose() {
    _testNameController.dispose();
    _testValueController.dispose();
    _normalRangeController.dispose();
    _notesController.dispose();
    _extractedTextController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = image;
          _isProcessing = true;
        });
        
        await _extractTextFromImage(image);
        
        setState(() {
          _isProcessing = false;
        });
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context). showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  Future<void> _extractTextFromImage(XFile imageFile) async {
    try {
      final inputImage = InputImage.fromFilePath(imageFile.path);
      final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
      
      String extractedText = recognizedText. text;
      
      setState(() {
        _extractedTextController.text = extractedText;
      });
      
      await textRecognizer.close();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Text extracted successfully!  You can edit it below.'),
            backgroundColor: Colors. green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OCR Error: $e')),
        );
      }
    }
  }

  void _handleSave() {
    if (_formKey.currentState! .validate()) {
      print('Test Name: ${_testNameController. text}');
      print('Test Value: ${_testValueController. text}');
      print('Normal Range: ${_normalRangeController.text}');
      print('Extracted Text: ${_extractedTextController.text}');
      print('Notes: ${_notesController.text}');
      print('Image Path: ${_selectedImage?.path ??  'No image'}');
      print('Date: $_selectedDate');
      
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lab results uploaded successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size. height * 0.85,
        ),
        decoration: const BoxDecoration(
          color: Color(0xFFFAF0FF),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.textSecondary.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                Center(
                  child: Text(
                    'Upload Lab Results',
                    style: AppTextStyles.headline2.copyWith(
                      fontSize: 20,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                Row(
                  children: [
                    Expanded(
                      child: _buildImagePickerButton(
                        icon: Icons.camera_alt,
                        label: 'Take Photo',
                        onTap: () => _pickImage(ImageSource. camera),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildImagePickerButton(
                        icon: Icons. photo_library,
                        label: 'From Gallery',
                        onTap: () => _pickImage(ImageSource.gallery),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                if (_selectedImage != null) ...[
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                        BoxShadow(
                          color: AppColors.white,
                          blurRadius: 6,
                          offset: Offset(-3, -3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          Image.file(
                            File(_selectedImage!.path),
                            width: double.infinity,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedImage = null;
                                  _extractedTextController.clear();
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                
                if (_isProcessing) ...[
                  const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.main500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Extracting text...',
                      style: AppTextStyles.body1. copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                
                if (_extractedTextController.text.isNotEmpty) ...[
                  Row(
                    children: [
                      const Icon(Icons.text_fields, color: AppColors.main500, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Extracted Text (editable)',
                        style: AppTextStyles.subtitle1.copyWith(
                          fontSize: 14,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _extractedTextController,
                    label: 'Extracted text',
                    maxLines: 4,
                  ),
                  const SizedBox(height: 20),
                ],
                
                Text(
                  'Test Details',
                  style: AppTextStyles.subtitle1.copyWith(
                    fontSize: 16,
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                
                _buildTextField(
                  controller: _testNameController,
                  label: 'Test Name',
                  validator: (value) {
                    if (value == null || value. isEmpty) {
                      return 'Please enter test name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                
                _buildTextField(
                  controller: _testValueController,
                  label: 'Test Value',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter test value';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                
                _buildTextField(
                  controller: _normalRangeController,
                  label: 'Normal Range',
                ),
                const SizedBox(height: 12),
                
                GestureDetector(
                  onTap: _selectDate,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius. circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                        BoxShadow(
                          color: AppColors.white,
                          blurRadius: 6,
                          offset: Offset(-3, -3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, color: AppColors.main500, size: 20),
                        const SizedBox(width: 12),
                        Text(
                          'Test Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                          style: AppTextStyles.body1.copyWith(
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                
                _buildTextField(
                  controller: _notesController,
                  label: 'Notes (optional)',
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        onPressed: () => Navigator.pop(context),
                        text: 'Cancel',
                        filled: false,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppButton(
                        onPressed: _handleSave,
                        text: 'Save',
                        filled: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePickerButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.main500, AppColors.main600],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
            BoxShadow(
              color: AppColors. white,
              blurRadius: 6,
              offset: Offset(-3, -3),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.body1.copyWith(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
          BoxShadow(
            color: AppColors.white,
            blurRadius: 6,
            offset: Offset(-3, -3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: label,
          hintStyle: AppTextStyles.body1. copyWith(
  color: Colors.grey. shade600,  // Much more readable!
  fontSize: 14,
),
        ),
        style: AppTextStyles.body1. copyWith(
          color: AppColors.textDark,
          fontSize: 14,
        ),
        validator: validator,
      ),
    );
  }
}