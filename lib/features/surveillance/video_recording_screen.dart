import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/glow_button.dart';
import '../../core/widgets/pulse_indicator.dart';
import 'surveillance_config.dart';
import 'surveillance_config_notifier.dart';

class VideoRecordingScreen extends StatefulWidget {
  const VideoRecordingScreen({super.key});
  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen> {
  SurveillanceConfigNotifier get _notifier =>
      SurveillanceConfigNotifier.instance;

  final _cameras = ['Front', 'Back'];
  final _qualities = ['360p (Small)', '720p (HD)'];
  final _durations = ['30s', '1m', '5m'];

  @override
  void initState() {
    super.initState();
    _notifier.load();
  }

  bool get _videoActive =>
      _notifier.config.captureMode == CaptureMode.video;

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
                if (!_videoActive) ...[
                  const SizedBox(height: 12),
                  _buildPausedBanner(),
                ],
                const SectionHeader(title: 'RECORDING SETTINGS'),
                _buildAutoStartCard(),
                const SizedBox(height: 10),
                _buildCameraCard(),
                const SizedBox(height: 10),
                _buildQualityCard(),
                const SizedBox(height: 10),
                _buildDurationCard(),
                const SectionHeader(title: 'RECENT RECORDINGS'),
                _buildRecordingsList(),
                const SizedBox(height: 16),
                GlowButton(
                  label: _videoActive ? 'Test Recording (3s)' : 'Video Mode Paused',
                  icon: Icons.videocam_rounded,
                  onPressed: _videoActive ? () {} : null,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF3131), Color(0xFFCC0000)],
                  ),
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

  // ── Config-bound cards ──────────────────────────────────────────────────────

  Widget _buildAutoStartCard() {
    return ListenableBuilder(
      listenable: _notifier,
      builder: (context, _) {
        final cfg = _notifier.config;
        return Opacity(
          opacity: _videoActive ? 1.0 : 0.55,
          child: AbsorbPointer(
            absorbing: !_videoActive,
            child: GlassCard(
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: cfg.videoAutoStart
                          ? AppColors.danger.withOpacity(0.15)
                          : AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.fiber_manual_record_rounded,
                      color: cfg.videoAutoStart
                          ? AppColors.danger
                          : AppColors.textTertiary,
                      size: 22,
                    ),
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
                    value: cfg.videoAutoStart,
                    onChanged: _videoActive
                        ? (v) => _notifier.setVideoAutoStart(v)
                        : null,
                    activeTrackColor: AppColors.danger,
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

  Widget _buildCameraCard() {
    return ListenableBuilder(
      listenable: _notifier,
      builder: (context, _) {
        final cfg = _notifier.config;
        return Opacity(
          opacity: _videoActive ? 1.0 : 0.55,
          child: AbsorbPointer(
            absorbing: !_videoActive,
            child: GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Camera to Use', style: AppTextStyles.titleMedium),
                  const SizedBox(height: 12),
                  _SegmentedSelector(
                    options: _cameras,
                    selected: cfg.videoCameraIdx,
                    color: AppColors.danger,
                    onSelect: (i) => _notifier.setVideoCameraIdx(i),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).animate().fadeIn(delay: 260.ms);
  }

  Widget _buildQualityCard() {
    return ListenableBuilder(
      listenable: _notifier,
      builder: (context, _) {
        final cfg = _notifier.config;
        return Opacity(
          opacity: _videoActive ? 1.0 : 0.55,
          child: AbsorbPointer(
            absorbing: !_videoActive,
            child: GlassCard(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Quality', style: AppTextStyles.titleMedium),
                  const SizedBox(height: 12),
                  _SegmentedSelector(
                    options: _qualities,
                    selected: cfg.videoQualityIdx,
                    color: AppColors.danger,
                    onSelect: (i) => _notifier.setVideoQualityIdx(i),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).animate().fadeIn(delay: 320.ms);
  }

  Widget _buildDurationCard() {
    return ListenableBuilder(
      listenable: _notifier,
      builder: (context, _) {
        final cfg = _notifier.config;
        return Opacity(
          opacity: _videoActive ? 1.0 : 0.55,
          child: AbsorbPointer(
            absorbing: !_videoActive,
            child: GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Max Duration', style: AppTextStyles.titleMedium),
                  const SizedBox(height: 12),
                  _SegmentedSelector(
                    options: _durations,
                    selected: cfg.videoDurationIdx,
                    color: AppColors.danger,
                    onSelect: (i) => _notifier.setVideoDurationIdx(i),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).animate().fadeIn(delay: 380.ms);
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
              'Video recording paused — Photo mode is active. Switch Capture Mode on the Surveillance tab to resume.',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.warning),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms);
  }

  // ── Visual helpers (preserved from original) ────────────────────────────────

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
          Positioned(
            top: 16,
            left: 16,
            child: Row(
              children: [
                PulseIndicator(color: AppColors.danger, size: 8, pulseSize: 18),
                const SizedBox(width: 8),
                Text('REC',
                    style: AppTextStyles.labelLarge
                        .copyWith(color: AppColors.danger)),
              ],
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: Text('00:00:00',
                style: AppTextStyles.mono.copyWith(color: Colors.white70)),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.videocam_outlined,
                    color: Colors.white12, size: 48),
                const SizedBox(height: 8),
                Text(
                  'Video preview is hidden during actual recording',
                  style:
                      AppTextStyles.bodySmall.copyWith(color: Colors.white24),
                ),
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
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.danger),
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
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHighest,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.play_arrow_rounded,
                      color: AppColors.textSecondary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'VID_2026051${7 - index}_0${index}2345.mp4',
                        style: AppTextStyles.titleMedium,
                      ),
                      const SizedBox(height: 2),
                      Text('30s • ${4 + index * 2}.2 MB',
                          style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
                const Icon(Icons.more_vert_rounded,
                    color: AppColors.textTertiary),
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
