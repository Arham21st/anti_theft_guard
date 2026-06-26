import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../models/admin_device.dart';
import '../models/admin_event.dart';

/// Consolidated color utilities for admin module.
/// Provides consistent color mapping for status, severity, and threshold-based values.
/// Replaces duplicate _batteryColor(), _severityColor(), and _eventIcon() functions.
class AdminThresholdColors {
  AdminThresholdColors._();

  // ── Battery Thresholds ────────────────────────────────────────────────────────────

  /// Critical battery level (≤20%)
  static const int batteryCritical = 20;

  /// Warning battery level (≤45%)
  static const int batteryWarning = 45;

  /// Good battery level (>45%)
  static const int batteryGood = 45;

  /// Get color based on battery percentage
  /// - 0-20%: danger (red)
  /// - 21-45%: warning (yellow)
  /// - 46%+: success (green)
  static Color battery(int percentage) {
    if (percentage <= batteryCritical) return AppColors.danger;
    if (percentage <= batteryWarning) return AppColors.warning;
    return AppColors.success;
  }

  /// Get color for battery charging state
  static const Color batteryCharging = AppColors.info;

  /// Get battery status text
  static String getBatteryStatusText(int percentage, {bool isCharging = false}) {
    if (isCharging) return 'Charging';
    if (percentage <= batteryCritical) return 'Critical';
    if (percentage <= batteryWarning) return 'Low';
    return 'Good';
  }

  // ── Severity Colors ───────────────────────────────────────────────────────────────

  /// Get color based on event severity
  static Color severity(AdminSeverity severity) {
    switch (severity) {
      case AdminSeverity.info:
        return AppColors.info;
      case AdminSeverity.success:
        return AppColors.success;
      case AdminSeverity.warning:
        return AppColors.warning;
      case AdminSeverity.critical:
        return AppColors.danger;
    }
  }

  /// Get severity display name
  static String getSeverityDisplayName(AdminSeverity severity) {
    switch (severity) {
      case AdminSeverity.info:
        return 'Info';
      case AdminSeverity.success:
        return 'Success';
      case AdminSeverity.warning:
        return 'Warning';
      case AdminSeverity.critical:
        return 'Critical';
    }
  }

  // ── Device Status Colors ───────────────────────────────────────────────────────────

  /// Get color based on device protection status
  static Color deviceStatus(DeviceProtectionStatus status) {
    switch (status) {
      case DeviceProtectionStatus.protected:
        return AppColors.success;
      case DeviceProtectionStatus.warning:
        return AppColors.warning;
      case DeviceProtectionStatus.offline:
        return AppColors.textTertiary;
      case DeviceProtectionStatus.stolen:
        return AppColors.danger;
    }
  }

  /// Get device status display name
  static String getDeviceStatusDisplayName(DeviceProtectionStatus status) {
    switch (status) {
      case DeviceProtectionStatus.protected:
        return 'Protected';
      case DeviceProtectionStatus.warning:
        return 'Warning';
      case DeviceProtectionStatus.offline:
        return 'Offline';
      case DeviceProtectionStatus.stolen:
        return 'Stolen';
    }
  }

  /// Get icon data based on device status
  static IconData getDeviceStatusIcon(DeviceProtectionStatus status) {
    switch (status) {
      case DeviceProtectionStatus.protected:
        return Icons.shield_rounded;
      case DeviceProtectionStatus.warning:
        return Icons.warning_rounded;
      case DeviceProtectionStatus.offline:
        return Icons.cloud_off_rounded;
      case DeviceProtectionStatus.stolen:
        return Icons.report_rounded;
    }
  }

  // ── Event Type Icons ──────────────────────────────────────────────────────────────

  /// Get icon data based on event type
  static IconData getEventIcon(AdminEventType type) {
    switch (type) {
      case AdminEventType.capture:
        return Icons.camera_alt_rounded;
      case AdminEventType.location:
        return Icons.location_on_rounded;
      case AdminEventType.sms:
        return Icons.sms_rounded;
      case AdminEventType.system:
        return Icons.settings_rounded;
      case AdminEventType.security:
        return Icons.security_rounded;
      case AdminEventType.battery:
        return Icons.battery_alert_rounded;
    }
  }

  /// Get event type display name
  static String getEventTypeDisplayName(AdminEventType type) {
    switch (type) {
      case AdminEventType.capture:
        return 'Capture';
      case AdminEventType.location:
        return 'Location';
      case AdminEventType.sms:
        return 'SMS';
      case AdminEventType.system:
        return 'System';
      case AdminEventType.security:
        return 'Security';
      case AdminEventType.battery:
        return 'Battery';
    }
  }

  // ── Alert/Notification Colors ─────────────────────────────────────────────────────

  /// Get color for alert priority level (0-5 scale)
  static Color alertPriority(int level) {
    if (level >= 4) return AppColors.danger;
    if (level >= 3) return AppColors.warning;
    if (level >= 2) return AppColors.info;
    return AppColors.textSecondary;
  }

