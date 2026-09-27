import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:universal_html/html.dart' as html;
import '../theme/app_colors.dart';

import '../../domain/entities/event_config.dart';

/// Service providing unified download and Instagram sharing capabilities
/// across both the Photobooth Studio and the Community Wall.
class SocialShareService {
  static const String officialHashtag = '#devfestquito26';
  static const String shareCaption =
      '¡Mi credencial oficial de DevFest Quito 2026 con Dash! 🦜✨🌋 #devfestquito26';

  /// Rasterizes the widget wrapped in [boundaryKey] into PNG bytes.
  static Future<Uint8List?> captureWidgetPng({
    required GlobalKey boundaryKey,
    double pixelRatio = 2.0,
  }) async {
    try {
      final boundary = boundaryKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return null;

      final ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return null;

      return byteData.buffer.asUint8List();
    } catch (e) {
      debugPrint('SocialShareService.captureWidgetPng error: $e');
      return null;
    }
  }

  /// Triggers a client-side browser file download of the rasterized badge.
  static Future<bool> downloadBadge(
    BuildContext context, {
    required GlobalKey boundaryKey,
    required String attendeeName,
    EventConfig? config,
  }) async {
    final sanitized = attendeeName
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), '_')
        .replaceAll(RegExp(r'[^a-z0-9_]'), '');
    final eventSlug = (config != null)
        ? config.eventName
            .trim()
            .toLowerCase()
            .replaceAll(RegExp(r'\s+'), '_')
            .replaceAll(RegExp(r'[^a-z0-9_]'), '')
        : 'devfest';
    final fileName =
        'badge_${eventSlug}_${sanitized.isEmpty ? 'attendee' : sanitized}.png';

    final bytes = await captureWidgetPng(boundaryKey: boundaryKey);
    if (bytes == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo generar la imagen para descarga.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return false;
    }

    if (kIsWeb) {
      final blob = html.Blob([bytes], 'image/png');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', fileName)
        ..style.display = 'none';

      html.document.body?.children.add(anchor);
      anchor.click();
      anchor.remove();
      html.Url.revokeObjectUrl(url);
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Credencial HD descargada exitosamente! 📥'),
          backgroundColor: AppColors.success,
        ),
      );
    }
    return true;
  }

  /// Downloads the badge PNG, copies caption and hashtag to clipboard,
  /// invokes native Web Share API with file if supported (for direct Instagram Stories sharing),
  /// and presents the Instagram guidance dialog as fallback.
  static Future<void> shareToInstagram(
    BuildContext context, {
    required GlobalKey boundaryKey,
    required String attendeeName,
    EventConfig? config,
  }) async {
    final activeCaption = (config != null)
        ? config.interpolateShareCaption(attendeeName)
        : shareCaption;
    final activeHashtag = config?.hashtag ?? officialHashtag;

    final sanitized = attendeeName
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), '_')
        .replaceAll(RegExp(r'[^a-z0-9_]'), '');
    final eventSlug = (config != null)
        ? config.eventName
            .trim()
            .toLowerCase()
            .replaceAll(RegExp(r'\s+'), '_')
            .replaceAll(RegExp(r'[^a-z0-9_]'), '')
        : 'devfest';
    final fileName =
        'badge_${eventSlug}_${sanitized.isEmpty ? 'attendee' : sanitized}.png';

    // 1. Capture the high-res badge image bytes
    final bytes = await captureWidgetPng(boundaryKey: boundaryKey);

    if (!context.mounted) return;

    // 2. Download the badge image to local camera roll/downloads
    await downloadBadge(
      context,
      boundaryKey: boundaryKey,
      attendeeName: attendeeName,
      config: config,
    );

    // 3. Copy caption with official hashtag to clipboard
    await Clipboard.setData(ClipboardData(text: activeCaption));

    // 4. Try native Web Share API Level 2 with attached File (Safari iOS / Android Chrome)
    // Passing the actual image File allows native OS to list Instagram Stories in the share sheet!
    bool sharedViaNative = false;
    if (kIsWeb && bytes != null) {
      try {
        final nav = html.window.navigator as dynamic;
        if (nav != null) {
          final file = html.File([bytes], fileName, {'type': 'image/png'});
          bool canShareFiles = false;
          try {
            canShareFiles =
                nav.canShare != null && nav.canShare({'files': [file]}) == true;
          } catch (_) {
            canShareFiles = false;
          }

          if (canShareFiles) {
            await nav.share({
              'files': [file],
              'title': config?.eventName ?? 'EventBooth',
              'text': activeCaption,
            });
            sharedViaNative = true;
          } else if (nav.share != null) {
            await nav.share({
              'title': config?.eventName ?? 'EventBooth',
              'text': activeCaption,
              'url': html.window.location.href,
            });
            sharedViaNative = true;
          }
        }
      } catch (e) {
        // Fallback gracefully to modal if Web Share is dismissed or unsupported
        debugPrint('SocialShareService.shareToInstagram Web Share dismissed or error: $e');
      }
    }

    // 5. Show Instagram Stories Share Guide Dialog
    if (context.mounted && !sharedViaNative) {
      showDialog(
        context: context,
        builder: (ctx) => _InstagramShareGuideDialog(hashtag: activeHashtag),
      );
    }
  }
}

