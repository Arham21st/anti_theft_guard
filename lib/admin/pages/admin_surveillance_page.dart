import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../data/admin_mock_data.dart';
import '../models/admin_capture.dart';
import '../models/admin_device.dart';
import '../widgets/admin_shared_components.dart';
import '../widgets/admin_stat_card.dart';
import '../widgets/admin_status_badge.dart';
import '../widgets/admin_ui_components.dart';

class AdminSurveillancePage extends StatelessWidget {
  const AdminSurveillancePage({super.key, required this.selectedDevice});

  final AdminDevice selectedDevice;

  @override
  Widget build(BuildContext context) {
    final captures = AdminMockData.captures
        .where((capture) => capture.deviceId == selectedDevice.id)
        .toList();
    final recordings = AdminMockData.recordings
        .where((recording) => recording.deviceId == selectedDevice.id)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AdminPageHeader(
          title: 'Surveillance',
          subtitle:
              'Static capture gallery and video review for ${selectedDevice.deviceName}.',
          actions: [
            AdminStatusBadge.custom(
              label: selectedDevice.stealthEnabled
                  ? 'Stealth on'
                  : 'Stealth off',
              color: selectedDevice.stealthEnabled
                  ? AppColors.success
                  : AppColors.textTertiary,
            ),
            const AdminIconButton(
              icon: Icons.refresh_rounded,
              tooltip: 'Refresh demo media',
            ),
          ],
        ),
        const SizedBox(height: 22),
        AdminResponsiveGrid(
          minItemWidth: 280,
          children: [
            AdminStatCard(
              icon: Icons.camera_front_rounded,
              label: 'Photo captures',
              value: '${selectedDevice.capturedPhotos}',
              change: 'Front and rear camera',
              color: AppColors.info,
            ),
            AdminStatCard(
              icon: Icons.fiber_manual_record_rounded,
              label: 'Recordings',
              value: '${selectedDevice.recordings}',
              change: 'Silent video files',
              color: AppColors.danger,
            ),
            AdminStatCard(
              icon: Icons.visibility_off_rounded,
              label: 'Stealth mode',
              value: selectedDevice.stealthEnabled ? 'On' : 'Off',
              change: 'Visual indicators hidden',
              color: AppColors.success,
            ),
          ],
        ),
        const SizedBox(height: 18),
        AdminPanel(
          header: 'Captured media',
          child: AdminResponsiveGrid(
            minItemWidth: 220,
            children: captures.isEmpty
                ? [
                    const AdminEmptyState(
                      icon: Icons.photo_library_outlined,
                      title: 'No captures for this device',
                      subtitle: 'Demo media appears here after selection',
                    ),
                  ]
                : captures.map((capture) {
                    return _CaptureCard(capture: capture);
                  }).toList(),
          ),
        ),
        const SizedBox(height: 18),
        AdminResponsiveGrid(
          minItemWidth: 420,
          maxColumns: 2,
          children: [
            const AdminPanel(
              header: 'Recording settings',
              child: Column(
                children: [
                  AdminToggleRow(
                    title: 'Auto-start on trigger',
                    subtitle: 'Start recording when theft trigger fires',
                    icon: Icons.fiber_manual_record_rounded,
                    color: AppColors.danger,
                    initialValue: true,
                  ),
                  SizedBox(height: 14),
                  AdminSectionTitle(title: 'Camera source'),
                  SizedBox(height: 10),
                  AdminSegmentedControl(
                    options: ['Front', 'Back'],
                    color: AppColors.danger,
                  ),
                  SizedBox(height: 14),
                  AdminSectionTitle(title: 'Quality'),
                  SizedBox(height: 10),
                  AdminSegmentedControl(
                    options: ['360p', '720p'],
                    color: AppColors.danger,
                    initialIndex: 1,
                  ),
                ],
              ),
            ),
            AdminPanel(
              header: 'Recent recordings',
              child: recordings.isEmpty
                  ? const AdminEmptyState(
                      icon: Icons.videocam_off_outlined,
                      title: 'No video recordings',
                      subtitle: 'This static device has no demo videos.',
                    )
                  : Column(
                      children: recordings.map((recording) {
                        return _RecordingRow(recording: recording);
                      }).toList(),
                    ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CaptureCard extends StatelessWidget {
  const _CaptureCard({required this.capture});

  final AdminCapture capture;

  @override
  Widget build(BuildContext context) {
    final isFront = capture.camera == 'Front';
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: capture.color.withOpacity(0.25)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 4:3 photo placeholder — no real image yet.
          AspectRatio(
            aspectRatio: 4 / 3,
            child: Stack(
              children: [
                Positioned.fill(
                  child: DashedBorder(
                    color: capture.color.withOpacity(0.4),
                    child: Container(
                      color: AppColors.surfaceHighest.withOpacity(0.5),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isFront
                                ? Icons.camera_front_rounded
                                : Icons.camera_rear_rounded,
                            color: capture.color.withOpacity(0.7),
                            size: 30,
                          ),
                          const SizedBox(height: 10),
                          Icon(
                            Icons.image_outlined,
                            color: AppColors.textTertiary,
                            size: 22,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'No photo yet',
                            style: AdminTextStyles.small
                                .copyWith(color: AppColors.textTertiary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isFront
                              ? Icons.camera_front_rounded
                              : Icons.camera_rear_rounded,
                          size: 13,
                          color: capture.color,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${capture.camera} camera',
                          style: AdminTextStyles.small
                              .copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      capture.timestamp,
                      style: AdminTextStyles.small
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(capture.location, style: AdminTextStyles.cardTitle),
                const SizedBox(height: 4),
                Text(capture.confidence, style: AdminTextStyles.small),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A dashed outline border wrapper used for image placeholders.
class DashedBorder extends StatelessWidget {
  const DashedBorder({super.key, required this.child, required this.color});

  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(color: color),
      child: child,
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    const dashWidth = 6.0;
    const dashSpace = 5.0;
    // Top + bottom
    for (double x = 0; x < size.width; x += dashWidth + dashSpace) {
      canvas.drawLine(
          Offset(x, 0), Offset(x + dashWidth, 0), paint);
      canvas.drawLine(Offset(x, size.height),
          Offset(x + dashWidth, size.height), paint);
    }
    // Left + right
    for (double y = 0; y < size.height; y += dashWidth + dashSpace) {
      canvas.drawLine(
          Offset(0, y), Offset(0, y + dashWidth), paint);
      canvas.drawLine(Offset(size.width, y),
          Offset(size.width, y + dashWidth), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _RecordingRow extends StatelessWidget {
  const _RecordingRow({required this.recording});

  final AdminRecording recording;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.danger.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.play_arrow_rounded,
              color: AppColors.danger,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(recording.fileName, style: AdminTextStyles.cardTitle),
                const SizedBox(height: 3),
                Text(
                  '${recording.camera} camera | ${recording.duration} | ${recording.size}',
                  style: AdminTextStyles.small,
                ),
              ],
            ),
          ),
          Text(recording.timestamp, style: AdminTextStyles.small),
        ],
      ),
    );
  }
}
