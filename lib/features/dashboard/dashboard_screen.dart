import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/pulse_indicator.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/widgets/section_header.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isProtected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildHeroCard(),
                _buildQuickStats(),
                const SectionHeader(title: 'SECURITY FEATURES'),
                _buildFeatureGrid(),
                const SectionHeader(title: 'EMERGENCY BACKUP'),
                _buildSmsCard(),
                const SizedBox(height: 24),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: AppColors.background,
      floating: true,
      pinned: false,
      elevation: 0,
      toolbarHeight: 64,
      flexibleSpace: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Good Evening', style: AppTextStyles.bodySmall),
                  Text('Security Center', style: AppTextStyles.headlineMedium),
                ],
              ),
              const Spacer(),
              // Notification bell
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(Icons.notifications_outlined,
                        color: AppColors.textSecondary, size: 20),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroCard() {
    return GlassCard(
      glowColor: _isProtected ? AppColors.success : AppColors.primary,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          ShieldPulse(isActive: _isProtected, size: 90)
              .animate()
              .fadeIn(duration: 600.ms),
          const SizedBox(height: 16),
          LargeStatusChip(isActive: _isProtected),
          const SizedBox(height: 12),
          Text(
            _isProtected
                ? 'Your device is being monitored'
                : 'Anti-theft is not active',
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          // Master toggle row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.power_settings_new_rounded,
                    color: AppColors.textSecondary, size: 18),
                const SizedBox(width: 10),
                Text('Anti-Theft Mode', style: AppTextStyles.titleMedium),
                const Spacer(),
                Switch(
                  value: _isProtected,
                  onChanged: (v) => setState(() => _isProtected = v),
                  activeColor: Colors.white,
                  activeTrackColor: AppColors.success,
                  inactiveThumbColor: AppColors.textTertiary,
                  inactiveTrackColor: AppColors.surfaceHighest,
                  trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildQuickStats() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          _StatChip(
            icon: Icons.battery_charging_full_rounded,
            label: '72%',
            sublabel: 'Battery',
            color: AppColors.success,
          ),
          const SizedBox(width: 10),
          _StatChip(
            icon: Icons.location_on_rounded,
            label: 'Active',
            sublabel: 'GPS',
            color: AppColors.info,
          ),
          const SizedBox(width: 10),
          _StatChip(
            icon: Icons.camera_alt_rounded,
            label: '3 Pics',
            sublabel: 'Captured',
            color: AppColors.secondary,
          ),
          const SizedBox(width: 10),
          _StatChip(
            icon: Icons.visibility_off_rounded,
            label: 'ON',
            sublabel: 'Stealth',
            color: AppColors.primary,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 500.ms);
  }

  Widget _buildFeatureGrid() {
    final features = [
      _FeatureData(Icons.touch_app_rounded, 'Trigger', 'Power × 3',
          AppColors.primary, AppRoutes.triggerSettings),
      _FeatureData(Icons.remove_red_eye_rounded, 'Stealth Mode', 'Active',
          AppColors.info, AppRoutes.stealthMode),
      _FeatureData(Icons.restart_alt_rounded, 'Auto-Start', 'Enabled',
          AppColors.success, AppRoutes.autoStart),
      _FeatureData(Icons.camera_front_rounded, 'Front Camera', '3 captured',
          AppColors.secondary, AppRoutes.frontCamera),
      _FeatureData(Icons.camera_rear_rounded, 'Back Camera', 'Ready',
          AppColors.warning, AppRoutes.backCamera),
      _FeatureData(Icons.fiber_manual_record_rounded, 'Video Record', 'Idle',
          AppColors.danger, AppRoutes.videoRecording),
      _FeatureData(Icons.battery_full_rounded, 'Battery', '72%',
          AppColors.success, AppRoutes.batteryMonitor),
      _FeatureData(Icons.sms_rounded, 'SMS Backup', 'Ready',
          AppColors.info, AppRoutes.emergencySms),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.45,
      ),
      itemCount: features.length,
      itemBuilder: (_, i) => _FeatureGridCard(data: features[i])
          .animate()
          .fadeIn(delay: Duration(milliseconds: 100 * i), duration: 400.ms)
          .slideY(begin: 0.2, end: 0),
    );
  }

  Widget _buildSmsCard() {
    return GlassCard(
      onTap: () => Navigator.pushNamed(context, AppRoutes.emergencySms),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: AppColors.warningGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.sms_outlined, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Emergency SMS Backup', style: AppTextStyles.titleLarge),
                Text('Last sent: Never', style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          StatusBadge(type: StatusType.active, label: 'READY'),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms, duration: 500.ms);
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String sublabel;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 4),
            Text(label,
                style: AppTextStyles.labelLarge.copyWith(
                    color: color, fontSize: 11),
                overflow: TextOverflow.ellipsis),
            Text(sublabel, style: AppTextStyles.labelSmall),
          ],
        ),
      ),
    );
  }
}

class _FeatureData {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final String route;
  const _FeatureData(
      this.icon, this.title, this.subtitle, this.color, this.route);
}

class _FeatureGridCard extends StatelessWidget {
  const _FeatureGridCard({required this.data});

  final _FeatureData data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, data.route),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: data.color.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: data.color.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: data.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(data.icon, color: data.color, size: 20),
            ),
            const Spacer(),
            Text(data.title,
                style: AppTextStyles.titleMedium,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 2),
            Text(data.subtitle, style: AppTextStyles.bodySmall),
          ],
        ),
      ),
    );
  }
}
