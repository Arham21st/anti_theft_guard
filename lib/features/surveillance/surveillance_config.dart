import 'dart:convert';

/// The global capture mode for the device.
///
/// A physical camera can either snap photos OR record video at any one
/// moment — never both. This enum is the single arbiter that enforces that
/// invariant across the surveillance screens.
enum CaptureMode { photo, video }

CaptureMode _parseCaptureMode(String? value) {
  return value == CaptureMode.video.name ? CaptureMode.video : CaptureMode.photo;
}

/// Persisted surveillance settings.
///
/// Photo-side fields are only meaningful when [captureMode] == [CaptureMode.photo];
/// video-side fields only when [captureMode] == [CaptureMode.video]. The
/// [SurveillanceConfigNotifier] keeps the inactive side "off" automatically.
class SurveillanceConfig {
  const SurveillanceConfig({
    this.captureMode = CaptureMode.photo,
    // Photo side
    this.frontAutoCapture = true,
    this.frontDelayIdx = 0,
    this.frontMaxPhotosIdx = 1,
    this.backAutoCapture = true,
    this.backDelayIdx = 0,
    this.backMaxPhotosIdx = 1,
    // Video side
    this.videoAutoStart = true,
    this.videoCameraIdx = 0, // 0 = Front, 1 = Back
    this.videoQualityIdx = 0, // 0 = 360p, 1 = 720p
    this.videoDurationIdx = 1, // 0 = 30s, 1 = 1m, 2 = 5m
  });

  final CaptureMode captureMode;

  // ── Photo side ─────────────────────────────────────────────────────────────
  final bool frontAutoCapture;
  final int frontDelayIdx; // index into ['10s','20s','30s']
  final int frontMaxPhotosIdx; // index into ['1','3','5']

  final bool backAutoCapture;
  final int backDelayIdx;
  final int backMaxPhotosIdx;

  // ── Video side ─────────────────────────────────────────────────────────────
  final bool videoAutoStart;
  final int videoCameraIdx;
  final int videoQualityIdx;
  final int videoDurationIdx;

  /// Whether photo capture is currently armed (mode is photo AND a camera auto-capture is on).
  bool get photoArmed =>
      captureMode == CaptureMode.photo &&
      (frontAutoCapture || backAutoCapture);

  /// Whether video recording is currently armed (mode is video AND auto-start is on).
  bool get videoArmed =>
      captureMode == CaptureMode.video && videoAutoStart;

  /// A new copy with the inactive side forced off — used by the notifier
  /// whenever [captureMode] changes to guarantee mutual exclusivity.
  SurveillanceConfig normalizedFor(CaptureMode mode) {
    return copyWith(
      captureMode: mode,
      // When in photo mode the device cannot be recording.
      videoAutoStart: mode == CaptureMode.photo ? false : videoAutoStart,
      // When in video mode the device cannot be auto-capturing photos.
      frontAutoCapture:
          mode == CaptureMode.video ? false : frontAutoCapture,
      backAutoCapture:
          mode == CaptureMode.video ? false : backAutoCapture,
    );
  }

  SurveillanceConfig copyWith({
    CaptureMode? captureMode,
    bool? frontAutoCapture,
    int? frontDelayIdx,
    int? frontMaxPhotosIdx,
    bool? backAutoCapture,
    int? backDelayIdx,
    int? backMaxPhotosIdx,
    bool? videoAutoStart,
    int? videoCameraIdx,
    int? videoQualityIdx,
    int? videoDurationIdx,
  }) {
    return SurveillanceConfig(
      captureMode: captureMode ?? this.captureMode,
      frontAutoCapture: frontAutoCapture ?? this.frontAutoCapture,
      frontDelayIdx: frontDelayIdx ?? this.frontDelayIdx,
      frontMaxPhotosIdx: frontMaxPhotosIdx ?? this.frontMaxPhotosIdx,
      backAutoCapture: backAutoCapture ?? this.backAutoCapture,
      backDelayIdx: backDelayIdx ?? this.backDelayIdx,
      backMaxPhotosIdx: backMaxPhotosIdx ?? this.backMaxPhotosIdx,
      videoAutoStart: videoAutoStart ?? this.videoAutoStart,
      videoCameraIdx: videoCameraIdx ?? this.videoCameraIdx,
      videoQualityIdx: videoQualityIdx ?? this.videoQualityIdx,
      videoDurationIdx: videoDurationIdx ?? this.videoDurationIdx,
    );
  }

  Map<String, dynamic> toJson() => {
        'captureMode': captureMode.name,
        'frontAutoCapture': frontAutoCapture,
        'frontDelayIdx': frontDelayIdx,
        'frontMaxPhotosIdx': frontMaxPhotosIdx,
        'backAutoCapture': backAutoCapture,
        'backDelayIdx': backDelayIdx,
        'backMaxPhotosIdx': backMaxPhotosIdx,
        'videoAutoStart': videoAutoStart,
        'videoCameraIdx': videoCameraIdx,
        'videoQualityIdx': videoQualityIdx,
        'videoDurationIdx': videoDurationIdx,
      };

  static SurveillanceConfig fromJson(Map<String, dynamic> json) {
    return SurveillanceConfig(
      captureMode: _parseCaptureMode(json['captureMode'] as String?),
      frontAutoCapture: json['frontAutoCapture'] as bool? ?? true,
      frontDelayIdx: json['frontDelayIdx'] as int? ?? 0,
      frontMaxPhotosIdx: json['frontMaxPhotosIdx'] as int? ?? 1,
      backAutoCapture: json['backAutoCapture'] as bool? ?? true,
      backDelayIdx: json['backDelayIdx'] as int? ?? 0,
      backMaxPhotosIdx: json['backMaxPhotosIdx'] as int? ?? 1,
      videoAutoStart: json['videoAutoStart'] as bool? ?? true,
      videoCameraIdx: json['videoCameraIdx'] as int? ?? 0,
      videoQualityIdx: json['videoQualityIdx'] as int? ?? 0,
      videoDurationIdx: json['videoDurationIdx'] as int? ?? 1,
    );
  }

  String encode() => jsonEncode(toJson());

  static SurveillanceConfig decode(String? raw) {
    if (raw == null || raw.isEmpty) return const SurveillanceConfig();
    try {
      return SurveillanceConfig.fromJson(
          jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return const SurveillanceConfig();
    }
  }
}
