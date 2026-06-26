import 'package:flutter/widgets.dart';
import '../constants/admin_routes.dart';

/// Navigation state manager for the admin module.
/// Provides centralized navigation state, history tracking, and device selection.
class AdminNavigationState extends ChangeNotifier {
  AdminNavigationState();

  // ── Current Navigation State ──────────────────────────────────────────────
  String _currentRoute = AdminRoutes.overview;
  String? _selectedDeviceId;

  // ── Navigation History ────────────────────────────────────────────────────────
  /// Stack of previously visited routes for back button functionality
  final List<String> _historyStack = [];

  /// Maximum history stack size to prevent unbounded growth
  static const int _maxHistorySize = 20;

  // ── Getters ─────────────────────────────────────────────────────────────────
  /// The current active route
  String get currentRoute => _currentRoute;

  /// The currently selected device ID for filtering
  String? get selectedDeviceId => _selectedDeviceId;

  /// Whether there's history to pop back to
  bool get canPop => _historyStack.isNotEmpty;

  /// The current route index (0-8) for legacy compatibility
  int get currentIndex => AdminRoutes.routeToIndex(_currentRoute);

  /// The number of items in the navigation history
  int get historyLength => _historyStack.length;

  // ── Navigation Actions ────────────────────────────────────────────────────────

  /// Navigate to a new route
  /// If [addToHistory] is true, the current route is added to the history stack
  void navigateTo(
    String route, {
    String? deviceId,
    bool addToHistory = true,
  }) {
    // Validate route
    if (!AdminRoutes.isValidRoute(route)) {
      debugPrint('AdminNavigationState: Invalid route "$route"');
      return;
    }

    // Add current route to history before navigating
    if (addToHistory && _currentRoute != route) {
      _addToHistory(_currentRoute);
    }

    // Update state
    _currentRoute = route;
    if (deviceId != null) {
      _selectedDeviceId = deviceId;
    }

    notifyListeners();
  }

  /// Navigate to a route by its index (legacy compatibility)
  void navigateToIndex(int index) {
    final route = AdminRoutes.indexToRoute(index);
    navigateTo(route);
  }

  /// Navigate to the overview page
  void navigateToOverview({String? deviceId}) {
    navigateTo(AdminRoutes.overview, deviceId: deviceId);
  }

  /// Navigate to the devices page
  void navigateToDevices({String? deviceId}) {
    navigateTo(AdminRoutes.devices, deviceId: deviceId);
  }

  /// Navigate to the surveillance page
  void navigateToSurveillance({String? deviceId}) {
    navigateTo(AdminRoutes.surveillance, deviceId: deviceId);
  }

  /// Navigate to the location page
  void navigateToLocation({String? deviceId}) {
    navigateTo(AdminRoutes.location, deviceId: deviceId);
  }

  /// Navigate to the logs page
  void navigateToLogs({String? deviceId}) {
    navigateTo(AdminRoutes.logs, deviceId: deviceId);
  }

  /// Navigate to the security page
  void navigateToSecurity({String? deviceId}) {
    navigateTo(AdminRoutes.security, deviceId: deviceId);
  }

  /// Navigate to the SMS page
  void navigateToSms({String? deviceId}) {
    navigateTo(AdminRoutes.sms, deviceId: deviceId);
  }

  /// Navigate to the battery page
  void navigateToBattery({String? deviceId}) {
    navigateTo(AdminRoutes.battery, deviceId: deviceId);
  }

  /// Navigate to the settings page
  void navigateToSettings({String? deviceId}) {
    navigateTo(AdminRoutes.settings, deviceId: deviceId);
  }

  // ── Back Navigation ───────────────────────────────────────────────────────────

  /// Pop back to the previous route in history
  /// Returns the route that was popped, or null if no history
  String? pop() {
    if (_historyStack.isEmpty) return null;

    final previousRoute = _historyStack.removeLast();
    _currentRoute = previousRoute;
    notifyListeners();

    return previousRoute;
  }

  /// Pop multiple routes at once
  /// Returns the final route after all pops
  String? popMultiple(int count) {
    if (count < 1) return null;

    String? finalRoute;
    for (int i = 0; i < count && _historyStack.isNotEmpty; i++) {
      finalRoute = pop();
    }

    return finalRoute;
  }

