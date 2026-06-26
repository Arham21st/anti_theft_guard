import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/glow_button.dart';
import '../../core/widgets/pulse_indicator.dart';

class AutoStartScreen extends StatefulWidget {
  const AutoStartScreen({super.key});

  @override
  State<AutoStartScreen> createState() => _AutoStartScreenState();
}

class _AutoStartScreenState extends State<AutoStartScreen> {
  bool _autoStartEnabled = true;
  bool _silentReactivation = true;

  @override
  Widget build(BuildContext context) {
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
        title: Text(
          'Auto-Start on Reboot',
          style: AppTextStyles.headlineMedium,
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 8),
                // Status hero card
                _buildStatusHero(),
                const SectionHeader(title: 'BOOT SETTINGS'),
                GlassCard(
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: _autoStartEnabled
                              ? AppColors.success.withOpacity(0.15)
                              : AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.restart_alt_rounded,
                          color: _autoStartEnabled
                              ? AppColors.success
                              : AppColors.textTertiary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Auto-Start on Boot',
                              style: AppTextStyles.titleLarge,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Activate protection on every device reboot',
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _autoStartEnabled,
                        onChanged: (v) => setState(() => _autoStartEnabled = v),
                        activeTrackColor: AppColors.success,
                        activeThumbColor: Colors.white,
                        inactiveThumbColor: AppColors.textTertiary,
                        inactiveTrackColor: AppColors.surfaceHighest,
                        trackOutlineColor: WidgetStateProperty.all(
                          Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 100.ms),
                const SizedBox(height: 10),
                GlassCard(
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: _silentReactivation
                              ? AppColors.info.withOpacity(0.15)
                              : AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.visibility_off_rounded,
                          color: _silentReactivation
                              ? AppColors.info
                              : AppColors.textTertiary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Silent Reactivation',
                              style: AppTextStyles.titleLarge,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'No notification shown when system auto-starts',
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _silentReactivation,
                        onChanged: (v) =>
                            setState(() => _silentReactivation = v),
                        activeTrackColor: AppColors.info,
                        activeThumbColor: Colors.white,
                        inactiveThumbColor: AppColors.textTertiary,
                        inactiveTrackColor: AppColors.surfaceHighest,
                        trackOutlineColor: WidgetStateProperty.all(
                          Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 160.ms),
                const SectionHeader(title: 'BOOT SEQUENCE'),
                _buildBootFlow(),
                const SectionHeader(title: 'REQUIRED PERMISSIONS'),
                _buildPermissionChips(),
                const SectionHeader(title: 'LAST REBOOT'),
                GlassCard(
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.textTertiary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.history_rounded,
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
                              '3 days ago',
                              style: AppTextStyles.titleMedium,
                            ),
                            Text(
                              'Protection activated in 1.2s',
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'SUCCESS',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.success,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 350.ms),
                const SizedBox(height: 20),
                GlowButton(
                  label: 'Save Boot Settings',
                  icon: Icons.save_rounded,
                  onPressed: () => Navigator.pop(context),
                  gradient: AppColors.successGradient,
                  glowColor: AppColors.success,
                ).animate().fadeIn(delay: 400.ms),
                const SizedBox(height: 28),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusHero() {
    return GlassCard(
      glowColor: _autoStartEnabled ? AppColors.success : null,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          PulseIndicator(
            color: _autoStartEnabled
                ? AppColors.success
                : AppColors.textTertiary,
            size: 12,
            pulseSize: 26,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _autoStartEnabled
                      ? 'Boot Protection Active'
                      : 'Boot Protection Disabled',
                  style: AppTextStyles.titleLarge,
                ),
                const SizedBox(height: 3),
                Text(
                  _autoStartEnabled
                      ? 'System will auto-activate on every reboot'
                      : 'Thief can bypass by restarting the phone',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildBootFlow() {
    final steps = [
      (
        'Phone Powers On',
        Icons.power_settings_new_rounded,
        AppColors.textSecondary,
      ),
      ('System Boot Complete', Icons.phone_android_rounded, AppColors.info),
      ('Anti-Theft Activated', Icons.shield_rounded, AppColors.success),
    ];

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: steps.asMap().entries.map((e) {
          final (label, icon, color) = e.value;
          final isLast = e.key == steps.length - 1;
          return Column(
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: color, size: 18),
                      ),
                      if (!isLast)
                        Container(
                          width: 2,
                          height: 24,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          color: AppColors.border,
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Text(label, style: AppTextStyles.titleMedium),
                ],
              ),
            ],
          );
        }).toList(),
      ),
    ).animate().fadeIn(delay: 220.ms);
  }

  Widget _buildPermissionChips() {
    final perms = [
      ('RECEIVE_BOOT_COMPLETED', AppColors.success),
      ('FOREGROUND_SERVICE', AppColors.info),
      ('WAKE_LOCK', AppColors.warning),
    ];
    return GlassCard(
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: perms.map((p) {
          final (label, color) = p;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withOpacity(0.35)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle_rounded, color: color, size: 13),
                const SizedBox(width: 5),
                Text(
                  label,
                  style: AppTextStyles.labelSmall.copyWith(color: color),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    ).animate().fadeIn(delay: 290.ms);
  }
}
