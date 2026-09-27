import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'presentation/providers/event_config_provider.dart';
import 'presentation/screens/admin_config_screen.dart';
import 'presentation/screens/main_home_screen.dart';
import 'presentation/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: EventBoothApp(),
    ),
  );
}

/// Root application widget for the Event Photobooth.
class EventBoothApp extends ConsumerWidget {
  const EventBoothApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(currentEventConfigProvider);

    return MaterialApp(
      title: '${config.eventName} — EventBooth',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      onGenerateRoute: (settings) {
        final name = (settings.name ?? '').toLowerCase();

        bool isAdmin = name == '/admin' ||
            name == 'admin' ||
            name == '/secret-admin' ||
            name == 'secret-admin' ||
            name == '/config' ||
            name == 'config' ||
            name.contains('admin');

        if (kIsWeb) {
          final uri = Uri.base;
          final fragment = uri.fragment.toLowerCase();
          final path = uri.path.toLowerCase();
          if (fragment.contains('admin') ||
              fragment.contains('config') ||
              path.contains('/admin') ||
              uri.queryParameters.containsKey('admin') ||
              uri.queryParameters.containsKey('config')) {
            isAdmin = true;
          }
        }

        if (isAdmin) {
          return MaterialPageRoute(
            settings: settings,
            builder: (context) => const AdminConfigScreen(),
          );
        }

        return MaterialPageRoute(
          settings: settings,
          builder: (context) => const MainHomeScreen(),
        );
      },
    );
  }
}

/// Backwards compatibility alias.
typedef CancunDashBoothApp = EventBoothApp;
