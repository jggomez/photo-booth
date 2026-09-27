import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Supported application languages.
enum AppLanguage { es, en }

/// Notifier/StateProvider tracking the currently selected UI language.
final appLanguageProvider = StateProvider<AppLanguage>((ref) => AppLanguage.es);
