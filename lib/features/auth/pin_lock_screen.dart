import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/glow_button.dart';
import 'local_auth_repository.dart';

/// Cold-start unlock screen.
///
/// Default view: a PIN numpad. A "Forgot PIN?" action switches to an
/// email + password re-auth panel; on success the user sets a new PIN and
/// lands on Home.
class PinLockScreen extends StatefulWidget {
  const PinLockScreen({super.key});

  @override
  State<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends State<PinLockScreen> {
  // PIN panel state
  final List<String> _pin = [];
  bool _pinError = false;
  String? _pinMessage;
  bool _isVerifying = false;

  // Forgot-PIN panel state
  bool _showForgotPanel = false;
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _pwdCtrl = TextEditingController();
  bool _obscurePwd = true;
  bool _isResetting = false;
  String? _forgotError;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pwdCtrl.dispose();
    super.dispose();
  }

  // ── PIN numpad handlers ─────────────────────────────────────────────────────
  void _onKeyTap(String key) {
    if (_pin.length >= 4 || _isVerifying) return;
    setState(() {
      _pin.add(key);
      _pinError = false;
      _pinMessage = null;
    });
    if (_pin.length == 4) {
      Future.delayed(150.ms, _tryUnlock);
    }
  }

  void _onDelete() {
    if (_pin.isEmpty) return;
    setState(() => _pin.removeLast());
  }

