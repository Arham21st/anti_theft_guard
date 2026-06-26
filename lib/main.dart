import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/config/app_env.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'features/splash/splash_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/auth/pin_setup_screen.dart';
import 'features/auth/pin_lock_screen.dart';
import 'navigation/bottom_nav_shell.dart';
import 'features/trigger_settings/trigger_settings_screen.dart';
import 'features/trigger_settings/password_trigger_screen.dart';
import 'features/trigger_settings/volume_sequence_screen.dart';
import 'features/blackout/blackout_preview_screen.dart';
import 'features/stealth/stealth_mode_screen.dart';
import 'features/auto_start/auto_start_screen.dart';
import 'features/location/live_location_screen.dart';
import 'features/location/location_history_screen.dart';
import 'features/surveillance/front_camera_screen.dart';
import 'features/surveillance/back_camera_screen.dart';
import 'features/surveillance/video_recording_screen.dart';
import 'features/battery/battery_monitor_screen.dart';
import 'features/sms/emergency_sms_screen.dart';
import 'admin/admin_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0A0A0F),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const AntiTheftApp());
}

class AntiTheftApp extends StatelessWidget {
  const AntiTheftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppEnv.displayName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (_) => const SplashScreen(),
        AppRoutes.admin: (_) => const AdminShell(),
        AppRoutes.register: (_) => const RegisterScreen(),
        AppRoutes.pinSetup: (_) => const PinSetupScreen(),
        AppRoutes.pinLock: (_) => const PinLockScreen(),
        AppRoutes.home: (_) => const BottomNavShell(),
        AppRoutes.triggerSettings: (_) => const TriggerSettingsScreen(),
        AppRoutes.passwordTrigger: (_) => const PasswordTriggerScreen(),
        AppRoutes.volumeSequence: (_) => const VolumeSequenceScreen(),
        AppRoutes.blackoutPreview: (_) => const BlackoutPreviewScreen(),
        AppRoutes.stealthMode: (_) => const StealthModeScreen(),
        AppRoutes.autoStart: (_) => const AutoStartScreen(),
        AppRoutes.liveLocation: (_) => const LiveLocationScreen(),
        AppRoutes.locationHistory: (_) => const LocationHistoryScreen(),
        AppRoutes.frontCamera: (_) => const FrontCameraScreen(),
        AppRoutes.backCamera: (_) => const BackCameraScreen(),
        AppRoutes.videoRecording: (_) => const VideoRecordingScreen(),
        AppRoutes.batteryMonitor: (_) => const BatteryMonitorScreen(),
        AppRoutes.emergencySms: (_) => const EmergencySmsScreen(),
      },
    );
  }
}
