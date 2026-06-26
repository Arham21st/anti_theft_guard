import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_design_tokens.dart';
import '../auth/user_role.dart';
import '../auth/web_auth_state.dart';
import '../constants/admin_routes.dart';
import '../data/admin_mock_data.dart';
import '../models/admin_device.dart';
import '../pages/admin_battery_page.dart';
import '../pages/admin_devices_page.dart';
import '../pages/admin_location_page.dart';
import '../pages/admin_logs_page.dart';
import '../pages/admin_overview_page.dart';
import '../pages/admin_security_page.dart';
import '../pages/admin_settings_page.dart';
import '../pages/admin_sms_page.dart';
import '../pages/admin_surveillance_page.dart';
import '../state/admin_navigation_state.dart';
import '../widgets/admin_sidebar.dart';
import '../widgets/admin_top_bar.dart';

/// Enhanced navigation shell for the admin module.
/// Provides state preservation via IndexedStack and proper navigation history.
class AdminNavigationShell extends StatefulWidget {
  const AdminNavigationShell({super.key});

  @override
  State<AdminNavigationShell> createState() => _AdminNavigationShellState();
}

class _AdminNavigationShellState extends State<AdminNavigationShell> {
  // Use late initialization since the provider will be available in build
  late AdminNavigationState _navState;

  // Track device selection. For end-users this is forced to their own device
  // and never changes; for admins it's the fleet dropdown selection.
  String? _selectedDeviceId;

  // Subscribed to the nav state in initState so we rebuild when it notifies.
  // (The InheritedWidget's updateShouldNotify only fires on instance change,
  // which never happens for an in-place ChangeNotifier — so we must listen.)
  bool _isListening = false;
  void _onNavChanged() {
    if (mounted) setState(() {});
  }

  /// The role of the current web session.
  UserRole get _role => WebAuthProvider.of(context).role;

  /// A user owns one device; admins browse the fleet (default to first device).
  String get _effectiveDeviceId {
    final auth = WebAuthProvider.of(context);
    if (auth.role == UserRole.user) {
      return auth.userDeviceId ?? AdminMockData.devices.first.id;
    }
    return _selectedDeviceId ?? AdminMockData.devices.first.id;
  }

  AdminDevice get _selectedDevice {
    return AdminMockData.devices.firstWhere(
      (device) => device.id == _effectiveDeviceId,
      orElse: () => AdminMockData.devices.first,
    );
  }

  // Current page index for IndexedStack
  int get _currentIndex => _navState.currentIndex;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get navigation state from provider
    _navState = AdminNavigationProvider.of(context);

    // Attach our listener exactly once for this state instance.
    if (!_isListening) {
      _navState.addListener(_onNavChanged);
      _isListening = true;
    }

