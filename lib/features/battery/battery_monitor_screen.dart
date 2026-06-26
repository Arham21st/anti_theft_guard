import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/glow_button.dart';

class BatteryMonitorScreen extends StatefulWidget {
  const BatteryMonitorScreen({super.key});
  @override
  State<BatteryMonitorScreen> createState() => _BatteryMonitorScreenState();
}

class _BatteryMonitorScreenState extends State<BatteryMonitorScreen> {
  double _alertThreshold = 15;
  bool _autoSmsOnLow = true;

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
        title: Text('Battery Monitor', style: AppTextStyles.headlineMedium),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 16),
                _buildBatteryGauge(),
                const SizedBox(height: 24),
                _buildStatsRow(),
                const SectionHeader(title: 'BATTERY ALERTS'),
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            color: AppColors.warning,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Low Battery Alert',
                            style: AppTextStyles.titleMedium,
                          ),
                          const Spacer(),
                          Text(
                            '${_alertThreshold.toInt()}%',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: AppColors.warning,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SliderTheme(
                        data: SliderThemeData(
                          activeTrackColor: AppColors.warning,
                          inactiveTrackColor: AppColors.surfaceHighest,
                          thumbColor: Colors.white,
                          overlayColor: AppColors.warning.withOpacity(0.2),
                          trackHeight: 4,
                        ),
                        child: Slider(
                          value: _alertThreshold,
                          min: 5,
                          max: 30,
                          divisions: 5,
                          onChanged: (v) => setState(() => _alertThreshold = v),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: 10),
                GlassCard(
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.warning.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.sms_rounded,
                          color: AppColors.warning,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Auto-SMS on Low Battery',
                              style: AppTextStyles.titleMedium,
                            ),
                            Text(
                              'Send location when battery is critical',
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _autoSmsOnLow,
                        onChanged: (v) => setState(() => _autoSmsOnLow = v),
                        activeTrackColor: AppColors.warning,
                        activeThumbColor: Colors.white,
                        inactiveThumbColor: AppColors.textTertiary,
                        inactiveTrackColor: AppColors.surfaceHighest,
                        trackOutlineColor: WidgetStateProperty.all(
                          Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 260.ms),
                const SectionHeader(title: 'DISCHARGE HISTORY (Last 6h)'),
                _buildHistoryChart(),
                const SizedBox(height: 16),
                GlowButton(
                  label: 'Send Battery Status Now',
                  icon: Icons.send_rounded,
                  onPressed: () {},
                  gradient: AppColors.successGradient,
                  glowColor: AppColors.success,
                ).animate().fadeIn(delay: 420.ms),
                const SizedBox(height: 28),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBatteryGauge() {
    return Center(
      child: SizedBox(
        width: 220,
        height: 220,
        child: Stack(
          children: [
            SizedBox(
              width: 220,
              height: 220,
              child: CustomPaint(
                painter: _BatteryGaugePainter(
                  progress: 0.72,
                  color: AppColors.success,
                  backgroundColor: AppColors.surfaceHighest,
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.battery_charging_full_rounded,
                    color: AppColors.success,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text('72%', style: AppTextStyles.statNumber),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Charging',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.success,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.9, 0.9)),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _StatBox(
            title: 'Health',
            value: 'Good',
            color: AppColors.success,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatBox(title: 'Temp', value: '34°C', color: AppColors.info),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatBox(
            title: 'Voltage',
            value: '4.1V',
            color: AppColors.textSecondary,
          ),
        ),
      ],
    ).animate().fadeIn(delay: 100.ms);
  }

  Widget _buildHistoryChart() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        height: 120,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _Bar(height: 100, label: '-6h', color: AppColors.success),
            _Bar(height: 85, label: '-5h', color: AppColors.success),
            _Bar(height: 70, label: '-4h', color: AppColors.success),
            _Bar(height: 50, label: '-3h', color: AppColors.warning),
            _Bar(height: 35, label: '-2h', color: AppColors.warning),
            _Bar(height: 20, label: '-1h', color: AppColors.danger),
            _Bar(height: 10, label: 'Now', color: AppColors.danger),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 340.ms);
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.title,
    required this.value,
    required this.color,
  });
  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(title, style: AppTextStyles.bodySmall),
          const SizedBox(height: 4),
          Text(value, style: AppTextStyles.titleLarge.copyWith(color: color)),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.height, required this.label, required this.color});
  final double height;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 16,
          height: height,
          decoration: BoxDecoration(
            color: color.withOpacity(0.8),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: AppTextStyles.labelSmall.copyWith(fontSize: 9)),
      ],
    );
  }
}

class _BatteryGaugePainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  _BatteryGaugePainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    const startAngle = math.pi * 0.75;
    const sweepAngle = math.pi * 1.5;

    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      bgPaint,
    );

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle * progress,
      false,
      progressPaint,
    );

    // Draw little tick marks
    final tickPaint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 2;
    for (int i = 0; i <= 20; i++) {
      final angle = startAngle + (sweepAngle * (i / 20));
      final innerRad = radius - 18;
      final outerRad = radius - 12;
      canvas.drawLine(
        Offset(
          center.dx + innerRad * math.cos(angle),
          center.dy + innerRad * math.sin(angle),
        ),
        Offset(
          center.dx + outerRad * math.cos(angle),
          center.dy + outerRad * math.sin(angle),
        ),
        tickPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BatteryGaugePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
