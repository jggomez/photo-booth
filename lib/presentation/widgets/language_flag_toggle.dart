import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_language_provider.dart';
import '../theme/app_colors.dart';

/// Interactive dual flag toggle button for real-time switching between Spanish (🇨🇴 ES) and English (🇺🇸 EN).
class LanguageFlagToggle extends ConsumerWidget {
  const LanguageFlagToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLang = ref.watch(appLanguageProvider);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderCard),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildFlagItem(
            context: context,
            label: '🇨🇴 ES',
            tooltip: 'Español',
            isSelected: currentLang == AppLanguage.es,
            onTap: () =>
                ref.read(appLanguageProvider.notifier).state = AppLanguage.es,
          ),
          const SizedBox(width: 2),
          _buildFlagItem(
            context: context,
            label: '🇺🇸 EN',
            tooltip: 'English',
            isSelected: currentLang == AppLanguage.en,
            onTap: () =>
                ref.read(appLanguageProvider.notifier).state = AppLanguage.en,
          ),
        ],
      ),
    );
  }

  Widget _buildFlagItem({
    required BuildContext context,
    required String label,
    required String tooltip,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.dashCyan.withValues(alpha: 0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? AppColors.dashCyan.withValues(alpha: 0.6)
                  : Colors.transparent,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.dashCyan.withValues(alpha: 0.25),
                      blurRadius: 6,
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? AppColors.dashCyan : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
