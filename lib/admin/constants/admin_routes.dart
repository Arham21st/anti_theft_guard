/// Route constants and utilities for the admin module.
/// Provides type-safe routing and eliminates magic numbers used for navigation.
class AdminRoutes {
  AdminRoutes._();

  // ── Base Paths ────────────────────────────────────────────────────────────────
  /// Root path for all admin routes
  static const String root = '/admin';

  /// Login screen (entry point for the web portal)
  static const String login = '/admin/login';

  // ── Page Routes ───────────────────────────────────────────────────────────────
  /// Admin overview/dashboard page (index 0)
  static const String overview = '$root/overview';

  /// Device management page (index 1)
  static const String devices = '$root/devices';

  /// Surveillance/camera monitoring page (index 2)
  static const String surveillance = '$root/surveillance';

  /// Location tracking page (index 3)
  static const String location = '$root/location';

  /// Event logs page (index 4)
  static const String logs = '$root/logs';

  /// Security settings page (index 5)
  static const String security = '$root/security';

  /// Emergency SMS management page (index 6)
  static const String sms = '$root/sms';

  /// Battery monitoring page (index 7)
  static const String battery = '$root/battery';

  /// Admin settings page (index 8)
  static const String settings = '$root/settings';

  // ── Route Query Parameters ──────────────────────────────────────────────────────
  /// Query parameter for device ID filtering
  static const String deviceIdParam = 'deviceId';

  // ── All Routes List ───────────────────────────────────────────────────────────
  /// Ordered list of all admin routes for navigation
  static const List<String> allRoutes = [
    overview,
    devices,
    surveillance,
    location,
    logs,
    security,
    sms,
    battery,
    settings,
  ];

  // ── Navigation Helpers ────────────────────────────────────────────────────────

  /// Get route path for a specific device context
  /// Example: getDevicePath('device-123', AdminRoutes.location) -> '/admin/location?deviceId=device-123'
  static String getDevicePath(String deviceId, String route) {
    final uri = Uri.parse(route);
    final queryParams = Map<String, String>.from(uri.queryParameters);
    queryParams[deviceIdParam] = deviceId;
    return uri.replace(queryParameters: queryParams).toString();
  }

  /// Extract device ID from route query parameters
  static String? getDeviceIdFromRoute(String route) {
    try {
      final uri = Uri.parse(route);
      return uri.queryParameters[deviceIdParam];
    } catch (_) {
      return null;
    }
  }

  /// Check if a given route string is a valid admin route
  static bool isValidRoute(String? route) {
    if (route == null) return false;
    return allRoutes.any((r) => route.startsWith(r));
  }

  /// Convert route string to index for legacy compatibility
  /// Returns -1 if route is not found
  static int routeToIndex(String route) {
    // Check if route has query parameters and strip them
    final cleanRoute = route.contains('?')
        ? route.substring(0, route.indexOf('?'))
        : route;

    final index = allRoutes.indexWhere((r) => r == cleanRoute);
    return index; // Returns -1 if not found
  }

  /// Convert index to route string for legacy compatibility
  /// Returns root route if index is out of bounds
  static String indexToRoute(int index) {
    if (index >= 0 && index < allRoutes.length) {
      return allRoutes[index];
    }
    return overview; // Default to overview for invalid indices
  }

  /// Get the next route in the navigation sequence
  static String? getNextRoute(String currentRoute) {
    final index = routeToIndex(currentRoute);
    if (index >= 0 && index < allRoutes.length - 1) {
      return allRoutes[index + 1];
    }
    return null; // Already at last route
  }

  /// Get the previous route in the navigation sequence
  static String? getPreviousRoute(String currentRoute) {
    final index = routeToIndex(currentRoute);
    if (index > 0) {
      return allRoutes[index - 1];
    }
    return null; // Already at first route
  }

  // ── Display Names ─────────────────────────────────────────────────────────────
  /// Get a human-readable name for a route
  static String getDisplayName(String route) {
    final cleanRoute = route.contains('?')
        ? route.substring(0, route.indexOf('?'))
        : route;

    switch (cleanRoute) {
      case overview:
        return 'Overview';
      case devices:
        return 'Devices';
      case surveillance:
        return 'Surveillance';
      case location:
        return 'Location';
      case logs:
        return 'Logs';
      case security:
        return 'Security';
      case sms:
        return 'SMS';
      case battery:
        return 'Battery';
      case settings:
        return 'Settings';
      default:
        return 'Unknown';
    }
  }
}
