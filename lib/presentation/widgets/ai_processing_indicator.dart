import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_gradients.dart';
import 'glass_container.dart';

/// Animated loading indicator with rotating status ticker while Gemini 3.1
/// generates the attendee's Caribbean Dash avatar.
class AiProcessingIndicator extends StatefulWidget {
  final String? customStatusMessage;
  final List<String>? statusMessages;

  const AiProcessingIndicator({
    super.key,
    this.customStatusMessage,
    this.statusMessages,
  });

  @override
  State<AiProcessingIndicator> createState() => _AiProcessingIndicatorState();
}

class _AiProcessingIndicatorState extends State<AiProcessingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  Timer? _messageTimer;
  int _messageIndex = 0;

  static const List<String> _defaultStatusMessages = [
    'Preparando tu avatar para el evento...',
    'Inyectando el estilo oficial de la conferencia...',
    'Modelando rasgos con inteligencia artificial multimodal...',
    'Aplicando sellos de credencial oficial...',
    'Casi listo... ¡Generando tu credencial HD!',
  ];

  List<String> get _activeMessages {
    if (widget.statusMessages != null && widget.statusMessages!.isNotEmpty) {
      return widget.statusMessages!;
    }
    return _defaultStatusMessages;
  }

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _messageTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() {
          _messageIndex = (_messageIndex + 1) % _activeMessages.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _messageTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = _activeMessages;
    final safeIndex = _messageIndex % messages.length;
    final currentMessage = widget.customStatusMessage ?? messages[safeIndex];

    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Glowing Animated Avatar / Icon
          RotationTransition(
            turns: _animController,
            child: Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppGradients.carribeanDash,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.dashCyan.withValues(alpha: 0.4),
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.auto_awesome,
                  size: 42,
                  color: AppColors.bgDark,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'IA Creando tu Credencial',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              currentMessage,
              key: ValueKey(currentMessage),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.dashCyan,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Caribbean linear progress indicator
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 6,
              width: 220,
              child: LinearProgressIndicator(
                backgroundColor: AppColors.surfaceCard,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.dashCyan),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
