import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../models/admin_device.dart';
import '../widgets/admin_shared_components.dart';
import '../widgets/admin_status_badge.dart';
import '../widgets/admin_ui_components.dart';

class AdminSecurityPage extends StatelessWidget {
  const AdminSecurityPage({super.key, required this.selectedDevice});

  final AdminDevice selectedDevice;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AdminPageHeader(
          title: 'Security Controls',
          subtitle:
              'Static trigger, stealth, blackout, and boot-protection controls for ${selectedDevice.deviceName}.',
          actions: [
            AdminStatusBadge.device(status: selectedDevice.status),
            const AdminIconButton(
              icon: Icons.save_outlined,
              tooltip: 'Save static settings',
            ),
          ],
        ),
        const SizedBox(height: 22),
        AdminResponsiveGrid(
          minItemWidth: 420,
          maxColumns: 2,
          children: [
            AdminPanel(
              header: 'Activation trigger',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AdminDeviceIdentity(device: selectedDevice),
                  const SizedBox(height: 18),
                  const AdminSectionTitle(
                    title: 'Trigger method',
                    subtitle: 'Visual-only selector, no persistence.',
                  ),
                  const SizedBox(height: 12),
                  AdminSegmentedControl(
                    options: const ['Power x3', 'Password', 'Volume'],
                    color: AppColors.primary,
                    initialIndex:
                        selectedDevice.triggerMethod == 'Secret Password'
                        ? 1
                        : selectedDevice.triggerMethod == 'Volume Sequence'
                        ? 2
                        : 0,
                  ),
                  const SizedBox(height: 18),
                  const AdminToggleRow(
                    title: 'Silent activation',
                    subtitle: 'Do not show visual or audio feedback',
                    icon: Icons.volume_off_rounded,
                    color: AppColors.success,
                    initialValue: true,
                  ),
                ],
              ),
            ),
            const AdminPanel(
              header: 'Stealth mode',
              child: Column(
                children: [
                  AdminToggleRow(
                    title: 'Hide from launcher',
                    subtitle: 'App icon hidden from drawer',
                    icon: Icons.apps_rounded,
                    color: AppColors.primary,
                    initialValue: true,
                  ),
                  SizedBox(height: 14),
                  AdminToggleRow(
                    title: 'Suppress notifications',
                    subtitle: 'No banners or visible alerts',
                    icon: Icons.notifications_off_rounded,
                    color: AppColors.info,
                    initialValue: true,
                  ),
                  SizedBox(height: 14),
                  AdminToggleRow(
                    title: 'No recording indicator',
                    subtitle: 'Hide preview and red-dot indicators',
                    icon: Icons.visibility_off_rounded,
                    color: AppColors.danger,
                    initialValue: true,
                  ),
                ],
              ),
            ),
            const AdminPanel(
              header: 'Blackout screen',
              child: _BlackoutPreview(),
            ),
            const AdminPanel(header: 'Boot sequence', child: _BootSequence()),
          ],
        ),
      ],
    );
  }
}

class _BlackoutPreview extends StatelessWidget {
  const _BlackoutPreview();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 180,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderHighlight),
          ),
          child: Center(
            child: Text(
              'Blackout preview',
              style: AdminTextStyles.small.copyWith(color: Colors.white24),
            ),
          ),
        ),
        const SizedBox(height: 14),
        const AdminToggleRow(
          title: 'Activate on trigger',
          subtitle: 'Show fake dead-screen state',
          icon: Icons.brightness_1_rounded,
          color: AppColors.warning,
          initialValue: true,
        ),
      ],
    );
  }
}

class _BootSequence extends StatelessWidget {
  const _BootSequence();

  @override
  Widget build(BuildContext context) {
    const steps = [
      _BootStep(
        'Phone powers on',
        Icons.power_settings_new_rounded,
        AppColors.textSecondary,
      ),
      _BootStep(
        'System boot complete',
        Icons.phone_android_rounded,
        AppColors.info,
      ),
      _BootStep('Protection restored', Icons.shield_rounded, AppColors.success),
    ];

    return Column(
      children: [
        ...steps.asMap().entries.map((entry) {
          final step = entry.value;
          final isLast = entry.key == steps.length - 1;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: step.color.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(step.icon, color: step.color, size: 17),
                  ),
                  if (!isLast)
                    Container(
                      width: 2,
                      height: 24,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: AppColors.border,
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(step.label, style: AdminTextStyles.cardTitle),
              ),
            ],
          );
        }),
        const SizedBox(height: 14),
        const AdminToggleRow(
          title: 'Auto-start on boot',
          subtitle: 'Restore protection after restart',
          icon: Icons.restart_alt_rounded,
          color: AppColors.success,
          initialValue: true,
        ),
      ],
    );
  }
}

class _BootStep {
  const _BootStep(this.label, this.icon, this.color);

  final String label;
  final IconData icon;
  final Color color;
}