  /// Get color for trigger method status
  static Color triggerStatus(String triggerMethod) {
    // Common trigger methods that should be highlighted
    final criticalTriggers = ['sms', 'sim_change', 'wrong_pin'];
    final warningTriggers = ['battery_low', 'location_change'];

    if (criticalTriggers.contains(triggerMethod)) return AppColors.danger;
    if (warningTriggers.contains(triggerMethod)) return AppColors.warning;
    return AppColors.info;
  }

  // ── Status Badge Utilities ────────────────────────────────────────────────────────

  /// Check if status should pulse/animate
  static bool shouldPulse(DeviceProtectionStatus status) {
    return status == DeviceProtectionStatus.stolen;
  }

  /// Check if battery is critical
  static bool isBatteryCritical(int percentage) {
    return percentage <= batteryCritical;
  }

  /// Check if battery is low
  static bool isBatteryLow(int percentage) {
    return percentage <= batteryWarning;
  }

  /// Check if device needs attention
  static bool deviceNeedsAttention(DeviceProtectionStatus status, int battery) {
    return status == DeviceProtectionStatus.stolen ||
        status == DeviceProtectionStatus.warning ||
        isBatteryCritical(battery);
  }

  // ── Composite Status Colors ────────────────────────────────────────────────────────

  /// Get overall health color combining device status and battery
  static Color overallHealth({
    required DeviceProtectionStatus status,
    required int battery,
  }) {
    // Stolen always takes priority
    if (status == DeviceProtectionStatus.stolen) return AppColors.danger;

    // Critical battery takes next priority
    if (isBatteryCritical(battery)) return AppColors.danger;

    // Warning status
    if (status == DeviceProtectionStatus.warning) return AppColors.warning;

    // Low battery
    if (isBatteryLow(battery)) return AppColors.warning;

    // Offline device
    if (status == DeviceProtectionStatus.offline) return AppColors.textTertiary;

    // Everything is good
    return AppColors.success;
  }

  // ── Gradient Utilities ─────────────────────────────────────────────────────────────

  /// Get appropriate gradient for a status
  static LinearGradient getStatusGradient(Color statusColor) {
    if (statusColor == AppColors.danger) {
      return const LinearGradient(
        colors: [AppColors.danger, Color(0xFFCC0000)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    if (statusColor == AppColors.warning) return AppColors.warningGradient;
    if (statusColor == AppColors.success) return AppColors.successGradient;
    return AppColors.primaryGradient;
  }

  // ── Debug/Utilities ────────────────────────────────────────────────────────────────

  /// Get CSS-like color string for web (if needed)
  static String toCssColor(Color color) {
    return '#${color.toARGB32().toRadixString(16).padLeft(8, '0')}';
  }

  /// Get opacity-adjusted color for backgrounds
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }

  /// Get semi-transparent version of status color (for backgrounds)
  static Color statusBackground(Color statusColor) {
    return statusColor.withValues(alpha: 0.15); // 15% opacity
  }

  /// Get border version of status color
  static Color statusBorder(Color statusColor) {
    return statusColor.withValues(alpha: 0.4); // 40% opacity
  }
}

// ── Extension Methods for Convenience ────────────────────────────────────────────────

/// Extension on Color for additional admin-specific utilities
extension AdminColorExtension on Color {
  /// Get background opacity version of this color
  Color toBackground() {
    return AdminThresholdColors.statusBackground(this);
  }

  /// Get border opacity version of this color
  Color toBorder() {
    return AdminThresholdColors.statusBorder(this);
  }
}

/// Extension on AdminSeverity for quick color access
extension AdminSeverityExtension on AdminSeverity {
  /// Get the color for this severity
  Color get color => AdminThresholdColors.severity(this);

  /// Get the display name for this severity
  String get displayName => AdminThresholdColors.getSeverityDisplayName(this);
}

/// Extension on DeviceProtectionStatus for quick color access
extension DeviceProtectionStatusExtension on DeviceProtectionStatus {
  /// Get the color for this status
  Color get color => AdminThresholdColors.deviceStatus(this);

  /// Get the display name for this status
  String get displayName => AdminThresholdColors.getDeviceStatusDisplayName(this);

  /// Get the icon for this status
  IconData get icon => AdminThresholdColors.getDeviceStatusIcon(this);

  /// Check if this status should pulse
  bool get shouldPulse => AdminThresholdColors.shouldPulse(this);
}

/// Extension on AdminEventType for quick icon access
extension AdminEventTypeExtension on AdminEventType {
  /// Get the icon for this event type
  IconData get icon => AdminThresholdColors.getEventIcon(this);

  /// Get the display name for this event type
  String get displayName => AdminThresholdColors.getEventTypeDisplayName(this);
}
