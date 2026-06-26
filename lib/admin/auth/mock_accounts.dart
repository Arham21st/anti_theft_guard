import 'user_role.dart';

/// A simulated logged-in session (mock-only — no backend exists yet).
class MockSession {
  const MockSession({
    required this.email,
    required this.displayName,
    required this.role,
    this.deviceId,
  });

  final String email;
  final String displayName;
  final UserRole role;

  /// For [UserRole.user], the single device this account owns. `null` for admins.
  final String? deviceId;

  /// Initials for the avatar (e.g. "Ayesha Khan" -> "AK").
  String get initials {
    final parts = displayName.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';
  }
}

/// A single demo account row in the simulated "accounts database".
class _DemoAccount {
  const _DemoAccount({
    required this.email,
    required this.password,
    required this.displayName,
    required this.role,
    this.deviceId,
  });

  final String email;
  final String password;
  final String displayName;
  final UserRole role;
  final String? deviceId;
}

/// Simulated account store for the web portal.
///
/// In a future phase this is replaced by a real backend; the seam
/// (login -> session) stays the same, so UI code need not change.
class MockAccounts {
  MockAccounts._();

  // NOTE: emails are intentionally kept short/demo for easy typing on the
  // login screen. They map onto the device owners in AdminMockData.
  static const List<_DemoAccount> _accounts = [
    _DemoAccount(
      email: 'admin@guard.io',
      password: 'admin123',
      displayName: 'Fleet Admin',
      role: UserRole.admin,
    ),
    // End-user demo accounts — each owns exactly one mock device.
    _DemoAccount(
      email: 'sara@guard.io',
      password: 'sara123',
      displayName: 'Sara Ahmed',
      role: UserRole.user,
      deviceId: 'dev-003', // Sara iPhone 15 — status: stolen (demo lost phone)
    ),
    _DemoAccount(
      email: 'ayesha@guard.io',
      password: 'ayesha123',
      displayName: 'Ayesha Khan',
      role: UserRole.user,
      deviceId: 'dev-001', // Ayesha Pixel 8 — protected
    ),
    _DemoAccount(
      email: 'hamza@guard.io',
      password: 'hamza123',
      displayName: 'Hamza Ali',
      role: UserRole.user,
      deviceId: 'dev-002', // Hamza Galaxy S24 — warning, low battery
    ),
  ];

  /// All demo accounts, for rendering the login-screen hint card.
  /// Returns public view (no password reuse — callers get a [MockAccountDemo]).
  static List<MockAccountDemo> get demos => _accounts
      .map((a) => MockAccountDemo(
            email: a.email,
            password: a.password,
            role: a.role,
          ))
      .toList();

  /// Authenticate. Returns a session on success, or `null` on bad credentials.
  static MockSession? login(String email, String password) {
    final normalized = email.trim().toLowerCase();
    for (final account in _accounts) {
      if (account.email == normalized && account.password == password) {
        return MockSession(
          email: account.email,
          displayName: account.displayName,
          role: account.role,
          deviceId: account.deviceId,
        );
      }
    }
    return null;
  }
}

/// Public, login-screen-facing demo-account row (email + password + role only).
class MockAccountDemo {
  const MockAccountDemo({
    required this.email,
    required this.password,
    required this.role,
  });

  final String email;
  final String password;
  final UserRole role;
}
