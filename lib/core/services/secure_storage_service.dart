import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Typed wrapper around [FlutterSecureStorage].
///
/// Centralizes all persistent key-value reads/writes for the app so that
/// repositories never touch raw string keys directly. Values are encrypted at
/// rest by the platform (Android Keystore / iOS Keychain).
class SecureStorageService {
  SecureStorageService._();
  static final SecureStorageService instance = SecureStorageService._();

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  // ── Keys ──────────────────────────────────────────────────────────────────
  static const String _kAccountEmail = 'account_email';
  static const String _kAccountPasswordHash = 'account_password_hash';
  static const String _kPinHash = 'pin_hash';
  static const String _kSurveillanceConfig = 'surveillance_config';

  // ── Account ───────────────────────────────────────────────────────────────

  /// Whether the user has completed first-time registration (email + password).
  Future<bool> hasAccount() async {
    final email = await _storage.read(key: _kAccountEmail);
    final pwd = await _storage.read(key: _kAccountPasswordHash);
    return email != null && email.isNotEmpty && pwd != null && pwd.isNotEmpty;
  }

  Future<String?> getEmail() => _storage.read(key: _kAccountEmail);

  Future<void> setEmail(String email) =>
      _storage.write(key: _kAccountEmail, value: email);

  Future<void> setPasswordHash(String hash) =>
      _storage.write(key: _kAccountPasswordHash, value: hash);

  Future<String?> getPasswordHash() =>
      _storage.read(key: _kAccountPasswordHash);

  // ── PIN ───────────────────────────────────────────────────────────────────

  Future<bool> hasPin() async {
    final pin = await _storage.read(key: _kPinHash);
    return pin != null && pin.isNotEmpty;
  }

  Future<void> setPinHash(String hash) =>
      _storage.write(key: _kPinHash, value: hash);

  Future<String?> getPinHash() => _storage.read(key: _kPinHash);

  // ── Surveillance config ───────────────────────────────────────────────────

  Future<String?> getSurveillanceConfig() =>
      _storage.read(key: _kSurveillanceConfig);

  Future<void> setSurveillanceConfig(String json) =>
      _storage.write(key: _kSurveillanceConfig, value: json);

  Future<void> removeSurveillanceConfig() =>
      _storage.delete(key: _kSurveillanceConfig);

  // ── Reset ─────────────────────────────────────────────────────────────────

  /// Wipes all persisted app data.
  Future<void> wipe() => _storage.deleteAll();
}
