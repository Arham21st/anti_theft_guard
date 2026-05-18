import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum StatusType { active, inactive, warning, stealth }

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.type, this.label});

  final StatusType type;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final config = _config(type);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: config.color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: config.color.withOpacity(0.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: config.color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: config.color.withOpacity(0.6), blurRadius: 4),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label ?? config.label,
            style: AppTextStyles.labelSmall.copyWith(
              color: config.color,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  _BadgeConfig _config(StatusType type) {
    switch (type) {
      case StatusType.active:
        return _BadgeConfig(AppColors.success, 'ACTIVE');
      case StatusType.inactive:
        return _BadgeConfig(AppColors.textTertiary, 'INACTIVE');
      case StatusType.warning:
        return _BadgeConfig(AppColors.warning, 'WARNING');
      case StatusType.stealth:
        return _BadgeConfig(AppColors.info, 'STEALTH');
    }
  }
}

class _BadgeConfig {
  final Color color;
  final String label;
  const _BadgeConfig(this.color, this.label);
}

/// Large status chip for the dashboard hero card
class LargeStatusChip extends StatelessWidget {
  const LargeStatusChip({super.key, required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.success : AppColors.textTertiary;
    final label = isActive ? 'PROTECTED' : 'INACTIVE';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelMedium.copyWith(
          color: color,
          fontSize: 13,
          letterSpacing: 2,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
