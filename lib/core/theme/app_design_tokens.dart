import 'package:flutter/material.dart';

/// Design tokens for consistent spacing, sizing, and styling across the application.
/// This provides a single source of truth for common design values.
class AppDesignTokens {
  AppDesignTokens._();

  // ── Spacing ────────────────────────────────────────────────────────────────
  /// Extra small spacing (4px) - for tight gaps and fine adjustments
  static const double spacingXs = 4;

  /// Small spacing (8px) - for compact layouts
  static const double spacingSm = 8;

  /// Medium spacing (12px) - for standard padding and gaps
  static const double spacingMd = 12;

  /// Large spacing (16px) - for comfortable spacing
  static const double spacingLg = 16;

  /// Extra large spacing (20px) - for section separation
  static const double spacingXl = 20;

  /// Double extra large spacing (24px) - for major sections
  static const double spacingXxl = 24;

  /// Triple extra large spacing (32px) - for page-level spacing
  static const double spacingXxxl = 32;

  // ── Border Radius ────────────────────────────────────────────────────────────
  /// Small border radius (8px) - for cards and containers
  static const double radiusSm = 8;

  /// Medium border radius (12px) - for buttons and interactive elements
  static const double radiusMd = 12;

  /// Large border radius (16px) - for cards and panels
  static const double radiusLg = 16;

  /// Extra large border radius (20px) - for special elements
  static const double radiusXl = 20;

  /// Full border radius (30px) - for badges and pills
  static const double radiusFull = 30;

  // ── Icon Sizes ───────────────────────────────────────────────────────────────
  /// Small icon size (16px) - for compact icons
  static const double iconSm = 16;

  /// Medium icon size (18px) - for standard icons
  static const double iconMd = 18;

  /// Large icon size (24px) - for prominent icons
  static const double iconLg = 24;

  /// Extra large icon size (32px) - for hero icons
  static const double iconXl = 32;

  // ── Touch Targets ─────────────────────────────────────────────────────────────
  /// Minimum touch target for mobile devices (44px) - Android standard
  static const double touchMinMobile = 44.0;

  /// Minimum touch target for desktop (38px) - mouse-friendly minimum
  static const double touchMinDesktop = 38.0;

  /// Recommended touch target (48px) - for high accuracy and accessibility
  static const double touchRecommended = 48.0;

  /// Get adaptive touch target size based on device type
  static double getAdaptiveTouchTarget(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // Consider mobile if width is less than tablet breakpoint
    final isMobile = width < 600;
    return isMobile ? touchMinMobile : touchMinDesktop;
  }

  // ── Layout ────────────────────────────────────────────────────────────────────
  /// Standard container max width
  static const double containerMaxWidth = 1200;

  /// Narrow container width (400px)
  static const double containerNarrow = 400;

  /// Medium container width (800px)
  static const double containerMedium = 800;

  // ── Animation ─────────────────────────────────────────────────────────────────
  /// Fast animation duration (150ms)
  static const Duration animationFast = Duration(milliseconds: 150);

  /// Standard animation duration (250ms)
  static const Duration animationNormal = Duration(milliseconds: 250);

  /// Slow animation duration (350ms)
  static const Duration animationSlow = Duration(milliseconds: 350);

  /// Standard curve for most animations
  static const Curve curveDefault = Curves.easeInOut;

  /// Curve for entering elements
  static const Curve curveEnter = Curves.easeOut;

  /// Curve for exiting elements
  static const Curve curveExit = Curves.easeIn;

  // ── Opacity ──────────────────────────────────────────────────────────────────
  /// Disabled opacity
  static const double opacityDisabled = 0.38;

  /// Hover opacity overlay
  static const double opacityHover = 0.08;

  /// Focus opacity overlay
  static const double opacityFocus = 0.12;

  /// Pressed opacity overlay
  static const double opacityPressed = 0.16;

  /// Secondary text opacity (approximate for contrast)
  static const double opacitySecondaryText = 0.7;

  /// Tertiary text opacity (approximate for contrast)
  static const double opacityTertiaryText = 0.5;

  // ── Breakpoints ───────────────────────────────────────────────────────────────
  /// Mobile breakpoint
  static const double breakpointMobile = 0;

  /// Tablet breakpoint
  static const double breakpointTablet = 600;

  /// Desktop breakpoint (Material Design compact desktop)
  static const double breakpointDesktop = 904;

  /// Large desktop breakpoint
  static const double breakpointLargeDesktop = 1200;

  /// Ultra-wide breakpoint
  static const double breakpointUltraWide = 1600;
}
