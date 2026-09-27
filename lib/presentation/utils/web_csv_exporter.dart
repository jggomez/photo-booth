import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;
import '../../domain/entities/user_card.dart';

/// Web-compatible utility to generate and download attendee data in CSV format.
class WebCsvExporter {
  /// Builds a standard UTF-8 CSV string with BOM for Excel/Sheets compatibility.
  static String buildCsvContent({
    required List<UserCard> cards,
    required String eventName,
  }) {
    final buffer = StringBuffer();
    // UTF-8 Byte Order Mark (BOM) ensures special characters/accents render correctly
    buffer.write('\uFEFF');
    buffer.writeln('Nombre,Email,Evento,Fecha');

    for (final card in cards) {
      final safeName = card.name.replaceAll('"', '""');
      final safeEmail = card.email.replaceAll('"', '""');
      final safeEvent = eventName.replaceAll('"', '""');
      final date = card.createdAt.toIso8601String();
      buffer.writeln('"$safeName","$safeEmail","$safeEvent","$date"');
    }

    return buffer.toString();
  }

  /// Triggers a client-side file download of attendee CSV in the web browser.
  static void exportAttendeesToCsv({
    required List<UserCard> cards,
    required String eventName,
    String? fileName,
  }) {
    final csvContent = buildCsvContent(cards: cards, eventName: eventName);
    final safeSlug = eventName
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]'), '_')
        .replaceAll(RegExp(r'_+'), '_');
    final name = fileName ??
        'asistentes_${safeSlug}_${DateTime.now().millisecondsSinceEpoch}.csv';

    if (kIsWeb) {
      final bytes = utf8.encode(csvContent);
      final blob = html.Blob([bytes], 'text/csv;charset=utf-8');
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement(href: url)
        ..setAttribute('download', name)
        ..click();
      html.Url.revokeObjectUrl(url);
    }
  }
}
