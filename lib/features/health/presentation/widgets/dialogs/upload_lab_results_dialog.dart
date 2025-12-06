import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import '../../pages/ocr_extraction_page.dart';

class UploadLabResultsDialog extends StatelessWidget {
  const UploadLabResultsDialog({super.key});

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    try {
      // Request permissions
      if (source == ImageSource.camera) {
        final status = await Permission.camera.request();
        if (! status.isGranted) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Camera permission denied')),
            );
          }
          return;
        }
      } else {
        final status = await Permission. photos.request();
        if (!status.isGranted) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Photos permission denied')),
            );
          }
          return;
        }
      }

      // Pick image
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (pickedFile != null && context.mounted) {
        final imageFile = File(pickedFile. path);
        
        // Close dialog
        Navigator.pop(context);
        
        // Navigate to OCR extraction page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OcrExtractionPage(imageFile: imageFile),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          
          Text(
            'Upload Lab Results',
            style: AppTextStyles. headline2.copyWith(
              fontSize: 20,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 24),
          
          // Camera option
          _buildOptionButton(
            context,
            icon: Icons.camera_alt,
            title: 'Take Photo',
            subtitle: 'Use camera to capture lab result',
            onTap: () => _pickImage(context, ImageSource.camera),
          ),
          
          const SizedBox(height: 16),
          
          // Gallery option
          _buildOptionButton(
            context,
            icon: Icons.photo_library,
            title: 'Choose from Gallery',
            subtitle: 'Select existing photo',
            onTap: () => _pickImage(context, ImageSource.gallery),
          ),
          
          const SizedBox(height: 16),
          
          // Manual entry option (future feature)
          _buildOptionButton(
            context,
            icon: Icons.edit,
            title: 'Manual Entry',
            subtitle: 'Enter results manually',
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Manual entry coming soon!')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors. main300,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.main500. withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors. main500,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.subtitle1.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.body1.copyWith(
                      fontSize: 12,
                      color: Colors.grey. shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}