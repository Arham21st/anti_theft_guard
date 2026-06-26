import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Custom painter for a circular battery gauge.
/// Displays battery level as a colored arc with value in center.
class GaugePainter extends CustomPainter {
  const GaugePainter({
    required this.value,
    required this.color,
    this.startAngle = math.pi * 0.75,
    this.sweepAngle = math.pi * 1.5,
    this.strokeWidth = 13,
    this.padding = 14,
  });

  /// The value to display (0.0 to 1.0, representing 0-100%)
  final double value;

  /// Color for the value arc
  final Color color;

  /// Starting angle for the gauge arc (in radians)
  final double startAngle;

  /// Total sweep angle for the full gauge arc (in radians)
  final double sweepAngle;

  /// Width of the gauge arc stroke
  final double strokeWidth;

  /// Padding from the edge of the canvas
  final double padding;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - padding;

    // Draw background arc (track)
    final backgroundPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      backgroundPaint,
    );

    // Draw value arc (progress)
    final valuePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle * value.clamp(0.0, 1.0),
      false,
      valuePaint,
    );
  }

  @override
  bool shouldRepaint(covariant GaugePainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.color != color ||
        oldDelegate.startAngle != startAngle ||
        oldDelegate.sweepAngle != sweepAngle;
  }

  /// Create a copy of this painter with updated properties
  GaugePainter copyWith({
    double? value,
    Color? color,
    double? startAngle,
    double? sweepAngle,
    double? strokeWidth,
    double? padding,
  }) {
    return GaugePainter(
      value: value ?? this.value,
      color: color ?? this.color,
      startAngle: startAngle ?? this.startAngle,
      sweepAngle: sweepAngle ?? this.sweepAngle,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      padding: padding ?? this.padding,
    );
  }
}

/// Widget that displays a battery gauge with centered value.
class BatteryGauge extends StatelessWidget {
  const BatteryGauge({
    super.key,
    required this.value,
    this.size = 220,
    this.color,
    this.icon,
    this.label,
  });

  /// Battery percentage (0-100)
  final int value;

  /// Size of the gauge (width and height)
  final double size;

  /// Optional custom color (auto-calculated if not provided)
  final Color? color;

  /// Optional icon to display in center
  final IconData? icon;

  /// Optional label to display below value
  final String? label;

  /// Get the appropriate color for battery level
  static Color getColorForLevel(int level, {Color? success, Color? warning, Color? danger}) {
    final successColor = success ?? const Color(0xFF00E676);
    final warningColor = warning ?? const Color(0xFFFFB300);
    final dangerColor = danger ?? const Color(0xFFFF3131);

    if (level <= 20) return dangerColor;
    if (level <= 45) return warningColor;
    return successColor;
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? getColorForLevel(value);
    final displayIcon = icon ?? Icons.battery_charging_full_rounded;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: GaugePainter(
              value: value / 100,
              color: effectiveColor,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                displayIcon,
                color: effectiveColor,
                size: size * 0.15, // 15% of size
              ),
              SizedBox(height: size * 0.045),
              Text(
                '$value%',
                style: TextStyle(
                  fontSize: size * 0.14,
                  fontWeight: FontWeight.w800,
                  color: effectiveColor,
                ),
              ),
              if (label != null) ...[
                SizedBox(height: size * 0.023),
                Text(
                  label!,
                  style: TextStyle(
                    fontSize: size * 0.05,
                    color: Colors.grey.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
