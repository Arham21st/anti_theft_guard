import 'package:flutter/foundation.dart';

import '../../core/services/secure_storage_service.dart';
import 'surveillance_config.dart';

/// Reactive, persisted, single-source-of-truth holder for [SurveillanceConfig].
///
/// The key invariant lives here: **photo capture and video recording can never
/// be armed at the same time.** Switching the global [CaptureMode] is the only
/// way to flip which side is active, and [setCaptureMode] forces the inactive
/// side's "auto" toggles off before persisting. Side-specific setters (e.g.
/// [setFrontAutoCapture]) are no-ops while their side is inactive, so a stale
/// UI can never re-arm the wrong mode.
class SurveillanceConfigNotifier extends ChangeNotifier {
  SurveillanceConfigNotifier._() : _config = const SurveillanceConfig();
  static final SurveillanceConfigNotifier instance =
      SurveillanceConfigNotifier._();

  SurveillanceConfig _config;
  bool _loaded = false;

  SurveillanceConfig get config => _config;
  CaptureMode get captureMode => _config.captureMode;

  /// Load persisted config (if any). Safe to call multiple times.
  Future<void> load() async {
    if (_loaded) return;
    final raw = await SecureStorageService.instance.getSurveillanceConfig();
    _config = SurveillanceConfig.decode(raw);
    _loaded = true;
    notifyListeners();
  }

  // ── The global mode switch (the mutual-exclusivity gate) ─────────────────────
  Future<void> setCaptureMode(CaptureMode mode) async {
    if (_config.captureMode == mode) return;
    _config = _config.normalizedFor(mode);
    notifyListeners();
    await _persist();
  }

  // ── Photo-side setters (no-op while in video mode) ──────────────────────────
  Future<void> setFrontAutoCapture(bool value) async {
    if (_config.captureMode != CaptureMode.photo) return;
    _config = _config.copyWith(frontAutoCapture: value);
    notifyListeners();
    await _persist();
  }

  Future<void> setFrontDelayIdx(int idx) async {
    if (_config.captureMode != CaptureMode.photo) return;
    _config = _config.copyWith(frontDelayIdx: idx);
    notifyListeners();
    await _persist();
  }

  Future<void> setFrontMaxPhotosIdx(int idx) async {
    if (_config.captureMode != CaptureMode.photo) return;
    _config = _config.copyWith(frontMaxPhotosIdx: idx);
    notifyListeners();
    await _persist();
  }

  Future<void> setBackAutoCapture(bool value) async {
    if (_config.captureMode != CaptureMode.photo) return;
    _config = _config.copyWith(backAutoCapture: value);
    notifyListeners();
    await _persist();
  }

  Future<void> setBackDelayIdx(int idx) async {
    if (_config.captureMode != CaptureMode.photo) return;
    _config = _config.copyWith(backDelayIdx: idx);
    notifyListeners();
    await _persist();
  }

  Future<void> setBackMaxPhotosIdx(int idx) async {
    if (_config.captureMode != CaptureMode.photo) return;
    _config = _config.copyWith(backMaxPhotosIdx: idx);
    notifyListeners();
    await _persist();
  }

  // ── Video-side setters (no-op while in photo mode) ──────────────────────────
  Future<void> setVideoAutoStart(bool value) async {
    if (_config.captureMode != CaptureMode.video) return;
    _config = _config.copyWith(videoAutoStart: value);
    notifyListeners();
    await _persist();
  }

  Future<void> setVideoCameraIdx(int idx) async {
    if (_config.captureMode != CaptureMode.video) return;
    _config = _config.copyWith(videoCameraIdx: idx);
    notifyListeners();
    await _persist();
  }

  Future<void> setVideoQualityIdx(int idx) async {
    if (_config.captureMode != CaptureMode.video) return;
    _config = _config.copyWith(videoQualityIdx: idx);
    notifyListeners();
    await _persist();
  }

  Future<void> setVideoDurationIdx(int idx) async {
    if (_config.captureMode != CaptureMode.video) return;
    _config = _config.copyWith(videoDurationIdx: idx);
    notifyListeners();
    await _persist();
  }

  /// Reset to defaults (used on factory reset).
  Future<void> reset() async {
    _config = const SurveillanceConfig();
    notifyListeners();
    await SecureStorageService.instance.removeSurveillanceConfig();
  }

  Future<void> _persist() {
    return SecureStorageService.instance.setSurveillanceConfig(_config.encode());
  }
}
