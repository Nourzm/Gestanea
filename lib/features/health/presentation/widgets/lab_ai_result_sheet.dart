import 'package:flutter/material.dart';
import 'package:gestanea/core/constants/app_colors.dart';
import 'package:gestanea/l10n/app_localizations.dart';
import '../../data/models/lab_ai_result.dart';

/// Shows the AI lab interpretation (provider-agnostic — Gemini/OpenRouter/
/// Claude, chosen server-side) in a scrollable modal sheet, with the red-flag
/// escalation banner (when present) and the mandatory disclaimer.
///
/// When [onSave] is provided, a "Save to my results" button is shown; it runs
/// the callback once, then closes the sheet.
Future<void> showLabAiResultSheet(
  BuildContext context,
  LabAiResult result, {
  Future<void> Function(LabAiResult result)? onSave,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _LabAiResultSheet(result: result, onSave: onSave),
  );
}

class _LabAiResultSheet extends StatefulWidget {
  final LabAiResult result;
  final Future<void> Function(LabAiResult result)? onSave;
  const _LabAiResultSheet({required this.result, this.onSave});

  @override
  State<_LabAiResultSheet> createState() => _LabAiResultSheetState();
}

class _LabAiResultSheetState extends State<_LabAiResultSheet> {
  bool _saving = false;

  LabAiResult get result => widget.result;

  Future<void> _handleSave() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await widget.onSave!(result);
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  ({Color bg, Color fg, String label}) _status(
    String status,
    AppLocalizations l10n,
  ) {
    switch (status) {
      case 'normal':
        return (
          bg: const Color(0xFFB8E6B8),
          fg: const Color(0xFF2D5F2D),
          label: l10n.normal,
        );
      case 'low':
        return (
          bg: const Color(0xFFBBDEFB),
          fg: const Color(0xFF0D47A1),
          label: l10n.low,
        );
      case 'high':
        return (
          bg: const Color(0xFFFFCDD2),
          fg: const Color(0xFFB71C1C),
          label: l10n.high,
        );
      case 'borderline':
        return (
          bg: const Color(0xFFFFE0B2),
          fg: const Color(0xFF8A5A00),
          label: l10n.borderline,
        );
      default:
        return (
          bg: const Color(0xFFE0E0E0),
          fg: const Color(0xFF616161),
          label: '—',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFAF0FF),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(20),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.auto_awesome, color: AppColors.main500),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.aiResultTitle,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Red-flag escalation
              if (result.redFlag && result.redFlagMessage.isNotEmpty) ...[
                _banner(
                  bg: const Color(0xFFFFEBEE),
                  border: const Color(0xFFE53935),
                  icon: Icons.warning_amber_rounded,
                  iconColor: const Color(0xFFC62828),
                  title: l10n.aiSeekCareTitle,
                  body: result.redFlagMessage,
                ),
                const SizedBox(height: 16),
              ],

              // Overall summary
              if (result.overallSummary.isNotEmpty) ...[
                _sectionTitle(l10n.aiOverallSummary),
                const SizedBox(height: 6),
                Text(
                  result.overallSummary,
                  style: const TextStyle(fontSize: 14, height: 1.4),
                ),
                const SizedBox(height: 16),
              ],

              // Per-test breakdown
              if (result.tests.isNotEmpty) ...[
                _sectionTitle(l10n.aiDetectedTests),
                const SizedBox(height: 8),
                ...result.tests.map((t) {
                  final s = _status(t.status, l10n);
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                t.testName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: s.bg,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                s.label,
                                style: TextStyle(fontSize: 11, color: s.fg),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${t.value} ${t.unit}'
                          '${t.referenceRange.isNotEmpty ? '  (${t.referenceRange})' : ''}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        if (t.explanation.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            t.explanation,
                            style: const TextStyle(fontSize: 12, height: 1.4),
                          ),
                        ],
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 8),
              ],

              // Guidance
              if (result.guidance.isNotEmpty) ...[
                _sectionTitle(l10n.aiGuidance),
                const SizedBox(height: 6),
                ...result.guidance.map(
                  (g) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          size: 16,
                          color: AppColors.main500,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            g,
                            style: const TextStyle(fontSize: 13, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Disclaimer
              if (result.disclaimer.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8D5F2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 18,
                        color: Color(0xFF7B4BA6),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          result.disclaimer,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF7B4BA6),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              // Save into the user's lab results (persists after this sheet
              // closes — the analysis itself is otherwise ephemeral).
              if (widget.onSave != null) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _saving ? null : _handleSave,
                    icon: _saving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.save_alt),
                    label: Text(l10n.aiSaveResults),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.main500,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _sectionTitle(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: AppColors.textDark,
    ),
  );

  Widget _banner({
    required Color bg,
    required Color border,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String body,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: iconColor,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(body, style: const TextStyle(fontSize: 13, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