    // For end-users, force the nav state's selected device to THEIR device so
    // that the page wrappers (which read navState.selectedDeviceId) render the
    // correct device — not the default fleet fallback. selectDevice() is a
    // no-op when the value is unchanged, so this is safe to run every time.
    if (_role == UserRole.user) {
      final auth = WebAuthProvider.of(context);
      final userDeviceId = auth.userDeviceId ?? AdminMockData.devices.first.id;
      if (_navState.selectedDeviceId != userDeviceId) {
        _navState.selectDevice(userDeviceId);
      }

      // Defensive guard: if a user lands on an admin-only page (deep link /
      // stale history), bounce them to overview. The sidebar hides these too.
      if (_isAdminOnlyRoute(_navState.currentRoute)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _navState.navigateTo(AdminRoutes.overview);
        });
      }
    }
  }

  @override
  void dispose() {
    if (_isListening) {
      _navState.removeListener(_onNavChanged);
      _isListening = false;
    }
    super.dispose();
  }

  /// Routes only fleet admins should reach (their sidebar entries are hidden).
  bool _isAdminOnlyRoute(String route) {
    return route.startsWith(AdminRoutes.devices) ||
        route.startsWith(AdminRoutes.security);
  }

  void _selectPage(int index) {
    // Belt-and-suspenders: users can't navigate to admin-only destinations.
    final targetRoute = AdminRoutes.indexToRoute(index);
    if (_role == UserRole.user && _isAdminOnlyRoute(targetRoute)) {
      _navState.navigateTo(AdminRoutes.overview);
      return;
    }
    // Navigate using the new navigation state manager
    _navState.navigateToIndex(index);
  }

  void _onDeviceChanged(String? deviceId) {
    if (deviceId == null) return;
    // Users can't change device (they own one); ignore any stray call.
    if (_role == UserRole.user) return;
    setState(() => _selectedDeviceId = deviceId);
    // Update navigation state with device selection
    _navState.selectDevice(deviceId);
  }

  // Handle back button with PopScope
  Future<bool> _onPopInvoked(bool didPop, dynamic result) async {
    if (didPop) return true;

    // If there's navigation history, pop to previous route
    if (_navState.canPop) {
      _navState.pop();
      return false; // Don't pop the route, we handled it internally
    }

    // At the root, allow the pop to exit
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use the design token breakpoint for consistency
        final isWide = constraints.maxWidth >=
            AppDesignTokens.breakpointDesktop + 80; // ~984px to match existing

        return PopScope(
          canPop: false, // We handle pop manually
          onPopInvokedWithResult: _onPopInvoked,
          child: Scaffold(
            backgroundColor: AppColors.background,
            drawer: isWide
                ? null
                : AdminDrawer(
                    child: AdminSidebar(
                      selectedIndex: _currentIndex,
                      onDestinationSelected: (index) {
                        _selectPage(index);
                        Navigator.of(context).pop();
                      },
                      persistent: false,
                    ),
                  ),
            body: Row(
              children: [
                // Persistent sidebar on wide screens
                if (isWide)
                  AdminSidebar(
                    selectedIndex: _currentIndex,
                    onDestinationSelected: _selectPage,
                    persistent: true,
                  ),
                // Main content area
                Expanded(
                  child: Column(
                    children: [
                      // Top bar with device selector
                      AdminTopBar(
                        selectedDevice: _selectedDevice,
                        selectedDeviceId: _effectiveDeviceId,
                        onDeviceChanged: _onDeviceChanged,
                        showMenu: !isWide,
                      ),
                      // Page content with state preservation
                      Expanded(
                        child: _buildPageContent(isWide),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPageContent(bool isWide) {
    return Container(
      color: AppColors.background,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          isWide
              ? AppDesignTokens.spacingXxl
              : AppDesignTokens.spacingLg,
          AppDesignTokens.spacingXxl,
          isWide
              ? AppDesignTokens.spacingXxl
              : AppDesignTokens.spacingLg,
          AppDesignTokens.spacingXxxl,
        ),
        child: _buildIndexedStack(),
      ),
    );
  }

  /// Build IndexedStack for state preservation
  /// All pages are built once and kept alive
  Widget _buildIndexedStack() {
    return SizedBox(
      // Use a reasonable height to ensure proper layout
      height: MediaQuery.of(context).size.height -
          70 - // Top bar height
          (MediaQuery.of(context).viewInsets.bottom), // Account for keyboard
      child: IndexedStack(
        index: _currentIndex,
        children: [
          // Overview page (index 0)
          _buildPageWrapper(
            const AdminOverviewPageWrapper(),
            AdminRoutes.overview,
          ),
          // Devices page (index 1)
          _buildPageWrapper(
            const AdminDevicesPageWrapper(),
            AdminRoutes.devices,
          ),
          // Surveillance page (index 2)
          _buildPageWrapper(
            const AdminSurveillancePageWrapper(),
            AdminRoutes.surveillance,
          ),
          // Location page (index 3)
          _buildPageWrapper(
            const AdminLocationPageWrapper(),
            AdminRoutes.location,
          ),
          // Logs page (index 4)
          _buildPageWrapper(
            const AdminLogsPageWrapper(),
            AdminRoutes.logs,
          ),
          // Security page (index 5)
          _buildPageWrapper(
            const AdminSecurityPageWrapper(),
            AdminRoutes.security,
          ),
          // SMS page (index 6)
          _buildPageWrapper(
            const AdminSmsPageWrapper(),
            AdminRoutes.sms,
          ),
          // Battery page (index 7)
          _buildPageWrapper(
            const AdminBatteryPageWrapper(),
            AdminRoutes.battery,
          ),
          // Settings page (index 8)
          _buildPageWrapper(
            const AdminSettingsPageWrapper(),
            AdminRoutes.settings,
          ),
        ],
      ),
    );
  }

  /// Wrap each page to provide state preservation and navigation callbacks
  Widget _buildPageWrapper(Widget child, String route) {
    return child;
  }
}

// ── Page Wrappers with AutomaticKeepAliveClientMixin ──────────────────────────────
/// These wrappers ensure each page maintains its state when switching

class AdminOverviewPageWrapper extends StatefulWidget {
  const AdminOverviewPageWrapper({super.key});

  @override
  State<AdminOverviewPageWrapper> createState() =>
      _AdminOverviewPageWrapperState();
}

class _AdminOverviewPageWrapperState extends State<AdminOverviewPageWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    final navState = AdminNavigationProvider.of(context);
    final deviceId = navState.selectedDeviceId ??
        AdminMockData.devices.first.id;
    final device = AdminMockData.devices.firstWhere(
      (d) => d.id == deviceId,
      orElse: () => AdminMockData.devices.first,
    );

    return AdminOverviewPage(
      selectedDevice: device,
      onNavigate: (index) => navState.navigateToIndex(index),
    );
  }
}

class AdminDevicesPageWrapper extends StatefulWidget {
  const AdminDevicesPageWrapper({super.key});

  @override
  State<AdminDevicesPageWrapper> createState() =>
      _AdminDevicesPageWrapperState();
}

class _AdminDevicesPageWrapperState extends State<AdminDevicesPageWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final navState = AdminNavigationProvider.of(context);
    final deviceId = navState.selectedDeviceId ??
        AdminMockData.devices.first.id;
    final device = AdminMockData.devices.firstWhere(
      (d) => d.id == deviceId,
      orElse: () => AdminMockData.devices.first,
    );

    return AdminDevicesPage(
      selectedDevice: device,
      onDeviceSelected: (selectedDevice) {
        // Update device selection
        navState.selectDevice(selectedDevice.id);
      },
    );
  }
}

class AdminSurveillancePageWrapper extends StatefulWidget {
  const AdminSurveillancePageWrapper({super.key});

  @override
  State<AdminSurveillancePageWrapper> createState() =>
      _AdminSurveillancePageWrapperState();
}

class _AdminSurveillancePageWrapperState
    extends State<AdminSurveillancePageWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final navState = AdminNavigationProvider.of(context);
    final deviceId = navState.selectedDeviceId ??
        AdminMockData.devices.first.id;
    final device = AdminMockData.devices.firstWhere(
      (d) => d.id == deviceId,
      orElse: () => AdminMockData.devices.first,
    );

    return AdminSurveillancePage(selectedDevice: device);
  }
}

