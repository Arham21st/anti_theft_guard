import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Backgrounds ─────────────────────────────────────────────────────────────
  static const Color background = Color(0xFF0A0A0F);
  static const Color surface = Color(0xFF12121A);
  static const Color surfaceElevated = Color(0xFF1A1A28);
  static const Color surfaceHighest = Color(0xFF22223A);

  // ── Brand ────────────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFFFF3131);
  static const Color primaryLight = Color(0xFFFF5E5E);
  static const Color primaryDark = Color(0xFFCC0000);
  static const Color secondary = Color(0xFFFF6B35);

  // ── Status ───────────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF00E676);
  static const Color successDim = Color(0xFF00A854);
  static const Color warning = Color(0xFFFFB300);
  static const Color danger = Color(0xFFFF3131);
  static const Color info = Color(0xFF29B6F6);

  // ── Text ─────────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8A8A9A);
  static const Color textTertiary = Color(0xFF55556A);
  static const Color textDisabled = Color(0xFF3A3A4A);

  // ── Borders & Glass ──────────────────────────────────────────────────────────
  static const Color border = Color(0xFF1E1E2E);
  static const Color borderHighlight = Color(0xFF2E2E42);
  static const Color borderGlow = Color(0x40FF3131);
  static const Color glassStroke = Color(0x20FFFFFF);
  static const Color glassFill = Color(0x10FFFFFF);

  // ── Gradients ────────────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFF3131), Color(0xFFFF6B35)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF0A0A0F), Color(0xFF0D0D18)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF00E676), Color(0xFF00B248)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [Color(0xFFFFB300), Color(0xFFFF6F00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [Color(0x18FFFFFF), Color(0x08FFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF14141E), Color(0xFF0E0E16)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
