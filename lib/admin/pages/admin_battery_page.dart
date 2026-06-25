import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../data/admin_mock_data.dart';
import '../models/admin_device.dart';
import '../widgets/admin_shared_components.dart';
import '../widgets/admin_status_badge.dart';
import '../widgets/admin_ui_components.dart';

class AdminBatteryPage extends StatelessWidget {
  const AdminBatteryPage({super.key, required this.selectedDevice});

  final AdminDevice selectedDevice;

  Color _batteryColor(int value) {
    if (value <= 20) return AppColors.danger;
    if (value <= 45) return AppColors.warning;
    return AppColors.success;
  }

  @override
  Widget build(BuildContext context) {
    final lowBatteryDevices = AdminMockData.devices.where(
      (device) => device.batteryLevel <= 20,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AdminPageHeader(
          title: 'Battery Monitor',
          subtitle:
              'Fleet battery health and static discharge chart for ${selectedDevice.deviceName}.',
          actions: [
            AdminStatusBadge.custom(
              label: '${selectedDevice.batteryLevel}% selected',
              color: _batteryColor(selectedDevice.batteryLevel),
            ),
          ],
        ),
        const SizedBox(height: 22),
        AdminResponsiveGrid(
          minItemWidth: 320,
          maxColumns: 3,
          children: [
            AdminPanel(
              header: 'Selected battery',
              child: _BatteryGauge(value: selectedDevice.batteryLevel),
            ),
            AdminPanel(
              header: 'Health summary',
              child: AdminMetricGrid(
                metrics: [
                  AdminMetricData(
                    'Battery',
                    '${selectedDevice.batteryLevel}%',
                    _batteryColor(selectedDevice.batteryLevel),
                  ),
                  const AdminMetricData('Health', 'Good', AppColors.success),
                  const AdminMetricData('Temp', '34 C', AppColors.info),
                  const AdminMetricData('Voltage', '4.1V', AppColors.textSecondary),
                ],
              ),
            ),
            const AdminPanel(
              header: 'Low battery automation',
              child: Column(
                children: [
                  AdminToggleRow(
                    title: 'Auto-SMS on low battery',
                    subtitle: 'Send location when threshold is reached',
                    icon: Icons.sms_rounded,
                    color: AppColors.warning,
                    initialValue: true,
                  ),
                  SizedBox(height: 18),
                  AdminSectionTitle(title: 'Threshold'),
                  SizedBox(height: 8),
                  _StaticSlider(value: 15),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        AdminResponsiveGrid(
          minItemWidth: 420,
          maxColumns: 2,
          children: [
            const AdminPanel(
              header: 'Discharge history',
              child: _BatteryChart(),
            ),
            AdminPanel(
              header: 'Low battery devices',
              child: Column(
                children: lowBatteryDevices.map((device) {
                  return _DeviceBatteryRow(device: device);
                }).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BatteryGauge extends StatelessWidget {
  const _BatteryGauge({required this.value});

  final int value;

  Color _batteryColor(int value) {
    if (value <= 20) return AppColors.danger;
    if (value <= 45) return AppColors.warning;
    return AppColors.success;
  }

  @override
  Widget build(BuildContext context) {
    final color = _batteryColor(value);
    return Center(
      child: SizedBox(
        width: 220,
        height: 220,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: const Size(220, 220),
              painter: _GaugePainter(value: value / 100, color: color),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.battery_charging_full_rounded,
                  color: color,
                  size: 34,
                ),
                const SizedBox(height: 10),
                Text('$value%', style: AdminTextStyles.metric),
                const SizedBox(height: 5),
                Text('Selected device', style: AdminTextStyles.small),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StaticSlider extends StatelessWidget {
  const _StaticSlider({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        activeTrackColor: AppColors.warning,
        inactiveTrackColor: AppColors.surfaceHighest,
        thumbColor: Colors.white,
        overlayColor: AppColors.warning.withOpacity(0.16),
        trackHeight: 4,
      ),
      child: Slider(
        value: value,
        min: 5,
        max: 30,
        divisions: 5,
        onChanged: (_) {},
      ),
    );
  }
}

class _BatteryChart extends StatelessWidget {
  const _BatteryChart();

  Color _batteryColor(int value) {
    if (value <= 20) return AppColors.danger;
    if (value <= 45) return AppColors.warning;
    return AppColors.success;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: AdminMockData.batterySamples.map((sample) {
          final color = _batteryColor(sample.value);
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: sample.value * 1.35,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.85),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(sample.label, style: AdminTextStyles.small),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _DeviceBatteryRow extends StatelessWidget {
  const _DeviceBatteryRow({required this.device});

  final AdminDevice device;

  Color _batteryColor(int value) {
    if (value <= 20) return AppColors.danger;
    if (value <= 45) return AppColors.warning;
    return AppColors.success;
  }

  @override
  Widget build(BuildContext context) {
    final color = _batteryColor(device.batteryLevel);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          AdminAvatar(name: device.ownerName),
          const SizedBox(width: 12),
          Expanded(child: AdminDeviceIdentity(device: device, compact: true)),
          const SizedBox(width: 12),
          Text(
            '${device.batteryLevel}%',
            style: AdminTextStyles.cardTitle.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  const _GaugePainter({required this.value, required this.color});

  final double value;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 14;
    const startAngle = math.pi * 0.75;
    const sweepAngle = math.pi * 1.5;

    final backgroundPaint = Paint()
      ..color = AppColors.surfaceHighest
      ..style = PaintingStyle.stroke
      ..strokeWidth = 13
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      backgroundPaint,
    );

    final valuePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 13
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle * value,
      false,
      valuePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.color != color;
  }
}
