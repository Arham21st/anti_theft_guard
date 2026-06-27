import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../auth/user_role.dart';
import '../auth/web_auth_state.dart';
import '../constants/admin_routes.dart';
import 'admin_ui_components.dart';

/// Role-aware navigation sidebar.
///
/// [UserRole.admin] sees all destinations (fleet console). [UserRole.user]
/// sees only their own-device destinations — "Devices" and "Security" (the
/// fleet-only pages) are hidden. Both roles get a Logout action.
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

  // Full ordered list of destinations. The index here matches the shell's
  // IndexedStack order (0..8) — DO NOT reorder without updating the shell.
  static const _allDestinations = [
    _AdminDestination(Icons.dashboard_rounded, 'Overview', null),
    _AdminDestination(Icons.devices_rounded, 'Devices', 'admin'),
    _AdminDestination(Icons.videocam_rounded, 'Surveillance', null),
    _AdminDestination(Icons.location_on_rounded, 'Location', null),
    _AdminDestination(Icons.receipt_long_rounded, 'Alerts & Logs', null),
    _AdminDestination(Icons.admin_panel_settings_rounded, 'Security', 'admin'),
    _AdminDestination(Icons.sms_rounded, 'Emergency SMS', null),
    _AdminDestination(Icons.battery_charging_full_rounded, 'Battery', null),
    _AdminDestination(Icons.settings_rounded, 'Settings', null),
  ];

  @override
  Widget build(BuildContext context) {
    final role = WebAuthProvider.of(context).role;
    final visible = _allDestinations.where((d) => d.visibleFor(role)).toList();
    final isAdmin = role == UserRole.admin;

    return Container(
      width: 264,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _header(isAdmin),
            const Divider(color: AppColors.border, height: 1),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: visible.length,
                separatorBuilder: (_, _) => const SizedBox(height: 4),
                itemBuilder: (context, index) {
                  final item = visible[index];
                  final selected = selectedIndex == item.stackIndex;
                  return _SidebarItem(
                    icon: item.icon,
                    label: item.label,
                    selected: selected,
                    onTap: () {
                      // Map the visible-list position back to the shell index.
                      onDestinationSelected(item.stackIndex);
                      if (!persistent) Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
            _footer(context),
          ],
        ),
      ),
    );
  }

  Widget _header(bool isAdmin) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primary.withOpacity(0.35)),
            ),
            child: const Icon(Icons.shield_rounded,
                color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Anti-Theft Guard',
                    style: AdminTextStyles.cardTitle,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 3),
                Text(
                  isAdmin ? 'Admin Console' : 'My Device',
                  style: AdminTextStyles.small,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _footer(BuildContext context) {
    final auth = WebAuthProvider.of(context);
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AdminPanel(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Icon(
                  auth.role == UserRole.admin
                      ? Icons.admin_panel_settings_rounded
                      : Icons.phone_iphone_rounded,
                  color: auth.role == UserRole.admin
                      ? AppColors.warning
                      : AppColors.info,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    auth.isLoggedIn
                        ? (auth.role == UserRole.admin
                            ? 'Fleet Admin'
                            : auth.session!.displayName)
                        : '',
                    style: AdminTextStyles.small,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _SidebarItem(
            icon: Icons.logout_rounded,
            label: 'Logout',
            selected: false,
            danger: true,
            onTap: () {
              auth.logout();
              // The router's redirect (driven by refreshListenable) sends the
              // now-logged-out user to login automatically.
              context.go(AdminRoutes.login);
              if (!persistent) Navigator.of(context).pop();
            },
          ),
        ],
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
    this.danger = false,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final accent = danger ? AppColors.danger : AppColors.primary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: selected ? accent.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: selected ? Border.all(color: accent.withOpacity(0.28)) : null,
        ),
        child: Row(
          children: [
            Icon(icon,
                color: selected ? accent : AppColors.textSecondary, size: 19),
            const SizedBox(width: 10),
            Expanded(
              child: Text(label,
                  style: AdminTextStyles.label.copyWith(
                    color: selected ? accent : AppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminDestination {
  const _AdminDestination(this.icon, this.label, this.roleTag);

  final IconData icon;
  final String label;

  /// `null` = visible to all roles; otherwise a role tag (e.g. 'admin').
  final String? roleTag;

  /// Index of this destination in the full list — matches the shell's
  /// IndexedStack order, so we can pass it straight through to the shell.
  int get stackIndex => AdminSidebar._allDestinations.indexOf(this);

  bool visibleFor(UserRole role) {
    if (roleTag == null) return true; // all roles
    if (roleTag == 'admin') return role == UserRole.admin;
    return false;
  }
}

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Drawer(backgroundColor: AppColors.surface, width: 264, child: child);
  }
}
