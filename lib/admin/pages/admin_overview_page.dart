import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../auth/user_role.dart';
import '../auth/web_auth_state.dart';
import '../data/admin_mock_data.dart';
import '../models/admin_device.dart';
import '../models/admin_event.dart';
import '../widgets/admin_data_table.dart';
import '../widgets/admin_shared_components.dart';
import '../widgets/admin_stat_card.dart';
import '../widgets/admin_status_badge.dart';
import '../widgets/admin_ui_components.dart';

class AdminOverviewPage extends StatelessWidget {
  const AdminOverviewPage({
    super.key,
    required this.selectedDevice,
    required this.onNavigate,
  });

  final AdminDevice selectedDevice;
  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    // Role-aware: end-users get a personal dashboard; admins get the fleet view.
    final role = WebAuthProvider.of(context).role;
    if (role == UserRole.user) {
      return _UserOverview(device: selectedDevice, onNavigate: onNavigate);
    }
    return _AdminFleetOverview(
        device: selectedDevice, onNavigate: onNavigate);
  }
}

// ── User (single personal device) overview ────────────────────────────────────

class _UserOverview extends StatelessWidget {
  const _UserOverview({required this.device, required this.onNavigate});

  final AdminDevice device;
  final ValueChanged<int> onNavigate;

  Color _batteryColor(int value) {
    if (value <= 20) return AppColors.danger;
    if (value <= 45) return AppColors.warning;
    return AppColors.success;
  }