class _InstagramShareGuideDialog extends StatelessWidget {
  final String hashtag;

  const _InstagramShareGuideDialog({
    this.hashtag = SocialShareService.officialHashtag,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420),
        decoration: BoxDecoration(
          color: const Color(0xFF161B26),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFFFD1D1D).withValues(alpha: 0.5),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFD1D1D).withValues(alpha: 0.25),
              blurRadius: 28,
              spreadRadius: 2,
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Instagram Gradient Header
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF833AB4),
                        Color(0xFFFD1D1D),
                        Color(0xFFFCAF45),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child:
                        Icon(Icons.camera_alt, color: Colors.white, size: 26),
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Compartir en Instagram',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Stories o Publicación',
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white54),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Step 1: Image downloaded
            _buildStepRow(
              icon: Icons.check_circle_rounded,
              iconColor: AppColors.success,
              title: '1. Imagen HD descargada',
              description:
                  'Tu credencial ya se guardó automáticamente en tu carpeta de descargas o galería.',
            ),
            const SizedBox(height: 14),

            // Step 2: Clipboard
            _buildStepRow(
              icon: Icons.copy_rounded,
              iconColor: AppColors.dashCyan,
              title: '2. Hashtag copiado al portapapeles',
              description:
                  'El texto con $hashtag está listo para pegarse en tu descripción.',
            ),
            const SizedBox(height: 14),

            // Step 3: Open Instagram
            _buildStepRow(
              icon: Icons.auto_awesome,
              iconColor: AppColors.sunshineAmber,
              title: '3. Abre Instagram y comparte',
              description:
                  'Sube la foto a tus Stories, pega el texto y menciona a la comunidad.',
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white70,
                      side: const BorderSide(color: Colors.white24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                    child: const Text('Cerrar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF833AB4),
                          Color(0xFFFD1D1D),
                          Color(0xFFFCAF45),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFD1D1D).withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (kIsWeb) {
                          final userAgent =
                              html.window.navigator.userAgent.toLowerCase();
                          final isMobile = userAgent.contains('mobile') ||
                              userAgent.contains('iphone') ||
                              userAgent.contains('ipad') ||
                              userAgent.contains('android');
                          if (isMobile) {
                            html.window.location.href =
                                'instagram://story-camera';
                          } else {
                            html.window
                                .open('https://www.instagram.com', '_blank');
                          }
                        }
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.open_in_new,
                          color: Colors.white, size: 18),
                      label: const Text(
                        'Abrir Instagram 📸',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 12,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
