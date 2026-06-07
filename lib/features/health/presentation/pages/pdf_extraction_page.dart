import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/core/database/models/lab_result_model.dart';
import '../../logic/bloc/lab_results_bloc.dart';
import '../../logic/bloc/lab_results_event.dart';
import 'manual_lab_entry_page.dart';

class PdfExtractionPage extends StatelessWidget {
  final String pdfPath;

  const PdfExtractionPage({super.key, required this.pdfPath});

  void _saveJustPdf(BuildContext context) {
    final labResult = LabResultModel(
      id: DateTime.now(). millisecondsSinceEpoch.toString(),
      userId: 'current_user',
      testName: 'PDF Lab Report',
      labDate: DateTime.now(),
      reportImageUrl: pdfPath,
      extractedByOcr: false,
      createdAt: DateTime. now(),
    );
    
    context.read<LabResultsBloc>().add(AddLabResult(labResult));
    
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('PDF saved! '),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Lab Report'),
        backgroundColor: AppColors.main500,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.picture_as_pdf, size: 100, color: Colors.red),
              const SizedBox(height: 20),
              const Text(
                'PDF Saved',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'File: ${pdfPath. split('/').last}',
                style: const TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              
              ElevatedButton. icon(
                onPressed: () => _saveJustPdf(context),
                icon: const Icon(Icons.save),
                label: const Text('Save PDF Reference'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.main500,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                ),
              ),
              const SizedBox(height: 12),
              
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ManualLabEntryPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
                label: const Text('Enter Data Manually'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.main500,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}