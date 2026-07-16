import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/image_storage_service.dart';
import '../../logic/bloc/lab_results_bloc.dart';
import '../../logic/bloc/lab_results_state.dart';
import 'package:gestanea/core/theme/theme_cubit.dart';

class LabPapersGalleryPage extends StatelessWidget {
  const LabPapersGalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = context.watch<ThemeCubit>().currentTheme;
    final imageStorage = ImageStorageService();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.labPapersGallery),
        backgroundColor: themeData.primaryColor,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              await imageStorage.shareZip();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppLocalizations.of(context)!.exportingLabPapers)),
                );
              }
            },
            tooltip: 'Export all as ZIP',
          ),
        ],
      ),
      body: BlocBuilder<LabResultsBloc, LabResultsState>(
        builder: (context, state) {
          if (state is LabResultsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is LabResultsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('${AppLocalizations.of(context)!.error}: ${state.message}'),
                ],
              ),
            );
          }

          if (state is LabResultsLoaded) {
            // Get all unique image paths
            final imagePaths = state.labResults
                .where((r) => r.reportImageUrl != null && r.reportImageUrl!.isNotEmpty)
                .map((r) => r.reportImageUrl!)
                .toSet()
                .toList();

            if (imagePaths.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image_not_supported, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No lab papers found',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(AppLocalizations.of(context)!.uploadLabReportsToSee),
                  ],
                ),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: imagePaths.length,
              itemBuilder: (context, index) {
                final imagePath = imagePaths[index];

                return _buildPaperCard(
                  context,
                  imagePath,
                  index + 1,
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildPaperCard(
    BuildContext context,
    String imagePath,
    int index,
  ) {
    final themeData = context.watch<ThemeCubit>().currentTheme;
    final isPdf = imagePath.toLowerCase().endsWith('.pdf');
    final isRemoteUrl = imagePath.startsWith('http://') || imagePath.startsWith('https://');

    print('Building card for: $imagePath');
    print('  isPdf: $isPdf, isRemoteUrl: $isRemoteUrl');

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          _showImageDialog(context, imagePath, isPdf, isRemoteUrl);
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image preview
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: isPdf
                    ? Container(
                        color: Colors.red.shade50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.picture_as_pdf,
                              size: 64,
                              color: Colors.red.shade300,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'PDF Document',
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    : isRemoteUrl
                        ? Image.network(
                            imagePath,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: Colors.grey.shade200,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey.shade200,
                                child: const Icon(
                                  Icons.broken_image,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          )
                        : FutureBuilder<File?>(
                            future: ImageStorageService().getImageAsync(imagePath),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Container(
                                  color: Colors.grey.shade200,
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                              if (snapshot.hasData && snapshot.data != null) {
                                return Image.file(
                                  snapshot.data!,
                                  fit: BoxFit.cover,
                                );
                              }
                              return Container(
                                color: Colors.grey.shade200,
                                child: const Icon(
                                  Icons.broken_image,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
              ),
            ),

            // Actions bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: themeData.primaryColor.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'Paper #$index',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: themeData.primaryColor,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.print, size: 18),
                        onPressed: !isPdf
                            ? () => _printImageFromPath(imagePath, isRemoteUrl)
                            : null,
                        tooltip: 'Print',
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        icon: const Icon(Icons.fullscreen, size: 18),
                        onPressed: () => _showImageDialog(context, imagePath, isPdf, isRemoteUrl),
                        tooltip: 'View full',
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showImageDialog(BuildContext context, String imagePath, bool isPdf, bool isRemoteUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: isPdf
                    ? Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.picture_as_pdf,
                              size: 120,
                              color: Colors.red.shade300,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'PDF Document',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'File: ${imagePath.split('/').last}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      )
                    : isRemoteUrl
                        ? Image.network(
                            imagePath,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.white,
                                padding: const EdgeInsets.all(32),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
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
                                return Image.file(snapshot.data!);
                              }
                              return Container(
                                color: Colors.white,
                                padding: const EdgeInsets.all(32),
                                child: const CircularProgressIndicator(),
                              );
                            },
                          ),
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 32),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _printImage(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final image = pw.MemoryImage(bytes);

      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) => pw.Center(
            child: pw.Image(image, fit: pw.BoxFit.contain),
          ),
        ),
      );

      await Printing.layoutPdf(
        onLayout: (format) async => pdf.save(),
      );
    } catch (e) {
      print('Error printing: $e');
    }
  }

  Future<void> _printImageFromPath(String imagePath, bool isRemoteUrl) async {
    try {
      File? imageFile;
      
      if (isRemoteUrl) {
        // Try to get local cached file
        imageFile = await ImageStorageService().getImageAsync(imagePath);
        
        // If no local file, download from remote URL
        if (imageFile == null) {
          final response = await http.get(Uri.parse(imagePath));
          if (response.statusCode == 200) {
            final tempDir = await getTemporaryDirectory();
            final tempFile = File('${tempDir.path}/temp_print.jpg');
            await tempFile.writeAsBytes(response.bodyBytes);
            imageFile = tempFile;
          }
        }
      } else {
        // Local path
        imageFile = await ImageStorageService().getImageAsync(imagePath);
      }
      
      if (imageFile != null) {
        await _printImage(imageFile);
      }
    } catch (e) {
      print('Error printing from path: $e');
    }
  }
}
