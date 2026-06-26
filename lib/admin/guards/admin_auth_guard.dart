import 'package:flutter/material.dart';

/// Authentication guard for admin module routes.
/// Provides authorization checks and redirects for protected admin routes.
///
/// This is a placeholder implementation that can be extended with a real
/// authentication system when needed. Currently allows all access for demo purposes.
class AdminAuthGuard {
  AdminAuthGuard._();

  // ── Configuration ──────────────────────────────────────────────────────────────

  /// Enable/disable authentication checks
  /// Set to false to bypass authentication (useful for development/demo)
  static const bool authenticationEnabled = false;

  /// Enable debug logging for authentication attempts
  static const bool debugMode = true;

  // ── Authentication State ────────────────────────────────────────────────────────

  /// Mock authentication state (to be replaced with real auth system)
  static bool _isAuthenticated = false;
  static String? _currentUserRole;
  static const Set<String> _allowedRoles = {'admin', 'superadmin'};

  // ── Public API ──────────────────────────────────────────────────────────────────

  /// Check if user can access the admin module
  /// Returns true if access is allowed, false otherwise
  static Future<bool> canAccessAdmin() async {
    if (!authenticationEnabled) {
      _log('Authentication disabled, allowing access');
      return true;
    }

    // In a real implementation, this would check session, tokens, etc.
    _log('Checking admin access: authenticated=$_isAuthenticated, role=$_currentUserRole');
    return _isAuthenticated && _allowedRoles.contains(_currentUserRole);
  }

  /// Check if user can access a specific route
  /// More granular permission checking for specific routes
  static Future<bool> canAccessRoute(String route) async {
    if (!authenticationEnabled) {
      return true;
    }

    // Basic access check
    if (!(await canAccessAdmin())) {
      return false;
    }

    // Route-specific permissions can be added here
    // For example, only superadmin can access settings
    // if (route == AdminRoutes.settings && _currentUserRole != 'superadmin') {
    //   return false;
    // }

    return true;
  }

  /// Redirect to login screen if authentication fails
  static void redirectToLogin(BuildContext context) {
    _log('Redirecting to login');
    // TODO: Implement login screen navigation
    // Navigator.of(context).pushReplacementNamed('/login');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Authentication required. Please log in.'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  /// Show access denied message
  static void showAccessDenied(BuildContext context, {String? route}) {
    _log('Access denied${route != null ? " for route: $route" : ""}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          route != null
              ? 'Access denied for ${getRouteDisplayName(route)}'
              : 'Access denied. Insufficient permissions.',
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Check permissions before navigating to a route
  /// Returns true if navigation should proceed, false otherwise
  static Future<bool> checkPermissions(
    BuildContext context,
    String route,
  ) async {
    if (!authenticationEnabled) {
      return true;
    }

    final canAccess = await canAccessRoute(route);

    if (!canAccess) {
      if (context.mounted) {
        showAccessDenied(context, route: route);
      }
      return false;
    }

    return true;
  }

  // ── Mock Authentication Methods (for testing/demo) ───────────────────────────────

  /// Mock login method (for testing purposes)
  static Future<bool> login(String username, String password) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate API call

    // Mock authentication logic
    if (username == 'admin' && password == 'admin') {
      _isAuthenticated = true;
      _currentUserRole = 'admin';
      _log('Login successful: username=$username, role=$_currentUserRole');
      return true;
    }

    if (username == 'superadmin' && password == 'superadmin') {
      _isAuthenticated = true;
      _currentUserRole = 'superadmin';
      _log('Login successful: username=$username, role=$_currentUserRole');
      return true;
    }

    _log('Login failed: username=$username');
    return false;
  }

  /// Mock logout method
  static void logout() {
    _isAuthenticated = false;
    _currentUserRole = null;
    _log('Logout successful');
  }

  /// Get current user role
  static String? getCurrentUserRole() {
    return _currentUserRole;
  }

  /// Check if currently authenticated
  static bool isAuthenticated() {
    return _isAuthenticated;
  }

  // ── Utility Methods ─────────────────────────────────────────────────────────────

  /// Get a human-readable name for a route
  static String getRouteDisplayName(String route) {
    // Extract the route name from the path
    final segments = route.split('/').where((s) => s.isNotEmpty);
    if (segments.isEmpty) return 'Home';

    final page = segments.last;
    return page[0].toUpperCase() + page.substring(1);
  }

  /// Debug logging
  static void _log(String message) {
    if (debugMode) {
      debugPrint('[AdminAuthGuard] $message');
    }
  }

  // ── Route Middleware ───────────────────────────────────────────────────────────────

  /// Middleware function for route protection
  /// Can be used with Navigator 2.0 or routing packages
  static RouteGuardMiddleware get middleware => RouteGuardMiddleware();

  /// Get login route (for redirect)
  static String get loginRoute => '/admin/login';
}

/// Route guard middleware for use with navigation systems
class RouteGuardMiddleware {
  const RouteGuardMiddleware();

  /// Check if route can be accessed
  Future<bool> canAccess(String route) async {
    return AdminAuthGuard.canAccessRoute(route);
  }

  /// Get redirect route if access denied
  String? getRedirectRoute(String attemptedRoute) {
    if (!AdminAuthGuard.isAuthenticated()) {
      return AdminAuthGuard.loginRoute;
    }
    return null; // No redirect needed, just show access denied
  }
}

// ── Mixin for Easy Access ────────────────────────────────────────────────────────────

/// Mixin to provide easy access to authentication methods in widgets
mixin AdminAuthMixin {
  /// Check if current user can access admin
  Future<bool> canAccessAdmin() => AdminAuthGuard.canAccessAdmin();

  /// Check if current user can access specific route
  Future<bool> canAccessRoute(String route) =>
      AdminAuthGuard.canAccessRoute(route);

  /// Get current user role
  String? get currentUserRole => AdminAuthGuard.getCurrentUserRole();

  /// Check if authenticated
  bool get isAuthenticated => AdminAuthGuard.isAuthenticated();
}
