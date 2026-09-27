import '../providers/app_language_provider.dart';

/// Type-safe contract and dictionary for internationalized strings (ES & EN).
class AppStrings {
  // --- Navbar & Header ---
  final String createBadge;
  final String liveWall;
  final String adminPanel;

  // --- Photobooth ---
  final String heroTitle;
  final String heroSubtitle;
  final String formTitle;
  final String nameLabel;
  final String nameHint;
  final String emailLabel;
  final String emailHint;
  final String selfieLabel;
  final String takePhoto;
  final String uploadPhoto;
  final String retakePhoto;
  final String generateBadge;
  final String generatingBadge;
  final String shareInstagram;
  final String downloadBadge;
  final String publishToWall;
  final String createAnotherBadge;
  final String badgePublishedSuccess;
  final String formValidationWarning;

  // --- Community Wall ---
  final String liveAlbumTitle;
  final String liveAlbumSubtitle;
  final String photosCount;
  final String f1Roulette;
  final String emptyAlbumTitle;
  final String emptyAlbumSubtitle;
  final String createFirstBadge;

  // --- F1 Roulette ---
  final String grandPrix;
  final String officialPrizeRoulette;
  final String podiumHeader;
  final String firstPlace;
  final String secondPlace;
  final String thirdPlace;
  final String spinButton;
  final String spinning;

  // --- Admin Panel ---
  final String adminTitle;
  final String pinPrompt;
  final String pinLabel;
  final String pinIncorrect;
  final String login;
  final String presets;
  final String generalInfo;
  final String eventName;
  final String tagline;
  final String location;
  final String hashtag;
  final String badgeRoleTitle;
  final String communityTagline;
  final String apiKeyTitle;
  final String apiKeyHint;
  final String apiKeyHelp;
  final String assetsTitle;
  final String logoLabel;
  final String mascotLabel;
  final String uploadFile;
  final String resetDefault;
  final String pasteUrlHint;
  final String promptTitle;
  final String fallbackPhrasesTitle;
  final String albumManagement;
  final String exportCsv;
  final String deleteAlbum;
  final String deleteConfirmTitle;
  final String deleteConfirmMessage;
  final String cancel;
  final String confirmDelete;
  final String livePreview;
  final String saveLiveConfig;
  final String savedSuccess;
  final String testApiKeyButton;
  final String testingApiKey;
  final String apiKeySuccess;
  final String apiKeyInvalid;
  final String aiGeneratedSuccess;
  final String aiFallbackTip;

  const AppStrings({
    required this.createBadge,
    required this.liveWall,
    required this.adminPanel,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.formTitle,
    required this.nameLabel,
    required this.nameHint,
    required this.emailLabel,
    required this.emailHint,
    required this.selfieLabel,
    required this.takePhoto,
    required this.uploadPhoto,
    required this.retakePhoto,
    required this.generateBadge,
    required this.generatingBadge,
    required this.shareInstagram,
    required this.downloadBadge,
    required this.publishToWall,
    required this.createAnotherBadge,
    required this.badgePublishedSuccess,
    required this.formValidationWarning,
    required this.liveAlbumTitle,
    required this.liveAlbumSubtitle,
    required this.photosCount,
    required this.f1Roulette,
    required this.emptyAlbumTitle,
    required this.emptyAlbumSubtitle,
    required this.createFirstBadge,
    required this.grandPrix,
    required this.officialPrizeRoulette,
    required this.podiumHeader,
    required this.firstPlace,
    required this.secondPlace,
    required this.thirdPlace,
    required this.spinButton,
    required this.spinning,
    required this.adminTitle,
    required this.pinPrompt,
    required this.pinLabel,
    required this.pinIncorrect,
    required this.login,
    required this.presets,
    required this.generalInfo,
    required this.eventName,
    required this.tagline,
    required this.location,
    required this.hashtag,
    required this.badgeRoleTitle,
    required this.communityTagline,
    required this.apiKeyTitle,
    required this.apiKeyHint,
    required this.apiKeyHelp,
    required this.assetsTitle,
    required this.logoLabel,
    required this.mascotLabel,
    required this.uploadFile,
    required this.resetDefault,
    required this.pasteUrlHint,
    required this.promptTitle,
    required this.fallbackPhrasesTitle,
    required this.albumManagement,
    required this.exportCsv,
    required this.deleteAlbum,
    required this.deleteConfirmTitle,
    required this.deleteConfirmMessage,
    required this.cancel,
    required this.confirmDelete,
    required this.livePreview,
    required this.saveLiveConfig,
    required this.savedSuccess,
    required this.testApiKeyButton,
    required this.testingApiKey,
    required this.apiKeySuccess,
    required this.apiKeyInvalid,
    required this.aiGeneratedSuccess,
    required this.aiFallbackTip,
  });

