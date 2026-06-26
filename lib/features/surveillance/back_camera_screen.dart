import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/glow_button.dart';
import 'surveillance_config.dart';
import 'surveillance_config_notifier.dart';

class BackCameraScreen extends StatefulWidget {
  const BackCameraScreen({super.key});
  @override
  State<BackCameraScreen> createState() => _BackCameraScreenState();
}

class _BackCameraScreenState extends State<BackCameraScreen> {
  SurveillanceConfigNotifier get _notifier =>
      SurveillanceConfigNotifier.instance;

  final _delays = ['10s', '20s', '30s'];
  final _photoCounts = ['1', '3', '5'];

  @override
  void initState() {
    super.initState();
    _notifier.load();
  }

  bool get _photoActive =>
      _notifier.config.captureMode == CaptureMode.photo;

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
        title: Text('Back Camera', style: AppTextStyles.headlineMedium),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ListenableBuilder(
              listenable: _notifier,
              builder: (context, _) {
                final cfg = _notifier.config;
                final active = _photoActive && cfg.backAutoCapture;
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: (active ? AppColors.warning : AppColors.textTertiary)
                        .withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: (active
                              ? AppColors.warning
                              : AppColors.textTertiary)
                          .withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    _photoActive
                        ? (cfg.backAutoCapture ? 'Ready' : 'Off')
                        : 'Paused',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: active ? AppColors.warning : AppColors.textTertiary,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 4),
                _buildCameraPreview(),
                _buildInfoBanner(),
                if (!_photoActive) ...[
                  const SizedBox(height: 12),
                  _buildPausedBanner(),
                ],
                const SectionHeader(title: 'CAPTURE SETTINGS'),
                _buildAutoCaptureCard(),
                const SizedBox(height: 10),
                _buildDelayCard(),
                const SizedBox(height: 10),
                _buildMaxPhotosCard(),
                const SectionHeader(title: 'RECENT CAPTURES'),
                _buildGallery(),
                const SizedBox(height: 16),
                GlowButton(
                  label: _photoActive ? 'Capture Now (Preview)' : 'Photo Mode Paused',
                  icon: Icons.camera_rear_rounded,
                  onPressed: _photoActive ? () {} : null,
                  gradient: AppColors.warningGradient,
                  glowColor: AppColors.warning,
                ).animate().fadeIn(delay: 420.ms),
                const SizedBox(height: 28),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  // ── Config-bound cards ──────────────────────────────────────────────────────

  Widget _buildAutoCaptureCard() {
    return ListenableBuilder(
      listenable: _notifier,
      builder: (context, _) {
        final cfg = _notifier.config;
        return Opacity(
          opacity: _photoActive ? 1.0 : 0.55,
          child: AbsorbPointer(
            absorbing: !_photoActive,
            child: GlassCard(
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: cfg.backAutoCapture
                          ? AppColors.warning.withOpacity(0.15)
                          : AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.camera_rear_rounded,
                      color: cfg.backAutoCapture
                          ? AppColors.warning
                          : AppColors.textTertiary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Auto-capture in Stealth Mode',
                            style: AppTextStyles.titleMedium),
                        Text(
                          'Capture recurring images when stealth mode is activated',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: cfg.backAutoCapture,
                    onChanged: _photoActive
                        ? (v) => _notifier.setBackAutoCapture(v)
                        : null,
                    activeTrackColor: AppColors.warning,
                    activeThumbColor: Colors.white,
                    inactiveThumbColor: AppColors.textTertiary,
                    inactiveTrackColor: AppColors.surfaceHighest,
                    trackOutlineColor:
                        WidgetStateProperty.all(Colors.transparent),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildDelayCard() {
    return ListenableBuilder(
      listenable: _notifier,
      builder: (context, _) {
        final cfg = _notifier.config;
        return Opacity(
          opacity: _photoActive ? 1.0 : 0.55,
          child: AbsorbPointer(
            absorbing: !_photoActive,
            child: GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Capture Delay', style: AppTextStyles.titleMedium),
                  const SizedBox(height: 12),
                  _SegmentedSelector(
                    options: _delays,
                    selected: cfg.backDelayIdx,
                    color: AppColors.warning,
                    onSelect: (i) => _notifier.setBackDelayIdx(i),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).animate().fadeIn(delay: 260.ms);
  }

  Widget _buildMaxPhotosCard() {
    return ListenableBuilder(
      listenable: _notifier,
      builder: (context, _) {
        final cfg = _notifier.config;
        return Opacity(
          opacity: _photoActive ? 1.0 : 0.55,
          child: AbsorbPointer(
            absorbing: !_photoActive,
            child: GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Max Photos per Trigger',
                      style: AppTextStyles.titleMedium),
                  const SizedBox(height: 12),
                  _SegmentedSelector(
                    options: _photoCounts,
                    selected: cfg.backMaxPhotosIdx,
                    color: AppColors.warning,
                    onSelect: (i) => _notifier.setBackMaxPhotosIdx(i),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).animate().fadeIn(delay: 320.ms);
  }

  Widget _buildPausedBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warning.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.pause_circle_outline_rounded,
              color: AppColors.warning, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Photo capture paused — Video mode is active. Switch Capture Mode on the Surveillance tab to resume.',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.warning),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms);
  }

  // ── Visual helpers (preserved from original) ────────────────────────────────

  Widget _buildCameraPreview() {
    return Container(
      height: 200,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF080810),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.warning.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(color: AppColors.warning.withOpacity(0.06), blurRadius: 16),
        ],
      ),
      child: Stack(
        children: [
          const Center(
            child: Icon(Icons.camera_rear_rounded, color: Colors.white12, size: 52),
          ),
          // Scope overlay
          Center(
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white10, width: 1.5),
              ),
            ),
          ),
          Center(
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white10, width: 1),
              ),
            ),
          ),
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Center(
              child: Text('Environment View',
                  style: AppTextStyles.bodySmall.copyWith(color: Colors.white24)),
            ),
          ),
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.background.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.camera_rear_rounded,
                      color: AppColors.warning, size: 12),
                  const SizedBox(width: 4),
                  Text('REAR',
                      style: AppTextStyles.labelSmall
                          .copyWith(color: AppColors.warning)),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warning.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.landscape_rounded,
              color: AppColors.warning, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Captures the environment around the device to identify the thief\'s location.',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.warning),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 150.ms);
  }

  Widget _buildGallery() {
    return SizedBox(
      height: 84,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final hasCapture = i == 0;
          return Container(
            width: 76,
            decoration: BoxDecoration(
              color: hasCapture ? AppColors.surfaceElevated : AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: hasCapture
                    ? AppColors.warning.withOpacity(0.3)
                    : AppColors.border,
              ),
            ),
            child: hasCapture
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(Icons.landscape_rounded,
                          color: Colors.white12, size: 28),
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.background.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text('01', style: AppTextStyles.labelSmall),
                        ),
                      ),
                    ],
                  )
                : const Icon(Icons.add_rounded,
                    color: AppColors.textTertiary, size: 24),
          );
        },
      ),
    ).animate().fadeIn(delay: 360.ms);
  }
}

class _SegmentedSelector extends StatelessWidget {
  const _SegmentedSelector({
    required this.options,
    required this.selected,
    required this.color,
    required this.onSelect,
  });
  final List<String> options;
  final int selected;
  final Color color;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: options.asMap().entries.map((e) {
        final isSelected = e.key == selected;
        return Expanded(
          child: GestureDetector(
            onTap: () => onSelect(e.key),
            child: AnimatedContainer(
              duration: 200.ms,
              height: 38,
              margin: EdgeInsets.only(
                right: e.key < options.length - 1 ? 8 : 0,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? color.withOpacity(0.15)
                    : AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? color.withOpacity(0.5) : AppColors.border,
                ),
              ),
              child: Center(
                child: Text(
                  e.value,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: isSelected ? color : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