  Future<void> _tryUnlock() async {
    setState(() => _isVerifying = true);
    final ok = await LocalAuthRepository.instance.verifyPin(_pin.join());
    if (!mounted) return;

    if (ok) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      setState(() {
        _pin.clear();
        _pinError = true;
        _pinMessage = 'Incorrect PIN. Try again.';
        _isVerifying = false;
      });
    }
  }

  // ── Forgot PIN → password re-auth ───────────────────────────────────────────
  Future<void> _submitReset() async {
    final email = _emailCtrl.text.trim();
    final password = _pwdCtrl.text;

    setState(() => _forgotError = null);

    // Validate the entered email against the stored one (the password is the
    // real gate; the email check gives a friendlier error and confirms intent).
    final storedEmail = await LocalAuthRepository.instance.getEmail();

    if (email.isEmpty || (storedEmail != null && email != storedEmail)) {
      setState(() => _forgotError = 'Email does not match the registered account.');
      return;
    }

    setState(() => _isResetting = true);
    final ok = await LocalAuthRepository.instance.verifyPassword(password);
    if (!mounted) return;

    if (ok) {
      // Password verified — send the user to set a fresh PIN. We use
      // pushReplacementNamed so the lock screen is removed from the stack.
      Navigator.pushReplacementNamed(context, AppRoutes.pinSetup);
    } else {
      setState(() {
        _forgotError = 'Incorrect password. Try again.';
        _isResetting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: 300.ms,
          child: _showForgotPanel ? _buildForgotPanel() : _buildPinPanel(),
        ),
      ),
    );
  }

  // ── PIN Panel ───────────────────────────────────────────────────────────────
  Widget _buildPinPanel() {
    return Padding(
      key: const ValueKey('pin'),
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          const SizedBox(height: 48),
          Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: const Icon(Icons.lock_rounded,
                    color: AppColors.primary, size: 28),
              )
              .animate()
              .fadeIn(duration: 500.ms)
              .scale(begin: const Offset(0.8, 0.8)),
          const SizedBox(height: 20),
          Text('Enter PIN', style: AppTextStyles.headlineLarge)
              .animate()
              .fadeIn(delay: 100.ms, duration: 400.ms),
          const SizedBox(height: 8),
          Text(
            'Unlock to access your security center',
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 150.ms, duration: 400.ms),
          const SizedBox(height: 32),
          _buildPinDots(),
          if (_pinError) ...[
            const SizedBox(height: 14),
            Text(
              _pinMessage ?? 'Incorrect PIN.',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.danger),
            ).animate().shakeX(amount: 4, duration: 400.ms),
          ],
          const Spacer(),
          _buildNumpad(),
          const SizedBox(height: 12),
          // Forgot PIN
          GestureDetector(
            onTap: () => setState(() {
              _showForgotPanel = true;
              _forgotError = null;
            }),
            child: Text(
              'Forgot PIN?',
              style: AppTextStyles.labelLarge.copyWith(color: AppColors.info),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPinDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (i) {
        final filled = i < _pin.length;
        return AnimatedContainer(
          duration: 200.ms,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: filled
                ? (_pinError ? AppColors.danger : AppColors.primary)
                : Colors.transparent,
            border: Border.all(
              color: _pinError
                  ? AppColors.danger
                  : (filled ? AppColors.primary : AppColors.border),
              width: 2,
            ),
            boxShadow: filled
                ? [
                    BoxShadow(
                      color: (_pinError ? AppColors.danger : AppColors.primary)
                          .withOpacity(0.4),
                      blurRadius: 8,
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }

  Widget _buildNumpad() {
    final keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['', '0', 'del'],
    ];
    return Column(
      children: keys.map((row) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row.map((key) {
              if (key.isEmpty) {
                return const SizedBox(width: 90, height: 60);
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: GestureDetector(
                  onTap: () => key == 'del' ? _onDelete() : _onKeyTap(key),
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Center(
                      child: key == 'del'
                          ? const Icon(Icons.backspace_outlined,
                              color: AppColors.textSecondary, size: 22)
                          : Text(
                              key,
                              style: AppTextStyles.headlineLarge
                                  .copyWith(fontWeight: FontWeight.w400),
                            ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  // ── Forgot PIN Panel ────────────────────────────────────────────────────────
  Widget _buildForgotPanel() {
    return SingleChildScrollView(
      key: const ValueKey('forgot'),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 56),
          Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.12),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.warning.withOpacity(0.3)),
                ),
                child: const Icon(Icons.help_outline_rounded,
                    color: AppColors.warning, size: 28),
              )
              .animate()
              .fadeIn(duration: 400.ms),
          const SizedBox(height: 20),
          Text('Reset PIN', style: AppTextStyles.headlineLarge),
          const SizedBox(height: 8),
          Text(
            'Enter your registered email and password to set a new PIN.',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 28),
          Text('Email', style: AppTextStyles.titleLarge),
          const SizedBox(height: 8),
          TextField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            style: AppTextStyles.titleMedium,
            decoration: const InputDecoration(
              hintText: 'you@example.com',
              prefixIcon: Icon(Icons.mail_outline_rounded,
                  color: AppColors.textTertiary, size: 20),
            ),
          ),
          const SizedBox(height: 20),
          Text('Password', style: AppTextStyles.titleLarge),
          const SizedBox(height: 8),
          TextField(
            controller: _pwdCtrl,
            obscureText: _obscurePwd,
            style: AppTextStyles.titleMedium,
            decoration: InputDecoration(
              hintText: 'Your account password',
              prefixIcon: const Icon(Icons.lock_outline_rounded,
                  color: AppColors.textTertiary, size: 20),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePwd
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.textTertiary,
                  size: 20,
                ),
                onPressed: () => setState(() => _obscurePwd = !_obscurePwd),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_forgotError != null) _buildErrorBox(_forgotError!),
          const SizedBox(height: 20),
          GlowButton(
            label: 'Verify & Continue',
            icon: Icons.check_rounded,
            isLoading: _isResetting,
            onPressed: _isResetting ? null : _submitReset,
          ),
          const SizedBox(height: 16),
          Center(
            child: GestureDetector(
              onTap: () => setState(() {
                _showForgotPanel = false;
                _forgotError = null;
              }),
              child: Text(
                'Back to PIN',
                style: AppTextStyles.labelLarge.copyWith(color: AppColors.info),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildErrorBox(String message) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.danger.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.danger.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: AppColors.danger, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.danger),
            ),
          ),
        ],
      ),
    ).animate().shakeX(amount: 4, duration: 400.ms);
  }
}
