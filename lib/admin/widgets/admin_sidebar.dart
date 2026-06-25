import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'admin_ui_components.dart';

class AdminSidebar extends StatelessWidget {
  const AdminSidebar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.persistent = true,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final bool persistent;

  static const destinations = [
    _AdminDestination(Icons.dashboard_rounded, 'Overview'),
    _AdminDestination(Icons.devices_rounded, 'Devices'),
    _AdminDestination(Icons.videocam_rounded, 'Surveillance'),
    _AdminDestination(Icons.location_on_rounded, 'Location'),
    _AdminDestination(Icons.receipt_long_rounded, 'Alerts & Logs'),
    _AdminDestination(Icons.admin_panel_settings_rounded, 'Security'),
    _AdminDestination(Icons.sms_rounded, 'Emergency SMS'),
    _AdminDestination(Icons.battery_charging_full_rounded, 'Battery'),
    _AdminDestination(Icons.settings_rounded, 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 264,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.35),
                      ),
                    ),
                    child: const Icon(
                      Icons.shield_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Anti-Theft Guard',
                          style: AdminTextStyles.cardTitle,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Admin Console',
                          style: AdminTextStyles.small,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: AppColors.border, height: 1),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: destinations.length,
                separatorBuilder: (_, __) => const SizedBox(height: 4),
                itemBuilder: (context, index) {
                  final item = destinations[index];
                  final selected = selectedIndex == index;
                  return _SidebarItem(
                    icon: item.icon,
                    label: item.label,
                    selected: selected,
                    onTap: () {
                      onDestinationSelected(index);
                      if (!persistent) Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: AdminPanel(
                padding: const EdgeInsets.all(12),
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
                        'Static interface demo. No backend actions are wired.',
                        style: AdminTextStyles.small,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: selected
              ? Border.all(color: AppColors.primary.withOpacity(0.28))
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: selected ? AppColors.primary : AppColors.textSecondary,
              size: 19,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: AdminTextStyles.label.copyWith(
                  color: selected ? AppColors.primary : AppColors.textSecondary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminDestination {
  const _AdminDestination(this.icon, this.label);

  final IconData icon;
  final String label;
}

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Drawer(backgroundColor: AppColors.surface, width: 264, child: child);
  }
}