  @override
  Widget build(BuildContext context) {
    final isStolen = device.status == DeviceProtectionStatus.stolen;
    final myEvents = AdminMockData.events
        .where((e) => e.deviceId == device.id)
        .take(5)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AdminPageHeader(
          title: 'Your device',
          subtitle:
              'Track and review data for your ${device.model}. Demo data is shown.',
          actions: [
            AdminPrimaryButton(
              label: 'View Location',
              icon: Icons.location_on_rounded,
              onPressed: () => onNavigate(3),
              color: AppColors.success,
            ),
            AdminPrimaryButton(
              label: 'Surveillance',
              icon: Icons.videocam_rounded,
              onPressed: () => onNavigate(2),
              color: AppColors.info,
            ),
          ],
        ),
        const SizedBox(height: 22),
        // Hero status banner — prominent when the phone is stolen.
        _DeviceStatusBanner(device: device),
        const SizedBox(height: 18),
        AdminResponsiveGrid(
          minItemWidth: 200,
          children: [
            AdminStatCard(
              icon: Icons.battery_charging_full_rounded,
              label: 'Battery',
              value: '${device.batteryLevel}%',
              change: device.batteryLevel <= 20 ? 'Low battery' : 'Healthy',
              color: _batteryColor(device.batteryLevel),
            ),
            AdminStatCard(
              icon: Icons.location_on_rounded,
              label: 'Last location',
              value: device.location,
              change: device.lastSeen,
              color: AppColors.info,
            ),
            AdminStatCard(
              icon: Icons.photo_camera_rounded,
              label: 'Photos captured',
              value: '${device.capturedPhotos}',
              change: 'Intruder evidence',
              color: AppColors.secondary,
            ),
            AdminStatCard(
              icon: Icons.videocam_rounded,
              label: 'Video recordings',
              value: '${device.recordings}',
              change: 'Silent clips',
              color: AppColors.danger,
            ),
          ],
        ),
        const SizedBox(height: 18),
        AdminResponsiveGrid(
          minItemWidth: 420,
          maxColumns: 2,
          children: [
            AdminPanel(
              header: 'Device details',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AdminDeviceIdentity(device: device),
                  const SizedBox(height: 14),
                  AdminInfoLine(label: 'Model', value: device.model),
                  const SizedBox(height: 8),
                  AdminInfoLine(label: 'Coordinates', value: device.coordinates),
                  const SizedBox(height: 8),
                  AdminInfoLine(label: 'Trigger', value: device.triggerMethod),
                  const SizedBox(height: 8),
                  AdminInfoLine(
                      label: 'Stealth',
                      value: device.stealthEnabled ? 'Enabled' : 'Disabled'),
                ],
              ),
            ),
            _RecentActivityPanel(
              events: myEvents,
              onOpenLogs: () => onNavigate(4),
            ),
          ],
        ),
        const SizedBox(height: 18),
        if (isStolen)
          AdminPanel(
            header: 'Recommended actions',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                AdminPrimaryButton(
                  label: 'See latest location',
                  icon: Icons.map_rounded,
                  onPressed: () => onNavigate(3),
                ),
                AdminPrimaryButton(
                  label: 'Review captures',
                  icon: Icons.camera_alt_rounded,
                  onPressed: () => onNavigate(2),
                  color: AppColors.info,
                ),
                AdminPrimaryButton(
                  label: 'Send emergency SMS',
                  icon: Icons.sms_rounded,
                  onPressed: () => onNavigate(6),
                  color: AppColors.warning,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _DeviceStatusBanner extends StatelessWidget {
  const _DeviceStatusBanner({required this.device});

  final AdminDevice device;

  Color _color(DeviceProtectionStatus status) {
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

  IconData _icon(DeviceProtectionStatus status) {
    switch (status) {
      case DeviceProtectionStatus.protected:
        return Icons.shield_rounded;
      case DeviceProtectionStatus.warning:
        return Icons.warning_amber_rounded;
      case DeviceProtectionStatus.offline:
        return Icons.cloud_off_rounded;
      case DeviceProtectionStatus.stolen:
        return Icons.report_gmailerrorred_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color(device.status);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(_icon(device.status), color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(device.deviceName, style: AdminTextStyles.cardTitle),
                const SizedBox(height: 3),
                Text(
                  device.status == DeviceProtectionStatus.stolen
                      ? 'This device is flagged stolen. Tracking and surveillance remain active.'
                      : device.status == DeviceProtectionStatus.offline
                          ? 'This device is currently offline. Last seen ${device.lastSeen}.'
                          : 'Anti-theft protection is active and monitoring.',
                  style: AdminTextStyles.small,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          AdminStatusBadge.device(status: device.status),
        ],
      ),
    );
  }
}

// ── Admin (fleet) overview — the original dashboard ───────────────────────────

class _AdminFleetOverview extends StatelessWidget {
  const _AdminFleetOverview({required this.device, required this.onNavigate});

  final AdminDevice device;
  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    final devices = AdminMockData.devices;
    final protectedCount = devices
        .where((device) => device.status == DeviceProtectionStatus.protected)
        .length;
    final criticalEvents = AdminMockData.events
        .where((event) => event.severity == AdminSeverity.critical)
        .length;
    final smsAlerts = devices.fold<int>(
      0,
      (sum, device) => sum + device.smsAlerts,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AdminPageHeader(
          title: 'Security Operations',
          subtitle:
              'Static multi-device command center for Anti-Theft Guard web administration.',
          actions: [
            AdminPrimaryButton(
              label: 'View Devices',
              icon: Icons.devices_rounded,
              onPressed: () => onNavigate(1),
            ),
            const AdminIconButton(
              icon: Icons.file_download_outlined,
              tooltip: 'Export demo report',
            ),
          ],
        ),
        const SizedBox(height: 22),
        AdminResponsiveGrid(
          minItemWidth: 220,
          children: [
            AdminStatCard(
              icon: Icons.devices_rounded,
              label: 'Total devices',
              value: '${devices.length}',
              change: 'All demo devices',
              color: AppColors.info,
            ),
            AdminStatCard(
              icon: Icons.shield_rounded,
              label: 'Protected',
              value: '$protectedCount',
              change: 'Monitoring active',
              color: AppColors.success,
            ),
            AdminStatCard(
              icon: Icons.report_gmailerrorred_rounded,
              label: 'Critical alerts',
              value: '$criticalEvents',
              change: 'Needs attention',
              color: AppColors.danger,
            ),
            AdminStatCard(
              icon: Icons.sms_rounded,
              label: 'SMS alerts',
              value: '$smsAlerts',
              change: 'Emergency payloads',
              color: AppColors.warning,
            ),
          ],
        ),
        const SizedBox(height: 18),
        AdminResponsiveGrid(
          minItemWidth: 420,
          maxColumns: 2,
          children: [
            _FleetStatusPanel(devices: devices),
            _RecentActivityPanel(
              events: AdminMockData.events.take(5).toList(),
              onOpenLogs: () => onNavigate(4),
            ),
          ],
        ),
        const SizedBox(height: 18),
        AdminResponsiveGrid(
          minItemWidth: 460,
          maxColumns: 2,
          children: [
            _HighRiskDevicesTable(devices: devices),
            _SelectedDeviceSummary(
              device: device,
              onOpenSurveillance: () => onNavigate(2),
              onOpenLocation: () => onNavigate(3),
            ),
          ],
        ),
      ],
    );
  }
}

class _FleetStatusPanel extends StatelessWidget {
  const _FleetStatusPanel({required this.devices});

  final List<AdminDevice> devices;

  Color _statusColor(DeviceProtectionStatus status) {
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

  @override
  Widget build(BuildContext context) {
    final statuses = DeviceProtectionStatus.values;
    return AdminPanel(
      header: 'Fleet protection status',
      child: Column(
        children: statuses.map((status) {
          final count = devices
              .where((device) => device.status == status)
              .length;
          final color = _statusColor(status);
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              children: [
                SizedBox(
                  width: 88,
                  child: AdminStatusBadge.device(status: status),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: devices.isEmpty ? 0 : count / devices.length,
                      minHeight: 8,
                      color: color,
                      backgroundColor: AppColors.surfaceElevated,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text('$count', style: AdminTextStyles.label),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _RecentActivityPanel extends StatelessWidget {
  const _RecentActivityPanel({required this.events, required this.onOpenLogs});

  final List<AdminEvent> events;
  final VoidCallback onOpenLogs;

  Color _severityColor(AdminSeverity severity) {
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

  IconData _eventIcon(AdminEventType type) {
    switch (type) {
      case AdminEventType.capture:
        return Icons.camera_alt_rounded;
      case AdminEventType.location:
        return Icons.location_on_rounded;
      case AdminEventType.sms:
        return Icons.sms_rounded;
      case AdminEventType.system:
        return Icons.restart_alt_rounded;
      case AdminEventType.security:
        return Icons.shield_rounded;
      case AdminEventType.battery:
        return Icons.battery_charging_full_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminPanel(
      header: 'Recent activity',
      trailing: TextButton(
        onPressed: onOpenLogs,
        child: Text(
          'Open logs',
          style: AdminTextStyles.label.copyWith(color: AppColors.info),
        ),
      ),
      child: Column(
        children: events.map((event) {
          final color = _severityColor(event.severity);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(_eventIcon(event.type), color: color, size: 19),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              event.title,
                              style: AdminTextStyles.cardTitle,
                            ),
                          ),
                          AdminStatusBadge.severity(severity: event.severity),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(event.description, style: AdminTextStyles.small),
                      const SizedBox(height: 4),
                      Text(
                        event.time,
                        style: AdminTextStyles.small.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _HighRiskDevicesTable extends StatelessWidget {
  const _HighRiskDevicesTable({required this.devices});

  final List<AdminDevice> devices;

  @override
  Widget build(BuildContext context) {
    final risky = devices
        .where(
          (device) =>
              device.status == DeviceProtectionStatus.warning ||
              device.status == DeviceProtectionStatus.stolen ||
              device.status == DeviceProtectionStatus.offline,
        )
        .toList();

    return AdminPanel(
      header: 'High-risk devices',
      padding: const EdgeInsets.only(top: 16),
      child: AdminDataTable(
        columns: const [
          DataColumn(label: Text('User')),
          DataColumn(label: Text('Model')),
          DataColumn(label: Text('Status')),
        ],
        rows: risky.map((device) {
          return DataRow(
            cells: [
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AdminAvatar(name: device.ownerName),
                    const SizedBox(width: 8),
                    Text(device.ownerName),
                  ],
                ),
              ),
              DataCell(Text(device.model)),
              DataCell(AdminStatusBadge.device(status: device.status)),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _SelectedDeviceSummary extends StatelessWidget {
  const _SelectedDeviceSummary({
    required this.device,
    required this.onOpenSurveillance,
    required this.onOpenLocation,
  });

  final AdminDevice device;
  final VoidCallback onOpenSurveillance;
  final VoidCallback onOpenLocation;

  Color _batteryColor(int value) {
    if (value <= 20) return AppColors.danger;
    if (value <= 45) return AppColors.warning;
    return AppColors.success;
  }

  @override
  Widget build(BuildContext context) {
    return AdminPanel(
      header: 'Selected device snapshot',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminDeviceIdentity(device: device),
          const SizedBox(height: 16),
          AdminMetricGrid(
            metrics: [
              AdminMetricData(
                'Battery',
                '${device.batteryLevel}%',
                _batteryColor(device.batteryLevel),
              ),
              AdminMetricData('Photos', '${device.capturedPhotos}', AppColors.info),
              AdminMetricData('Videos', '${device.recordings}', AppColors.danger),
              AdminMetricData('SMS', '${device.smsAlerts}', AppColors.warning),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              AdminPrimaryButton(
                label: 'Surveillance',
                icon: Icons.videocam_rounded,
                onPressed: onOpenSurveillance,
                color: AppColors.info,
              ),
              AdminPrimaryButton(
                label: 'Location',
                icon: Icons.location_on_rounded,
                onPressed: onOpenLocation,
                color: AppColors.success,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
