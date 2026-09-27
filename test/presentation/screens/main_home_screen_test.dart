import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cancun_dashbooth/domain/entities/event_config.dart';
import 'package:cancun_dashbooth/domain/entities/user_card.dart';
import 'package:cancun_dashbooth/domain/repositories/i_camera_service.dart';
import 'package:cancun_dashbooth/domain/usecases/generate_ai_badge_usecase.dart';
import 'package:cancun_dashbooth/domain/usecases/get_community_stream_usecase.dart';
import 'package:cancun_dashbooth/domain/usecases/publish_user_card_usecase.dart';
import 'package:cancun_dashbooth/presentation/providers/di_providers.dart';
import 'package:cancun_dashbooth/presentation/providers/event_config_provider.dart';
import 'package:cancun_dashbooth/presentation/screens/main_home_screen.dart';
import 'package:cancun_dashbooth/presentation/widgets/language_flag_toggle.dart';

class MockCameraService extends Mock implements ICameraService {}

class MockGenerateAiBadgeUseCase extends Mock
    implements GenerateAiBadgeUseCase {}

class MockPublishUserCardUseCase extends Mock
    implements PublishUserCardUseCase {}

class MockGetCommunityStreamUseCase extends Mock
    implements GetCommunityStreamUseCase {}

void main() {
  late MockCameraService mockCamera;
  late MockGenerateAiBadgeUseCase mockAi;
  late MockPublishUserCardUseCase mockPublish;
  late MockGetCommunityStreamUseCase mockCommunity;

  setUp(() {
    mockCamera = MockCameraService();
    mockAi = MockGenerateAiBadgeUseCase();
    mockPublish = MockPublishUserCardUseCase();
    mockCommunity = MockGetCommunityStreamUseCase();

    when(() => mockCommunity.execute())
        .thenAnswer((_) => Stream.value(<UserCard>[]));
  });

  Widget createTestWidget({EventConfig? config}) {
    final cfg = config ?? EventConfig.defaultQuito();
    return ProviderScope(
      overrides: [
        currentEventConfigProvider.overrideWithValue(cfg),
        cameraServiceProvider.overrideWithValue(mockCamera),
        generateAiBadgeUseCaseProvider.overrideWithValue(mockAi),
        publishUserCardUseCaseProvider.overrideWithValue(mockPublish),
        getCommunityStreamUseCaseProvider.overrideWithValue(mockCommunity),
      ],
      child: const MaterialApp(
        home: MainHomeScreen(),
      ),
    );
  }

  group('MainHomeScreen Widget & i18n Tests', () {
    testWidgets(
        'renders LanguageFlagToggle and switches tabs between ES and EN',
        (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(LanguageFlagToggle), findsOneWidget);
      expect(find.text('Crear mi Badge'), findsOneWidget);
      expect(find.text('Mural en Vivo'), findsOneWidget);

      // Switch to English
      await tester.tap(find.text('🇺🇸 EN'));
      await tester.pumpAndSettle();

      expect(find.text('Create Badge'), findsOneWidget);
      expect(find.text('Live Wall'), findsOneWidget);

      // Switch back to Spanish
      await tester.tap(find.text('🇨🇴 ES'));
      await tester.pumpAndSettle();

      expect(find.text('Crear mi Badge'), findsOneWidget);
      expect(find.text('Mural en Vivo'), findsOneWidget);
    });

    testWidgets(
        'renders mobile layout with LanguageFlagToggle without overflow',
        (tester) async {
      tester.view.physicalSize = const Size(360, 740);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(LanguageFlagToggle), findsOneWidget);
      expect(find.text('Crear mi Badge'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
