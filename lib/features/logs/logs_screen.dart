import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/section_header.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});
  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  int _selectedFilter = 0;
  final _filters = ['All', 'Captures', 'Location', 'SMS', 'System'];

  final _logs = const [
    _LogEntry(Icons.camera_front_rounded, 'Front Camera Capture', 'Photo captured silently', '08:32 PM', AppColors.info),
    _LogEntry(Icons.location_on_rounded, 'Location Ping', '24.8607° N, 67.0011° E', '08:15 PM', AppColors.success),
    _LogEntry(Icons.shield_rounded, 'Anti-Theft Activated', 'Trigger: Power × 3', '07:50 PM', AppColors.primary),
    _LogEntry(Icons.camera_rear_rounded, 'Back Camera Capture', 'Surroundings captured', '07:49 PM', AppColors.secondary),
    _LogEntry(Icons.sms_rounded, 'SMS Sent', 'Location sent to +92-XXX', '06:30 PM', AppColors.warning),
    _LogEntry(Icons.visibility_off_rounded, 'Stealth Mode ON', 'All indicators hidden', '06:00 PM', AppColors.info),
    _LogEntry(Icons.restart_alt_rounded, 'System Restarted', 'Auto-start triggered', '05:45 PM', AppColors.textTertiary),
    _LogEntry(Icons.fiber_manual_record_rounded, 'Video Recording', '45s recorded', '05:30 PM', AppColors.danger),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Text('Event Logs', style: AppTextStyles.headlineLarge),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                    ),
                    child: Text('${_logs.length} events',
                        style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Filter chips
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final selected = _selectedFilter == i;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilter = i),
                    child: AnimatedContainer(
                      duration: 200.ms,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.primary : AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected ? AppColors.primary : AppColors.border,
                        ),
                      ),
                      child: Text(
                        _filters[i],
                        style: AppTextStyles.labelMedium.copyWith(
                          color: selected ? Colors.white : AppColors.textSecondary,
                          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SectionHeader(
              title: 'TODAY — MAY 17, 2026',
              padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _logs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) => _LogTile(entry: _logs[i])
                    .animate()
                    .fadeIn(delay: Duration(milliseconds: 60 * i), duration: 300.ms)
                    .slideX(begin: 0.05, end: 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogEntry {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  final Color color;
  const _LogEntry(this.icon, this.title, this.subtitle, this.time, this.color);
}

class _LogTile extends StatelessWidget {
  const _LogTile({required this.entry});
  final _LogEntry entry;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: entry.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(entry.icon, color: entry.color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.title, style: AppTextStyles.titleMedium),
                Text(entry.subtitle, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          Text(entry.time, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}
