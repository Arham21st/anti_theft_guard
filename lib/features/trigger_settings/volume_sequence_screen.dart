import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/glow_button.dart';
import '../../core/widgets/glow_button.dart';

class VolumeSequenceScreen extends StatefulWidget {
  const VolumeSequenceScreen({super.key});
  @override
  State<VolumeSequenceScreen> createState() => _VolumeSequenceScreenState();
}

class _VolumeSequenceScreenState extends State<VolumeSequenceScreen> {
  final List<bool> _sequence = []; // true = Up, false = Down

  void _addUp() {
    if (_sequence.length >= 5) return;
    setState(() => _sequence.add(true));
  }

  void _addDown() {
    if (_sequence.length >= 5) return;
    setState(() => _sequence.add(false));
  }

  void _removeLast() {
    if (_sequence.isEmpty) return;
    setState(() => _sequence.removeLast());
  }

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
        title: Text('Volume Sequence', style: AppTextStyles.headlineMedium),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Build your secret trigger sequence (max 5 presses)',
                style: AppTextStyles.bodyLarge),
            const SizedBox(height: 24),
            // Sequence display
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Your Sequence', style: AppTextStyles.titleLarge),
                      const Spacer(),
                      Text('${_sequence.length}/5',
                          style: AppTextStyles.labelMedium.copyWith(
                              color: _sequence.length == 5 ? AppColors.warning : AppColors.textTertiary)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_sequence.isEmpty)
                    Center(
                      child: Text('Tap buttons below to build sequence',
                          style: AppTextStyles.bodySmall),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _sequence.asMap().entries.map((e) {
                        final isUp = e.value;
                        return AnimatedContainer(
                          duration: 200.ms,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isUp
                                ? AppColors.success.withOpacity(0.15)
                                : AppColors.primary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: isUp
                                    ? AppColors.success.withOpacity(0.4)
                                    : AppColors.primary.withOpacity(0.4)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isUp ? Icons.volume_up_rounded : Icons.volume_down_rounded,
                                color: isUp ? AppColors.success : AppColors.primary,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(isUp ? 'Vol ▲' : 'Vol ▼',
                                  style: AppTextStyles.labelSmall.copyWith(
                                      color: isUp ? AppColors.success : AppColors.primary)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),
            const SizedBox(height: 32),
            Text('ADD PRESS', style: AppTextStyles.labelMedium),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _addUp,
                    child: Container(
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.success.withOpacity(0.4)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.volume_up_rounded, color: AppColors.success, size: 28),
                          const SizedBox(height: 4),
                          Text('Volume Up', style: AppTextStyles.labelMedium.copyWith(color: AppColors.success)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: _addDown,
                    child: Container(
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.primary.withOpacity(0.4)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.volume_down_rounded, color: AppColors.primary, size: 28),
                          const SizedBox(height: 4),
                          Text('Volume Down', style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            OutlineButton(
              label: 'Remove Last',
              icon: Icons.backspace_outlined,
              onPressed: _removeLast,
              borderColor: AppColors.border,
              textColor: AppColors.textSecondary,
            ),
            const Spacer(),
            GlowButton(
              label: 'Save Sequence',
              icon: Icons.check_rounded,
              onPressed: _sequence.isNotEmpty ? () => Navigator.pop(context) : null,
              gradient: AppColors.successGradient,
              glowColor: AppColors.success,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
