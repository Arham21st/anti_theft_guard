import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'local_auth_repository.dart';

/// Set + confirm a 4-digit PIN. The numpad UX is migrated from the legacy
/// onboarding screen; on confirmation the PIN is persisted via [LocalAuthRepository]
/// before navigating to Home.
class PinSetupScreen extends StatefulWidget {
  const PinSetupScreen({super.key});

  @override
  State<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  final List<String> _pin = [];
  bool _isConfirming = false;
  List<String> _firstPin = [];
  bool _pinError = false;
  String? _errorMessage;
  bool _isSaving = false;

  void _onKeyTap(String key) {
    if (_pin.length >= 4) return;
    setState(() {
      _pin.add(key);
      _pinError = false;
      _errorMessage = null;
    });
    if (_pin.length == 4) {
      Future.delayed(200.ms, _handlePinComplete);
    }
  }

  void _onDelete() {
    if (_pin.isEmpty) return;
    setState(() => _pin.removeLast());
  }

  Future<void> _handlePinComplete() async {
    if (!_isConfirming) {
      setState(() {
        _firstPin = List.from(_pin);
        _pin.clear();
        _isConfirming = true;
      });
    } else {
      if (_pin.join() == _firstPin.join()) {
        // PINs match — persist, then navigate.
        setState(() => _isSaving = true);
        await LocalAuthRepository.instance.setPin(_firstPin.join());
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else {
        setState(() {
          _pin.clear();
          _pinError = true;
          _errorMessage = 'PINs do not match. Try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 48),
              // Header
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
              Text(
                _isConfirming ? 'Confirm Your PIN' : 'Set Security PIN',
                style: AppTextStyles.headlineLarge,
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
              const SizedBox(height: 8),
              Text(
                _isConfirming
                    ? 'Enter the same PIN again to confirm'
                    : 'Create a 4-digit PIN to quickly unlock your app',
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
              const SizedBox(height: 32),
              // PIN Dots
              _buildPinDots(),
              if (_pinError || _isSaving) ...[
                const SizedBox(height: 16),
                Text(
                  _isSaving ? 'Saving...' : (_errorMessage ?? 'PINs do not match.'),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: _isSaving ? AppColors.success : AppColors.danger,
                  ),
                ).animate().shakeX(amount: 4, duration: 400.ms),
              ],
              const Spacer(),
              _buildNumpad(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPinDots() {
    return AnimatedSwitcher(
      duration: 300.ms,
      child: Row(
        key: ValueKey(_isConfirming),
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
      ),
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
}
