import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../data/admin_mock_data.dart';
import '../models/admin_device.dart';
import '../models/admin_event.dart';
import '../widgets/admin_data_table.dart';
import '../widgets/admin_status_badge.dart';
import '../widgets/admin_ui_components.dart';

class AdminLogsPage extends StatefulWidget {
  const AdminLogsPage({super.key, required this.selectedDevice});

  final AdminDevice selectedDevice;

  @override
  State<AdminLogsPage> createState() => _AdminLogsPageState();
}

class _AdminLogsPageState extends State<AdminLogsPage> {
  String _filter = 'All';

  static const _filters = ['All', 'Captures', 'Location', 'SMS', 'System'];

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

  AdminDevice _deviceById(String id) {
    return AdminMockData.devices.firstWhere(
      (device) => device.id == id,
      orElse: () => AdminMockData.devices.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    final events = AdminMockData.events.where((event) {
      if (_filter == 'All') return true;
      if (_filter == 'Captures') return event.type == AdminEventType.capture;
      if (_filter == 'Location') return event.type == AdminEventType.location;
      if (_filter == 'SMS') return event.type == AdminEventType.sms;
      return event.type == AdminEventType.system ||
          event.type == AdminEventType.security ||
          event.type == AdminEventType.battery;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AdminPageHeader(
          title: 'Alerts & Logs',
          subtitle:
              'Chronological security activity across all static demo devices.',
          actions: [
            AdminSearchField(hint: 'Search events'),
            AdminIconButton(
              icon: Icons.file_download_outlined,
              tooltip: 'Export event logs',
            ),
          ],
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _filters.map((filter) {
            final selected = _filter == filter;
            return ChoiceChip(
              label: Text(filter),
              selected: selected,
              selectedColor: AppColors.primary.withOpacity(0.18),
              backgroundColor: AppColors.surface,
              side: BorderSide(
                color: selected ? AppColors.primary : AppColors.border,
              ),
              labelStyle: AdminTextStyles.label.copyWith(
                color: selected ? AppColors.primary : AppColors.textSecondary,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
              onSelected: (_) => setState(() => _filter = filter),
            );
          }).toList(),
        ),
        const SizedBox(height: 18),
        AdminPanel(
          header: 'Event stream',
          padding: const EdgeInsets.only(top: 16),
          child: AdminDataTable(
            columns: const [
              DataColumn(label: Text('Event')),
              DataColumn(label: Text('Description')),
              DataColumn(label: Text('Device')),
              DataColumn(label: Text('Severity')),
              DataColumn(label: Text('Time')),
            ],
            rows: events.map((event) {
              final device = _deviceById(event.deviceId);
              final color = _severityColor(event.severity);
              return DataRow(
                cells: [
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_eventIcon(event.type), color: color, size: 18),
                        const SizedBox(width: 8),
                        Text(event.title),
                      ],
                    ),
                  ),
                  DataCell(Text(event.description)),
                  DataCell(Text(device.deviceName)),
                  DataCell(AdminStatusBadge.severity(severity: event.severity)),
                  DataCell(Text(event.time)),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
