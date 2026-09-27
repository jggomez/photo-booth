import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/event_config.dart';

/// Data Transfer Object (DTO) for [EventConfig] with Firestore serialization.
class EventConfigModel extends EventConfig {
  const EventConfigModel({
    required super.id,
    required super.eventName,
    required super.eventTagline,
    required super.eventLocation,
    required super.eventBadgeLabel,
    required super.hashtag,
    super.badgeRoleTitle = 'TECH PIONEER',
    super.communityTagline = 'Quito • DevFest',
    super.logoUrl,
    super.heroImageUrl,
    super.customApiKey,
    required super.heroTitle,
    required super.heroSubtitle,
    required super.promptTemplate,
    required super.fallbackTitles,
    required super.socialShareCaptionTemplate,
    required super.loadingMessages,
    super.adminPin = '2026',
    super.updatedAt,
  });

  /// Factory constructor to parse a Cloud Firestore document snapshot.
  factory EventConfigModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    return EventConfigModel.fromJson(doc.data() ?? {}, id: doc.id);
  }

  /// Factory constructor to parse raw JSON / Map with defaults fallback to Quito.
  factory EventConfigModel.fromJson(Map<String, dynamic> json, {String? id}) {
    final defaultPreset = EventConfig.defaultQuito();

    final rawDate = json['updatedAt'];
    DateTime? date;
    if (rawDate is Timestamp) {
      date = rawDate.toDate();
    } else if (rawDate is String) {
      date = DateTime.tryParse(rawDate);
    }

    final rawFallbacks = json['fallbackTitles'];
    final List<String> fallbacks = (rawFallbacks is List)
        ? rawFallbacks.map((e) => e.toString()).toList()
        : defaultPreset.fallbackTitles;

    final rawLoading = json['loadingMessages'];
    final List<String> loadings = (rawLoading is List)
        ? rawLoading.map((e) => e.toString()).toList()
        : defaultPreset.loadingMessages;

    return EventConfigModel(
      id: id ?? (json['id'] as String? ?? defaultPreset.id),
      eventName: json['eventName'] as String? ?? defaultPreset.eventName,
      eventTagline:
          json['eventTagline'] as String? ?? defaultPreset.eventTagline,
      eventLocation:
          json['eventLocation'] as String? ?? defaultPreset.eventLocation,
      eventBadgeLabel:
          json['eventBadgeLabel'] as String? ?? defaultPreset.eventBadgeLabel,
      hashtag: json['hashtag'] as String? ?? defaultPreset.hashtag,
      badgeRoleTitle:
          json['badgeRoleTitle'] as String? ?? defaultPreset.badgeRoleTitle,
      communityTagline:
          json['communityTagline'] as String? ?? defaultPreset.communityTagline,
      logoUrl: json['logoUrl'] as String?,
      heroImageUrl: json['heroImageUrl'] as String?,
      customApiKey: json['customApiKey'] as String?,
      heroTitle: json['heroTitle'] as String? ?? defaultPreset.heroTitle,
      heroSubtitle:
          json['heroSubtitle'] as String? ?? defaultPreset.heroSubtitle,
      promptTemplate:
          json['promptTemplate'] as String? ?? defaultPreset.promptTemplate,
      fallbackTitles: fallbacks,
      socialShareCaptionTemplate:
          json['socialShareCaptionTemplate'] as String? ??
              defaultPreset.socialShareCaptionTemplate,
      loadingMessages: loadings,
      adminPin: json['adminPin'] as String? ?? defaultPreset.adminPin,
      updatedAt: date,
    );
  }

  /// Converts this model into a map for Firestore persistence.
  Map<String, dynamic> toFirestore() {
    return {
      'eventName': eventName,
      'eventTagline': eventTagline,
      'eventLocation': eventLocation,
      'eventBadgeLabel': eventBadgeLabel,
      'hashtag': hashtag,
      'badgeRoleTitle': badgeRoleTitle,
      'communityTagline': communityTagline,
      'logoUrl': logoUrl,
      'heroImageUrl': heroImageUrl,
      'customApiKey': customApiKey,
      'heroTitle': heroTitle,
      'heroSubtitle': heroSubtitle,
      'promptTemplate': promptTemplate,
      'fallbackTitles': fallbackTitles,
      'socialShareCaptionTemplate': socialShareCaptionTemplate,
      'loadingMessages': loadingMessages,
      'adminPin': adminPin,
      'updatedAt':
          updatedAt != null ? Timestamp.fromDate(updatedAt!) : Timestamp.now(),
    };
  }

  /// Converts this model into standard JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventName': eventName,
      'eventTagline': eventTagline,
      'eventLocation': eventLocation,
      'eventBadgeLabel': eventBadgeLabel,
      'hashtag': hashtag,
      'badgeRoleTitle': badgeRoleTitle,
      'communityTagline': communityTagline,
      'logoUrl': logoUrl,
      'heroImageUrl': heroImageUrl,
      'customApiKey': customApiKey,
      'heroTitle': heroTitle,
      'heroSubtitle': heroSubtitle,
      'promptTemplate': promptTemplate,
      'fallbackTitles': fallbackTitles,
      'socialShareCaptionTemplate': socialShareCaptionTemplate,
      'loadingMessages': loadingMessages,
      'adminPin': adminPin,
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Converts to pure domain entity.
  EventConfig toDomain() {
    return EventConfig(
      id: id,
      eventName: eventName,
      eventTagline: eventTagline,
      eventLocation: eventLocation,
      eventBadgeLabel: eventBadgeLabel,
      hashtag: hashtag,
      badgeRoleTitle: badgeRoleTitle,
      communityTagline: communityTagline,
      logoUrl: logoUrl,
      heroImageUrl: heroImageUrl,
      customApiKey: customApiKey,
      heroTitle: heroTitle,
      heroSubtitle: heroSubtitle,
      promptTemplate: promptTemplate,
      fallbackTitles: fallbackTitles,
      socialShareCaptionTemplate: socialShareCaptionTemplate,
      loadingMessages: loadingMessages,
      adminPin: adminPin,
      updatedAt: updatedAt,
    );
  }

  /// Factory to construct a model from a domain entity.
  factory EventConfigModel.fromDomain(EventConfig config) {
    return EventConfigModel(
      id: config.id,
      eventName: config.eventName,
      eventTagline: config.eventTagline,
      eventLocation: config.eventLocation,
      eventBadgeLabel: config.eventBadgeLabel,
      hashtag: config.hashtag,
      badgeRoleTitle: config.badgeRoleTitle,
      communityTagline: config.communityTagline,
      logoUrl: config.logoUrl,
      heroImageUrl: config.heroImageUrl,
      customApiKey: config.customApiKey,
      heroTitle: config.heroTitle,
      heroSubtitle: config.heroSubtitle,
      promptTemplate: config.promptTemplate,
      fallbackTitles: config.fallbackTitles,
      socialShareCaptionTemplate: config.socialShareCaptionTemplate,
      loadingMessages: config.loadingMessages,
      adminPin: config.adminPin,
      updatedAt: config.updatedAt,
    );
  }
}
