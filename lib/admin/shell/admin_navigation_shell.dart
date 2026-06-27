import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_design_tokens.dart';
import '../auth/user_role.dart';
import '../auth/web_auth_state.dart';
import '../data/admin_mock_data.dart';
import '../models/admin_device.dart';
import '../state/admin_navigation_state.dart';
import '../widgets/admin_sidebar.dart';
import '../widgets/admin_top_bar.dart';

/// Pure UI shell for the web portal.
///
/// Receives a [StatefulNavigationShell] from go_router's `StatefulShellRoute`
/// and renders the persistent sidebar + top bar + the active branch's page.
/// go_router owns the URL/history and branch state, so the shell no longer
/// derives the current page from `ModalRoute` or an in-memory history — it just
/// reflects the shell it's given.
class AdminNavigationShell extends StatelessWidget {
  const AdminNavigationShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  /// The current branch index (0..8), matching the router's branch order.
  int get currentIndex => navigationShell.currentIndex;

  /// Switch branches. goBranch keeps each branch's state alive (equivalent to
  /// the old IndexedStack + AutomaticKeepAliveClientMixin) and updates the URL.
  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final role = WebAuthProvider.of(context).role;
    final device = _resolveDevice(context, role);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide =
            constraints.maxWidth >= AppDesignTokens.breakpointDesktop + 80;

        return Scaffold(
          backgroundColor: AppColors.background,
          drawer: isWide
              ? null
              : AdminDrawer(
                  child: AdminSidebar(
                    // Map the shell's branch index through the role filter so
                    // the highlight lands on the right item for both roles.
                    selectedIndex: currentIndex,
                    onDestinationSelected: (index) {
                      _goBranch(index);
                      Navigator.of(context).pop(); // close the drawer
                    },
                    persistent: false,
                  ),
                ),
          body: Row(
            children: [
              if (isWide)
                AdminSidebar(
                  selectedIndex: currentIndex,
                  onDestinationSelected: _goBranch,
                  persistent: true,
                ),
              Expanded(
                child: Column(
                  children: [
                    AdminTopBar(
                      selectedDevice: device,
                      selectedDeviceId: device.id,
                      onDeviceChanged: (deviceId) {
                        // Device selection is admin-only; route through the
                        // shared nav state so pages that read it update.
                        if (deviceId == null || role != UserRole.admin) return;
                        AdminNavigationProvider.of(context).selectDevice(deviceId);
                      },
                      showMenu: !isWide,
                    ),
                    Expanded(child: navigationShell),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Resolve the device for the top bar: users see their own device; admins
  /// use the shared nav state's selection (default first device).
  AdminDevice _resolveDevice(BuildContext context, UserRole role) {
    final navState = AdminNavigationProvider.of(context);
    if (role == UserRole.user) {
      final auth = WebAuthProvider.of(context);
      final deviceId = auth.userDeviceId ?? AdminMockData.devices.first.id;
      return AdminMockData.devices.firstWhere(
        (d) => d.id == deviceId,
        orElse: () => AdminMockData.devices.first,
      );
    }
    final deviceId = navState.selectedDeviceId ?? AdminMockData.devices.first.id;
    return AdminMockData.devices.firstWhere(
      (d) => d.id == deviceId,
      orElse: () => AdminMockData.devices.first,
    );
  }
}
