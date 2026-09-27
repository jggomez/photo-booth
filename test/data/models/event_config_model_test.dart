import 'package:cancun_dashbooth/data/models/event_config_model.dart';
import 'package:cancun_dashbooth/domain/entities/event_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EventConfigModel Tests', () {
    final now = DateTime(2026, 9, 26, 12, 0, 0);
    final quito = EventConfig.defaultQuito().copyWith(updatedAt: now);

    test('converts fromDomain and toDomain accurately', () {
      final model = EventConfigModel.fromDomain(quito);
      final domain = model.toDomain();

      expect(domain, equals(quito));
      expect(model.eventName, equals('DevFest Quito 2026'));
      expect(model.eventTagline, contains('Innovating Together'));
      expect(model.badgeRoleTitle, equals('DEVFEST PIONEER'));
      expect(model.communityTagline, equals('Quito • DevFest'));
      expect(model.adminPin, equals('2026'));
    });

    test('serializes to JSON and deserializes from JSON accurately', () {
      final model = EventConfigModel.fromDomain(quito);
      final json = model.toJson();

      expect(json['id'], equals('event_current'));
      expect(json['eventName'], equals('DevFest Quito 2026'));
      expect(json['badgeRoleTitle'], equals('DEVFEST PIONEER'));
      expect(json['communityTagline'], equals('Quito • DevFest'));
      expect(json['fallbackTitles'], isA<List>());
      expect(json['updatedAt'], equals(now.toIso8601String()));

      final fromJson = EventConfigModel.fromJson(json);
      expect(fromJson.eventName, equals(model.eventName));
      expect(fromJson.badgeRoleTitle, equals('DEVFEST PIONEER'));
      expect(fromJson.communityTagline, equals('Quito • DevFest'));
      expect(fromJson.fallbackTitles, equals(model.fallbackTitles));
      expect(fromJson.loadingMessages, equals(model.loadingMessages));
      expect(fromJson.adminPin, equals('2026'));
      expect(fromJson.updatedAt, equals(now));
    });

    test('serializes to Firestore map and deserializes from Firestore map', () {
      final model = EventConfigModel.fromDomain(quito);
      final firestoreMap = model.toFirestore();

      expect(firestoreMap['eventName'], equals('DevFest Quito 2026'));
      expect(firestoreMap['badgeRoleTitle'], equals('DEVFEST PIONEER'));
      expect(firestoreMap['communityTagline'], equals('Quito • DevFest'));
      expect(firestoreMap['updatedAt'], isA<Timestamp>());
      expect(firestoreMap['adminPin'], equals('2026'));

      final reconstructed = EventConfigModel.fromJson(
        firestoreMap,
        id: 'event_current',
      );
      expect(reconstructed.eventName, equals(model.eventName));
      expect(reconstructed.badgeRoleTitle, equals('DEVFEST PIONEER'));
      expect(reconstructed.communityTagline, equals('Quito • DevFest'));
      expect(reconstructed.hashtag, equals('#devfestquito26'));
      expect(reconstructed.updatedAt, equals(now));
    });

    test('fromJson falls back to Quito defaults when fields are missing', () {
      final model = EventConfigModel.fromJson(const {}, id: 'event_current');

      expect(model.eventName, equals('DevFest Quito 2026'));
      expect(model.eventBadgeLabel, equals('⚡ DevFest Quito 2026'));
      expect(model.badgeRoleTitle, equals('DEVFEST PIONEER'));
      expect(model.communityTagline, equals('Quito • DevFest'));
      expect(model.adminPin, equals('2026'));
      expect(model.fallbackTitles.isNotEmpty, isTrue);
    });

    test('supports customApiKey in model conversion, JSON and Firestore', () {
      final configWithKey =
          quito.copyWith(customApiKey: 'AIzaSyMyCustomGeminiKey');
      final model = EventConfigModel.fromDomain(configWithKey);
      expect(model.customApiKey, equals('AIzaSyMyCustomGeminiKey'));

      final json = model.toJson();
      expect(json['customApiKey'], equals('AIzaSyMyCustomGeminiKey'));

      final fromJson = EventConfigModel.fromJson(json);
      expect(fromJson.customApiKey, equals('AIzaSyMyCustomGeminiKey'));

      final firestoreMap = model.toFirestore();
      expect(firestoreMap['customApiKey'], equals('AIzaSyMyCustomGeminiKey'));

      final fromFirestore = EventConfigModel.fromJson(firestoreMap);
      expect(fromFirestore.customApiKey, equals('AIzaSyMyCustomGeminiKey'));
      expect(fromFirestore.toDomain().customApiKey,
          equals('AIzaSyMyCustomGeminiKey'));
    });
  });
}
