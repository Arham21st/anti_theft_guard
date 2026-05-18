import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/glow_button.dart';

class FrontCameraScreen extends StatefulWidget {
  const FrontCameraScreen({super.key});
  @override
  State<FrontCameraScreen> createState() => _FrontCameraScreenState();
}

class _FrontCameraScreenState extends State<FrontCameraScreen> {
  bool _autoCapture = true;
  int _captureDelay = 0;  // 0=0s, 1=2s, 2=5s
  int _maxPhotos = 1;     // 0=1, 1=3, 2=5

  final _delays = ['0s', '2s', '5s'];
  final _photoCounts = ['1', '3', '5'];

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
        title: Text('Front Camera', style: AppTextStyles.headlineMedium),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.info.withOpacity(0.3)),
              ),
              child: Text('3 photos',
                  style: AppTextStyles.labelSmall
                      .copyWith(color: AppColors.info)),
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
                // Camera preview placeholder
                _buildCameraPreview(),
                // Stealth indicators
                _buildStealthRow(),
                const SectionHeader(title: 'CAPTURE SETTINGS'),
                GlassCard(
                  child: Row(
                    children: [
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          color: _autoCapture
                              ? AppColors.info.withOpacity(0.15)
                              : AppColors.surfaceElevated,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.camera_front_rounded,
                            color: _autoCapture
                                ? AppColors.info
                                : AppColors.textTertiary,
                            size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Auto-capture on Unlock',
                                style: AppTextStyles.titleMedium),
                            Text('Capture when someone tries to unlock',
                                style: AppTextStyles.bodySmall),
                          ],
                        ),
                      ),
                      Switch(
                        value: _autoCapture,
                        onChanged: (v) => setState(() => _autoCapture = v),
                        activeTrackColor: AppColors.info,
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
                      Text('Capture Delay', style: AppTextStyles.titleMedium),
                      const SizedBox(height: 12),
                      _SegmentedSelector(
                        options: _delays,
                        selected: _captureDelay,
                        color: AppColors.info,
                        onSelect: (i) => setState(() => _captureDelay = i),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 260.ms),
                const SizedBox(height: 10),
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Max Photos per Trigger',
                          style: AppTextStyles.titleMedium),
                      const SizedBox(height: 12),
                      _SegmentedSelector(
                        options: _photoCounts,
                        selected: _maxPhotos,
                        color: AppColors.info,
                        onSelect: (i) => setState(() => _maxPhotos = i),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 320.ms),
                const SectionHeader(title: 'CAPTURED PHOTOS'),
                _buildGallery(),
                const SizedBox(height: 16),
                GlowButton(
                  label: 'Capture Now (Preview)',
                  icon: Icons.camera_front_rounded,
                  onPressed: () {},
                  gradient: const LinearGradient(
                      colors: [AppColors.info, Color(0xFF0288D1)]),
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
          // Crosshair overlay
          Center(
            child: CustomPaint(
              size: const Size(80, 80),
              painter: _CrosshairPainter(),
            ),
          ),
          const Center(
            child: Icon(Icons.camera_front_rounded,
                color: Colors.white12, size: 48),
          ),
          Positioned(
            bottom: 12, left: 0, right: 0,
            child: Center(
              child: Text('Front Camera Preview',
                  style: AppTextStyles.bodySmall
                      .copyWith(color: Colors.white24)),
            ),
          ),
          // Corner brackets
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
      Positioned(top: 12, left: 12,
          child: _CornerBracket(color: color, len: len, thick: thick, top: true, left: true)),
      Positioned(top: 12, right: 12,
          child: _CornerBracket(color: color, len: len, thick: thick, top: true, left: false)),
      Positioned(bottom: 12, left: 12,
          child: _CornerBracket(color: color, len: len, thick: thick, top: false, left: true)),
      Positioned(bottom: 12, right: 12,
          child: _CornerBracket(color: color, len: len, thick: thick, top: false, left: false)),
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
                  Text(item.$1,
                      style: AppTextStyles.labelSmall
                          .copyWith(color: AppColors.success),
                      textAlign: TextAlign.center),
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
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final isCapture = i < 3;
          return Container(
            width: 76,
            decoration: BoxDecoration(
              color: isCapture
                  ? AppColors.surfaceElevated
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: isCapture
                      ? AppColors.borderHighlight
                      : AppColors.border),
            ),
            child: isCapture
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(Icons.person_rounded,
                          color: Colors.white12, size: 28),
                      Positioned(
                        bottom: 4, right: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.background.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text('0${i + 1}',
                              style: AppTextStyles.labelSmall),
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
              margin: EdgeInsets.only(right: e.key < options.length - 1 ? 8 : 0),
              decoration: BoxDecoration(
                color: isSelected ? color.withOpacity(0.15) : AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: isSelected ? color.withOpacity(0.5) : AppColors.border),
              ),
              child: Center(
                child: Text(e.value,
                    style: AppTextStyles.labelMedium.copyWith(
                      color: isSelected ? color : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    )),
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
        Offset(size.width / 2, size.height / 2), 16, p..style = PaintingStyle.stroke);
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
        painter: _BracketPainter(
            color: color, thick: thick, top: top, left: left),
      ),
    );
  }
}

class _BracketPainter extends CustomPainter {
  const _BracketPainter(
      {required this.color,
      required this.thick,
      required this.top,
      required this.left});
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
