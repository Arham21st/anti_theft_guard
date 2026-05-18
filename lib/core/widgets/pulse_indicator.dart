import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';

/// Animated pulsing circle indicator — used to show "live" or "active" state.
class PulseIndicator extends StatelessWidget {
  const PulseIndicator({
    super.key,
    this.color = AppColors.success,
    this.size = 12,
    this.pulseSize = 24,
  });

  final Color color;
  final double size;
  final double pulseSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: pulseSize,
      height: pulseSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Pulsing outer ring
          Container(
            width: pulseSize,
            height: pulseSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.15),
            ),
          )
              .animate(onPlay: (c) => c.repeat())
              .scale(
                begin: const Offset(0.7, 0.7),
                end: const Offset(1.1, 1.1),
                duration: 1200.ms,
                curve: Curves.easeInOut,
              )
              .then()
              .scale(
                begin: const Offset(1.1, 1.1),
                end: const Offset(0.7, 0.7),
                duration: 1200.ms,
                curve: Curves.easeInOut,
              ),
          // Inner solid dot
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.6),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Large shield with pulsing glow rings — used in dashboard and splash.
class ShieldPulse extends StatelessWidget {
  const ShieldPulse({
    super.key,
    required this.isActive,
    this.size = 100,
  });

  final bool isActive;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.success : AppColors.primary;
    return SizedBox(
      width: size * 1.8,
      height: size * 1.8,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer ring
          Container(
            width: size * 1.7,
            height: size * 1.7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.05),
              border: Border.all(color: color.withOpacity(0.1), width: 1),
            ),
          )
              .animate(onPlay: (c) => c.repeat())
              .scale(
                begin: const Offset(0.9, 0.9),
                end: const Offset(1.05, 1.05),
                duration: 2000.ms,
                curve: Curves.easeInOut,
              )
              .then()
              .scale(
                begin: const Offset(1.05, 1.05),
                end: const Offset(0.9, 0.9),
                duration: 2000.ms,
                curve: Curves.easeInOut,
              ),
          // Middle ring
          Container(
            width: size * 1.3,
            height: size * 1.3,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.08),
              border: Border.all(color: color.withOpacity(0.2), width: 1),
            ),
          )
              .animate(onPlay: (c) => c.repeat())
              .scale(
                begin: const Offset(1.0, 1.0),
                end: const Offset(0.95, 0.95),
                duration: 1500.ms,
                curve: Curves.easeInOut,
              )
              .then()
              .scale(
                begin: const Offset(0.95, 0.95),
                end: const Offset(1.0, 1.0),
                duration: 1500.ms,
                curve: Curves.easeInOut,
              ),
          // Shield icon
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.15),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(
              Icons.shield_rounded,
              color: color,
              size: size * 0.55,
            ),
          ),
        ],
      ),
    );
  }
}
