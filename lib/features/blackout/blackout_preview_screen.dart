import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/glow_button.dart';

class BlackoutPreviewScreen extends StatefulWidget {
  const BlackoutPreviewScreen({super.key});
  @override
  State<BlackoutPreviewScreen> createState() => _BlackoutPreviewScreenState();
}

class _BlackoutPreviewScreenState extends State<BlackoutPreviewScreen> {
  bool _enabledOnTrigger = true;
  bool _showingBlackout = false;

  @override
  Widget build(BuildContext context) {
    if (_showingBlackout) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      return _BlackoutOverlay(
        onExit: () async {
          await SystemChrome.setEnabledSystemUIMode(
            SystemUiMode.manual,
            overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
          );
          setState(() => _showingBlackout = false);
        },
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16,
              color: AppColors.textPrimary,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Blackout Screen', style: AppTextStyles.headlineMedium),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.warning.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.warning,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'When triggered, the phone shows a completely black/dead screen to deceive the thief.',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.warning,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),
            const SectionHeader(title: 'PREVIEW'),
            // Blackout preview card
            GestureDetector(
              onTap: () => setState(() => _showingBlackout = true),
              child: Container(
                height: 220,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Fake status bar
                    Positioned(
                      top: 12,
                      left: 16,
                      right: 16,
                      child: Row(
                        children: [
                          Text(
                            '9:41',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.black26,
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.signal_cellular_alt,
                            color: Colors.black26,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.wifi,
                            color: Colors.black26,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.battery_full,
                            color: Colors.black26,
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.touch_app_outlined,
                            color: Colors.white24,
                            size: 28,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap to preview full blackout',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.white24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: 150.ms),
            const SectionHeader(title: 'SETTINGS'),
            GlassCard(
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.brightness_1_rounded,
                      color: AppColors.textSecondary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Activate on Trigger',
                          style: AppTextStyles.titleLarge,
                        ),
                        Text(
                          'Show blackout when trigger fires',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _enabledOnTrigger,
                    onChanged: (v) => setState(() => _enabledOnTrigger = v),
                    activeTrackColor: AppColors.primary,
                    activeThumbColor: Colors.white,
                    inactiveThumbColor: AppColors.textTertiary,
                    inactiveTrackColor: AppColors.surfaceHighest,
                    trackOutlineColor: WidgetStateProperty.all(
                      Colors.transparent,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 250.ms),
            const Spacer(),
            GlowButton(
              label: 'Preview Full Blackout',
              icon: Icons.visibility_off_rounded,
              onPressed: () => setState(() => _showingBlackout = true),
              gradient: const LinearGradient(
                colors: [Color(0xFF1A1A1A), Color(0xFF000000)],
              ),
              glowColor: Colors.white24,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _BlackoutOverlay extends StatelessWidget {
  const _BlackoutOverlay({required this.onExit});
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: onExit,
      child: const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            '· · ·',
            style: TextStyle(color: Colors.black12, fontSize: 12),
          ),
        ),
      ),
    );
  }
}
