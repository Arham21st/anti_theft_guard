import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/glow_button.dart';

class PasswordTriggerScreen extends StatefulWidget {
  const PasswordTriggerScreen({super.key});
  @override
  State<PasswordTriggerScreen> createState() => _PasswordTriggerScreenState();
}

class _PasswordTriggerScreenState extends State<PasswordTriggerScreen> {
  bool _obscure1 = true;
  bool _obscure2 = true;
  final _c1 = TextEditingController();
  final _c2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background, elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border)),
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: AppColors.textPrimary),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Password Trigger', style: AppTextStyles.headlineMedium),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.info.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: AppColors.info, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'This password will silently activate anti-theft mode. Keep it secret.',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.info),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),
            const SizedBox(height: 28),
            Text('Secret Password', style: AppTextStyles.titleLarge),
            const SizedBox(height: 8),
            TextField(
              controller: _c1,
              obscureText: _obscure1,
              style: AppTextStyles.titleMedium,
              decoration: InputDecoration(
                hintText: 'Enter secret password',
                prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.textTertiary, size: 20),
                suffixIcon: IconButton(
                  icon: Icon(_obscure1 ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: AppColors.textTertiary, size: 20),
                  onPressed: () => setState(() => _obscure1 = !_obscure1),
                ),
              ),
            ).animate().fadeIn(delay: 100.ms),
            const SizedBox(height: 20),
            Text('Confirm Password', style: AppTextStyles.titleLarge),
            const SizedBox(height: 8),
            TextField(
              controller: _c2,
              obscureText: _obscure2,
              style: AppTextStyles.titleMedium,
              decoration: InputDecoration(
                hintText: 'Re-enter password',
                prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.textTertiary, size: 20),
                suffixIcon: IconButton(
                  icon: Icon(_obscure2 ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: AppColors.textTertiary, size: 20),
                  onPressed: () => setState(() => _obscure2 = !_obscure2),
                ),
              ),
            ).animate().fadeIn(delay: 200.ms),
            const Spacer(),
            GlowButton(
              label: 'Save Password',
              icon: Icons.save_outlined,
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
