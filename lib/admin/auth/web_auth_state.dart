import 'package:flutter/material.dart';

import 'mock_accounts.dart';
import 'user_role.dart';

/// Reactive holder of the current web session.
///
/// Mirrors the project's `ChangeNotifier` + `InheritedNotifier` convention
/// (see `AdminNavigationState`/`AdminNavigationProvider`). The shell, sidebar,
/// top bar, and pages read [role] / [session] to branch their UI.
class WebAuthState extends ChangeNotifier {
  WebAuthState();

  MockSession? _session;

  /// The current session, or `null` when logged out.
  MockSession? get session => _session;

  bool get isLoggedIn => _session != null;
  UserRole get role => _session?.role ?? UserRole.user;
  String? get userEmail => _session?.email;
  String? get userDeviceId => _session?.deviceId;

  /// Attempt a login. Returns `true` on success.
  bool login(String email, String password) {
    final session = MockAccounts.login(email, password);
    if (session == null) return false;
    _session = session;
    notifyListeners();
    return true;
  }

  void logout() {
    _session = null;
    notifyListeners();
  }
}

/// Provides [WebAuthState] to descendants and rebuilds them when it changes.
class WebAuthProvider extends InheritedNotifier {
  const WebAuthProvider({
    super.key,
    required WebAuthState authState,
    required super.child,
  }) : super(notifier: authState);

  static WebAuthState of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<WebAuthProvider>();
    if (provider == null) {
      throw FlutterError(
        'WebAuthProvider.of() called with a context that does not contain a '
        'WebAuthProvider. Wrap the web MaterialApp in WebAuthProvider.',
      );
    }
    return provider.notifier! as WebAuthState;
  }

  static WebAuthState? ofOrNull(BuildContext context) {
    final provider =
        context.getInheritedWidgetOfExactType<WebAuthProvider>();
    return provider?.notifier as WebAuthState?;
  }
}
