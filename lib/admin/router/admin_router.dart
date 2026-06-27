import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../auth/user_role.dart';
import '../auth/web_auth_state.dart';
import '../constants/admin_routes.dart';
import '../pages/admin_battery_page.dart';
import '../pages/admin_devices_page.dart';
import '../pages/admin_location_page.dart';
import '../pages/admin_logs_page.dart';
import '../pages/admin_login_page.dart';
import '../pages/admin_overview_page.dart';
import '../pages/admin_security_page.dart';
import '../pages/admin_settings_page.dart';
import '../pages/admin_sms_page.dart';
import '../pages/admin_surveillance_page.dart';
import '../shell/admin_navigation_shell.dart';
import '../widgets/admin_ui_components.dart';
import 'admin_device_resolver.dart';

/// The web portal's single source of routing truth.
///
/// Replaces the old dual-source model (Navigator named-routes + an in-memory
/// ChangeNotifier history). go_router owns the browser URL/history natively,
/// so Back/Forward, deep links, and refreshes all work.
///
/// Auth + role enforcement lives in [redirect], driven by [WebAuthState] via
/// [refreshListenable] so login/logout re-evaluates immediately.
GoRouter buildAdminRouter(WebAuthState authState) {
  return GoRouter(
    initialLocation: AdminRoutes.login,
    refreshListenable: authState,
    redirect: (context, state) => _guard(authState, state),
    errorBuilder: (context, state) => _AdminRouteError(
      path: state.uri.toString(),
      error: state.error?.toString(),
    ),
    routes: [
      // Login — full screen, outside the persistent shell.
      GoRoute(
        path: AdminRoutes.login,
        name: 'login',
        builder: (context, state) => const _LoginShim(),
      ),
      // Everything else lives inside the persistent shell (sidebar + top bar).
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AdminNavigationShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AdminRoutes.overview,
                name: 'overview',
                builder: (context, state) => AdminOverviewPage(
                  selectedDevice: AdminDeviceResolver.resolve(context),
                  onNavigate: (i) => context.go(AdminRoutes.indexToRoute(i)),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AdminRoutes.devices,
                name: 'devices',
                builder: (context, state) => AdminDevicesPage(
                  selectedDevice: AdminDeviceResolver.resolve(context),
                  onDeviceSelected: (_) =>
                      context.go(AdminRoutes.surveillance),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AdminRoutes.surveillance,
                name: 'surveillance',
                builder: (context, state) => AdminSurveillancePage(
                  selectedDevice: AdminDeviceResolver.resolve(context),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AdminRoutes.location,
                name: 'location',
                builder: (context, state) => AdminLocationPage(
                  selectedDevice: AdminDeviceResolver.resolve(context),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AdminRoutes.logs,
                name: 'logs',
                builder: (context, state) => AdminLogsPage(
                  selectedDevice: AdminDeviceResolver.resolve(context),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AdminRoutes.security,
                name: 'security',
                builder: (context, state) => AdminSecurityPage(
                  selectedDevice: AdminDeviceResolver.resolve(context),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AdminRoutes.sms,
                name: 'sms',
                builder: (context, state) => AdminSmsPage(
                  selectedDevice: AdminDeviceResolver.resolve(context),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AdminRoutes.battery,
                name: 'battery',
                builder: (context, state) => AdminBatteryPage(
                  selectedDevice: AdminDeviceResolver.resolve(context),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AdminRoutes.settings,
                name: 'settings',
                builder: (context, state) => AdminSettingsPage(
                  selectedDevice: AdminDeviceResolver.resolve(context),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

/// Centralized auth + role redirect.
String? _guard(WebAuthState auth, GoRouterState state) {
  final location = state.uri.path;
  final isLogin = location == AdminRoutes.login;
  final isLoggedIn = auth.isLoggedIn;

  // Not logged in → must go to login (unless already there).
  if (!isLoggedIn) {
    return isLogin ? null : AdminRoutes.login;
  }

  // Logged in on the login page → send to overview.
  if (isLogin) return AdminRoutes.overview;

  // Role guard: end-users may not visit fleet-only pages.
  if (auth.role == UserRole.user && _isAdminOnly(location)) {
    return AdminRoutes.overview;
  }

  return null; // OK to proceed.
}

bool _isAdminOnly(String location) {
  return location.startsWith(AdminRoutes.devices) ||
      location.startsWith(AdminRoutes.security);
}

// ── Login shim ────────────────────────────────────────────────────────────────
// The login page resolves auth itself; this thin wrapper keeps the router file
// decoupled from the page's other imports.
class _LoginShim extends StatelessWidget {
  const _LoginShim();
  @override
  Widget build(BuildContext context) => const AdminLoginPage();
}

// ── Error page (replaces the old onUnknownRoute handler) ─────────────────────
class _AdminRouteError extends StatelessWidget {
  const _AdminRouteError({this.path, this.error});

  final String? path;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded,
                size: 56, color: Color(0xFFFF3131)),
            const SizedBox(height: 16),
            Text('Page not found',
                style: AdminTextStyles.pageTitle),
            const SizedBox(height: 8),
            Text(
              path == null
                  ? 'The requested page could not be found.'
                  : 'The route "$path" does not exist.',
              style: AdminTextStyles.body,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => context.go(AdminRoutes.overview),
              icon: const Icon(Icons.home_rounded),
              label: const Text('Return to Overview'),
            ),
          ],
        ),
      ),
    );
  }
}