  /// Factory resolving the active dictionary for the specified [AppLanguage].
  static AppStrings get(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.en:
        return _enStrings;
      case AppLanguage.es:
        return _esStrings;
    }
  }

  static const _esStrings = AppStrings(
    // Navbar
    createBadge: 'Crear mi Badge',
    liveWall: 'Mural en Vivo',
    adminPanel: 'Admin',

    // Photobooth
    heroTitle: '¡Crea tu Credencial Oficial!',
    heroSubtitle:
        'Sube o tómate una foto y personalízala con inteligencia artificial.',
    formTitle: 'Tus Datos para la Credencial',
    nameLabel: 'Nombre completo',
    nameHint: 'Ej. Sofia Rodriguez',
    emailLabel: 'Correo del asistente',
    emailHint: 'Ej. valeria@gmail.com',
    selfieLabel: 'Tu Fotografía Oficial',
    takePhoto: 'Tomar Foto',
    uploadPhoto: 'Subir Foto',
    retakePhoto: 'Tomar otra foto',
    generateBadge: 'Personalizar con IA',
    generatingBadge: 'Generando tu credencial con IA...',
    shareInstagram: 'Compartir en Instagram',
    downloadBadge: 'Descargar Credencial HD',
    publishToWall: 'Publicar en el Álbum',
    createAnotherBadge: 'Crear Otra Credencial',
    badgePublishedSuccess: '¡Credencial publicada en el álbum comunitario! 🎉',
    formValidationWarning:
        'Completa tu nombre, correo y fotografía para continuar.',

    // Community Wall
    liveAlbumTitle: 'Álbum Comunitario en Vivo',
    liveAlbumSubtitle:
        'Credenciales oficiales generadas en tiempo real por los asistentes.',
    photosCount: 'Fotos en vivo',
    f1Roulette: 'Ruleta F1 de Premios',
    emptyAlbumTitle:
        '¡El álbum comunitario está esperando la primera credencial!',
    emptyAlbumSubtitle: 'Sé el primero en crear tu credencial oficial con IA.',
    createFirstBadge: 'Crear mi Credencial',

    // F1 Roulette
    grandPrix: 'GRAN PREMIO',
    officialPrizeRoulette: 'Ruleta Oficial de Premios',
    podiumHeader: '¡PODIO DEL GRAN PREMIO! 🏆',
    firstPlace: '¡CAMPEÓN!',
    secondPlace: '2º LUGAR',
    thirdPlace: '3ER LUGAR',
    spinButton: 'Girar Ruleta 🏁',
    spinning: 'GIRANDO EN PISTA...',

    // Admin Panel
    adminTitle: 'Configuración de EventBooth',
    pinPrompt: 'Ingresa el PIN de Administrador',
    pinLabel: 'PIN Admin',
    pinIncorrect: 'PIN incorrecto. Inténtalo de nuevo.',
    login: 'Desbloquear',
    presets: 'Presets Rápidos',
    generalInfo: 'Información General del Evento',
    eventName: 'Nombre del Evento',
    tagline: 'Tagline / Lema',
    location: 'Ubicación',
    hashtag: 'Hashtag Oficial',
    badgeRoleTitle: 'Título de Rol en Credencial',
    communityTagline: 'Tagline Álbum Comunitario',
    apiKeyTitle: 'Configuración de Gemini AI API Key',
    apiKeyHint: 'Pega tu Gemini API Key (AIzaSy...)',
    apiKeyHelp:
        'Opcional. Obtén una API Key gratuita en Google AI Studio (aistudio.google.com) para tu cuota de generación.',
    assetsTitle: 'Logotipo y Mascota del Evento',
    logoLabel: 'Logotipo Oficial',
    mascotLabel: 'Mascota Hero Photobooth',
    uploadFile: 'Subir Archivo',
    resetDefault: 'Restablecer',
    pasteUrlHint: 'URL o ruta del archivo',
    promptTitle: 'Plantilla del Prompt Multimodal (IA)',
    fallbackPhrasesTitle: 'Frases Vibe (Títulos de Respaldo)',
    albumManagement: 'Gestión del Álbum Comunitario',
    exportCsv: 'Exportar Asistentes a CSV',
    deleteAlbum: 'Borrar Todo el Álbum',
    deleteConfirmTitle: '¿Eliminar todas las credenciales?',
    deleteConfirmMessage:
        'Esta acción no se puede deshacer. Se eliminarán permanentemente las credenciales del álbum comunitario.',
    cancel: 'Cancelar',
    confirmDelete: 'Eliminar Todo',
    livePreview: 'Vista Previa en Vivo',
    saveLiveConfig: 'Guardar Configuración en Vivo',
    savedSuccess: 'Configuración guardada en vivo exitosamente',
    testApiKeyButton: 'Probar Conexión',
    testingApiKey: 'Probando conexión con Gemini...',
    apiKeySuccess: '¡API Key conectada con éxito a Gemini AI!',
    apiKeyInvalid: 'Error al validar API Key: ',
    aiGeneratedSuccess: '✨ ¡Retrato y Vibe generados con Inteligencia Artificial!',
    aiFallbackTip: '📸 Credencial creada con tu foto. (Tip: Puedes configurar tu API Key de Gemini en /admin para habilitar retratos con IA generativa).',
  );

  static const _enStrings = AppStrings(
    // Navbar
    createBadge: 'Create Badge',
    liveWall: 'Live Wall',
    adminPanel: 'Admin',

    // Photobooth
    heroTitle: 'Create Your Official Badge!',
    heroSubtitle:
        'Take or upload a photo and personalize it with multimodal AI.',
    formTitle: 'Your Info for the Badge',
    nameLabel: 'Full Name',
    nameHint: 'e.g. Alex Johnson',
    emailLabel: 'Attendee Email',
    emailHint: 'e.g. alex@gmail.com',
    selfieLabel: 'Your Official Photo',
    takePhoto: 'Take Photo',
    uploadPhoto: 'Upload Photo',
    retakePhoto: 'Retake photo',
    generateBadge: 'Customize with AI',
    generatingBadge: 'Generating your AI badge...',
    shareInstagram: 'Share on Instagram',
    downloadBadge: 'Download HD Badge',
    publishToWall: 'Publish to Live Album',
    createAnotherBadge: 'Create Another Badge',
    badgePublishedSuccess: 'Badge published to the live community album! 🎉',
    formValidationWarning:
        'Please enter your name, email and photo to continue.',

    // Community Wall
    liveAlbumTitle: 'Live Community Album',
    liveAlbumSubtitle:
        'Official badges generated in real time by event attendees.',
    photosCount: 'Live photos',
    f1Roulette: 'F1 Prize Roulette',
    emptyAlbumTitle: 'The community album is waiting for its first badge!',
    emptyAlbumSubtitle:
        'Be the first to create your official AI conference badge.',
    createFirstBadge: 'Create My Badge',

    // F1 Roulette
    grandPrix: 'GRAND PRIX',
    officialPrizeRoulette: 'Official Prize Roulette',
    podiumHeader: 'GRAND PRIX PODIUM! 🏆',
    firstPlace: 'CHAMPION!',
    secondPlace: '2ND PLACE',
    thirdPlace: '3RD PLACE',
    spinButton: 'Spin Roulette 🏁',
    spinning: 'SPINNING ON TRACK...',

    // Admin Panel
    adminTitle: 'EventBooth Configuration',
    pinPrompt: 'Enter Administrator PIN',
    pinLabel: 'Admin PIN',
    pinIncorrect: 'Incorrect PIN. Try again.',
    login: 'Unlock',
    presets: 'Quick Presets',
    generalInfo: 'General Event Information',
    eventName: 'Event Name',
    tagline: 'Tagline / Slogan',
    location: 'Location',
    hashtag: 'Official Hashtag',
    badgeRoleTitle: 'Badge Role Title',
    communityTagline: 'Community Album Tagline',
    apiKeyTitle: 'Gemini AI API Key Configuration',
    apiKeyHint: 'Paste your Gemini API Key (AIzaSy...)',
    apiKeyHelp:
        'Optional. Obtain a free Gemini API Key from Google AI Studio (aistudio.google.com) to use your own generation quota.',
    assetsTitle: 'Event Logo and Mascot',
    logoLabel: 'Official Logo',
    mascotLabel: 'Hero Photobooth Mascot',
    uploadFile: 'Upload File',
    resetDefault: 'Reset to Default',
    pasteUrlHint: 'File URL or path',
    promptTitle: 'Multimodal AI Prompt Template',
    fallbackPhrasesTitle: 'Vibe Phrases (Fallback Titles)',
    albumManagement: 'Community Album Management',
    exportCsv: 'Export Attendees to CSV',
    deleteAlbum: 'Delete All Album Badges',
    deleteConfirmTitle: 'Delete all badges?',
    deleteConfirmMessage:
        'This action cannot be undone. All attendee badges in the community album will be permanently deleted.',
    cancel: 'Cancel',
    confirmDelete: 'Delete All',
    livePreview: 'Live Preview',
    saveLiveConfig: 'Save Configuration Live',
    savedSuccess: 'Configuration saved live successfully',
    testApiKeyButton: 'Test Connection',
    testingApiKey: 'Testing connection to Gemini...',
    apiKeySuccess: 'API Key successfully connected to Gemini AI!',
    apiKeyInvalid: 'API Key validation failed: ',
    aiGeneratedSuccess: '✨ Portrait and Vibe successfully generated with AI!',
    aiFallbackTip: '📸 Badge created with your photo. (Tip: You can set your Gemini API Key in /admin to enable generative AI portraits).',
  );
}
