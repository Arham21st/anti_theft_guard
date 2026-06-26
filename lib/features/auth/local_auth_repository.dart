import 'package:crypto/crypto.dart';
import 'dart:convert';

import '../../core/services/secure_storage_service.dart';
import 'auth_repository.dart';

/// Local implementation of [AuthRepository] backed by [SecureStorageService].
///
/// Credentials are never stored in plaintext: even though secure storage
/// encrypts at rest, we additionally SHA-256 hash the PIN and password with a
/// static salt so that a raw dump of storage never reveals them.
class LocalAuthRepository implements AuthRepository {
  LocalAuthRepository._();
  static final LocalAuthRepository instance = LocalAuthRepository._();

  final SecureStorageService _storage = SecureStorageService.instance;

  // Domain-separated salt. Not a secret — its purpose is to prevent rainbow
  // table reuse across this app and other apps.
  static const String _salt = 'anti_theft_guard::v1';

  /// Hash a secret with the static salt.
  String _hash(String value) {
    final bytes = utf8.encode('$_salt::$value');
    return sha256.convert(bytes).toString();
  }

  // ── Registration state ───────────────────────────────────────────────────────
  @override
  Future<bool> isRegistered() => _storage.hasAccount();

  @override
  Future<bool> hasPin() => _storage.hasPin();

  @override
  Future<String?> getEmail() => _storage.getEmail();

  // ── Registration & authentication ────────────────────────────────────────────
  @override
  Future<void> registerAccount({
    required String email,
    required String password,
  }) async {
    if (await _storage.hasAccount()) {
      throw const AccountAlreadyExistsException();
    }
    await _storage.setEmail(email.trim());
    await _storage.setPasswordHash(_hash(password));
  }

  @override
  Future<void> setPin(String pin) async {
    await _storage.setPinHash(_hash(pin));
  }

  @override
  Future<bool> verifyPin(String pin) async {
    final stored = await _storage.getPinHash();
    if (stored == null || stored.isEmpty) return false;
    return _hash(pin) == stored;
  }

  @override
  Future<bool> verifyPassword(String password) async {
    final stored = await _storage.getPasswordHash();
    if (stored == null || stored.isEmpty) return false;
    return _hash(password) == stored;
  }

  @override
  Future<bool> resetPinWithPassword({
    required String password,
    required String newPin,
  }) async {
    if (!await verifyPassword(password)) return false;
    await setPin(newPin);
    return true;
  }

  @override
  Future<void> reset() => _storage.wipe();
}
