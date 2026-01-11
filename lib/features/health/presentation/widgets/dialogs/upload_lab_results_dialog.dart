import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/constants/app_text_styles.dart';
import '../../pages/ocr_extraction_page.dart';
import 'package:file_picker/file_picker.dart';
import '../../pages/pdf_extraction_page.dart';
import '../../pages/manual_lab_entry_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/theme/theme_cubit.dart';
import '../../../logic/bloc/lab_results_bloc.dart';

class UploadLabResultsDialog extends StatelessWidget {
  final LabResultsBloc bloc;
  
  const UploadLabResultsDialog({super.key, required this.bloc});

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    try {
      // Request permissions based on source
      if (source == ImageSource.camera) {
        final status = await Permission.camera.request();
        if (!status.isGranted) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppLocalizations.of(context)!.cameraPermissionDenied)),
            );
          }
          return;
        }
      } else {
        // For gallery - try photos first, then storage
        PermissionStatus status;
        if (Platform.isAndroid) {
          // Android 13+ uses different permissions
          if (await Permission.photos.isGranted ||
              await Permission.storage.isGranted) {
            status = PermissionStatus.granted;
          } else {
            status = await Permission.photos.request();
            if (!status.isGranted) {
              status = await Permission.storage.request();
            }
          }
        } else {
          // iOS
          status = await Permission.photos.request();
        }

        if (!status.isGranted) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppLocalizations.of(context)!.photosPermissionDenied)),
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
        final imageFile = File(pickedFile.path);

        // Close dialog
        Navigator.pop(context);

        // Navigate to OCR extraction page with bloc provider
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (newContext) => BlocProvider.value(
              value: bloc,
              child: OcrExtractionPage(imageFile: imageFile),
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.failedToPickImage(e.toString()))));
      }
    }
  }

  Future<void> _pickPDF(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null &&
          result.files.single.path != null &&
          context.mounted) {
        final pdfPath = result.files.single.path!;

        // Close dialog
        Navigator.pop(context);

        // Navigate to PDF viewer/extraction page with bloc provider
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (newContext) => BlocProvider.value(
              value: bloc,
              child: PdfExtractionPage(pdfPath: pdfPath),
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.failedToPickPDF(e.toString()))));
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
            style: AppTextStyles.headline2.copyWith(
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

          // PDF option
          _buildOptionButton(
            context,
            icon: Icons.picture_as_pdf,
            title: 'Upload PDF',
            subtitle: 'Select PDF lab report',
            onTap: () => _pickPDF(context),
          ),

          // Manual entry option
          const SizedBox(height: 16),

          // Manual entry option (future feature)
          // Manual entry option
          _buildOptionButton(
            context,
            icon: Icons.edit,
            title: 'Manual Entry',
            subtitle: 'Enter results manually',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ManualLabEntryPage(),
                ),
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
    final themeData = context.watch<ThemeCubit>().currentTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: themeData.lightColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: themeData.primaryColor.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: themeData.primaryColor,
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
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
