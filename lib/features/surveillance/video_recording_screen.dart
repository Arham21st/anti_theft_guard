import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/glow_button.dart';
import '../../core/widgets/pulse_indicator.dart';

class VideoRecordingScreen extends StatefulWidget {
  const VideoRecordingScreen({super.key});
  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen> {
  bool _autoStart = true;
  int _cameraSelector = 0; // 0=Front, 1=Back
  int _qualitySelector = 0; // 0=360p, 1=720p
  int _durationSelector = 1; // 0=30s, 1=1m, 2=5m

  final _cameras = ['Front', 'Back'];
  final _qualities = ['360p (Small)', '720p (HD)'];
  final _durations = ['30s', '1m', '5m'];

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
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                size: 16, color: AppColors.textPrimary),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Silent Video', style: AppTextStyles.headlineMedium),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 4),
                _buildVideoPreview(),
                _buildInfoBanner(),
                const SectionHeader(title: 'RECORDING SETTINGS'),
                GlassCard(
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: _autoStart
                              ? AppColors.danger.withOpacity(0.15)
                              : AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.fiber_manual_record_rounded,
                            color: _autoStart
                                ? AppColors.danger
                                : AppColors.textTertiary,
                            size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Auto-start on Trigger',
                                style: AppTextStyles.titleMedium),
                            Text('Start recording silently in background',
                                style: AppTextStyles.bodySmall),
                          ],
                        ),
                      ),
                      Switch(
                        value: _autoStart,
                        onChanged: (v) => setState(() => _autoStart = v),
                        activeTrackColor: AppColors.danger,
                        activeColor: Colors.white,
                        inactiveThumbColor: AppColors.textTertiary,
                        inactiveTrackColor: AppColors.surfaceHighest,
                        trackOutlineColor:
                            WidgetStateProperty.all(Colors.transparent),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: 10),
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Camera to Use', style: AppTextStyles.titleMedium),
                      const SizedBox(height: 12),
                      _SegmentedSelector(
                        options: _cameras,
                        selected: _cameraSelector,
                        color: AppColors.danger,
                        onSelect: (i) => setState(() => _cameraSelector = i),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 260.ms),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: GlassCard(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Quality', style: AppTextStyles.titleMedium),
                            const SizedBox(height: 12),
                            _SegmentedSelector(
                              options: _qualities,
                              selected: _qualitySelector,
                              color: AppColors.danger,
                              onSelect: (i) =>
                                  setState(() => _qualitySelector = i),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 320.ms),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                 GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Max Duration', style: AppTextStyles.titleMedium),
                      const SizedBox(height: 12),
                      _SegmentedSelector(
                        options: _durations,
                        selected: _durationSelector,
                        color: AppColors.danger,
                        onSelect: (i) => setState(() => _durationSelector = i),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 380.ms),
                const SectionHeader(title: 'RECENT RECORDINGS'),
                _buildRecordingsList(),
                const SizedBox(height: 16),
                GlowButton(
                  label: 'Test Recording (3s)',
                  icon: Icons.videocam_rounded,
                  onPressed: () {},
                  gradient: const LinearGradient(
                      colors: [Color(0xFFFF3131), Color(0xFFCC0000)]),
                  glowColor: AppColors.danger,
                ).animate().fadeIn(delay: 480.ms),
                const SizedBox(height: 28),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPreview() {
    return Container(
      height: 180,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0505),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.danger.withOpacity(0.3)),
      ),
      child: Stack(
        children: [
          // REC indicator hidden by default, shown for preview
          Positioned(
            top: 16, left: 16,
            child: Row(
              children: [
                PulseIndicator(color: AppColors.danger, size: 8, pulseSize: 18),
                const SizedBox(width: 8),
                Text('REC', style: AppTextStyles.labelLarge.copyWith(color: AppColors.danger)),
              ],
            ),
          ),
          Positioned(
            top: 16, right: 16,
            child: Text('00:00:00', style: AppTextStyles.mono.copyWith(color: Colors.white70)),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.videocam_outlined, color: Colors.white12, size: 48),
                const SizedBox(height: 8),
                Text('Video preview is hidden during actual recording',
                    style: AppTextStyles.bodySmall.copyWith(color: Colors.white24)),
              ],
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
        color: AppColors.danger.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.danger.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.visibility_off_rounded,
              color: AppColors.danger, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Recordings happen silently in the background with no visual indicators.',
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.danger),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 150.ms);
  }

  Widget _buildRecordingsList() {
    return Column(
      children: List.generate(2, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: GlassCard(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHighest,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.play_arrow_rounded, color: AppColors.textSecondary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('VID_2026051${7 - index}_0${index}2345.mp4', style: AppTextStyles.titleMedium),
                      const SizedBox(height: 2),
                      Text('30s • ${4 + index * 2}.2 MB', style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
                const Icon(Icons.more_vert_rounded, color: AppColors.textTertiary),
              ],
            ),
          ).animate().fadeIn(delay: Duration(milliseconds: 400 + (index * 60))),
        );
      }),
    );
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
                  right: e.key < options.length - 1 ? 8 : 0),
              decoration: BoxDecoration(
                color: isSelected
                    ? color.withOpacity(0.15)
                    : AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: isSelected
                        ? color.withOpacity(0.5)
                        : AppColors.border),
              ),
              child: Center(
                child: Text(e.value,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: isSelected ? color : AppColors.textSecondary,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                    )),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
