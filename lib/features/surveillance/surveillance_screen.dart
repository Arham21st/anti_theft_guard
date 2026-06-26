import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/status_badge.dart';
import 'surveillance_config.dart';
import 'surveillance_config_notifier.dart';

class SurveillanceScreen extends StatefulWidget {
  const SurveillanceScreen({super.key});

  @override
  State<SurveillanceScreen> createState() => _SurveillanceScreenState();
}

class _SurveillanceScreenState extends State<SurveillanceScreen> {
  @override
  void initState() {
    super.initState();
    // Ensure the persisted config is loaded before rendering derived tags.
    SurveillanceConfigNotifier.instance.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    Text('Surveillance', style: AppTextStyles.headlineLarge),
                    const Spacer(),
                    const StatusBadge(type: StatusType.active, label: 'STEALTH'),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 16),
                  _buildCaptureModeCard(),
                  const SizedBox(height: 20),
                  const SectionHeader(title: 'CAMERA CAPTURE'),
                  // Front / Back tiles react to capture mode below.
                  _buildFrontTile(),
                  const SizedBox(height: 12),
                  _buildBackTile(),
                  const SectionHeader(title: 'VIDEO RECORDING'),
                  _buildVideoTile(),
                  const SectionHeader(title: 'BLACKOUT SCREEN'),
                  _SurveillanceTile(
                    icon: Icons.brightness_1_rounded,
                    title: 'Instant Blackout',
                    subtitle: 'Make phone appear dead on trigger',
                    tag: 'Enabled',
                    tagColor: AppColors.warning,
                    route: AppRoutes.blackoutPreview,
                    iconColor: AppColors.textTertiary,
                    iconBg: AppColors.surfaceHighest,
                    enabled: true,
                  ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.1, end: 0),
                  const SizedBox(height: 24),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// The global Photo/Video arbiter. Flipping this is the ONLY way to change
  /// which capture type is armed, and it auto-disables the opposite side.
  Widget _buildCaptureModeCard() {
    return ListenableBuilder(
      listenable: SurveillanceConfigNotifier.instance,
      builder: (context, _) {
        final cfg = SurveillanceConfigNotifier.instance.config;
        final isPhoto = cfg.captureMode == CaptureMode.photo;
        return GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: (isPhoto ? AppColors.info : AppColors.danger)
                          .withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isPhoto
                          ? Icons.camera_alt_rounded
                          : Icons.videocam_rounded,
                      color: isPhoto ? AppColors.info : AppColors.danger,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Capture Mode',
                            style: AppTextStyles.titleMedium),
                        Text(
                          isPhoto
                              ? 'Photos — video recording paused'
                              : 'Video — photo capture paused',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _ModeSwitch(
                isPhoto: isPhoto,
                onChanged: (photo) => SurveillanceConfigNotifier.instance
                    .setCaptureMode(
                        photo ? CaptureMode.photo : CaptureMode.video),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 400.ms);
      },
    );
  }

  Widget _buildFrontTile() {
    return ListenableBuilder(
      listenable: SurveillanceConfigNotifier.instance,
      builder: (context, _) {
        final cfg = SurveillanceConfigNotifier.instance.config;
        final active = cfg.captureMode == CaptureMode.photo;
        final counts = ['1', '3', '5'];
        final count = counts[cfg.frontMaxPhotosIdx.clamp(0, counts.length - 1)];
        return _SurveillanceTile(
          icon: Icons.camera_front_rounded,
          title: 'Front Camera',
          subtitle: 'Capture intruder photos silently',
          tag: active
              ? (cfg.frontAutoCapture ? '$count photos' : 'Off')
              : 'Paused',
          tagColor: active
              ? (cfg.frontAutoCapture ? AppColors.info : AppColors.textTertiary)
              : AppColors.warning,
          route: AppRoutes.frontCamera,
          enabled: active,
        ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1, end: 0);
      },
    );
  }

