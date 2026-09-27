import 'package:flutter/foundation.dart';

/// Immutable domain entity representing the dynamic configuration of an event photobooth.
@immutable
class EventConfig {
  final String id;
  final String eventName;
  final String eventTagline;
  final String eventLocation;
  final String eventBadgeLabel;
  final String hashtag;
  final String? logoUrl;
  final String? heroImageUrl;
  final String heroTitle;
  final String heroSubtitle;
  final String promptTemplate;
  final List<String> fallbackTitles;
  final String socialShareCaptionTemplate;
  final List<String> loadingMessages;
  final String badgeRoleTitle;
  final String communityTagline;
  final String? customApiKey;
  final String adminPin;
  final DateTime? updatedAt;

  const EventConfig({
    required this.id,
    required this.eventName,
    required this.eventTagline,
    required this.eventLocation,
    required this.eventBadgeLabel,
    required this.hashtag,
    this.badgeRoleTitle = 'TECH PIONEER',
    this.communityTagline = 'Quito • DevFest',
    this.logoUrl,
    this.heroImageUrl,
    this.customApiKey,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.promptTemplate,
    required this.fallbackTitles,
    required this.socialShareCaptionTemplate,
    required this.loadingMessages,
    this.adminPin = '2026',
    this.updatedAt,
  });

  /// Default active preset configured for DevFest Quito 2026 (GDG Quito - Multi-Tech).
  factory EventConfig.defaultQuito() {
    return const EventConfig(
      id: 'event_current',
      eventName: 'DevFest Quito 2026',
      eventTagline: 'Quito, Ecuador • Innovating Together',
      eventLocation: 'Quito, Ecuador',
      eventBadgeLabel: '⚡ DevFest Quito 2026',
      hashtag: '#devfestquito26',
      logoUrl: null, // Generic default logo
      heroImageUrl: null, // Generic default hero
      heroTitle: '¡Crea tu Credencial Oficial de DevFest Quito!',
      heroSubtitle:
          'Sube o tómate una foto y transfórmala con IA multimodal para la conferencia de tecnología más grande de Ecuador.',
      promptTemplate:
          'A vibrant, high-quality digital art portrait of the conference attendee ({name}) '
          'from the reference photo celebrating at {eventName} in {location}. '
          'Setting: stunning panoramic view of historic colonial Quito, Ecuador, surrounded by the majestic green Andean mountains and the snow-capped Pichincha/Cotopaxi volcano under a crisp blue Andean sky, seamlessly blended with the high-tech main stage of DevFest Quito: giant LED screens displaying code, AI neural networks, Google Cloud infrastructure nodes, and celebratory Google Developer Groups banners with vibrant tech festival lighting. '
          'Celebratory elements: standing next to the attendee is an adorable tech mascot wearing a futuristic DevFest Quito VIP badge. '
          'Style: polished conference badge illustration, sharp focus, rich colors, joyful and inspiring global tech event atmosphere. '
          'CRITICAL REQUIREMENT FOR THE TEXT VIBE: You MUST provide a short, punchy 3 to 5 word conference vibe or title in Spanish celebrating multi-technology innovation and Ecuadorian tech culture, incorporating authentic expressions from Quito and the Andes (such as "¡De Ley!", "Chulla Quiteño", "Innovando Juntos", "Mitad del Mundo", "Pichincha Tech", "Vibra DevFest", "Cotopaxi AI", "Canelazo & Code", "Qué Chévere", etc.). '
          'Examples of expected output: "¡De Ley en DevFest! 100%", "Chulla Quiteño Innovador", "Vibra DevFest 100% Chévere", "Mitad del Mundo & Cloud Tech", "Pichincha de la Inteligencia Artificial", "Cotopaxi Tech Pioneer 99%". Do not include quotes, markdown, or conversational filler.',
      fallbackTitles: [
        '¡De Ley en DevFest! 100%',
        'Chulla Quiteño Innovador',
        'Vibra DevFest 100% Chévere',
        'Mitad del Mundo & Cloud Tech',
        'Pichincha de la Inteligencia Artificial',
        'Cotopaxi Tech Pioneer 99%',
        'Fullstack Dev en las Alturas',
        'Innovando Juntos en Quito 100%',
        'Líder Tech Ecuador 2026',
        'Pura Buena Vibra Quiteña',
        'Arquitecto Cloud & AI 100%',
        'DevFest Pioneer Mitad del Mundo',
      ],
      socialShareCaptionTemplate:
          '¡Mi credencial oficial de {eventName} en {location}! 🚀✨🏔️ {hashtag}',
      loadingMessages: [
        'Sintonizando la energía tech de DevFest Quito 2026...',
        'Conectando con la innovación de la Mitad del Mundo...',
        'Generando tu credencial oficial multitecnológica con IA...',
        'Afinando los colores de los Andes ecuatorianos y DevFest...',
      ],
      badgeRoleTitle: 'DEVFEST PIONEER',
      communityTagline: 'Quito • DevFest',
      adminPin: '2026',
    );
  }

