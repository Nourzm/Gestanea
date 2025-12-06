import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive.dart';
import 'package:share_plus/share_plus.dart';

class ImageStorageService {
  static const String _folderName = 'lab_results';

  // Get the directory where lab result images are stored
  Future<Directory> get _labResultsDirectory async {
    final appDir = await getApplicationDocumentsDirectory();
    final labDir = Directory('${appDir.path}/$_folderName');
    
    if (! await labDir.exists()) {
      await labDir.create(recursive: true);
    }
    
    return labDir;
  }

  // Save image to storage
  Future<String> saveImage(File imageFile) async {
    try {
      final directory = await _labResultsDirectory;
      final fileName = 'lab_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedPath = '${directory.path}/$fileName';
      
      await imageFile.copy(savedPath);
      return savedPath;
    } catch (e) {
      throw Exception('Failed to save image: $e');
    }
  }

  // Get image file from path
  File?  getImage(String?  path) {
    if (path == null || path.isEmpty) return null;
    final file = File(path);
    return file.existsSync() ?  file : null;
  }

  // Delete image
  Future<void> deleteImage(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete image: $e');
    }
  }

  // Get all lab result images
  Future<List<File>> getAllImages() async {
    try {
      final directory = await _labResultsDirectory;
      final files = directory
          .listSync()
          .where((item) => item is File && item.path.endsWith('.jpg'))
          .map((item) => item as File)
          .toList();
      
      files.sort((a, b) => b.path.compareTo(a.path)); // Sort by newest first
      return files;
    } catch (e) {
      return [];
    }
  }

  // Export all images as ZIP
  Future<String?> exportAsZip() async {
    try {
      final images = await getAllImages();
      
      if (images.isEmpty) {
        return null;
      }

      // Create archive
      final archive = Archive();
      
      // Add all images to archive
      for (final image in images) {
        final bytes = await image.readAsBytes();
        final fileName = image.path.split('/'). last;
        final file = ArchiveFile(fileName, bytes. length, bytes);
        archive. addFile(file);
      }

      // Encode to ZIP
      final zipEncoder = ZipEncoder();
      final zipBytes = zipEncoder.encode(archive);
      
      if (zipBytes == null) {
        throw Exception('Failed to create ZIP');
      }

      // Save ZIP to temp directory
      final tempDir = await getTemporaryDirectory();
      final zipPath = '${tempDir. path}/lab_results_${DateTime.now().millisecondsSinceEpoch}.zip';
      final zipFile = File(zipPath);
      await zipFile.writeAsBytes(zipBytes);

      return zipPath;
    } catch (e) {
      throw Exception('Failed to export ZIP: $e');
    }
  }

  // Share ZIP file
  Future<void> shareZip() async {
    try {
      final zipPath = await exportAsZip();
      
      if (zipPath == null) {
        throw Exception('No images to export');
      }

      await Share.shareXFiles(
        [XFile(zipPath)],
        subject: 'Lab Results',
        text: 'My lab results archive',
      );
    } catch (e) {
      throw Exception('Failed to share ZIP: $e');
    }
  }
}