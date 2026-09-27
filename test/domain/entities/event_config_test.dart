import 'package:flutter_test/flutter_test.dart';
import 'package:cancun_dashbooth/domain/entities/event_config.dart';

void main() {
  group('EventConfig Entity Tests', () {
    test('defaultQuito preset contains Quito event parameters and Andean slang',
        () {
      final config = EventConfig.defaultQuito();

      expect(config.eventName, 'DevFest Quito 2026');
      expect(config.eventLocation, 'Quito, Ecuador');
      expect(config.eventTagline, contains('Innovating Together'));
      expect(config.eventBadgeLabel, '⚡ DevFest Quito 2026');
      expect(config.hashtag, '#devfestquito26');
      expect(config.logoUrl, isNull); // Generic default
      expect(config.heroImageUrl, isNull); // Generic default
      expect(config.adminPin, '2026');
      expect(config.badgeRoleTitle, 'DEVFEST PIONEER');
      expect(config.communityTagline, 'Quito • DevFest');
      expect(config.fallbackTitles, contains('¡De Ley en DevFest! 100%'));
      expect(config.loadingMessages.first, contains('DevFest Quito 2026'));
    });

    test('cancun preset contains Cancun event parameters and Mexican slang',
        () {
      final config = EventConfig.cancun();

      expect(config.eventName, 'FlutterConf LATAM 2026');
      expect(config.eventBadgeLabel, '🌴 Cancún 2026');
      expect(config.hashtag, '#flutterconflatam26');
      expect(config.badgeRoleTitle, 'FLUTTER PIONEER');
      expect(config.communityTagline, 'Cancún • FlutterConf');
      expect(config.logoUrl, 'images/logo.png');
      expect(config.heroImageUrl, 'images/dash_playa.png');
      expect(config.fallbackTitles, contains('¡Qué Chido Cancún! 100%'));
    });

    test('generic preset contains generic event parameters', () {
      final config = EventConfig.generic();

      expect(config.eventName, 'Tech Event 2026');
      expect(config.badgeRoleTitle, 'TECH PIONEER');
      expect(config.communityTagline, 'Global • TechConf');
      expect(config.logoUrl, isNull);
      expect(config.heroImageUrl, isNull);
    });

    test('interpolatePrompt replaces placeholders correctly', () {
      final config = EventConfig.defaultQuito();
      final interpolated = config.interpolatePrompt('Santiago Morales');

      expect(interpolated, contains('Santiago Morales'));
      expect(interpolated, contains('DevFest Quito 2026'));
      expect(interpolated, contains('Quito, Ecuador'));
      expect(interpolated, isNot(contains('{name}')));
      expect(interpolated, isNot(contains('{eventName}')));
      expect(interpolated, isNot(contains('{location}')));
    });

    test('interpolateShareCaption replaces placeholders correctly', () {
      final config = EventConfig.defaultQuito();
      final caption = config.interpolateShareCaption('Mateo');

      expect(caption, contains('DevFest Quito 2026'));
      expect(caption, contains('Quito, Ecuador'));
      expect(caption, contains('#devfestquito26'));
    });

    test('getFallbackTitle returns deterministic title from catalog', () {
      final config = EventConfig.defaultQuito();
      final title1 = config.getFallbackTitle('Juan Perez');
      final title2 = config.getFallbackTitle('Juan Perez');

      expect(title1, equals(title2));
      expect(config.fallbackTitles, contains(title1));
    });

    test('supports copyWith and value equality', () {
      final config = EventConfig.defaultQuito();
      final updated = config.copyWith(
        eventName: 'DevFest Quito',
        badgeRoleTitle: 'VIP PIONEER',
        communityTagline: 'Quito • VIP',
      );

      expect(updated.eventName, 'DevFest Quito');
      expect(updated.eventLocation, config.eventLocation);
      expect(updated.badgeRoleTitle, 'VIP PIONEER');
      expect(updated.communityTagline, 'Quito • VIP');
      expect(config == updated, isFalse);

      final identicalClone = config.copyWith();
      expect(config, equals(identicalClone));
      expect(config.hashCode, equals(identicalClone.hashCode));
    });

    test('supports customApiKey in copyWith, equality and clearing', () {
      final config = EventConfig.defaultQuito();
      expect(config.customApiKey, isNull);

      final withKey = config.copyWith(customApiKey: 'AIzaSyTestKey123');
      expect(withKey.customApiKey, 'AIzaSyTestKey123');
      expect(config == withKey, isFalse);

      final cleared = withKey.copyWith(clearCustomApiKey: true);
      expect(cleared.customApiKey, isNull);
      expect(cleared, equals(config));
    });
  });
}
