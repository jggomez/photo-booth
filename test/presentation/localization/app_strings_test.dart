import 'package:flutter_test/flutter_test.dart';
import 'package:cancun_dashbooth/presentation/localization/app_strings.dart';
import 'package:cancun_dashbooth/presentation/providers/app_language_provider.dart';

void main() {
  group('AppStrings & AppLanguage Tests', () {
    test('provides complete and distinct strings for ES and EN', () {
      final es = AppStrings.get(AppLanguage.es);
      final en = AppStrings.get(AppLanguage.en);

      // Navbar
      expect(es.createBadge, equals('Crear mi Badge'));
      expect(en.createBadge, equals('Create Badge'));
      expect(es.liveWall, equals('Mural en Vivo'));
      expect(en.liveWall, equals('Live Wall'));
      expect(es.adminPanel, equals('Admin'));
      expect(en.adminPanel, equals('Admin'));

      // Photobooth
      expect(es.formTitle, contains('Tus Datos'));
      expect(en.formTitle, contains('Your Info'));
      expect(es.nameLabel, contains('Nombre'));
      expect(en.nameLabel, contains('Name'));
      expect(es.emailLabel, contains('Correo'));
      expect(en.emailLabel, contains('Email'));
      expect(es.takePhoto, contains('Tomar Foto'));
      expect(en.takePhoto, contains('Take Photo'));
      expect(es.generateBadge, contains('Personalizar'));
      expect(en.generateBadge, contains('Customize'));

      // Community Wall
      expect(es.liveAlbumTitle, contains('Comunitario'));
      expect(en.liveAlbumTitle, contains('Community'));
      expect(es.f1Roulette, contains('Ruleta'));
      expect(en.f1Roulette, contains('Roulette'));

      // F1 Roulette
      expect(es.officialPrizeRoulette, contains('Ruleta Oficial'));
      expect(en.officialPrizeRoulette, contains('Official Prize Roulette'));

      // Admin Panel
      expect(es.adminTitle, contains('Configuración'));
      expect(en.adminTitle, contains('Configuration'));
      expect(es.apiKeyTitle, contains('API Key'));
      expect(en.apiKeyTitle, contains('API Key'));
      expect(es.saveLiveConfig, contains('Guardar'));
      expect(en.saveLiveConfig, contains('Save'));
    });
  });
}