  /// Preset configured for Cancun, Mexico (FlutterConf LATAM).
  factory EventConfig.cancun() {
    return const EventConfig(
      id: 'event_current',
      eventName: 'FlutterConf LATAM 2026',
      eventTagline: 'Cancún, México • All-Access Pass',
      eventLocation: 'Cancún, México',
      eventBadgeLabel: '🌴 Cancún 2026',
      hashtag: '#flutterconflatam26',
      badgeRoleTitle: 'FLUTTER PIONEER',
      communityTagline: 'Cancún • FlutterConf',
      logoUrl: 'images/logo.png',
      heroImageUrl: 'images/dash_playa.png',
      heroTitle: '¡Crea tu Credencial Interactiva Oficial!',
      heroSubtitle:
          'Sube o tómate una foto y personalízala con inteligencia artificial multimodal.',
      promptTemplate:
          'A vibrant, high-quality digital art portrait of the conference attendee ({name}) '
          'from the reference photo celebrating at FlutterConf LATAM Cancún 2026. '
          'Standing happily right next to the attendee is Dash, the official Flutter mascot. '
          'CRITICAL MASCOT DETAILS: Dash is a cute, round, chubby, fluffy blue plush bird toy (NOT a dolphin, NOT a fish, NOT an aquatic animal). '
          'Dash has a plump round body covered in soft cyan and royal-blue felt feathers with a cream-white belly patch, '
          'large friendly round cartoon eyes, a tiny short triangular orange beak, two small rounded blue bird wings, and two tiny orange bird feet standing on the sand. '
          'Setting: picturesque tropical Cancun beach in Quintana Roo, Mexico, with turquoise Caribbean ocean in the background, fine white sand of the Riviera Maya, swaying green palm trees under bright warm sunlight, with subtle colorful Mexican festival touches. '
          'Style: polished conference badge illustration, sharp focus, rich colors, joyful and festive atmosphere. '
          'CRITICAL REQUIREMENT FOR THE TEXT VIBE: You MUST provide a short, punchy 3 to 5 word conference vibe or title in Spanish that ALWAYS includes authentic Mexican phrases and regional expressions from Cancún, Quintana Roo, and Yucatán (such as "¡Qué Chido!", "Bomba Yucateca", "Vibra Maya", "¡Qué Padre!", "A Toda Madre", "Cenote", "Kukulcán", "Mayab", "Marquesita", etc.). '
          'Examples of expected output: "¡Qué Chido Cancún! 100%", "Bomba Yucateca de Código", "Vibra Maya 100% Chida", "¡Qué Padre la Riviera!", "Kukulcán del Hot Reload", "Cenote Sagrado 99%". Do not include quotes, markdown, or conversational filler.',
      fallbackTitles: [
        '¡Qué Chido Cancún! 100%',
        'Bomba Yucateca de Código',
        'Vibra Maya Sagrada 99%',
        '¡A Toda Madre en el Caribe!',
        'Kukulcán del Hot Reload',
        'Cenote Sagrado & Flutter 99%',
        '¡Qué Padre la Riviera Maya!',
        'Marquesita & Widgets 100%',
        'Dash en Chichén Itzá 98%',
        'Rey del Caribe Mexicano',
        '¡Chulada de Widget en Cancún!',
        'Pura Buena Vibra Yucateca',
      ],
      socialShareCaptionTemplate:
          '¡Mi credencial oficial de FlutterConf LATAM Cancún 2026 con Dash! 🦜✨🌴 #flutterconflatam26',
      loadingMessages: [
        'Dash está buscando la mejor palmera bajo el sol de Cancún...',
        'Agregando vibras tropicales y gafas de sol a tu retrato...',
        'Componiendo tu credencial oficial de FlutterConf LATAM...',
        'Casi listo, afinando los colores del Caribe...',
      ],
      adminPin: '2026',
    );
  }

