import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cancun_dashbooth/domain/entities/event_config.dart';
import 'package:cancun_dashbooth/domain/entities/user_card.dart';
import 'package:cancun_dashbooth/domain/usecases/clear_community_wall_usecase.dart';
import 'package:cancun_dashbooth/domain/usecases/save_event_config_usecase.dart';
import 'package:cancun_dashbooth/domain/usecases/upload_event_asset_usecase.dart';
import 'package:cancun_dashbooth/presentation/providers/community_wall_provider.dart';
import 'package:cancun_dashbooth/presentation/providers/di_providers.dart';
import 'package:cancun_dashbooth/presentation/providers/event_config_provider.dart';
import 'package:cancun_dashbooth/presentation/screens/admin_config_screen.dart';
import 'package:cancun_dashbooth/presentation/widgets/official_badge_card.dart';

class MockSaveEventConfigUseCase extends Mock
    implements SaveEventConfigUseCase {}

class MockUploadEventAssetUseCase extends Mock
    implements UploadEventAssetUseCase {}

class MockClearCommunityWallUseCase extends Mock
    implements ClearCommunityWallUseCase {}

void main() {
  late MockSaveEventConfigUseCase mockSaveUseCase;
  late MockUploadEventAssetUseCase mockUploadUseCase;
  late MockClearCommunityWallUseCase mockClearUseCase;

  setUpAll(() {
    registerFallbackValue(EventConfig.defaultQuito());
  });

  setUp(() {
    mockSaveUseCase = MockSaveEventConfigUseCase();
    mockUploadUseCase = MockUploadEventAssetUseCase();
    mockClearUseCase = MockClearCommunityWallUseCase();
  });

  Widget createTestWidget({
    EventConfig? initialConfig,
    List<UserCard>? initialCards,
  }) {
    final cfg = initialConfig ?? EventConfig.defaultQuito();
    final cards = initialCards ?? [];
    return ProviderScope(
      overrides: [
        currentEventConfigProvider.overrideWithValue(cfg),
        eventConfigStreamProvider.overrideWith((ref) => Stream.value(cfg)),
        eventConfigNotifierProvider.overrideWith((ref) {
          return EventConfigNotifier(
            saveUseCase: mockSaveUseCase,
            uploadUseCase: mockUploadUseCase,
            initialConfig: cfg,
          );
        }),
        communityWallProvider.overrideWith((ref) => Stream.value(cards)),
        clearCommunityWallUseCaseProvider.overrideWithValue(mockClearUseCase),
      ],
      child: const MaterialApp(
        home: AdminConfigScreen(),
      ),
    );
  }

  Future<void> unlockScreen(WidgetTester tester) async {
    await tester.enterText(find.byType(TextField).first, '2026');
    await tester.tap(find.text('Desbloquear'));
    await tester.pumpAndSettle();
  }

  group('AdminConfigScreen Widget Tests', () {
    testWidgets('displays PIN lock screen initially', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('EventBooth Admin'), findsOneWidget);
      expect(find.text('Ingresa el PIN de Administrador'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Desbloquear'), findsOneWidget);
    });

    testWidgets('shows error on incorrect PIN', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextField), '0000');
      await tester.tap(find.text('Desbloquear'));
      await tester.pumpAndSettle();

      expect(find.text('PIN incorrecto. Inténtalo de nuevo.'), findsOneWidget);
      expect(find.byType(OfficialBadgeCard), findsNothing);
    });

    testWidgets('unlocks dashboard when entering correct PIN 2026',
        (tester) async {
      tester.view.physicalSize = const Size(1280, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createTestWidget());
      await unlockScreen(tester);

      expect(find.text('Configuración de EventBooth'), findsOneWidget);
      expect(find.text('Presets Rápidos'), findsOneWidget);
      expect(find.text('DevFest Quito 2026'), findsWidgets);
      expect(find.text('Cancún 2026'), findsOneWidget);
      expect(find.text('Genérico'), findsOneWidget);
      expect(find.text('Guardar Configuración en Vivo'), findsOneWidget);
      expect(find.byType(OfficialBadgeCard), findsOneWidget);
    });

    testWidgets('preset buttons update form values and badge preview',
        (tester) async {
      tester.view.physicalSize = const Size(1280, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createTestWidget());
      await unlockScreen(tester);

      // Click Cancún 2026 preset
      await tester.tap(find.text('Cancún 2026'));
      await tester.pumpAndSettle();

      expect(find.text('FlutterConf LATAM 2026'), findsWidgets);

      // Click Genérico preset
      await tester.tap(find.text('Genérico'));
      await tester.pumpAndSettle();

      expect(find.text('Tech Event 2026'), findsWidgets);
    });

    testWidgets('tapping save calls SaveEventConfigUseCase and shows snackbar',
        (tester) async {
      tester.view.physicalSize = const Size(1280, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      when(() => mockSaveUseCase.execute(any())).thenAnswer((_) async {});

      await tester.pumpWidget(createTestWidget());
      await unlockScreen(tester);

      // Tap Save
      await tester.scrollUntilVisible(
        find.text('Guardar Configuración en Vivo'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Guardar Configuración en Vivo'));
      await tester.pumpAndSettle();

      verify(() => mockSaveUseCase.execute(any())).called(1);
      expect(find.text('Configuración guardada en vivo exitosamente'),
          findsOneWidget);
    });

    testWidgets('adds a new fallback title phrase', (tester) async {
      tester.view.physicalSize = const Size(1280, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createTestWidget());
      await unlockScreen(tester);

      // Find phrase input field
      final phraseField = find.widgetWithText(TextField, 'Nueva frase vibe...');
      await tester.scrollUntilVisible(
        phraseField,
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.enterText(phraseField, '¡Chévere Total 100%!');
      await tester.tap(find.text('Agregar'));
      await tester.pumpAndSettle();

      expect(find.text('¡Chévere Total 100%!'), findsOneWidget);
    });

    testWidgets('lock icon button locks the dashboard back to PIN screen',
        (tester) async {
      tester.view.physicalSize = const Size(1280, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createTestWidget());
      await unlockScreen(tester);

      expect(find.text('Configuración de EventBooth'), findsOneWidget);

      // Lock
      await tester.tap(find.byIcon(Icons.lock_outline));
      await tester.pumpAndSettle();

      expect(find.text('EventBooth Admin'), findsOneWidget);
      expect(find.text('Configuración de EventBooth'), findsNothing);
    });

    testWidgets('displays redesigned assets section with status pills',
        (tester) async {
      tester.view.physicalSize = const Size(1280, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createTestWidget());
      await unlockScreen(tester);

      expect(find.text('Logotipo y Mascota del Evento'), findsOneWidget);
      expect(find.text('Logotipo Oficial'), findsOneWidget);
      expect(find.text('Mascota Hero Photobooth'), findsOneWidget);
      expect(find.text('Subir Archivo'), findsNWidgets(2));
      // In defaultQuito, both logoUrl and heroImageUrl are null by default -> "Predeterminado"
      expect(find.text('Predeterminado'), findsNWidgets(2));

      // Enter custom URL in the first asset field (Logotipo Oficial)
      final urlFields =
          find.widgetWithText(TextField, 'URL o ruta del archivo');
      await tester.enterText(
          urlFields.first, 'https://example.com/custom_logo.png');
      await tester.pumpAndSettle();

      expect(find.text('Personalizado'), findsOneWidget);
      expect(find.text('Predeterminado'), findsOneWidget);

      // Tap Restablecer
      await tester.scrollUntilVisible(
        find.text('Restablecer'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Restablecer'));
      await tester.pumpAndSettle();

      expect(find.text('Predeterminado'), findsNWidgets(2));
    });

    testWidgets('displays album management section and exports CSV',
        (tester) async {
      tester.view.physicalSize = const Size(1280, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final dummyCards = [
        UserCard(
          id: 'card-1',
          name: 'Ana Gomez',
          email: 'ana@flutter.dev',
          imageUri: 'https://example.com/ana.png',
          createdAt: DateTime(2026, 9, 26, 12, 0),
        ),
        UserCard(
          id: 'card-2',
          name: 'Carlos Ruiz',
          email: 'carlos@flutter.dev',
          imageUri: 'https://example.com/carlos.png',
          createdAt: DateTime(2026, 9, 26, 13, 0),
        ),
      ];

      await tester.pumpWidget(createTestWidget(initialCards: dummyCards));
      await unlockScreen(tester);

      expect(find.text('Gestión del Álbum Comunitario'), findsOneWidget);
      expect(find.text('Total de credenciales en el álbum: 2'), findsOneWidget);

      final exportBtn = find.text('Exportar Asistentes a CSV');
      expect(exportBtn, findsOneWidget);
      await tester.scrollUntilVisible(
        exportBtn,
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(exportBtn);
      await tester.pumpAndSettle();

      expect(find.text('Exportación completada exitosamente'), findsOneWidget);
    });

    testWidgets('warns when exporting CSV with 0 attendees', (tester) async {
      tester.view.physicalSize = const Size(1280, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createTestWidget(initialCards: []));
      await unlockScreen(tester);

      final exportBtn = find.text('Exportar Asistentes a CSV');
      await tester.scrollUntilVisible(
        exportBtn,
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(exportBtn);
      await tester.pumpAndSettle();

      expect(find.text('No hay credenciales registradas para exportar'),
          findsOneWidget);
    });

    testWidgets('confirms and deletes all album cards when accepted',
        (tester) async {
      tester.view.physicalSize = const Size(1280, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      when(() => mockClearUseCase.call()).thenAnswer((_) async {});

      final dummyCards = [
        UserCard(
          id: 'card-1',
          name: 'Ana Gomez',
          email: 'ana@flutter.dev',
          imageUri: 'https://example.com/ana.png',
          createdAt: DateTime(2026, 9, 26, 12, 0),
        ),
      ];

      await tester.pumpWidget(createTestWidget(initialCards: dummyCards));
      await unlockScreen(tester);

      final deleteBtn = find.text('Borrar Todo el Álbum');
      await tester.scrollUntilVisible(
        deleteBtn,
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(deleteBtn);
      await tester.pumpAndSettle();

      // Dialog should be visible
      expect(find.text('¿Eliminar todas las credenciales?'), findsOneWidget);
      expect(
          find.textContaining(
              'Se eliminarán permanentemente las 1 credenciales'),
          findsOneWidget);

      await tester.tap(find.text('Eliminar Todo'));
      await tester.pumpAndSettle();

      verify(() => mockClearUseCase.call()).called(1);
      expect(find.text('Se han eliminado todas las credenciales del álbum'),
          findsOneWidget);
    });

    testWidgets('cancels album deletion when cancellation is tapped in dialog',
        (tester) async {
      tester.view.physicalSize = const Size(1280, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final dummyCards = [
        UserCard(
          id: 'card-1',
          name: 'Ana Gomez',
          email: 'ana@flutter.dev',
          imageUri: 'https://example.com/ana.png',
          createdAt: DateTime(2026, 9, 26, 12, 0),
        ),
      ];

      await tester.pumpWidget(createTestWidget(initialCards: dummyCards));
      await unlockScreen(tester);

      final deleteBtn = find.text('Borrar Todo el Álbum');
      await tester.scrollUntilVisible(
        deleteBtn,
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(deleteBtn);
      await tester.pumpAndSettle();

      expect(find.text('¿Eliminar todas las credenciales?'), findsOneWidget);

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      verifyNever(() => mockClearUseCase.call());
      expect(find.text('¿Eliminar todas las credenciales?'), findsNothing);
    });

    testWidgets('displays Gemini API key card and saves customApiKey',
        (tester) async {
      tester.view.physicalSize = const Size(1280, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      when(() => mockSaveUseCase.execute(any())).thenAnswer((_) async {});

      final configWithKey = EventConfig.defaultQuito().copyWith(
        customApiKey: 'AIzaSyInitialKey123',
      );

      await tester.pumpWidget(createTestWidget(initialConfig: configWithKey));
      await unlockScreen(tester);

      expect(find.text('Configuración de Gemini AI API Key'), findsOneWidget);
      expect(find.textContaining('aistudio.google.com'), findsOneWidget);

      final keyField = find.widgetWithText(TextField, 'AIzaSyInitialKey123');
      expect(keyField, findsOneWidget);

      // Verify toggle obscure
      final visibilityBtn = find.byIcon(Icons.visibility_outlined);
      expect(visibilityBtn, findsOneWidget);
      await tester.tap(visibilityBtn);
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);

      // Enter a new key
      await tester.enterText(keyField, 'AIzaSyNewCustomKey999');
      await tester.pumpAndSettle();

      // Tap Save
      await tester.scrollUntilVisible(
        find.text('Guardar Configuración en Vivo'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Guardar Configuración en Vivo'));
      await tester.pumpAndSettle();

      final captured =
          verify(() => mockSaveUseCase.execute(captureAny())).captured;
      final savedConfig = captured.first as EventConfig;
      expect(savedConfig.customApiKey, equals('AIzaSyNewCustomKey999'));
    });

    testWidgets(
        'admin app bar contains LanguageFlagToggle and reacts to toggle',
        (tester) async {
      tester.view.physicalSize = const Size(1280, 1000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createTestWidget());
      await unlockScreen(tester);

      expect(find.text('🇨🇴 ES'), findsOneWidget);
      expect(find.text('🇺🇸 EN'), findsOneWidget);

      // Switch to EN
      await tester.tap(find.text('🇺🇸 EN'));
      await tester.pumpAndSettle();

      expect(find.text('EventBooth Configuration'), findsOneWidget);
      expect(find.text('Quick Presets'), findsOneWidget);
    });

    testWidgets(
        'renders narrow responsive layout without overflow on small screens',
        (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createTestWidget());
      await unlockScreen(tester);

      expect(find.byType(OfficialBadgeCard), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
