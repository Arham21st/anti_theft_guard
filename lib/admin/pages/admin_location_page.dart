import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../data/admin_mock_data.dart';
import '../models/admin_device.dart';
import '../models/admin_misc_models.dart';
import '../widgets/admin_shared_components.dart';
import '../widgets/admin_status_badge.dart';
import '../widgets/admin_ui_components.dart';

class AdminLocationPage extends StatelessWidget {
  const AdminLocationPage({super.key, required this.selectedDevice});

  final AdminDevice selectedDevice;

  @override
  Widget build(BuildContext context) {
    final history = AdminMockData.locations
        .where((point) => point.deviceId == selectedDevice.id)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AdminPageHeader(
          title: 'Location Tracking',
          subtitle:
              'Static fleet map, selected-device coordinates, and location history.',
          actions: [
            const AdminStatusBadge.custom(
              label: 'Live mock GPS',
              color: AppColors.info,
            ),
            const AdminIconButton(
              icon: Icons.open_in_new_rounded,
              tooltip: 'Open external map',
            ),
          ],
        ),
        const SizedBox(height: 22),
        AdminResponsiveGrid(
          minItemWidth: 440,
          maxColumns: 2,
          children: [
            AdminPanel(
              padding: EdgeInsets.zero,
              child: _FleetMap(selectedDevice: selectedDevice),
            ),
            AdminPanel(
              header: 'Selected device',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AdminDeviceIdentity(device: selectedDevice),
                  const SizedBox(height: 16),
                  AdminMetricGrid(
                    metrics: [
                      AdminMetricData(
                        'Coordinates',
                        selectedDevice.coordinates,
                        AppColors.success,
                      ),
                      const AdminMetricData('Accuracy', '5m', AppColors.info),
                      const AdminMetricData('Speed', '0 km/h', AppColors.warning),
                      const AdminMetricData('Altitude', '12m', AppColors.textSecondary),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        AdminPanel(
          header: 'Location history',
          trailing: const SizedBox(
            width: 190,
            child: AdminSegmentedControl(
              options: ['All', 'Today', 'Week'],
              color: AppColors.info,
            ),
          ),
          child: history.isEmpty
              ? const AdminEmptyState(
                  icon: Icons.location_off_outlined,
                  title: 'No location history',
                  subtitle: 'This static device has no recent GPS entries.',
                )
              : Column(
                  children: history.map((point) {
                    return _LocationTimelineRow(point: point);
                  }).toList(),
                ),
        ),
      ],
    );
  }
}

class _FleetMap extends StatelessWidget {
  const _FleetMap({required this.selectedDevice});

  final AdminDevice selectedDevice;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 360,
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _MapPainter())),
          ...AdminMockData.devices.asMap().entries.map((entry) {
            final isSelected = entry.value.id == selectedDevice.id;
            final left = 56.0 + (entry.key * 53) % 260;
            final top = 54.0 + (entry.key * 71) % 220;
            return Positioned(
              left: left,
              top: top,
              child: _MapMarker(device: entry.value, selected: isSelected),
            );
          }),
          const Positioned(
            left: 16,
            top: 16,
            child: AdminStatusBadge.custom(
              label: 'Karachi fleet map',
              color: AppColors.info,
            ),
          ),
        ],
      ),
    );
  }
}

class _MapMarker extends StatelessWidget {
  const _MapMarker({required this.device, required this.selected});

  final AdminDevice device;
  final bool selected;

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
    final color = _statusColor(device.status);
    return Column(
      children: [
        Container(
          width: selected ? 36 : 28,
          height: selected ? 36 : 28,
          decoration: BoxDecoration(
            color: color.withOpacity(0.16),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: selected ? 2 : 1),
          ),
          child: Icon(
            Icons.phone_android_rounded,
            color: color,
            size: selected ? 18 : 14,
          ),
        ),
        if (selected)
          Container(
            margin: const EdgeInsets.only(top: 6),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surface.withOpacity(0.95),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(device.ownerName, style: AdminTextStyles.small),
          ),
      ],
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFF0D1117),
    );

    final gridPaint = Paint()
      ..color = const Color(0xFF1A2030)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 32) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 32) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final roadPaint = Paint()
      ..color = const Color(0xFF253040)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(0, size.height * 0.32),
      Offset(size.width, size.height * 0.32),
      roadPaint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.67),
      Offset(size.width, size.height * 0.67),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.25, 0),
      Offset(size.width * 0.25, size.height),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.72, 0),
      Offset(size.width * 0.72, size.height),
      roadPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LocationTimelineRow extends StatelessWidget {
  const _LocationTimelineRow({required this.point});

  final AdminLocationPoint point;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.location_on_rounded,
              color: AppColors.info,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(point.address, style: AdminTextStyles.cardTitle),
                const SizedBox(height: 3),
                Text(point.coordinates, style: AdminTextStyles.mono),
                const SizedBox(height: 3),
                Text(
                  'Accuracy ${point.accuracy} | Speed ${point.speed} | Distance ${point.distance}',
                  style: AdminTextStyles.small,
                ),
              ],
            ),
          ),
          Text(point.time, style: AdminTextStyles.small),
        ],
      ),
    );
  }
}
