import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/event_config.dart';
import '../../domain/entities/user_card.dart';
import '../localization/app_strings.dart';
import '../providers/app_language_provider.dart';
import '../providers/community_wall_provider.dart';
import '../providers/di_providers.dart';
import '../providers/event_config_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_gradients.dart';
import '../utils/web_csv_exporter.dart';
import '../widgets/language_flag_toggle.dart';
import '../widgets/official_badge_card.dart';
import 'main_home_screen.dart';

/// Secret Admin Configuration Screen for live event customization and branding.
class AdminConfigScreen extends ConsumerStatefulWidget {
  const AdminConfigScreen({super.key});

  @override
  ConsumerState<AdminConfigScreen> createState() => _AdminConfigScreenState();
}

class _AdminConfigScreenState extends ConsumerState<AdminConfigScreen> {
  final GlobalKey _previewKey = GlobalKey();
  final TextEditingController _pinInputController = TextEditingController();
  final TextEditingController _newPhraseController = TextEditingController();

  late final TextEditingController _nameController;
  late final TextEditingController _taglineController;
  late final TextEditingController _badgeLabelController;
  late final TextEditingController _locationController;
  late final TextEditingController _hashtagController;
  late final TextEditingController _badgeRoleTitleController;
  late final TextEditingController _communityTaglineController;
  late final TextEditingController _heroTitleController;
  late final TextEditingController _heroSubtitleController;
  late final TextEditingController _adminPinController;
  late final TextEditingController _promptController;
  late final TextEditingController _socialCaptionController;
  late final TextEditingController _logoUrlController;
  late final TextEditingController _heroUrlController;

  bool _obscureAdminPin = true;
  bool _obscurePinInput = true;
  bool _isUnlocked = false;
  bool _isAuthenticating = false;
  bool _hasUserModifiedForm = false;
  String? _pinError;
  bool _isSaving = false;
  bool _isUploadingAsset = false;

  List<String> _fallbackTitles = [];

  @override
  void initState() {
    super.initState();
    _initControllers();
    final initial = ref.read(currentEventConfigProvider);
    _populateFromConfig(initial);
  }

  void _initControllers() {
    _nameController = TextEditingController();
    _taglineController = TextEditingController();
    _badgeLabelController = TextEditingController();
    _locationController = TextEditingController();
    _hashtagController = TextEditingController();
    _badgeRoleTitleController = TextEditingController();
    _communityTaglineController = TextEditingController();
    _heroTitleController = TextEditingController();
    _heroSubtitleController = TextEditingController();
    _adminPinController = TextEditingController();
    _promptController = TextEditingController();
    _socialCaptionController = TextEditingController();
    _logoUrlController = TextEditingController();
    _heroUrlController = TextEditingController();
  }

  void _populateFromConfig(EventConfig config) {
    _nameController.text = config.eventName;
    _taglineController.text = config.eventTagline;
    _badgeLabelController.text = config.eventBadgeLabel;
    _locationController.text = config.eventLocation;
    _hashtagController.text = config.hashtag;
    _badgeRoleTitleController.text = config.badgeRoleTitle;
    _communityTaglineController.text = config.communityTagline;
    _heroTitleController.text = config.heroTitle;
    _heroSubtitleController.text = config.heroSubtitle;
    _adminPinController.text = config.adminPin;
    _promptController.text = config.promptTemplate;
    _socialCaptionController.text = config.socialShareCaptionTemplate;
    _logoUrlController.text = config.logoUrl ?? '';
    _heroUrlController.text = config.heroImageUrl ?? '';
    _fallbackTitles = List<String>.from(config.fallbackTitles);
  }

  @override
  void dispose() {
    _pinInputController.dispose();
    _newPhraseController.dispose();
    _nameController.dispose();
    _taglineController.dispose();
    _badgeLabelController.dispose();
    _locationController.dispose();
    _hashtagController.dispose();
    _badgeRoleTitleController.dispose();
    _communityTaglineController.dispose();
    _heroTitleController.dispose();
    _heroSubtitleController.dispose();
    _adminPinController.dispose();
    _promptController.dispose();
    _socialCaptionController.dispose();
    _logoUrlController.dispose();
    _heroUrlController.dispose();
    super.dispose();
  }

