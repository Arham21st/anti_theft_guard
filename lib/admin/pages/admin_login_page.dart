import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_colors.dart';
import '../auth/mock_accounts.dart';
import '../auth/web_auth_state.dart';
import '../constants/admin_routes.dart';
import '../widgets/admin_ui_components.dart';

/// Role-aware login screen for the web portal.
///
/// Validates against [MockAccounts] and, on success, drives [WebAuthState]
/// into a logged-in session before navigating to the overview (which then
/// branches by role).
class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _pwdCtrl = TextEditingController();
  bool _obscure = true;
  bool _isSubmitting = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pwdCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailCtrl.text.trim();
    final password = _pwdCtrl.text;

    setState(() => _error = null);

    if (email.isEmpty || password.isEmpty) {
      setState(() => _error = 'Enter your email and password.');
      return;
    }

    setState(() => _isSubmitting = true);
    // Simulate a brief auth round-trip so the UI feedback feels real.
    await Future.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;
    final auth = WebAuthProvider.of(context);
    final ok = auth.login(email, password);

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (ok) {
      Navigator.pushReplacementNamed(context, AdminRoutes.overview);
    } else {
      setState(() => _error = 'Invalid email or password. Try a demo account below.');
    }
  }

  /// One-tap fill of a demo account.
  void _fillDemo(MockAccountDemo demo) {
    setState(() {
      _emailCtrl.text = demo.email;
      _pwdCtrl.text = demo.password;
      _error = null;
      _obscure = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Brand header
                Center(
                  child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: AppColors.primary.withOpacity(0.35)),
                        ),
                        child: const Icon(Icons.shield_rounded,
                            color: AppColors.primary, size: 28),
                      )
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .scale(begin: const Offset(0.8, 0.8)),
                ),
                const SizedBox(height: 18),
                Text('Anti-Theft Guard',
                    style: AdminTextStyles.pageTitle.copyWith(fontSize: 22),
                    textAlign: TextAlign.center),
                const SizedBox(height: 6),
                Text('Sign in to view your device',
                    style: AdminTextStyles.body, textAlign: TextAlign.center),
                const SizedBox(height: 28),

                // Form panel
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Email', style: AdminTextStyles.label),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        style: AdminTextStyles.body
                            .copyWith(color: AppColors.textPrimary),
                        decoration: const InputDecoration(
                          hintText: 'you@example.com',
                          prefixIcon: Icon(Icons.mail_outline_rounded,
                              color: AppColors.textTertiary, size: 18),
                        ),
                        onSubmitted: (_) => _submit(),
                      ),
                      const SizedBox(height: 16),
                      Text('Password', style: AdminTextStyles.label),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _pwdCtrl,
                        obscureText: _obscure,
                        style: AdminTextStyles.body
                            .copyWith(color: AppColors.textPrimary),
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          prefixIcon: const Icon(Icons.lock_outline_rounded,
                              color: AppColors.textTertiary, size: 18),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscure
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textTertiary,
                              size: 18,
                            ),
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                          ),
                        ),
                        onSubmitted: (_) => _submit(),
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: 14),
                        _errorBox(_error!),
                      ],
                      const SizedBox(height: 18),
                      SizedBox(
                        height: 44,
                        child: FilledButton.icon(
                          onPressed: _isSubmitting ? null : _submit,
                          icon: _isSubmitting
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.white),
                                )
                              : const Icon(Icons.login_rounded, size: 18),
                          label: Text(_isSubmitting ? 'Signing in…' : 'Sign in'),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            textStyle: AdminTextStyles.label,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                _demoAccountsCard(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _errorBox(String message) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.danger.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.danger.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded,
              color: AppColors.danger, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message,
                style: AdminTextStyles.small.copyWith(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }

  /// Lists the demo accounts so a reviewer can one-tap fill them.
  Widget _demoAccountsCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.info.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline_rounded,
                  color: AppColors.info, size: 16),
              const SizedBox(width: 8),
              Text('Demo accounts — tap to fill',
                  style: AdminTextStyles.label.copyWith(color: AppColors.info)),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: MockAccounts.demos.map((d) {
              final isAdmin = d.role.name == 'admin';
              return ActionChip(
                label: Text(
                  isAdmin ? 'Admin' : d.email.split('@').first,
                  style: AdminTextStyles.small
                      .copyWith(color: AppColors.textPrimary),
                ),
                avatar: Icon(
                  isAdmin ? Icons.admin_panel_settings_rounded : Icons.person_rounded,
                  size: 15,
                  color: isAdmin ? AppColors.warning : AppColors.info,
                ),
                backgroundColor: AppColors.surfaceElevated,
                side: BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                onPressed: () => _fillDemo(d),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          Text(
            'Password is the login name + "123" (e.g. sara123).',
            style: AdminTextStyles.small,
          ),
        ],
      ),
    );
  }
}
