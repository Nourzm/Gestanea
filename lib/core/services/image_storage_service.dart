import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ImageStorageService {
  static const String _folderName = 'lab_results';
  static const String _supabaseBucket = 'lab-results';

  // Get the directory where lab result images are stored
  Future<Directory> get _labResultsDirectory async {
    final appDir = await getApplicationDocumentsDirectory();
    final labDir = Directory('${appDir.path}/$_folderName');
    
    if (!await labDir.exists()) {
      await labDir.create(recursive: true);
    }
    
    return labDir;
  }

  // Save image to storage
  Future<String> saveImage(File imageFile, String userId) async {
    try {
      // First, save locally as backup
      final directory = await _labResultsDirectory;
      final fileName = 'lab_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final localPath = '${directory.path}/$fileName';
      
      await imageFile.copy(localPath);
      
      // Then upload to Supabase Storage in user-specific folder
      try {
        print('Attempting to upload image to Supabase...');
        final supabase = Supabase.instance.client;
        final bytes = await imageFile.readAsBytes();
        print('Image size: ${bytes.length} bytes');
        
        // Upload to user-specific folder: userId/fileName
        final storagePath = '$userId/$fileName';
        print('Uploading to path: $storagePath');
        
        final uploadResponse = await supabase.storage
            .from(_supabaseBucket)
            .uploadBinary(
              storagePath,
              bytes,
              fileOptions: const FileOptions(
                contentType: 'image/jpeg',
                upsert: false,
              ),
            );
        
        print('Upload response: $uploadResponse');
        
        // Get public URL
        final publicUrl = supabase.storage
            .from(_supabaseBucket)
            .getPublicUrl(storagePath);
        
        print('✅ Image uploaded successfully to Supabase: $publicUrl');
        return publicUrl;
      } catch (storageError) {
        print('❌ Supabase storage upload failed: $storageError');
        print('Error type: ${storageError.runtimeType}');
        print('Using local path instead: $localPath');
        // If Supabase upload fails, return local path
        return localPath;
      }
    } catch (e) {
      throw Exception('Failed to save image: $e');
    }
  }

  // Save PDF to storage
  Future<String> savePdf(File pdfFile, String userId) async {
    try {
      // First, save locally as backup
      final directory = await _labResultsDirectory;
      final fileName = 'lab_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final localPath = '${directory.path}/$fileName';
      
      await pdfFile.copy(localPath);
      
      // Then upload to Supabase Storage in user-specific folder
      try {
        print('Attempting to upload PDF to Supabase...');
        final supabase = Supabase.instance.client;
        final bytes = await pdfFile.readAsBytes();
        print('PDF size: ${bytes.length} bytes');
        
        // Upload to user-specific folder: userId/fileName
        final storagePath = '$userId/$fileName';
        print('Uploading to path: $storagePath');
        
        final uploadResponse = await supabase.storage
            .from(_supabaseBucket)
            .uploadBinary(
              storagePath,
              bytes,
              fileOptions: const FileOptions(
                contentType: 'application/pdf',
                upsert: false,
              ),
            );
        
        print('Upload response: $uploadResponse');
        
        // Get public URL
        final publicUrl = supabase.storage
            .from(_supabaseBucket)
            .getPublicUrl(storagePath);
        
        print('✅ PDF uploaded successfully to Supabase: $publicUrl');
        return publicUrl;
      } catch (storageError) {
        print('❌ Supabase storage upload failed: $storageError');
        print('Error type: ${storageError.runtimeType}');
        print('Using local path instead: $localPath');
        // If Supabase upload fails, return local path
        return localPath;
      }
    } catch (e) {
      throw Exception('Failed to save PDF: $e');
    }
  }

  // Get image file from path (handles both local paths and remote URLs)
  Future<File?> getImageAsync(String? path) async {
    if (path == null || path.isEmpty) return null;
    
    // If it's a remote URL, extract filename and find in local storage
    if (path.startsWith('http://') || path.startsWith('https://')) {
      try {
        final uri = Uri.parse(path);
        final segments = uri.pathSegments;
        
        // The filename is always the last segment, regardless of folder structure
        // Old format: .../lab-results/filename.jpg
        // New format: .../lab-results/userId/filename.jpg
        final filename = segments.isNotEmpty ? segments.last : null;
        
        if (filename != null && filename.isNotEmpty) {
          // Look for the file in local storage
          final directory = await _labResultsDirectory;
          final file = File('${directory.path}/$filename');
          
          if (await file.exists()) {
            print('Found local file: ${file.path}');
            return file;
          } else {
            print('Local file not found: ${file.path}');
          }
        }
      } catch (e) {
        print('Error parsing URL: $e');
      }
      return null;
    }
    
    // Local path - check if exists
    final file = File(path);
    return await file.exists() ? file : null;
  }
  
  // Get image file from path (synchronous - for existing code compatibility)
  File? getImage(String? path) {
    if (path == null || path.isEmpty) return null;
    
    // For remote URLs, we can't do synchronous lookup, return null
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return null;
    }
    
    // Local path
    final file = File(path);
    return file.existsSync() ? file : null;
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
        final fileName = image.path.split('/').last;
        final file = ArchiveFile(fileName, bytes.length, bytes);
        archive.addFile(file);
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
      await zipFile. writeAsBytes(zipBytes);

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

      await Share. shareXFiles(
        [XFile(zipPath)],
        subject: 'Lab Results',
        text: 'My lab results archive',
      );
    } catch (e) {
      throw Exception('Failed to share ZIP: $e');
    }
  }
}