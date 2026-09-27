import 'package:flutter_test/flutter_test.dart';
import 'package:cancun_dashbooth/domain/entities/user_card.dart';
import 'package:cancun_dashbooth/presentation/utils/web_csv_exporter.dart';

void main() {
  group('WebCsvExporter Tests', () {
    test('buildCsvContent generates correct CSV format with UTF-8 BOM', () {
      final cards = [
        UserCard(
          id: '1',
          name: 'María José "Majo"',
          email: 'majo@devfest.ec',
          imageUri: 'https://test.com/photo1.png',
          createdAt: DateTime(2026, 9, 26, 10, 30),
        ),
        UserCard(
          id: '2',
          name: 'Carlos Pérez',
          email: 'carlos@flutter.ec',
          imageUri: 'https://test.com/photo2.png',
          createdAt: DateTime(2026, 9, 26, 11, 00),
        ),
      ];

      final csv = WebCsvExporter.buildCsvContent(
        cards: cards,
        eventName: 'DevFest Quito 2026',
      );

      // Verify UTF-8 BOM
      expect(csv.startsWith('\uFEFF'), isTrue);

      // Verify Header
      expect(csv, contains('Nombre,Email,Evento,Fecha'));

      // Verify row escaping
      expect(csv, contains('"María José ""Majo"""'));
      expect(csv, contains('"majo@devfest.ec"'));
      expect(csv, contains('"DevFest Quito 2026"'));
      expect(csv, contains('"Carlos Pérez"'));
      expect(csv, contains('"carlos@flutter.ec"'));
    });

    test('buildCsvContent handles empty list gracefully', () {
      final csv = WebCsvExporter.buildCsvContent(
        cards: [],
        eventName: 'DevFest Quito 2026',
      );

      expect(csv.startsWith('\uFEFF'), isTrue);
      expect(csv, contains('Nombre,Email,Evento,Fecha'));
    });

    test('exportAttendeesToCsv executes without errors', () {
      final cards = [
        UserCard(
          id: '1',
          name: 'Test User',
          email: 'test@example.com',
          imageUri: 'https://test.com/1.png',
          createdAt: DateTime(2026, 9, 26),
        ),
      ];

      expect(
        () => WebCsvExporter.exportAttendeesToCsv(
          cards: cards,
          eventName: 'DevFest Quito 2026',
        ),
        returnsNormally,
      );
    });
  });
}
