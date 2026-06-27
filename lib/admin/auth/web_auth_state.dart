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
///
/// Supports a [builder] form (preferred) so callers that need the [WebAuthState]
/// instance — e.g. to wire it into a `GoRouter.refreshListenable` — can receive
/// it directly. Also still works as a plain `InheritedNotifier` for descendants
/// that only read it via [of].
class WebAuthProvider extends StatefulWidget {
  const WebAuthProvider({
    super.key,
    required this.authState,
    this.builder,
    this.child,
  });

  final WebAuthState authState;

  /// Receives the build context and the [authState]. Use this when a child
  /// needs the notifier instance itself (not just to depend on it).
  final Widget Function(BuildContext context, WebAuthState authState)? builder;

  /// Alternative to [builder] for a static subtree.
  final Widget? child;

  @override
  State<WebAuthProvider> createState() => _WebAuthProviderState();

  static WebAuthState of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<_WebAuthInherited>();
    if (provider == null) {
      throw FlutterError(
        'WebAuthProvider.of() called with a context that does not contain a '
        'WebAuthProvider. Wrap the web MaterialApp in WebAuthProvider.',
      );
    }
    return provider.authState;
  }

  static WebAuthState? ofOrNull(BuildContext context) {
    final provider =
        context.getInheritedWidgetOfExactType<_WebAuthInherited>();
    return provider?.authState;
  }
}

class _WebAuthProviderState extends State<WebAuthProvider> {
  @override
  void initState() {
    super.initState();
    widget.authState.addListener(_handleChange);
  }

  @override
  void dispose() {
    widget.authState.removeListener(_handleChange);
    super.dispose();
  }

  void _handleChange() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return _WebAuthInherited(
      authState: widget.authState,
      child: widget.builder != null
          ? widget.builder!(context, widget.authState)
          : widget.child!,
    );
  }
}

class _WebAuthInherited extends InheritedWidget {
  const _WebAuthInherited({required this.authState, required super.child});

  final WebAuthState authState;

  @override
  bool updateShouldNotify(_WebAuthInherited oldWidget) =>
      authState != oldWidget.authState;
}
