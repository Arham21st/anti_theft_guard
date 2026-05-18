import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/status_badge.dart';

class SurveillanceScreen extends StatelessWidget {
  const SurveillanceScreen({super.key});

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
                    StatusBadge(type: StatusType.active, label: 'STEALTH'),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SectionHeader(title: 'CAMERA CAPTURE'),
                  _SurveillanceTile(
                    icon: Icons.camera_front_rounded,
                    title: 'Front Camera',
                    subtitle: 'Capture intruder photos silently',
                    tag: '3 photos',
                    tagColor: AppColors.info,
                    route: AppRoutes.frontCamera,
                  ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1, end: 0),
                  const SizedBox(height: 12),
                  _SurveillanceTile(
                    icon: Icons.camera_rear_rounded,
                    title: 'Back Camera',
                    subtitle: 'Capture surroundings discreetly',
                    tag: 'Ready',
                    tagColor: AppColors.success,
                    route: AppRoutes.backCamera,
                  ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1, end: 0),
                  const SectionHeader(title: 'VIDEO RECORDING'),
                  _SurveillanceTile(
                    icon: Icons.fiber_manual_record_rounded,
                    title: 'Silent Video Recording',
                    subtitle: 'Record activity in background',
                    tag: 'Idle',
                    tagColor: AppColors.textTertiary,
                    route: AppRoutes.videoRecording,
                    iconColor: AppColors.danger,
                    iconBg: AppColors.danger.withOpacity(0.12),
                  ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.1, end: 0),
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
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String tag;
  final Color tagColor;
  final String route;
  final Color iconColor;
  final Color? iconBg;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: () => Navigator.pushNamed(context, route),
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
    );
  }
}
