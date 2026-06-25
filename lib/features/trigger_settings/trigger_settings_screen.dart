import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/glow_button.dart';

class TriggerSettingsScreen extends StatefulWidget {
  const TriggerSettingsScreen({super.key});
  @override
  State<TriggerSettingsScreen> createState() => _TriggerSettingsScreenState();
}

class _TriggerSettingsScreenState extends State<TriggerSettingsScreen> {
  int _selected = 0;

  final _options = [
    _TriggerOption(
      Icons.power_settings_new_rounded,
      'Power Button × 3',
      'Press power button 3 times rapidly to activate',
      AppColors.primary,
    ),
    _TriggerOption(
      Icons.lock_rounded,
      'Secret Password',
      'Enter a secret password to activate security mode',
      AppColors.info,
    ),
    _TriggerOption(
      Icons.volume_up_rounded,
      'Volume Button Sequence',
      'Set a custom Volume Up/Down sequence (max 5 presses)',
      AppColors.success,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16,
              color: AppColors.textPrimary,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Trigger Settings', style: AppTextStyles.headlineMedium),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'Choose your secret activation method',
              style: AppTextStyles.bodyLarge,
            ),
            const SectionHeader(title: 'ACTIVATION METHOD'),
            Expanded(
              child: ListView.separated(
                itemCount: _options.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) {
                  final opt = _options[i];
                  final isSelected = _selected == i;
                  return GestureDetector(
                    onTap: () => setState(() => _selected = i),
                    child: AnimatedContainer(
                      duration: 250.ms,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: AppColors.cardGradient,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? opt.color : AppColors.border,
                          width: isSelected ? 1.5 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: opt.color.withOpacity(0.15),
                                  blurRadius: 16,
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? opt.color.withOpacity(0.15)
                                  : AppColors.surfaceElevated,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              opt.icon,
                              color: isSelected
                                  ? opt.color
                                  : AppColors.textTertiary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  opt.title,
                                  style: AppTextStyles.titleLarge,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  opt.description,
                                  style: AppTextStyles.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          AnimatedContainer(
                            duration: 200.ms,
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? opt.color
                                  : Colors.transparent,
                              border: Border.all(
                                color: isSelected
                                    ? opt.color
                                    : AppColors.border,
                                width: 2,
                              ),
                            ),
                            child: isSelected
                                ? const Icon(
                                    Icons.check_rounded,
                                    size: 14,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(
                    delay: Duration(milliseconds: 80 * i),
                    duration: 350.ms,
                  );
                },
              ),
            ),
            // Configure button
            if (_selected == 1)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GlowButton(
                  label: 'Set Password',
                  icon: Icons.lock_outline_rounded,
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.passwordTrigger),
                ),
              ),
            if (_selected == 2)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GlowButton(
                  label: 'Build Sequence',
                  icon: Icons.tune_rounded,
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.volumeSequence),
                  gradient: AppColors.successGradient,
                  glowColor: AppColors.success,
                ),
              ),
            GlowButton(
              label: 'Save Trigger',
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _TriggerOption {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  const _TriggerOption(this.icon, this.title, this.description, this.color);
}
