import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../data/admin_mock_data.dart';
import '../models/admin_device.dart';
import '../widgets/admin_data_table.dart';
import '../widgets/admin_shared_components.dart';
import '../widgets/admin_status_badge.dart';
import '../widgets/admin_ui_components.dart';

class AdminDevicesPage extends StatelessWidget {
  const AdminDevicesPage({
    super.key,
    required this.selectedDevice,
    required this.onDeviceSelected,
  });

  final AdminDevice selectedDevice;
  final ValueChanged<AdminDevice> onDeviceSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AdminPageHeader(
          title: 'Devices & Users',
          subtitle:
              'Browse static user devices, protection states, battery levels, and last known locations.',
          actions: [
            AdminSearchField(hint: 'Search users or devices'),
            AdminIconButton(
              icon: Icons.filter_list_rounded,
              tooltip: 'Filter devices',
            ),
          ],
        ),
        const SizedBox(height: 22),
        AdminPanel(
          header: 'Device inventory',
          trailing: AdminStatusBadge.custom(
            label: '${AdminMockData.devices.length} devices',
            color: AppColors.info,
          ),
          padding: const EdgeInsets.only(top: 16),
          child: _DevicesTable(
            devices: AdminMockData.devices,
            selectedDevice: selectedDevice,
            onDeviceSelected: onDeviceSelected,
          ),
        ),
        const SizedBox(height: 18),
        _DeviceDetailPanel(device: selectedDevice),
      ],
    );
  }
}

class _DevicesTable extends StatelessWidget {
  const _DevicesTable({
    required this.devices,
    required this.selectedDevice,
    required this.onDeviceSelected,
  });

  final List<AdminDevice> devices;
  final AdminDevice selectedDevice;
  final ValueChanged<AdminDevice> onDeviceSelected;

  Color _batteryColor(int value) {
    if (value <= 20) return AppColors.danger;
    if (value <= 45) return AppColors.warning;
    return AppColors.success;
  }

  @override
  Widget build(BuildContext context) {
    return AdminDataTable(
      columns: const [
        DataColumn(label: Text('User')),
        DataColumn(label: Text('Device Model')),
        DataColumn(label: Text('Status')),
        DataColumn(label: Text('Battery')),
        DataColumn(label: Text('Location')),
        DataColumn(label: Text('Last Seen')),
        DataColumn(label: Text('Stealth')),
      ],
      rows: devices.map((device) {
        final selected = device.id == selectedDevice.id;
        return DataRow(
          selected: selected,
          onSelectChanged: (_) => onDeviceSelected(device),
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
            DataCell(Text(device.deviceName)),
            DataCell(AdminStatusBadge.device(status: device.status)),
            DataCell(
              Text(
                '${device.batteryLevel}%',
                style: TextStyle(color: _batteryColor(device.batteryLevel)),
              ),
            ),
            DataCell(Text(device.location)),
            DataCell(Text(device.lastSeen)),
            DataCell(
              AdminStatusBadge.custom(
                label: device.stealthEnabled ? 'On' : 'Off',
                color: device.stealthEnabled ? AppColors.success : AppColors.textTertiary,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class _DeviceDetailPanel extends StatelessWidget {
  const _DeviceDetailPanel({required this.device});

  final AdminDevice device;

  @override
  Widget build(BuildContext context) {
    return AdminPanel(
      header: 'Selected Device Detail',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminDeviceIdentity(device: device),
          const SizedBox(height: 16),
          AdminResponsiveGrid(
            minItemWidth: 280,
            children: [
              Column(
                children: [
                  AdminInfoLine(label: 'Model', value: device.model),
                  const SizedBox(height: 10),
                  AdminInfoLine(label: 'Owner email', value: device.ownerEmail),
                  const SizedBox(height: 10),
                  AdminInfoLine(label: 'Last seen', value: device.lastSeen),
                  const SizedBox(height: 10),
                  AdminInfoLine(label: 'Location', value: device.location),
                  const SizedBox(height: 10),
                  AdminInfoLine(label: 'Trigger', value: device.triggerMethod),
                ],
              ),
              AdminMetricGrid(
                metrics: [
                  AdminMetricData(
                    'Stealth',
                    device.stealthEnabled ? 'On' : 'Off',
                    device.stealthEnabled ? AppColors.success : AppColors.warning,
                  ),
                  AdminMetricData(
                    'Auto-start',
                    device.autoStartEnabled ? 'On' : 'Off',
                    device.autoStartEnabled ? AppColors.success : AppColors.warning,
                  ),
                  AdminMetricData('Photos', '${device.capturedPhotos}', AppColors.info),
                  AdminMetricData('SMS', '${device.smsAlerts}', AppColors.warning),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