  Future<void> _unlock() async {
    final enteredPin = _pinInputController.text.trim();
    if (enteredPin.isEmpty) return;

    final strings = AppStrings.get(ref.read(appLanguageProvider));

    setState(() {
      _isAuthenticating = true;
      _pinError = null;
    });

    try {
      EventConfig config;
      try {
        config = await ref.read(getEventConfigUseCaseProvider).execute();
      } catch (_) {
        config = ref.read(currentEventConfigProvider);
      }

      if (enteredPin == config.adminPin) {
        if (!mounted) return;
        _populateFromConfig(config);
        setState(() {
          _isUnlocked = true;
          _pinError = null;
          _isAuthenticating = false;
        });
      } else {
        if (!mounted) return;
        setState(() {
          _pinError = strings.pinIncorrect;
          _isAuthenticating = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _pinError = strings.pinIncorrect;
        _isAuthenticating = false;
      });
    }
  }

  EventConfig _buildWorkingConfig() {
    final current = ref.read(eventConfigNotifierProvider).config;
    final logoText = _logoUrlController.text.trim();
    final heroText = _heroUrlController.text.trim();

    return current.copyWith(
      eventName: _nameController.text.trim(),
      eventTagline: _taglineController.text.trim(),
      eventBadgeLabel: _badgeLabelController.text.trim(),
      eventLocation: _locationController.text.trim(),
      hashtag: _hashtagController.text.trim(),
      badgeRoleTitle: _badgeRoleTitleController.text.trim(),
      communityTagline: _communityTaglineController.text.trim(),
      heroTitle: _heroTitleController.text.trim(),
      heroSubtitle: _heroSubtitleController.text.trim(),
      adminPin: _adminPinController.text.trim(),
      promptTemplate: _promptController.text.trim(),
      socialShareCaptionTemplate: _socialCaptionController.text.trim(),
      fallbackTitles: _fallbackTitles,
      logoUrl: logoText.isEmpty ? null : logoText,
      clearLogoUrl: logoText.isEmpty,
      heroImageUrl: heroText.isEmpty ? null : heroText,
      clearHeroImageUrl: heroText.isEmpty,
      updatedAt: DateTime.now(),
    );
  }

  void _applyPreset(void Function() presetAction) {
    final currentPin = _adminPinController.text.trim();
    presetAction();
    final newConfig = ref.read(eventConfigNotifierProvider).config;
    _populateFromConfig(newConfig.copyWith(
      adminPin: currentPin.isNotEmpty ? currentPin : newConfig.adminPin,
    ));
    _hasUserModifiedForm = true;
    setState(() {});
  }

  Future<void> _saveCurrentConfig() async {
    final pin = _adminPinController.text.trim();
    if (pin.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'El PIN de administrador debe tener al menos 4 caracteres.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);
    final working = _buildWorkingConfig();
    final success = await ref
        .read(eventConfigNotifierProvider.notifier)
        .saveConfig(working);
    if (!mounted) return;
    setState(() => _isSaving = false);

    final messenger = ScaffoldMessenger.of(context);
    if (success) {
      _hasUserModifiedForm = false;
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Configuración guardada en vivo exitosamente'),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      final errorState = ref.read(eventConfigNotifierProvider).saveStatus;
      final errorMsg = errorState.hasError
          ? '${errorState.error}'
          : 'Error al guardar la configuración';
      messenger.showSnackBar(
        SnackBar(
          content: Text(errorMsg),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _pickAndUploadAsset({required bool isLogo}) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    setState(() => _isUploadingAsset = true);
    try {
      final bytes = await picked.readAsBytes();
      final ext =
          picked.name.contains('.') ? picked.name.split('.').last : 'png';
      final fileName =
          '${isLogo ? "logo" : "hero"}_${DateTime.now().millisecondsSinceEpoch}.$ext';
      final url =
          await ref.read(eventConfigNotifierProvider.notifier).uploadAsset(
                bytes: bytes,
                fileName: fileName,
              );
      if (!mounted) return;
      if (url != null) {
        setState(() {
          if (isLogo) {
            _logoUrlController.text = url;
          } else {
            _heroUrlController.text = url;
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Imagen subida exitosamente'),
            backgroundColor: AppColors.success,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al subir la imagen'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al subir la imagen: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploadingAsset = false);
    }
  }

  void _addFallbackTitle() {
    final text = _newPhraseController.text.trim();
    if (text.isNotEmpty && !_fallbackTitles.contains(text)) {
      setState(() {
        _fallbackTitles.add(text);
        _newPhraseController.clear();
      });
    }
  }

  void _removeFallbackTitle(int index) {
    setState(() {
      _fallbackTitles.removeAt(index);
    });
  }

  void _insertPromptTag(String tag) {
    final currentText = _promptController.text;
    final selection = _promptController.selection;
    if (selection.start >= 0 && selection.end >= 0) {
      final newText =
          currentText.replaceRange(selection.start, selection.end, tag);
      _promptController.value = TextEditingValue(
        text: newText,
        selection:
            TextSelection.collapsed(offset: selection.start + tag.length),
      );
    } else {
      _promptController.text = '$currentText $tag';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<EventConfig>>(eventConfigStreamProvider,
        (prev, next) {
      next.whenData((config) {
        if (!_hasUserModifiedForm && !_isSaving) {
          _populateFromConfig(config);
        }
      });
    });

    final strings = AppStrings.get(ref.watch(appLanguageProvider));
    if (!_isUnlocked) {
      return _buildPinLockScaffold(strings);
    }
    return _buildAdminScaffold(strings);
  }

  Widget _buildPinLockScaffold(AppStrings strings) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: AppColors.dashCyan.withValues(alpha: 0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.admin_panel_settings,
                    size: 52, color: AppColors.dashCyan),
                const SizedBox(height: 16),
                const Text(
                  'EventBooth Admin',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  strings.pinPrompt,
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _pinInputController,
                  obscureText: _obscurePinInput,
                  keyboardType: TextInputType.number,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: strings.pinLabel,
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePinInput
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 20,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () {
                        setState(() => _obscurePinInput = !_obscurePinInput);
                      },
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onSubmitted: (_) => _isAuthenticating ? null : _unlock(),
                ),
                if (_pinError != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _pinError!,
                    style:
                        const TextStyle(color: AppColors.error, fontSize: 13),
                  ),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.dashCyan,
                      foregroundColor: AppColors.bgDark,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _isAuthenticating ? null : _unlock,
                    child: _isAuthenticating
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.bgDark,
                            ),
                          )
                        : Text(strings.login,
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton.icon(
                  icon: const Icon(Icons.arrow_back,
                      size: 16, color: AppColors.dashCyan),
                  label: const Text('Volver al Photobooth',
                      style: TextStyle(color: AppColors.dashCyan)),
                  onPressed: () {
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    } else {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (_) => const MainHomeScreen()),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAdminScaffold(AppStrings strings) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Volver al Photobooth',
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const MainHomeScreen()),
              );
            }
          },
        ),
        title: Text(
          strings.adminTitle,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        backgroundColor: AppColors.surfaceDark,
        actions: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: LanguageFlagToggle(),
          ),
          IconButton(
            tooltip: 'Photobooth',
            icon: const Icon(Icons.photo_camera,
                size: 20, color: AppColors.dashCyan),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const MainHomeScreen()),
              );
            },
          ),
          IconButton(
            tooltip: 'Bloquear panel',
            icon: const Icon(Icons.lock_outline),
            onPressed: () {
              setState(() {
                _isUnlocked = false;
                _pinInputController.clear();
                _pinError = null;
              });
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 980;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1300),
                child: isWide
                    ? _buildWideLayout(strings)
                    : _buildNarrowLayout(strings),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWideLayout(AppStrings strings) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildPresetsSection(strings),
              const SizedBox(height: 24),
              _buildGeneralInfoSection(strings, isNarrow: false),
              const SizedBox(height: 24),
              _buildAssetsSection(strings, isNarrow: false),
              const SizedBox(height: 24),
              _buildAlbumManagementSection(),
              const SizedBox(height: 24),
              _buildPromptEditorSection(),
              const SizedBox(height: 24),
              _buildFallbackTitlesSection(),
              const SizedBox(height: 32),
              _buildSaveButton(strings),
            ],
          ),
        ),
        const SizedBox(width: 32),
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildLivePreviewHeader(strings),
              const SizedBox(height: 16),
              _buildLivePreviewCard(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout(AppStrings strings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildPresetsSection(strings),
        const SizedBox(height: 24),
        _buildLivePreviewHeader(strings),
        const SizedBox(height: 16),
        _buildLivePreviewCard(),
        const SizedBox(height: 24),
        _buildGeneralInfoSection(strings, isNarrow: true),
        const SizedBox(height: 24),
        _buildAssetsSection(strings, isNarrow: true),
        const SizedBox(height: 24),
        _buildAlbumManagementSection(),
        const SizedBox(height: 24),
        _buildPromptEditorSection(),
        const SizedBox(height: 24),
        _buildFallbackTitlesSection(),
        const SizedBox(height: 32),
        _buildSaveButton(strings),
      ],
    );
  }

  Widget _buildPresetsSection(AppStrings strings) {
    final notifier = ref.read(eventConfigNotifierProvider.notifier);
    return Card(
      color: AppColors.surfaceDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              strings.presets,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary),
            ),
            const SizedBox(height: 6),
            const Text(
              'Carga configuraciones predeterminadas completas en un clic.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 10,
              children: [
                _buildPresetButton(
                  title: 'DevFest Quito 2026',
                  icon: Icons.flash_on,
                  color: AppColors.dashCyan,
                  onTap: () => _applyPreset(() => notifier.applyQuitoPreset(_adminPinController.text.trim())),
                ),
                _buildPresetButton(
                  title: 'Cancún 2026',
                  icon: Icons.beach_access,
                  color: AppColors.caribbeanTeal,
                  onTap: () => _applyPreset(() => notifier.applyCancunPreset(_adminPinController.text.trim())),
                ),
                _buildPresetButton(
                  title: 'Genérico',
                  icon: Icons.public,
                  color: AppColors.sunshineAmber,
                  onTap: () => _applyPreset(() => notifier.applyGenericPreset(_adminPinController.text.trim())),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withValues(alpha: 0.15),
        foregroundColor: color,
        side: BorderSide(color: color.withValues(alpha: 0.5)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildGeneralInfoSection(AppStrings strings,
      {required bool isNarrow}) {
    return Card(
      color: AppColors.surfaceDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              strings.generalInfo,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            _buildField(
              controller: _nameController,
              label: strings.eventName,
              hint: 'DevFest Quito 2026',
              icon: Icons.event,
            ),
            const SizedBox(height: 12),
            _buildField(
              controller: _taglineController,
              label: strings.tagline,
              hint: 'Quito, Ecuador • Mitad del Mundo',
              icon: Icons.subtitles,
            ),
            const SizedBox(height: 12),
            _buildResponsiveRow(
              isNarrow: isNarrow,
              child1: _buildField(
                controller: _badgeLabelController,
                label: 'Etiqueta Badge Pill',
                hint: '🌋 Quito 2026',
                icon: Icons.label_important_outline,
              ),
              child2: _buildField(
                controller: _locationController,
                label: strings.location,
                hint: 'Quito, Ecuador',
                icon: Icons.place_outlined,
              ),
            ),
            const SizedBox(height: 12),
            _buildResponsiveRow(
              isNarrow: isNarrow,
              child1: _buildField(
                controller: _hashtagController,
                label: strings.hashtag,
                hint: '#devfestquito26',
                icon: Icons.tag,
              ),
              child2: _buildField(
                controller: _adminPinController,
                label: strings.pinLabel,
                hint: '2026',
                icon: Icons.password,
                obscureText: _obscureAdminPin,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureAdminPin
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 20,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () {
                    setState(() => _obscureAdminPin = !_obscureAdminPin);
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildResponsiveRow(
              isNarrow: isNarrow,
              child1: _buildField(
                controller: _badgeRoleTitleController,
                label: strings.badgeRoleTitle,
                hint: 'DEVFEST PIONEER',
                icon: Icons.military_tech_outlined,
              ),
              child2: _buildField(
                controller: _communityTaglineController,
                label: strings.communityTagline,
                hint: 'Quito • DevFest',
                icon: Icons.photo_album_outlined,
              ),
            ),
            const SizedBox(height: 12),
            _buildField(
              controller: _heroTitleController,
              label: 'Título de la Cabecera Photobooth',
              hint: '¡Crea tu Credencial Interactiva Oficial!',
              icon: Icons.title,
            ),
            const SizedBox(height: 12),
            _buildField(
              controller: _heroSubtitleController,
              label: 'Subtítulo de la Cabecera Photobooth',
              hint: 'Sube o tómate una foto y personalízala con IA...',
              icon: Icons.short_text,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResponsiveRow({
    required Widget child1,
    required Widget child2,
    required bool isNarrow,
  }) {
    if (isNarrow) {
      return Column(
        children: [
          child1,
          const SizedBox(height: 12),
          child2,
        ],
      );
    }
    return Row(
      children: [
        Expanded(child: child1),
        const SizedBox(width: 12),
        Expanded(child: child2),
      ],
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 20),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: AppColors.surfaceCard,
      ),
      onChanged: (_) {
        _hasUserModifiedForm = true;
        setState(() {});
      },
    );
  }

  Widget _buildAssetsSection(AppStrings strings, {required bool isNarrow}) {
    return Card(
      color: AppColors.surfaceDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              strings.assetsTitle,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Personaliza el logotipo en la credencial y la imagen representativa del photobooth.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            _buildAssetCard(
              title: strings.logoLabel,
              controller: _logoUrlController,
              isLogo: true,
              defaultNote: 'Logo por defecto (Icono de Conferencia)',
              onUpload: () => _pickAndUploadAsset(isLogo: true),
              strings: strings,
              isNarrow: isNarrow,
            ),
            const Divider(color: AppColors.borderCard, height: 32),
            _buildAssetCard(
              title: strings.mascotLabel,
              controller: _heroUrlController,
              isLogo: false,
              defaultNote: 'Mascota por defecto (Icono AI)',
              onUpload: () => _pickAndUploadAsset(isLogo: false),
              strings: strings,
              isNarrow: isNarrow,
            ),
            if (_isUploadingAsset) ...[
              const SizedBox(height: 16),
              const LinearProgressIndicator(color: AppColors.dashCyan),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAssetCard({
    required String title,
    required TextEditingController controller,
    required bool isLogo,
    required String defaultNote,
    required VoidCallback onUpload,
    required AppStrings strings,
    required bool isNarrow,
  }) {
    final text = controller.text.trim();
    final isCustom = text.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 6,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontSize: 14,
              ),
            ),
            _buildStatusPill(isCustom: isCustom),
          ],
        ),
        const SizedBox(height: 10),
        if (isNarrow)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImagePreviewBox(url: text, isLogo: isLogo),
              const SizedBox(height: 12),
              _buildAssetInput(
                controller: controller,
                isCustom: isCustom,
                onUpload: onUpload,
                strings: strings,
              ),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImagePreviewBox(url: text, isLogo: isLogo),
              const SizedBox(width: 14),
              Expanded(
                child: _buildAssetInput(
                  controller: controller,
                  isCustom: isCustom,
                  onUpload: onUpload,
                  strings: strings,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildAssetInput({
    required TextEditingController controller,
    required bool isCustom,
    required VoidCallback onUpload,
    required AppStrings strings,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: strings.pasteUrlHint,
            hintText: 'https://... o images/...',
            prefixIcon: const Icon(Icons.link, size: 20),
            suffixIcon: isCustom
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      controller.clear();
                      setState(() {});
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: AppColors.surfaceCard,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.dashCyan.withValues(alpha: 0.15),
                foregroundColor: AppColors.dashCyan,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _isUploadingAsset ? null : onUpload,
              icon: const Icon(Icons.cloud_upload_outlined, size: 16),
              label: Text(strings.uploadFile,
                  style: const TextStyle(fontSize: 12)),
            ),
            if (isCustom)
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: BorderSide(
                    color: AppColors.error.withValues(alpha: 0.5),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  controller.clear();
                  setState(() {});
                },
                icon: const Icon(Icons.restore, size: 16),
                label: Text(strings.resetDefault,
                    style: const TextStyle(fontSize: 12)),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildImagePreviewBox({required String? url, required bool isLogo}) {
    final hasUrl = url != null && url.trim().isNotEmpty;
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasUrl
              ? AppColors.dashCyan.withValues(alpha: 0.6)
              : AppColors.borderCard,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (hasUrl ? AppColors.dashCyan : Colors.transparent)
                .withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: _buildPreviewContent(url: url, isLogo: isLogo),
    );
  }

  Widget _buildPreviewContent({required String? url, required bool isLogo}) {
    if (url == null || url.trim().isEmpty) {
      return Center(
        child: Icon(
          isLogo ? Icons.terminal_rounded : Icons.flutter_dash,
          color: AppColors.dashCyan.withValues(alpha: 0.7),
          size: 32,
        ),
      );
    }
    final trimmed = url.trim();
    final isNetwork =
        trimmed.startsWith('http://') || trimmed.startsWith('https://');

    if (isNetwork) {
      return Image.network(
        trimmed,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.dashCyan,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Icon(Icons.broken_image_outlined,
              color: AppColors.error, size: 28),
        ),
      );
    } else {
      return Image.asset(
        trimmed,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Icon(Icons.broken_image_outlined,
              color: AppColors.error, size: 28),
        ),
      );
    }
  }

  Widget _buildStatusPill({required bool isCustom}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isCustom
            ? AppColors.dashCyan.withValues(alpha: 0.15)
            : AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCustom
              ? AppColors.dashCyan.withValues(alpha: 0.5)
              : AppColors.borderCard,
        ),
      ),
      child: Text(
        isCustom ? 'Personalizado' : 'Predeterminado',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isCustom ? AppColors.dashCyan : AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildAlbumManagementSection() {
    final wallAsync = ref.watch(communityWallProvider);
    final cards = wallAsync.valueOrNull ?? [];
    final hasCards = cards.isNotEmpty;

    return Card(
      color: AppColors.surfaceDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.photo_library_outlined,
                    color: AppColors.dashCyan, size: 22),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Gestión del Álbum Comunitario',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                _buildCardCountBadge(cards.length, wallAsync.isLoading),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Visualiza métricas del evento, descarga la base de datos de asistentes y gestiona las credenciales publicadas.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            _buildAlbumMetricsBanner(cards.length),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 10,
              children: [
                _buildExportCsvButton(cards),
                _buildDeleteAlbumButton(cards, hasCards),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardCountBadge(int count, bool isLoading) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderCard),
      ),
      child: isLoading
          ? const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.dashCyan,
              ),
            )
          : Text(
              '$count credenciales',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.dashCyan,
              ),
            ),
    );
  }

  Widget _buildAlbumMetricsBanner(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderCard),
      ),
      child: Row(
        children: [
          const Icon(Icons.badge_outlined, color: AppColors.dashCyan, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Total de credenciales en el álbum: $count',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportCsvButton(List<UserCard> cards) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.dashCyan.withValues(alpha: 0.15),
        foregroundColor: AppColors.dashCyan,
        side: BorderSide(color: AppColors.dashCyan.withValues(alpha: 0.5)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () => _handleExportCsv(cards),
      icon: const Icon(Icons.download_rounded, size: 18),
      label: const Text('Exportar Asistentes a CSV',
          style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  void _handleExportCsv(List<UserCard> cards) {
    if (cards.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay credenciales registradas para exportar'),
          backgroundColor: AppColors.sunshineAmber,
        ),
      );
      return;
    }
    final config = ref.read(currentEventConfigProvider);
    final sanitizedName = config.eventName.replaceAll(RegExp(r'[^\w\-]'), '_');
    final filename =
        'asistentes_${sanitizedName.isEmpty ? "evento" : sanitizedName}.csv';
    WebCsvExporter.exportAttendeesToCsv(
      cards: cards,
      eventName: config.eventName,
      fileName: filename,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Exportación completada exitosamente'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  Widget _buildDeleteAlbumButton(List<UserCard> cards, bool hasCards) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.error.withValues(alpha: 0.15),
        foregroundColor: AppColors.error,
        side: BorderSide(color: AppColors.error.withValues(alpha: 0.5)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: hasCards ? () => _confirmDeleteAlbum(cards.length) : null,
      icon: const Icon(Icons.delete_forever, size: 18),
      label: const Text('Borrar Todo el Álbum',
          style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Future<void> _confirmDeleteAlbum(int count) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.error),
            SizedBox(width: 8),
            Text(
              '¿Eliminar todas las credenciales?',
              style: TextStyle(color: AppColors.textPrimary, fontSize: 18),
            ),
          ],
        ),
        content: Text(
          'Esta acción no se puede deshacer. Se eliminarán permanentemente las $count credenciales del álbum comunitario.',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Eliminar Todo'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(clearCommunityWallUseCaseProvider).call();
        ref.invalidate(communityWallProvider);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Se han eliminado todas las credenciales del álbum'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al eliminar las credenciales: $e'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  Widget _buildPromptEditorSection() {
    return Card(
      color: AppColors.surfaceDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Plantilla del Prompt Multimodal (IA)',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary),
            ),
            const SizedBox(height: 6),
            const Text(
              'Usa las variables dinámicas para insertar datos del asistente en tiempo de generación.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildTagChip('{name}'),
                _buildTagChip('{eventName}'),
                _buildTagChip('{location}'),
                _buildTagChip('{hashtag}'),
              ],
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _promptController,
              minLines: 4,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: 'A vibrant portrait of {name} at {eventName}...',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: AppColors.surfaceCard,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagChip(String tag) {
    return ActionChip(
      label: Text(tag,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: AppColors.dashCyan)),
      backgroundColor: AppColors.dashCyan.withValues(alpha: 0.1),
      side: BorderSide(color: AppColors.dashCyan.withValues(alpha: 0.4)),
      onPressed: () => _insertPromptTag(tag),
    );
  }

  Widget _buildFallbackTitlesSection() {
    return Card(
      color: AppColors.surfaceDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Frases Vibe (Títulos de Respaldo)',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary),
            ),
            const SizedBox(height: 6),
            const Text(
              'Títulos asignados aleatoriamente cuando la IA está en modo fallback.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (int i = 0; i < _fallbackTitles.length; i++)
                  Chip(
                    label: Text(_fallbackTitles[i],
                        style: const TextStyle(fontSize: 12)),
                    backgroundColor: AppColors.surfaceCard,
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () => _removeFallbackTitle(i),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _newPhraseController,
                    decoration: InputDecoration(
                      hintText: 'Nueva frase vibe...',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      filled: true,
                      fillColor: AppColors.surfaceCard,
                    ),
                    onSubmitted: (_) => _addFallbackTitle(),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.dashCyan,
                    foregroundColor: AppColors.bgDark,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _addFallbackTitle,
                  child: const Text('Agregar',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLivePreviewHeader(AppStrings strings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strings.livePreview,
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary),
        ),
        const SizedBox(height: 4),
        const Text(
          'Así lucirá la credencial oficial generada con tu configuración activa.',
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildLivePreviewCard() {
    final workingConfig = _buildWorkingConfig();
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: OfficialBadgeCard(
          repaintBoundaryKey: _previewKey,
          attendeeName: 'Vista Previa',
          attendeeEmail: 'preview@event.com',
          aiVibeTitle:
              _fallbackTitles.isNotEmpty ? _fallbackTitles.first : 'Dev Legend',
          config: workingConfig,
        ),
      ),
    );
  }

  Widget _buildSaveButton(AppStrings strings) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppGradients.flutterPrimary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: _isSaving ? null : _saveCurrentConfig,
        child: _isSaving
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2),
              )
            : Text(
                strings.saveLiveConfig,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
      ),
    );
  }
}
