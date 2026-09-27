import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cancun_dashbooth/presentation/providers/app_language_provider.dart';
import 'package:cancun_dashbooth/presentation/widgets/language_flag_toggle.dart';

void main() {
  group('LanguageFlagToggle Widget Tests', () {
    testWidgets('renders flag buttons and toggles between ES and EN',
        (tester) async {
      late AppLanguage currentLanguage;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Consumer(
                builder: (context, ref, child) {
                  currentLanguage = ref.watch(appLanguageProvider);
                  return const LanguageFlagToggle();
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('🇨🇴 ES'), findsOneWidget);
      expect(find.text('🇺🇸 EN'), findsOneWidget);
      expect(currentLanguage, equals(AppLanguage.es));

      // Tap EN
      await tester.tap(find.text('🇺🇸 EN'));
      await tester.pumpAndSettle();

      expect(currentLanguage, equals(AppLanguage.en));

      // Tap ES
      await tester.tap(find.text('🇨🇴 ES'));
      await tester.pumpAndSettle();

      expect(currentLanguage, equals(AppLanguage.es));
    });
  });
}
