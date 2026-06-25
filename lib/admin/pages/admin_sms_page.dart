import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../data/admin_mock_data.dart';
import '../models/admin_device.dart';
import '../models/admin_event.dart';
import '../widgets/admin_data_table.dart';
import '../widgets/admin_shared_components.dart';
import '../widgets/admin_status_badge.dart';
import '../widgets/admin_ui_components.dart';

class AdminSmsPage extends StatelessWidget {
  const AdminSmsPage({super.key, required this.selectedDevice});

  final AdminDevice selectedDevice;

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
    return Icons.sms_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final contacts = AdminMockData.contacts
        .where((contact) => contact.deviceId == selectedDevice.id)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AdminPageHeader(
          title: 'Emergency SMS',
          subtitle:
              'Trusted contacts, payload preview, and static delivery history for ${selectedDevice.deviceName}.',
          actions: [
            AdminPrimaryButton(
              label: 'Send Test SMS',
              icon: Icons.send_rounded,
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 22),
        AdminResponsiveGrid(
          minItemWidth: 420,
          maxColumns: 2,
          children: [
            AdminPanel(
              header: 'Trusted contacts',
              padding: const EdgeInsets.only(top: 16),
              child: contacts.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(18.0),
                      child: AdminEmptyState(
                        icon: Icons.person_off_outlined,
                        title: 'No contacts on this device',
                        subtitle: 'Demo contacts are attached to other devices.',
                      ),
                    )
                  : AdminDataTable(
                      columns: const [
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Relationship')),
                        DataColumn(label: Text('Phone')),
                        DataColumn(label: Text('Status')),
                      ],
                      rows: contacts.map((contact) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AdminAvatar(name: contact.name),
                                  const SizedBox(width: 8),
                                  Text(contact.name),
                                ],
                              ),
                            ),
                            DataCell(Text(contact.relationship)),
                            DataCell(
                              Text(contact.phone, style: AdminTextStyles.mono),
                            ),
                            DataCell(
                              AdminStatusBadge.custom(
                                label: contact.enabled ? 'Enabled' : 'Off',
                                color: contact.enabled ? AppColors.success : AppColors.textTertiary,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
            ),
            const AdminPanel(
              header: 'Message payload',
              child: Column(
                children: [
                  AdminToggleRow(
                    title: 'GPS location link',
                    subtitle: 'Include current Google Maps URL',
                    icon: Icons.location_on_rounded,
                    color: AppColors.info,
                    initialValue: true,
                  ),
                  SizedBox(height: 14),
                  AdminToggleRow(
                    title: 'Battery status',
                    subtitle: 'Include battery percent and charging state',
                    icon: Icons.battery_charging_full_rounded,
                    color: AppColors.success,
                    initialValue: true,
                  ),
                  SizedBox(height: 14),
                  AdminToggleRow(
                    title: 'Remote wipe code',
                    subtitle: 'Show emergency wipe instructions',
                    icon: Icons.delete_forever_outlined,
                    color: AppColors.danger,
                    initialValue: false,
                  ),
                  SizedBox(height: 18),
                  _SmsPreview(),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        AdminPanel(
          header: 'Delivery history',
          padding: const EdgeInsets.only(top: 16),
          child: AdminDataTable(
            columns: const [
              DataColumn(label: Text('Event')),
              DataColumn(label: Text('Description')),
              DataColumn(label: Text('Severity')),
              DataColumn(label: Text('Time')),
            ],
            rows: AdminMockData.events
                .where((event) => event.type == AdminEventType.sms)
                .map((event) {
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

class _SmsPreview extends StatelessWidget {
  const _SmsPreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        'ANTI-THEFT ALERT\nMy phone was marked stolen.\nLoc: https://maps.google.com/?q=24.8607,67.0011\nBattery: 42% discharging\nDo not call. Silent mode is active.',
        style: AdminTextStyles.body.copyWith(color: AppColors.textPrimary),
      ),
    );
  }
}
