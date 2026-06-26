import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/pulse_indicator.dart';
import '../auth/local_auth_repository.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 3000));
    if (!mounted) return;

    final auth = LocalAuthRepository.instance;
    final isRegistered = await auth.isRegistered();

    String next;
    if (!isRegistered) {
      // First run — collect email + password, then set a PIN.
      next = AppRoutes.register;
    } else if (!await auth.hasPin()) {
      // Registered but PIN missing — send straight to PIN setup.
      next = AppRoutes.pinSetup;
    } else {
      // Returning user — require PIN on cold start.
      next = AppRoutes.pinLock;
    }

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, next);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Shield logo with pulse
              Center(
                child: ShieldPulse(isActive: true, size: 110)
                    .animate()
                    .fadeIn(duration: 800.ms)
                    .scale(
                      begin: const Offset(0.7, 0.7),
                      end: const Offset(1.0, 1.0),
                      duration: 800.ms,
                      curve: Curves.elasticOut,
                    ),
              ),
              const SizedBox(height: 32),
              // App name
              Text(
                    AppStrings.appName,
                    style: AppTextStyles.displayLarge,
                    textAlign: TextAlign.center,
                  )
                  .animate()
                  .fadeIn(delay: 400.ms, duration: 600.ms)
                  .slideY(begin: 0.3, end: 0, delay: 400.ms, duration: 600.ms),
              const SizedBox(height: 8),
              Text(
                AppStrings.tagline,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.primary.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 600.ms, duration: 600.ms),
              const Spacer(flex: 2),
              // Loading indicator
              Column(
                children: [
                  _LoadingBar().animate().fadeIn(
                    delay: 800.ms,
                    duration: 400.ms,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Initializing Security Systems...',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.success.withOpacity(0.7),
                    ),
                  ).animate().fadeIn(delay: 900.ms, duration: 400.ms),
                  const SizedBox(height: 40),
                  Text(
                    AppStrings.version,
                    style: AppTextStyles.labelSmall,
                  ).animate().fadeIn(delay: 1000.ms, duration: 400.ms),
                  const SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingBar extends StatefulWidget {
  @override
  State<_LoadingBar> createState() => _LoadingBarState();
}

class _LoadingBarState extends State<_LoadingBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: 2000.ms);
    _progress = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: AnimatedBuilder(
        animation: _progress,
        builder: (_, _) => ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: _progress.value,
            backgroundColor: AppColors.surfaceElevated,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
            minHeight: 3,
          ),
        ),
      ),
    );
  }
}
