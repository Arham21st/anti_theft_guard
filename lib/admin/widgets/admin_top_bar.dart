import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../data/admin_mock_data.dart';
import '../models/admin_device.dart';
import 'admin_status_badge.dart';
import 'admin_ui_components.dart';

class AdminTopBar extends StatelessWidget {
  const AdminTopBar({
    super.key,
    required this.selectedDevice,
    required this.selectedDeviceId,
    required this.onDeviceChanged,
    required this.showMenu,
  });

  final AdminDevice selectedDevice;
  final String selectedDeviceId;
  final ValueChanged<String?> onDeviceChanged;
  final bool showMenu;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          if (showMenu) ...[
            AdminIconButton(
              icon: Icons.menu_rounded,
              tooltip: 'Open navigation',
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Wrap(
              spacing: 12,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                AdminStatusBadge.device(status: selectedDevice.status),
                const AdminStatusBadge.custom(
                  label: 'Demo Mode',
                  color: AppColors.info,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 250),
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedDeviceId,
                  dropdownColor: AppColors.surfaceElevated,
                  iconEnabledColor: AppColors.textSecondary,
                  style: AdminTextStyles.body,
                  isExpanded: true,
                  items: AdminMockData.devices.map((device) {
                    return DropdownMenuItem<String>(
                      value: device.id,
                      child: Text(
                        device.deviceName,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: onDeviceChanged,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          const AdminIconButton(
            icon: Icons.notifications_outlined,
            tooltip: 'Notifications',
          ),
          const SizedBox(width: 10),
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: Text(
              'AD',
              style: AdminTextStyles.label.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
