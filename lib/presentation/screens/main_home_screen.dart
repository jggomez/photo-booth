import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/event_config.dart';
import '../localization/app_strings.dart';
import '../providers/app_language_provider.dart';
import '../providers/event_config_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_gradients.dart';
import '../widgets/language_flag_toggle.dart';
import 'photobooth_screen.dart';
import 'community_wall_screen.dart';
import 'admin_config_screen.dart';

/// Main navigation shell hosting the Photobooth and the Live Community Wall.
class MainHomeScreen extends ConsumerStatefulWidget {
  const MainHomeScreen({super.key});

  @override
  ConsumerState<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends ConsumerState<MainHomeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _logoTapCount = 0;
  DateTime? _lastLogoTap;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onLogoTapped() {
    final now = DateTime.now();
    if (_lastLogoTap == null ||
        now.difference(_lastLogoTap!) > const Duration(seconds: 2)) {
      _logoTapCount = 1;
    } else {
      _logoTapCount++;
    }
    _lastLogoTap = now;

    if (_logoTapCount >= 5) {
      _logoTapCount = 0;
      _openAdmin();
    }
  }

  void _openAdmin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        settings: const RouteSettings(name: '/admin'),
        builder: (context) => const AdminConfigScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(currentEventConfigProvider);
    final strings = AppStrings.get(ref.watch(appLanguageProvider));

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: Stack(
        children: [
          // Ambient Background Glow
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppGradients.ambientGlow,
              ),
            ),
          ),

          // Main Layout
          SafeArea(
            child: Column(
              children: [
                // Top App Header
                _buildTopHeader(config, strings),

                // Tab Content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      PhotoboothScreen(),
                      CommunityWallScreen(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopHeader(EventConfig config, AppStrings strings) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withValues(alpha: 0.85),
        border: const Border(
          bottom: BorderSide(color: AppColors.borderCard, width: 1),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 650;

              if (isNarrow) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Mobile Header Row 1: Brand, Flags & Admin
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(child: _buildBrand(config, compact: true)),
                          const SizedBox(width: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const LanguageFlagToggle(),
                              const SizedBox(width: 4),
                              IconButton(
                                icon: const Icon(Icons.settings_outlined,
                                    color: AppColors.dashCyan, size: 20),
                                tooltip: strings.adminPanel,
                                constraints: const BoxConstraints(),
                                padding: const EdgeInsets.all(4),
                                onPressed: _openAdmin,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Mobile Header Row 2: Full Width Segmented Tabs (50% / 50%)
                      _buildTabBar(strings, isFullWidth: true),
                    ],
                  ),
                );
              }

              // Desktop / Tablet Header: Single Horizontal Row
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: _buildBrand(config, compact: false)),
                    const SizedBox(width: 16),
                    _buildTabBar(strings, isFullWidth: false),
                    const SizedBox(width: 16),
                    const LanguageFlagToggle(),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.settings_outlined,
                          color: AppColors.dashCyan, size: 22),
                      tooltip: strings.adminPanel,
                      onPressed: _openAdmin,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBrand(EventConfig config, {required bool compact}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Tooltip(
          message: 'Configuración Admin (5 toques o mantén presionado)',
          child: GestureDetector(
            onTap: _onLogoTapped,
            onLongPress: _openAdmin,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: _buildLogoImage(config, compact: compact),
            ),
          ),
        ),
        SizedBox(width: compact ? 10 : 12),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                config.eventName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: compact ? 14.5 : 16,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                config.eventTagline,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: compact ? 10 : 11,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogoImage(EventConfig config, {required bool compact}) {
    final size = compact ? 38.0 : 44.0;
    final logo = config.logoUrl?.trim();

    Widget logoContent;
    if (logo != null && logo.isNotEmpty) {
      final isNetwork =
          logo.startsWith('http://') || logo.startsWith('https://');
      logoContent = isNetwork
          ? Image.network(
              logo,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.flutter_dash,
                color: AppColors.flutterBlue,
                size: compact ? 22 : 26,
              ),
            )
          : Image.asset(
              logo,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.flutter_dash,
                color: AppColors.flutterBlue,
                size: compact ? 22 : 26,
              ),
            );
    } else {
      logoContent = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(compact ? 8 : 10),
          gradient: const LinearGradient(
            colors: [Color(0xFF4285F4), Color(0xFF34A853)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(4),
        child: Icon(
          Icons.terminal_rounded,
          color: Colors.white,
          size: compact ? 20 : 24,
        ),
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(compact ? 10 : 12),
        boxShadow: [
          BoxShadow(
            color: AppColors.dashCyan.withValues(alpha: 0.3),
            blurRadius: 10,
          ),
        ],
      ),
      padding: EdgeInsets.all(compact ? 3 : 4),
      child: logoContent,
    );
  }

  Widget _buildTabBar(AppStrings strings, {required bool isFullWidth}) {
    return Container(
      width: isFullWidth ? double.infinity : 340,
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderCard),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: false,
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        labelPadding: const EdgeInsets.symmetric(horizontal: 8),
        indicator: BoxDecoration(
          gradient: AppGradients.flutterPrimary,
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: TextStyle(
          fontSize: isFullWidth ? 12 : 13,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.all(4),
        tabs: [
          Tab(
            height: isFullWidth ? 38 : 42,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.camera_alt_outlined, size: 17),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    strings.createBadge,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
          Tab(
            height: isFullWidth ? 38 : 42,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.grid_view_rounded, size: 17),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    strings.liveWall,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