  Widget _buildBackTile() {
    return ListenableBuilder(
      listenable: SurveillanceConfigNotifier.instance,
      builder: (context, _) {
        final cfg = SurveillanceConfigNotifier.instance.config;
        final active = cfg.captureMode == CaptureMode.photo;
        return _SurveillanceTile(
          icon: Icons.camera_rear_rounded,
          title: 'Back Camera',
          subtitle: 'Capture surroundings discreetly',
          tag: active
              ? (cfg.backAutoCapture ? 'Ready' : 'Off')
              : 'Paused',
          tagColor: active
              ? (cfg.backAutoCapture ? AppColors.success : AppColors.textTertiary)
              : AppColors.warning,
          route: AppRoutes.backCamera,
          enabled: active,
        ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1, end: 0);
      },
    );
  }

  Widget _buildVideoTile() {
    return ListenableBuilder(
      listenable: SurveillanceConfigNotifier.instance,
      builder: (context, _) {
        final cfg = SurveillanceConfigNotifier.instance.config;
        final active = cfg.captureMode == CaptureMode.video;
        return _SurveillanceTile(
          icon: Icons.fiber_manual_record_rounded,
          title: 'Silent Video Recording',
          subtitle: 'Record activity in background',
          tag: active
              ? (cfg.videoAutoStart ? 'Armed' : 'Idle')
              : 'Paused',
          tagColor: active
              ? (cfg.videoAutoStart ? AppColors.danger : AppColors.textTertiary)
              : AppColors.warning,
          route: AppRoutes.videoRecording,
          iconColor: AppColors.danger,
          iconBg: AppColors.danger.withOpacity(0.12),
          enabled: active,
        ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.1, end: 0);
      },
    );
  }
}

/// Photo | Video segmented switch.
class _ModeSwitch extends StatelessWidget {
  const _ModeSwitch({required this.isPhoto, required this.onChanged});

  final bool isPhoto;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ModeSegment(
            label: 'Photo',
            icon: Icons.photo_camera_rounded,
            color: AppColors.info,
            selected: isPhoto,
            onTap: () => onChanged(true),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ModeSegment(
            label: 'Video',
            icon: Icons.videocam_rounded,
            color: AppColors.danger,
            selected: !isPhoto,
            onTap: () => onChanged(false),
          ),
        ),
      ],
    );
  }
}

class _ModeSegment extends StatelessWidget {
  const _ModeSegment({
    required this.label,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: 200.ms,
        height: 44,
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.15) : AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? color.withOpacity(0.5) : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: selected ? color : AppColors.textSecondary, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                color: selected ? color : AppColors.textSecondary,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SurveillanceTile extends StatelessWidget {
  const _SurveillanceTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.tagColor,
    required this.route,
    this.iconColor = AppColors.primary,
    this.iconBg,
    this.enabled = true,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String tag;
  final Color tagColor;
  final String route;
  final Color iconColor;
  final Color? iconBg;
  final bool enabled;

  void _handleTap(BuildContext context) {
    if (enabled) {
      Navigator.pushNamed(context, route);
      return;
    }
    // Disabled tile — explain why the opposite mode is blocking it.
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.swap_horiz_rounded, color: AppColors.warning, size: 22),
            const SizedBox(width: 8),
            Text('Switch Capture Mode?',
                style: AppTextStyles.headlineMedium),
          ],
        ),
        content: Text(
          'This device can capture photos OR record video at one time — not both. '
          'Switch the Capture Mode above to use this.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Got it',
                style: AppTextStyles.labelLarge.copyWith(color: AppColors.info)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: () => _handleTap(context),
      child: Opacity(
        opacity: enabled ? 1.0 : 0.55,
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBg ?? iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.titleLarge),
                  const SizedBox(height: 3),
                  Text(subtitle, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: tagColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    tag,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: tagColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const Icon(Icons.chevron_right_rounded,
                    color: AppColors.textTertiary, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