class AdminLocationPageWrapper extends StatefulWidget {
  const AdminLocationPageWrapper({super.key});

  @override
  State<AdminLocationPageWrapper> createState() =>
      _AdminLocationPageWrapperState();
}

class _AdminLocationPageWrapperState extends State<AdminLocationPageWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final navState = AdminNavigationProvider.of(context);
    final deviceId = navState.selectedDeviceId ??
        AdminMockData.devices.first.id;
    final device = AdminMockData.devices.firstWhere(
      (d) => d.id == deviceId,
      orElse: () => AdminMockData.devices.first,
    );

    return AdminLocationPage(selectedDevice: device);
  }
}

class AdminLogsPageWrapper extends StatefulWidget {
  const AdminLogsPageWrapper({super.key});

  @override
  State<AdminLogsPageWrapper> createState() => _AdminLogsPageWrapperState();
}

class _AdminLogsPageWrapperState extends State<AdminLogsPageWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final navState = AdminNavigationProvider.of(context);
    final deviceId = navState.selectedDeviceId ??
        AdminMockData.devices.first.id;
    final device = AdminMockData.devices.firstWhere(
      (d) => d.id == deviceId,
      orElse: () => AdminMockData.devices.first,
    );

    return AdminLogsPage(selectedDevice: device);
  }
}

class AdminSecurityPageWrapper extends StatefulWidget {
  const AdminSecurityPageWrapper({super.key});

  @override
  State<AdminSecurityPageWrapper> createState() =>
      _AdminSecurityPageWrapperState();
}

class _AdminSecurityPageWrapperState extends State<AdminSecurityPageWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final navState = AdminNavigationProvider.of(context);
    final deviceId = navState.selectedDeviceId ??
        AdminMockData.devices.first.id;
    final device = AdminMockData.devices.firstWhere(
      (d) => d.id == deviceId,
      orElse: () => AdminMockData.devices.first,
    );

    return AdminSecurityPage(selectedDevice: device);
  }
}

class AdminSmsPageWrapper extends StatefulWidget {
  const AdminSmsPageWrapper({super.key});

  @override
  State<AdminSmsPageWrapper> createState() => _AdminSmsPageWrapperState();
}

class _AdminSmsPageWrapperState extends State<AdminSmsPageWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final navState = AdminNavigationProvider.of(context);
    final deviceId = navState.selectedDeviceId ??
        AdminMockData.devices.first.id;
    final device = AdminMockData.devices.firstWhere(
      (d) => d.id == deviceId,
      orElse: () => AdminMockData.devices.first,
    );

    return AdminSmsPage(selectedDevice: device);
  }
}

class AdminBatteryPageWrapper extends StatefulWidget {
  const AdminBatteryPageWrapper({super.key});

  @override
  State<AdminBatteryPageWrapper> createState() =>
      _AdminBatteryPageWrapperState();
}

class _AdminBatteryPageWrapperState extends State<AdminBatteryPageWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final navState = AdminNavigationProvider.of(context);
    final deviceId = navState.selectedDeviceId ??
        AdminMockData.devices.first.id;
    final device = AdminMockData.devices.firstWhere(
      (d) => d.id == deviceId,
      orElse: () => AdminMockData.devices.first,
    );

    return AdminBatteryPage(selectedDevice: device);
  }
}

class AdminSettingsPageWrapper extends StatefulWidget {
  const AdminSettingsPageWrapper({super.key});

  @override
  State<AdminSettingsPageWrapper> createState() =>
      _AdminSettingsPageWrapperState();
}

class _AdminSettingsPageWrapperState extends State<AdminSettingsPageWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final navState = AdminNavigationProvider.of(context);
    final deviceId = navState.selectedDeviceId ??
        AdminMockData.devices.first.id;
    final device = AdminMockData.devices.firstWhere(
      (d) => d.id == deviceId,
      orElse: () => AdminMockData.devices.first,
    );

    return AdminSettingsPage(selectedDevice: device);
  }
}
