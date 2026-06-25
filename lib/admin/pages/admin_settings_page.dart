import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../models/admin_device.dart';
import '../widgets/admin_shared_components.dart';
import '../widgets/admin_ui_components.dart';

class AdminSettingsPage extends StatelessWidget {
  const AdminSettingsPage({super.key, required this.selectedDevice});

  final AdminDevice selectedDevice;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AdminPageHeader(
          title: 'Admin Settings',
          subtitle:
              'Static interface preferences and demo metadata for the web admin panel.',
          actions: [
            AdminIconButton(
              icon: Icons.restart_alt_rounded,
              tooltip: 'Reset visual settings',
            ),
          ],
        ),
        const SizedBox(height: 22),
        AdminResponsiveGrid(
          minItemWidth: 420,
          maxColumns: 2,
          children: [
            AdminPanel(
              header: 'Console preferences',
              child: Column(
                children: [
                  const AdminToggleRow(
                    title: 'Compact tables',
                    subtitle: 'Use dense operational table spacing',
                    icon: Icons.table_rows_rounded,
                    color: AppColors.info,
                    initialValue: true,
                  ),
                  const SizedBox(height: 14),
                  const AdminToggleRow(
                    title: 'Critical alert emphasis',
                    subtitle: 'Highlight stolen and warning devices',
                    icon: Icons.priority_high_rounded,
                    color: AppColors.danger,
                    initialValue: true,
                  ),
                  const SizedBox(height: 14),
                  AdminInfoLine(
                    label: 'Selected device',
                    value: selectedDevice.deviceName,
                  ),
                  const SizedBox(height: 10),
                  AdminInfoLine(
                    label: 'Selected owner',
                    value: selectedDevice.ownerName,
                  ),
                ],
              ),
            ),
            const AdminPanel(
              header: 'Demo build',
              child: Column(
                children: [
                  AdminInfoLine(label: 'Product', value: 'Anti-Theft Guard Admin'),
                  SizedBox(height: 10),
                  AdminInfoLine(label: 'Mode', value: 'Static UI Demo'),
                  SizedBox(height: 10),
                  AdminInfoLine(label: 'Version', value: 'v1.0.0 Alpha'),
                  SizedBox(height: 10),
                  AdminInfoLine(label: 'Backend', value: 'Not connected'),
                  SizedBox(height: 18),
                  _DemoNotice(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DemoNotice extends StatelessWidget {
  const _DemoNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.info.withOpacity(0.24)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.info,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Every control is visual-only and uses in-memory demo data.',
              style: AdminTextStyles.small.copyWith(color: AppColors.info),
            ),
          ),
        ],
      ),
    );
  }
}
