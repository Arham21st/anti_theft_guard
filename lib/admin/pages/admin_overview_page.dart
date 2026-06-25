import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
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
              device: selectedDevice,
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
