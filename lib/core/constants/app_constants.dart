class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String admin = '/admin';
  static const String register = '/register';
  static const String pinSetup = '/pin-setup';
  static const String pinLock = '/pin-lock';
  static const String home = '/home';
  static const String triggerSettings = '/trigger-settings';
  static const String passwordTrigger = '/password-trigger';
  static const String volumeSequence = '/volume-sequence';
  static const String blackoutPreview = '/blackout-preview';
  static const String stealthMode = '/stealth-mode';
  static const String autoStart = '/auto-start';
  static const String liveLocation = '/live-location';
  static const String locationHistory = '/location-history';
  static const String frontCamera = '/front-camera';
  static const String backCamera = '/back-camera';
  static const String videoRecording = '/video-recording';
  static const String batteryMonitor = '/battery-monitor';
  static const String emergencySms = '/emergency-sms';
}

class AppStrings {
  AppStrings._();

  static const String appName = 'Anti-Theft Guard';
  static const String tagline = 'Your Silent Security Shield';
  static const String version = 'v1.0.0 Alpha';

  // Status
  static const String protected = 'PROTECTED';
  static const String inactive = 'INACTIVE';
  static const String active = 'ACTIVE';
  static const String stealthActive = 'STEALTH ACTIVE';

  // Nav labels
  static const String dashboard = 'Dashboard';
  static const String surveillance = 'Surveillance';
  static const String location = 'Location';
  static const String logs = 'Logs';
  static const String settings = 'Settings';
}
