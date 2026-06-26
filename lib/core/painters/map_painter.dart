import 'package:flutter/material.dart';

/// Custom painter for a simplified fleet map background.
/// Draws a grid pattern with simulated roads.
class MapPainter extends CustomPainter {
  const MapPainter({
    this.backgroundColor = const Color(0xFF0D1117),
    this.gridColor = const Color(0xFF1A2030),
    this.roadColor = const Color(0xFF253040),
    this.gridSpacing = 32,
    this.roadWidth = 8,
  });

  /// Background color of the map
  final Color backgroundColor;

  /// Color of the grid lines
  final Color gridColor;

  /// Color of the roads
  final Color roadColor;

  /// Spacing between grid lines
  final double gridSpacing;

  /// Width of road lines
  final double roadWidth;

  @override
  void paint(Canvas canvas, Size size) {
    // Draw background
    final backgroundPaint = Paint()..color = backgroundColor;
    canvas.drawRect(
      Offset.zero & size,
      backgroundPaint,
    );

    // Draw grid lines
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;

    // Vertical grid lines
    for (double x = 0; x < size.width; x += gridSpacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        gridPaint,
      );
    }

    // Horizontal grid lines
    for (double y = 0; y < size.height; y += gridSpacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    // Draw simulated roads
    final roadPaint = Paint()
      ..color = roadColor
      ..strokeWidth = roadWidth
      ..strokeCap = StrokeCap.round;

    // Horizontal roads
    _drawRoad(
      canvas: canvas,
      start: Offset(0, size.height * 0.32),
      end: Offset(size.width, size.height * 0.32),
      paint: roadPaint,
    );
    _drawRoad(
      canvas: canvas,
      start: Offset(0, size.height * 0.67),
      end: Offset(size.width, size.height * 0.67),
      paint: roadPaint,
    );

    // Vertical roads
    _drawRoad(
      canvas: canvas,
      start: Offset(size.width * 0.25, 0),
      end: Offset(size.width * 0.25, size.height),
      paint: roadPaint,
    );
    _drawRoad(
      canvas: canvas,
      start: Offset(size.width * 0.72, 0),
      end: Offset(size.width * 0.72, size.height),
      paint: roadPaint,
    );
  }

  /// Draw a single road with rounded caps
  void _drawRoad({
    required Canvas canvas,
    required Offset start,
    required Offset end,
    required Paint paint,
  }) {
    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(covariant MapPainter oldDelegate) {
    return oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.gridColor != gridColor ||
        oldDelegate.roadColor != roadColor;
  }

  /// Create a copy of this painter with updated properties
  MapPainter copyWith({
    Color? backgroundColor,
    Color? gridColor,
    Color? roadColor,
    double? gridSpacing,
    double? roadWidth,
  }) {
    return MapPainter(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      gridColor: gridColor ?? this.gridColor,
      roadColor: roadColor ?? this.roadColor,
      gridSpacing: gridSpacing ?? this.gridSpacing,
      roadWidth: roadWidth ?? this.roadWidth,
    );
  }
}

/// Widget that displays a fleet map with the specified background.
class FleetMapBackground extends StatelessWidget {
  const FleetMapBackground({
    super.key,
    this.backgroundColor,
    this.gridColor,
    this.roadColor,
    this.child,
  });

  /// Optional background color override
  final Color? backgroundColor;

  /// Optional grid color override
  final Color? gridColor;

  /// Optional road color override
  final Color? roadColor;

  /// Optional child widget to overlay on the map
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MapPainter(
        backgroundColor: backgroundColor ?? const Color(0xFF0D1117),
        gridColor: gridColor ?? const Color(0xFF1A2030),
        roadColor: roadColor ?? const Color(0xFF253040),
      ),
      child: child,
    );
  }
}
