/// Repository interface for account authentication operations.
///
/// Mirrors the abstract [AdminRepository] pattern used elsewhere in the app.
/// Implementations decide where/how credentials are persisted.
abstract class AuthRepository {
  // ── Registration state ───────────────────────────────────────────────────────

  /// Whether the user has completed first-time registration (email + password).
  Future<bool> isRegistered();

  /// Whether a PIN has been set (independent of full registration).
  Future<bool> hasPin();

  /// The registered email, if any.
  Future<String?> getEmail();

  // ── Registration & authentication ────────────────────────────────────────────

  /// Persist a new account (email + password) without setting a PIN.
  /// Throws if already registered.
  Future<void> registerAccount({required String email, required String password});

  /// Persist (or overwrite) the PIN.
  Future<void> setPin(String pin);

  /// Returns true if [pin] matches the stored PIN.
  Future<bool> verifyPin(String pin);

  /// Returns true if [password] matches the stored account password.
  Future<bool> verifyPassword(String password);

  /// Re-authenticate with [password] and set a new PIN.
  /// Returns true on success, false if the password was incorrect.
  Future<bool> resetPinWithPassword({
    required String password,
    required String newPin,
  });

  /// Wipe all account & PIN data (factory reset for the app).
  Future<void> reset();
}

/// Thrown when an account already exists and a fresh registration is attempted.
class AccountAlreadyExistsException implements Exception {
  const AccountAlreadyExistsException();
  @override
  String toString() => 'An account is already registered on this device.';
}
