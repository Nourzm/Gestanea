import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:gestanea/core/services/supabase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/lab_ai_result.dart';

/// Thrown for any failure analyzing a lab result via the Edge Function.
class LabAiException implements Exception {
  final String code; // e.g. offline, rate_limited, server, parse
  final String message;
  const LabAiException(this.code, this.message);
  @override
  String toString() => 'LabAiException($code): $message';
}

/// Calls the `analyze-lab` Supabase Edge Function, which proxies the AI
/// provider chosen server-side (Gemini / OpenRouter / Claude).
///
/// The Anthropic key lives only on the server; this just forwards the image
/// and/or OCR text plus pregnancy context and parses the structured reply.
class LabAiService {
  static const _functionName = 'analyze-lab';

  /// Whether the backend is reachable. The app authenticates users locally
  /// (not via Supabase Auth), so we only require Supabase to be configured —
  /// the function accepts the anon key. Callers fall back to the offline
  /// threshold view when this is false.
  bool get isAvailable => SupabaseService.instance.isReady;

  /// Stable per-install id used by the server for rate limiting, since the
  /// app authenticates locally and there is no Supabase user to bucket by.
  static Future<String> _installId() async {
    final prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('lab_ai_install_id');
    if (id == null) {
      id = const Uuid().v4();
      await prefs.setString('lab_ai_install_id', id);
    }
    return id;
  }

  Future<LabAiResult> analyze({
    File? image,
    String? ocrText,
    int? week,
    String? trimester,
    List<String> conditions = const [],
    String? priorResults,
    required String locale,
  }) async {
    if (!isAvailable) {
      throw const LabAiException('offline', 'AI analysis needs a connection');
    }

    String? imageBase64;
    String? mediaType;
    if (image != null) {
      final bytes = await image.readAsBytes();
      imageBase64 = base64Encode(bytes);
      final lower = image.path.toLowerCase();
      mediaType = lower.endsWith('.png')
          ? 'image/png'
          : lower.endsWith('.pdf')
          ? 'application/pdf'
          : 'image/jpeg';
    }

    final body = <String, dynamic>{
      'installId': await _installId(),
      if (imageBase64 != null) 'imageBase64': imageBase64,
      if (mediaType != null) 'mediaType': mediaType,
      if (ocrText != null && ocrText.trim().isNotEmpty) 'ocrText': ocrText,
      'context': {
        if (week != null) 'week': week,
        if (trimester != null) 'trimester': trimester,
        if (conditions.isNotEmpty) 'conditions': conditions,
        if (priorResults != null) 'priorResults': priorResults,
      },
      'locale': locale,
    };

    try {
      final res = await SupabaseService.instance.client.functions.invoke(
        _functionName,
        body: body,
      );
      final status = res.status;
      final data = res.data;
      if (status == 429) {
        throw const LabAiException('rate_limited', 'Daily AI limit reached');
      }
      if (status < 200 || status >= 300 || data is! Map) {
        throw LabAiException('server', 'Analysis failed (status $status)');
      }
      final result = data['result'];
      if (result is! Map) {
        throw const LabAiException('parse', 'Unexpected response shape');
      }
      return LabAiResult.fromJson(Map<String, dynamic>.from(result));
    } on LabAiException {
      rethrow;
    } catch (e) {
      debugPrint('LabAiService.analyze failed: $e');
      throw LabAiException('server', e.toString());
    }
  }
}
