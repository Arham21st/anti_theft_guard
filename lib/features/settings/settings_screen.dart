import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/glow_button.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
                child: Text('Settings', style: AppTextStyles.headlineLarge),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SectionHeader(title: 'SECURITY'),
                  ..._buildSection(context, [
                    _SettingItem(Icons.touch_app_rounded, 'Trigger Settings', 'Configure secret trigger', AppColors.primary, AppRoutes.triggerSettings),
                    _SettingItem(Icons.visibility_off_rounded, 'Stealth Mode', 'App visibility & sounds', AppColors.info, AppRoutes.stealthMode),
                    _SettingItem(Icons.brightness_1_rounded, 'Blackout Screen', 'Decoy dead screen', AppColors.textSecondary, AppRoutes.blackoutPreview),
                    _SettingItem(Icons.restart_alt_rounded, 'Auto-Start on Reboot', 'Boot persistence', AppColors.success, AppRoutes.autoStart),
                  ]),
                  const SectionHeader(title: 'SURVEILLANCE'),
                  ..._buildSection(context, [
                    _SettingItem(Icons.camera_front_rounded, 'Front Camera', 'Secret photo capture', AppColors.secondary, AppRoutes.frontCamera),
                    _SettingItem(Icons.camera_rear_rounded, 'Back Camera', 'Surroundings capture', AppColors.warning, AppRoutes.backCamera),
                    _SettingItem(Icons.fiber_manual_record_rounded, 'Video Recording', 'Silent background recording', AppColors.danger, AppRoutes.videoRecording),
                  ]),
                  const SectionHeader(title: 'LOCATION & COMMUNICATION'),
                  ..._buildSection(context, [
                    _SettingItem(Icons.location_on_rounded, 'Live GPS Location', 'Real-time tracking', AppColors.info, AppRoutes.liveLocation),
                    _SettingItem(Icons.history_rounded, 'Location History', 'Movement records', AppColors.info, AppRoutes.locationHistory),
                    _SettingItem(Icons.battery_full_rounded, 'Battery Monitor', 'Power level tracking', AppColors.success, AppRoutes.batteryMonitor),
                    _SettingItem(Icons.sms_rounded, 'Emergency SMS', 'Offline backup system', AppColors.warning, AppRoutes.emergencySms),
                  ]),
                  const SectionHeader(title: 'APP INFO'),
                  GlassCard(
                    child: Column(
                      children: [
                        _infoRow('App Version', 'v1.0.0 Alpha'),
                        const Divider(color: AppColors.border, height: 20),
                        _infoRow('Build', '2026.05.17'),
                        const Divider(color: AppColors.border, height: 20),
                        _infoRow('Mode', 'Alpha (UI Demo)'),
                      ],
                    ),
                  ).animate().fadeIn(delay: 400.ms),
                  const SizedBox(height: 20),
                  OutlineButton(
                    label: 'Reset All Settings',
                    onPressed: () => _showResetDialog(context),
                    borderColor: AppColors.danger.withOpacity(0.5),
                    textColor: AppColors.danger,
                  ).animate().fadeIn(delay: 500.ms),
                  const SizedBox(height: 28),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      children: [
        Text(label, style: AppTextStyles.bodyMedium),
        const Spacer(),
        Text(value, style: AppTextStyles.labelLarge),
      ],
    );
  }

  List<Widget> _buildSection(BuildContext context, List<_SettingItem> items) {
    return items.asMap().entries.map((e) {
      final item = e.value;
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FeatureCard(
          icon: item.icon,
          title: item.title,
          subtitle: item.subtitle,
          iconColor: item.color,
          iconBgColor: item.color.withOpacity(0.12),
          onTap: () => Navigator.pushNamed(context, item.route),
        ).animate().fadeIn(delay: Duration(milliseconds: 60 * e.key + 100), duration: 350.ms),
      );
    }).toList();
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surfaceElevated,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Reset Settings?', style: AppTextStyles.headlineSmall),
        content: Text('This will reset all configurations to default. This action cannot be undone.',
            style: AppTextStyles.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Reset', style: AppTextStyles.labelLarge.copyWith(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }
}

class _SettingItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final String route;
  const _SettingItem(this.icon, this.title, this.subtitle, this.color, this.route);
}
