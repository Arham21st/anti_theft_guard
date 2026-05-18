import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/glow_button.dart';
import '../../core/widgets/status_badge.dart';

class StealthModeScreen extends StatefulWidget {
  const StealthModeScreen({super.key});

  @override
  State<StealthModeScreen> createState() => _StealthModeScreenState();
}

class _StealthModeScreenState extends State<StealthModeScreen> {
  bool _masterStealth = true;
  bool _hideFromLauncher = true;
  bool _suppressNotifications = true;
  bool _noShutterSound = true;
  bool _flashAlwaysOff = true;
  bool _noRecordingIndicator = true;
  bool _keepScreenDark = true;

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
        title: Text('Stealth Mode', style: AppTextStyles.headlineMedium),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: StatusBadge(
              type: _masterStealth ? StatusType.active : StatusType.inactive,
              label: _masterStealth ? 'ACTIVE' : 'OFF',
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 8),
                _buildMasterToggle(),
                const SectionHeader(title: 'APP VISIBILITY'),
                _buildToggleCard(
                  Icons.apps_rounded,
                  'Hide from Launcher',
                  'App icon not visible in app drawer',
                  AppColors.primary,
                  _hideFromLauncher,
                  (v) => setState(() => _hideFromLauncher = v),
                  delay: 100,
                ),
                const SizedBox(height: 10),
                _buildToggleCard(
                  Icons.notifications_off_rounded,
                  'Suppress Notifications',
                  'No alerts or banners shown from this app',
                  AppColors.info,
                  _suppressNotifications,
                  (v) => setState(() => _suppressNotifications = v),
                  delay: 160,
                ),
                const SectionHeader(title: 'CAMERA STEALTH'),
                _buildToggleCard(
                  Icons.volume_off_rounded,
                  'Silent Camera Shutter',
                  'No sound when a photo is captured',
                  AppColors.success,
                  _noShutterSound,
                  (v) => setState(() => _noShutterSound = v),
                  delay: 220,
                ),
                const SizedBox(height: 10),
                _buildToggleCard(
                  Icons.flash_off_rounded,
                  'Flash Always Off',
                  'Flash disabled during all captures',
                  AppColors.warning,
                  _flashAlwaysOff,
                  (v) => setState(() => _flashAlwaysOff = v),
                  delay: 280,
                ),
                const SizedBox(height: 10),
                _buildToggleCard(
                  Icons.brightness_2_rounded,
                  'Keep Screen Dark',
                  'Camera preview stays black while capturing',
                  AppColors.secondary,
                  _keepScreenDark,
                  (v) => setState(() => _keepScreenDark = v),
                  delay: 340,
                ),
                const SectionHeader(title: 'VIDEO STEALTH'),
                _buildToggleCard(
                  Icons.fiber_manual_record_rounded,
                  'Hide Recording Indicator',
                  'No red dot or system banner during recording',
                  AppColors.danger,
                  _noRecordingIndicator,
                  (v) => setState(() => _noRecordingIndicator = v),
                  delay: 400,
                ),
                const SizedBox(height: 20),
                _buildInfoBanner(),
                const SizedBox(height: 16),
                GlowButton(
                  label: _masterStealth
                      ? 'Disable Stealth Mode'
                      : 'Enable Stealth Mode',
                  icon: _masterStealth
                      ? Icons.visibility_rounded
                      : Icons.visibility_off_rounded,
                  onPressed: () =>
                      setState(() => _masterStealth = !_masterStealth),
                  gradient: _masterStealth
                      ? const LinearGradient(
                          colors: [Color(0xFF2A2A3A), Color(0xFF1A1A28)],
                        )
                      : AppColors.primaryGradient,
                  glowColor:
                      _masterStealth ? Colors.transparent : AppColors.primary,
                ).animate().fadeIn(delay: 460.ms),
                const SizedBox(height: 28),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMasterToggle() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: _masterStealth
            ? const LinearGradient(
                colors: [Color(0xFF0D1A0D), Color(0xFF0A140A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : AppColors.cardGradient,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _masterStealth
              ? AppColors.success.withOpacity(0.4)
              : AppColors.border,
          width: _masterStealth ? 1.5 : 1,
        ),
        boxShadow: _masterStealth
            ? [
                BoxShadow(
                  color: AppColors.success.withOpacity(0.08),
                  blurRadius: 20,
                )
              ]
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: _masterStealth
                  ? AppColors.success.withOpacity(0.15)
                  : AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.visibility_off_rounded,
              color:
                  _masterStealth ? AppColors.success : AppColors.textTertiary,
              size: 26,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Master Stealth', style: AppTextStyles.titleLarge),
                const SizedBox(height: 3),
                Text(
                  _masterStealth
                      ? 'All stealth features active'
                      : 'Stealth mode is disabled',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
          Switch(
            value: _masterStealth,
            onChanged: (v) => setState(() => _masterStealth = v),
            activeTrackColor: AppColors.success,
            activeColor: Colors.white,
            inactiveThumbColor: AppColors.textTertiary,
            inactiveTrackColor: AppColors.surfaceHighest,
            trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildToggleCard(
    IconData icon,
    String title,
    String subtitle,
    Color color,
    bool value,
    ValueChanged<bool> onChanged, {
    int delay = 0,
  }) {
    return GlassCard(
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: value
                  ? color.withOpacity(0.15)
                  : AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: value ? color : AppColors.textTertiary,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.titleMedium),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: color,
            activeColor: Colors.white,
            inactiveThumbColor: AppColors.textTertiary,
            inactiveTrackColor: AppColors.surfaceHighest,
            trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
          ),
        ],
      ),
    ).animate().fadeIn(
          delay: Duration(milliseconds: delay),
          duration: 350.ms,
        );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.success.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          const Icon(Icons.security_rounded,
              color: AppColors.success, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'When Stealth Mode is active, no visual or audio cues will indicate the app is running in the background.',
              style:
                  AppTextStyles.bodySmall.copyWith(color: AppColors.success),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 420.ms);
  }
}
