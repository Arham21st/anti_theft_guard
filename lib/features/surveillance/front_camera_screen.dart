import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/glow_button.dart';
import 'surveillance_config.dart';
import 'surveillance_config_notifier.dart';

class FrontCameraScreen extends StatefulWidget {
  const FrontCameraScreen({super.key});
  @override
  State<FrontCameraScreen> createState() => _FrontCameraScreenState();
}

class _FrontCameraScreenState extends State<FrontCameraScreen> {
  SurveillanceConfigNotifier get _notifier =>
      SurveillanceConfigNotifier.instance;

  final _delays = ['10s', '20s', '30s'];
  final _photoCounts = ['1', '3', '5'];

  @override
  void initState() {
    super.initState();
    _notifier.load();
  }

  // True when this screen's mode (photo) is the active capture mode.
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
        title: Text('Front Camera', style: AppTextStyles.headlineMedium),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ListenableBuilder(
              listenable: _notifier,
              builder: (context, _) {
                final cfg = _notifier.config;
                final count =
                    _photoCounts[cfg.frontMaxPhotosIdx.clamp(0, 2)];
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: (_photoActive && cfg.frontAutoCapture
                            ? AppColors.info
                            : AppColors.textTertiary)
                        .withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: (_photoActive && cfg.frontAutoCapture
                              ? AppColors.info
                              : AppColors.textTertiary)
                          .withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    _photoActive
                        ? (cfg.frontAutoCapture ? '$count photos' : 'Off')
                        : 'Paused',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: _photoActive && cfg.frontAutoCapture
                          ? AppColors.info
                          : AppColors.textTertiary,
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
                _buildStealthRow(),
                if (!_photoActive) ...[
                  const SizedBox(height: 4),
                  _buildPausedBanner(),
                ],
                const SectionHeader(title: 'CAPTURE SETTINGS'),
                _buildAutoCaptureCard(),
                const SizedBox(height: 10),
                _buildDelayCard(),
                const SizedBox(height: 10),
                _buildMaxPhotosCard(),
                const SectionHeader(title: 'CAPTURED PHOTOS'),
                _buildGallery(),
                const SizedBox(height: 16),
                GlowButton(
                  label: _photoActive ? 'Capture Now (Preview)' : 'Photo Mode Paused',
                  icon: Icons.camera_front_rounded,
                  onPressed: _photoActive ? () {} : null,
                  gradient: const LinearGradient(
                    colors: [AppColors.info, Color(0xFF0288D1)],
                  ),
                  glowColor: AppColors.info,
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
                      color: cfg.frontAutoCapture
                          ? AppColors.info.withOpacity(0.15)
                          : AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.camera_front_rounded,
                      color: cfg.frontAutoCapture
                          ? AppColors.info
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
                    value: cfg.frontAutoCapture,
                    onChanged: _photoActive
                        ? (v) => _notifier.setFrontAutoCapture(v)
                        : null,
                    activeTrackColor: AppColors.info,
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
                    selected: cfg.frontDelayIdx,
                    color: AppColors.info,
                    onSelect: (i) => _notifier.setFrontDelayIdx(i),
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
                    selected: cfg.frontMaxPhotosIdx,
                    color: AppColors.info,
                    onSelect: (i) => _notifier.setFrontMaxPhotosIdx(i),
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
        border: Border.all(color: AppColors.border),
      ),
      child: Stack(
        children: [
          Center(
            child: CustomPaint(
              size: const Size(80, 80),
              painter: _CrosshairPainter(),
            ),
          ),
          const Center(
            child: Icon(
              Icons.camera_front_rounded,
              color: Colors.white12,
              size: 48,
            ),
          ),
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Front Camera Preview',
                style: AppTextStyles.bodySmall.copyWith(color: Colors.white24),
              ),
            ),
          ),
          ..._buildCornerBrackets(),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  List<Widget> _buildCornerBrackets() {
    const color = Colors.white12;
    const len = 16.0;
    const thick = 2.0;
    return [
      Positioned(
        top: 12, left: 12,
        child: _CornerBracket(color: color, len: len, thick: thick, top: true, left: true),
      ),
      Positioned(
        top: 12, right: 12,
        child: _CornerBracket(color: color, len: len, thick: thick, top: true, left: false),
      ),
      Positioned(
        bottom: 12, left: 12,
        child: _CornerBracket(color: color, len: len, thick: thick, top: false, left: true),
      ),
      Positioned(
        bottom: 12, right: 12,
        child: _CornerBracket(color: color, len: len, thick: thick, top: false, left: false),
      ),
    ];
  }

  Widget _buildStealthRow() {
    final items = [
      ('No Sound', Icons.volume_off_rounded),
      ('No Flash', Icons.flash_off_rounded),
      ('No Preview', Icons.visibility_off_rounded),
    ];
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: items.map((item) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.success.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  Icon(item.$2, color: AppColors.success, size: 16),
                  const SizedBox(height: 3),
                  Text(
                    item.$1,
                    style: AppTextStyles.labelSmall.copyWith(color: AppColors.success),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
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
          final isCapture = i < 3;
          return Container(
            width: 76,
            decoration: BoxDecoration(
              color: isCapture ? AppColors.surfaceElevated : AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isCapture ? AppColors.borderHighlight : AppColors.border,
              ),
            ),
            child: isCapture
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(Icons.person_rounded,
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
                          child: Text('0${i + 1}', style: AppTextStyles.labelSmall),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Icon(Icons.add_rounded,
                        color: AppColors.textTertiary, size: 22),
                  ),
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

class _CrosshairPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white12
      ..strokeWidth = 1;
    canvas.drawLine(
        Offset(size.width / 2, 0), Offset(size.width / 2, size.height), p);
    canvas.drawLine(
        Offset(0, size.height / 2), Offset(size.width, size.height / 2), p);
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      16,
      p..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

class _CornerBracket extends StatelessWidget {
  const _CornerBracket({
    required this.color,
    required this.len,
    required this.thick,
    required this.top,
    required this.left,
  });
  final Color color;
  final double len;
  final double thick;
  final bool top;
  final bool left;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: len,
      height: len,
      child: CustomPaint(
        painter: _BracketPainter(color: color, thick: thick, top: top, left: left),
      ),
    );
  }
}

class _BracketPainter extends CustomPainter {
  const _BracketPainter({
    required this.color,
    required this.thick,
    required this.top,
    required this.left,
  });
  final Color color;
  final double thick;
  final bool top;
  final bool left;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = thick
      ..strokeCap = StrokeCap.square;
    final x = left ? 0.0 : size.width;
    final y = top ? 0.0 : size.height;
    final ex = left ? size.width : 0.0;
    final ey = top ? size.height : 0.0;
    canvas.drawLine(Offset(x, y), Offset(ex, y), p);
    canvas.drawLine(Offset(x, y), Offset(x, ey), p);
  }

  @override
  bool shouldRepaint(_) => false;
}
