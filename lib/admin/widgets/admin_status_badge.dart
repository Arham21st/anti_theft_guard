import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../models/admin_device.dart';
import '../models/admin_event.dart';
import 'admin_ui_components.dart';

class AdminStatusBadge extends StatelessWidget {
  AdminStatusBadge.device({super.key, required DeviceProtectionStatus status})
    : label = _DeviceStatusConfig.fromStatus(status).label,
      color = _DeviceStatusConfig.fromStatus(status).color;

  AdminStatusBadge.severity({super.key, required AdminSeverity severity})
    : label = _SeverityConfig.fromSeverity(severity).label,
      color = _SeverityConfig.fromSeverity(severity).color;

  const AdminStatusBadge.custom({
    super.key,
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.11),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: AdminTextStyles.label.copyWith(color: color, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _DeviceStatusConfig {
  const _DeviceStatusConfig(this.label, this.color);

  final String label;
  final Color color;

  static _DeviceStatusConfig fromStatus(DeviceProtectionStatus status) {
    switch (status) {
      case DeviceProtectionStatus.protected:
        return const _DeviceStatusConfig('Protected', AppColors.success);
      case DeviceProtectionStatus.warning:
        return const _DeviceStatusConfig('Warning', AppColors.warning);
      case DeviceProtectionStatus.offline:
        return const _DeviceStatusConfig('Offline', AppColors.textTertiary);
      case DeviceProtectionStatus.stolen:
        return const _DeviceStatusConfig('Stolen', AppColors.danger);
    }
  }
}

class _SeverityConfig {
  const _SeverityConfig(this.label, this.color);

  final String label;
  final Color color;

  static _SeverityConfig fromSeverity(AdminSeverity severity) {
    switch (severity) {
      case AdminSeverity.info:
        return const _SeverityConfig('Info', AppColors.info);
      case AdminSeverity.success:
        return const _SeverityConfig('Success', AppColors.success);
      case AdminSeverity.warning:
        return const _SeverityConfig('Warning', AppColors.warning);
      case AdminSeverity.critical:
        return const _SeverityConfig('Critical', AppColors.danger);
    }
  }
}
