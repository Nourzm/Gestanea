import 'package:flutter/material.dart';

import 'package:gestanea/l10n/app_localizations.dart';

// Page 2: Appointment Location
class AppointmentLocationPage extends StatefulWidget {
  final String initialLocation;
  final Function(String) onLocationChanged;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const AppointmentLocationPage({
    super.key,
    required this.initialLocation,
    required this.onLocationChanged,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<AppointmentLocationPage> createState() =>
      _AppointmentLocationPageState();
}

class _AppointmentLocationPageState extends State<AppointmentLocationPage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialLocation);
    _controller.addListener(() {
      widget.onLocationChanged(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 20),
                onPressed: widget.onBack,
              ),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.appointmentLocation,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextField(
              controller: _controller,
              autofocus: true,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: '',
                contentPadding: EdgeInsets.symmetric(vertical: 16),
              ),
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _controller.text.isNotEmpty ? widget.onNext : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _controller.text.isNotEmpty
                    ? const Color(0xFFA67FF5)
                    : const Color(0xFFE0E0E0),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: Text(
                AppLocalizations.of(context)!.doneLabel,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
