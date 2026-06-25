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
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: capture.color.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminEmptyMediaTile(
            icon: capture.camera == 'Front'
                ? Icons.camera_front_rounded
                : Icons.camera_rear_rounded,
            title: '${capture.camera} camera',
            subtitle: capture.timestamp,
            color: capture.color,
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