  /// Pop to the first route in history (clear all history)
  /// Returns the first route, or null if no history
  String? popToFirst() {
    if (_historyStack.isEmpty) return null;

    final firstRoute = _historyStack.first;
    _historyStack.clear();
    _currentRoute = firstRoute;
    notifyListeners();

    return firstRoute;
  }

  /// Pop to a specific route in history
  /// Returns the route if found, null otherwise
  String? popToRoute(String targetRoute) {
    final index = _historyStack.lastIndexOf(targetRoute);
    if (index < 0) return null;

    // Remove all routes after the target
    final routesToKeep = _historyStack.sublist(0, index);
    _historyStack
      ..clear()
      ..addAll(routesToKeep);

    _currentRoute = targetRoute;
    notifyListeners();

    return targetRoute;
  }

  // ── Device Selection ──────────────────────────────────────────────────────────

  /// Select a device for filtering across admin pages
  void selectDevice(String deviceId) {
    if (_selectedDeviceId != deviceId) {
      _selectedDeviceId = deviceId;
      notifyListeners();
    }
  }

  /// Clear the device selection
  void clearDeviceSelection() {
    if (_selectedDeviceId != null) {
      _selectedDeviceId = null;
      notifyListeners();
    }
  }

  // ── History Management ────────────────────────────────────────────────────────

  /// Get the previous route without popping
  String? getPreviousRoute() {
    if (_historyStack.isEmpty) return null;
    return _historyStack.last;
  }

  /// Get the full navigation history
  List<String> getHistory() {
    return List.unmodifiable(_historyStack);
  }

  /// Clear all navigation history
  void clearHistory() {
    _historyStack.clear();
    notifyListeners();
  }

  // ── Utility Methods ───────────────────────────────────────────────────────────

  /// Add a route to the history stack
  void _addToHistory(String route) {
    // Don't add duplicate consecutive routes
    if (_historyStack.isNotEmpty && _historyStack.last == route) {
      return;
    }

    _historyStack.add(route);

    // Prevent unbounded growth
    if (_historyStack.length > _maxHistorySize) {
      _historyStack.removeAt(0);
    }
  }

  /// Reset navigation state to initial values
  void reset() {
    _currentRoute = AdminRoutes.overview;
    _selectedDeviceId = null;
    _historyStack.clear();
    notifyListeners();
  }

  /// Check if we're currently on a specific route
  bool isOnRoute(String route) {
    final cleanRoute = route.contains('?')
        ? route.substring(0, route.indexOf('?'))
        : route;

    final cleanCurrentRoute = _currentRoute.contains('?')
        ? _currentRoute.substring(0, _currentRoute.indexOf('?'))
        : _currentRoute;

    return cleanCurrentRoute == cleanRoute;
  }

  @override
  String toString() {
    return 'AdminNavigationState(currentRoute: $_currentRoute, '
        'selectedDeviceId: $_selectedDeviceId, '
        'historyLength: ${_historyStack.length})';
  }
}

// ── Inherited Widget for Access ────────────────────────────────────────────────

/// Widget that provides AdminNavigationState to its descendants
class AdminNavigationProvider extends InheritedWidget {
  const AdminNavigationProvider({
    super.key,
    required AdminNavigationState navigationState,
    required Widget child,
  })  : _navigationState = navigationState,
        super(child: child);

  final AdminNavigationState _navigationState;

  /// Get the navigation state from the given context
  static AdminNavigationState of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<
        AdminNavigationProvider>();

    if (provider == null) {
      throw FlutterError(
        'AdminNavigationState.of() called with a context that does not contain '
        'an AdminNavigationProvider. This can happen when:\n'
        '1. The admin app is not wrapped in an AdminNavigationProvider\n'
        '2. The context used is from a widget that is outside the provider tree\n'
        'Make sure to wrap your AdminNavigationShell with AdminNavigationProvider.',
      );
    }

    return provider._navigationState;
  }

  /// Look up the navigation state without establishing a dependency
  static AdminNavigationState? ofOrNull(BuildContext context) {
    final provider = context
        .getInheritedWidgetOfExactType<AdminNavigationProvider>();
    return provider?._navigationState;
  }

  @override
  bool updateShouldNotify(AdminNavigationProvider oldWidget) {
    return _navigationState != oldWidget._navigationState;
  }
}