  /// Preset configured for a generic conference or meetup.
  factory EventConfig.generic() {
    return const EventConfig(
      id: 'event_current',
      eventName: 'Tech Event 2026',
      eventTagline: 'Global Edition • All-Access Pass',
      eventLocation: 'Worldwide',
      eventBadgeLabel: '🚀 Tech 2026',
      hashtag: '#TechEvent2026',
      badgeRoleTitle: 'TECH PIONEER',
      communityTagline: 'Global • TechConf',
      logoUrl: null,
      heroImageUrl: null,
      heroTitle: '¡Crea tu Credencial Oficial!',
      heroSubtitle:
          'Captura o sube tu foto para transformarla con inteligencia artificial.',
      promptTemplate:
          'A vibrant, polished digital art portrait of the conference attendee ({name}) '
          'from the reference photo celebrating at {eventName} in {location}. '
          'Standing happily right next to the attendee is Dash, the official Flutter mascot. '
          'CRITICAL MASCOT DETAILS: Dash is a cute, round, chubby, fluffy blue plush bird toy. '
          'Setting: futuristic and sleek modern tech conference stage with neon accent lights and celebratory banners. '
          'Style: polished high-definition badge portrait, vibrant lighting, joyful atmosphere. '
          'CRITICAL REQUIREMENT FOR THE TEXT VIBE: You MUST provide a short, punchy 3 to 5 word conference vibe or title in Spanish or English celebrating coding and community.',
      fallbackTitles: [
        '¡Pura Buena Vibra Dev! 100%',
        'Pioneer de Código 100%',
        'Maestro del Hot Reload',
        'Innovador Global 99%',
        'Vibra de Conferencia 100%',
      ],
      socialShareCaptionTemplate:
          '¡Mi credencial oficial de {eventName} con Dash! 🚀✨ {hashtag}',
      loadingMessages: [
        'Dash está preparando tu credencial para el evento...',
        'Generando tu retrato con inteligencia artificial...',
        'Afinando los últimos detalles de tu credencial...',
      ],
      adminPin: '2026',
    );
  }

  /// Interpolates {name}, {eventName}, {location}, {hashtag} into the prompt template.
  String interpolatePrompt(String attendeeName) {
    final cleanName =
        attendeeName.trim().isEmpty ? 'Pioneer' : attendeeName.trim();
    return promptTemplate
        .replaceAll('{name}', cleanName)
        .replaceAll('{attendeeName}', cleanName)
        .replaceAll('{eventName}', eventName)
        .replaceAll('{location}', eventLocation)
        .replaceAll('{hashtag}', hashtag);
  }

  /// Interpolates {name}, {eventName}, {location}, {hashtag} into the social share caption.
  String interpolateShareCaption(String attendeeName) {
    final cleanName =
        attendeeName.trim().isEmpty ? 'Pioneer' : attendeeName.trim();
    return socialShareCaptionTemplate
        .replaceAll('{name}', cleanName)
        .replaceAll('{attendeeName}', cleanName)
        .replaceAll('{eventName}', eventName)
        .replaceAll('{location}', eventLocation)
        .replaceAll('{hashtag}', hashtag);
  }

  /// Resolves a deterministic fallback title based on [attendeeName].
  String getFallbackTitle(String attendeeName) {
    if (fallbackTitles.isEmpty) return 'Pioneer 100%';
    final cleanName = attendeeName.trim();
    if (cleanName.isEmpty) return fallbackTitles.first;
    final index = cleanName.hashCode.abs() % fallbackTitles.length;
    return fallbackTitles[index];
  }

  EventConfig copyWith({
    String? id,
    String? eventName,
    String? eventTagline,
    String? eventLocation,
    String? eventBadgeLabel,
    String? hashtag,
    String? badgeRoleTitle,
    String? communityTagline,
    String? logoUrl,
    bool clearLogoUrl = false,
    String? heroImageUrl,
    bool clearHeroImageUrl = false,
    String? customApiKey,
    bool clearCustomApiKey = false,
    String? heroTitle,
    String? heroSubtitle,
    String? promptTemplate,
    List<String>? fallbackTitles,
    String? socialShareCaptionTemplate,
    List<String>? loadingMessages,
    String? adminPin,
    DateTime? updatedAt,
  }) {
    return EventConfig(
      id: id ?? this.id,
      eventName: eventName ?? this.eventName,
      eventTagline: eventTagline ?? this.eventTagline,
      eventLocation: eventLocation ?? this.eventLocation,
      eventBadgeLabel: eventBadgeLabel ?? this.eventBadgeLabel,
      hashtag: hashtag ?? this.hashtag,
      badgeRoleTitle: badgeRoleTitle ?? this.badgeRoleTitle,
      communityTagline: communityTagline ?? this.communityTagline,
      logoUrl: clearLogoUrl ? null : (logoUrl ?? this.logoUrl),
      heroImageUrl:
          clearHeroImageUrl ? null : (heroImageUrl ?? this.heroImageUrl),
      customApiKey:
          clearCustomApiKey ? null : (customApiKey ?? this.customApiKey),
      heroTitle: heroTitle ?? this.heroTitle,
      heroSubtitle: heroSubtitle ?? this.heroSubtitle,
      promptTemplate: promptTemplate ?? this.promptTemplate,
      fallbackTitles: fallbackTitles ?? this.fallbackTitles,
      socialShareCaptionTemplate:
          socialShareCaptionTemplate ?? this.socialShareCaptionTemplate,
      loadingMessages: loadingMessages ?? this.loadingMessages,
      adminPin: adminPin ?? this.adminPin,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventConfig &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          eventName == other.eventName &&
          eventTagline == other.eventTagline &&
          eventLocation == other.eventLocation &&
          eventBadgeLabel == other.eventBadgeLabel &&
          hashtag == other.hashtag &&
          badgeRoleTitle == other.badgeRoleTitle &&
          communityTagline == other.communityTagline &&
          logoUrl == other.logoUrl &&
          heroImageUrl == other.heroImageUrl &&
          customApiKey == other.customApiKey &&
          heroTitle == other.heroTitle &&
          heroSubtitle == other.heroSubtitle &&
          promptTemplate == other.promptTemplate &&
          listEquals(fallbackTitles, other.fallbackTitles) &&
          socialShareCaptionTemplate == other.socialShareCaptionTemplate &&
          listEquals(loadingMessages, other.loadingMessages) &&
          adminPin == other.adminPin;

  @override
  int get hashCode => Object.hash(
        id,
        eventName,
        eventTagline,
        eventLocation,
        eventBadgeLabel,
        hashtag,
        badgeRoleTitle,
        communityTagline,
        logoUrl,
        heroImageUrl,
        customApiKey,
        heroTitle,
        heroSubtitle,
        promptTemplate,
        Object.hashAll(fallbackTitles),
        socialShareCaptionTemplate,
        Object.hashAll(loadingMessages),
        adminPin,
      );
}
