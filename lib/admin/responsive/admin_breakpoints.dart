import 'package:flutter/material.dart';

/// Standardized breakpoint system for responsive layouts in the admin module.
/// Replaces hardcoded breakpoint values with Material Design standards.
class AdminBreakpoints {
  AdminBreakpoints._();

  // ── Material Design Breakpoints ─────────────────────────────────────────────────
  /// Mobile breakpoint (0px) - All devices
  static const double mobile = 0;

  /// Tablet breakpoint (600px) - Small tablets and large phones in landscape
  static const double tablet = 600;

  /// Desktop breakpoint (904px) - Material Design's compact desktop
  static const double desktop = 904;

  /// Large desktop breakpoint (1200px) - Standard desktop displays
  static const double largeDesktop = 1200;

  /// Ultra-wide breakpoint (1600px) - Ultra-wide displays
  static const double ultraWide = 1600;

  // ── Admin-Specific Adjustments ────────────────────────────────────────────────────
  /// Width threshold for persistent sidebar (slightly above desktop for better UX)
  static const double sidebarPersistent = desktop + 80; // ~984px

  /// Width threshold for wide content layout
  static const double wideContent = largeDesktop;

  /// Width threshold for ultra-wide content layout
  static const double ultraWideContent = ultraWide;

  // ── Device Type Detection ─────────────────────────────────────────────────────────

  /// Check if current width is mobile size
  static bool isMobile(double width) => width < tablet;

  /// Check if current width is tablet size
  static bool isTablet(double width) =>
      width >= tablet && width < desktop;

  /// Check if current width is desktop size
  static bool isDesktop(double width) =>
      width >= desktop && width < largeDesktop;

  /// Check if current width is large desktop size
  static bool isLargeDesktop(double width) =>
      width >= largeDesktop && width < ultraWide;

  /// Check if current width is ultra-wide size
  static bool isUltraWide(double width) => width >= ultraWide;

  // ── Context-Based Detection ───────────────────────────────────────────────────────

  /// Check if current context is mobile size
  static bool isMobileContext(BuildContext context) {
    return isMobile(MediaQuery.of(context).size.width);
  }

  /// Check if current context is tablet size
  static bool isTabletContext(BuildContext context) {
    return isTablet(MediaQuery.of(context).size.width);
  }

  /// Check if current context is desktop size
  static bool isDesktopContext(BuildContext context) {
    return isDesktop(MediaQuery.of(context).size.width);
  }

  /// Check if current context is large desktop size
  static bool isLargeDesktopContext(BuildContext context) {
    return isLargeDesktop(MediaQuery.of(context).size.width);
  }

  /// Check if current context is ultra-wide size
  static bool isUltraWideContext(BuildContext context) {
    return isUltraWide(MediaQuery.of(context).size.width);
  }

  /// Check if sidebar should be persistent (not in drawer)
  static bool shouldShowPersistentSidebar(BuildContext context) {
    return MediaQuery.of(context).size.width >= sidebarPersistent;
  }

  // ── Density and Pixel Ratio ──────────────────────────────────────────────────────

  /// Get device pixel ratio
  static double getPixelRatio(BuildContext context) {
    return MediaQuery.of(context).devicePixelRatio;
  }

  /// Get density factor for scaling (xxxhdpi: 1.3, xxhdpi: 1.15, xhdpi: 1.0, mdpi/hdpi: 0.85)
  static double getDensityFactor(BuildContext context) {
    final pixelRatio = getPixelRatio(context);
    if (pixelRatio > 3.0) return 1.3; // xxxhdpi
    if (pixelRatio > 2.0) return 1.15; // xxhdpi
    if (pixelRatio > 1.5) return 1.0; // xhdpi
    return 0.85; // mdpi/hdpi
  }

  /// Check if device is high density
  static bool isHighDensity(BuildContext context) {
    return getPixelRatio(context) > 2.0;
  }

  // ── Orientation Helpers ────────────────────────────────────────────────────────────

  /// Check if device is in landscape orientation
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// Check if device is in portrait orientation
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  /// Get orientation-appropriate spacing factor
  /// Landscape uses slightly less spacing for vertical space
  static double getSpacingFactor(BuildContext context) {
    return isLandscape(context) ? 0.85 : 1.0;
  }

  // ── Adaptive Layout Values ─────────────────────────────────────────────────────────

  /// Get adaptive padding for page content
  static double getPagePadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;

    if (isMobile(width)) {
      return isLandscape ? 16 : 24;
    }
    if (isTablet(width)) {
      return isLandscape ? 20 : 28;
    }
    return 24;
  }

  /// Get adaptive padding for panels
  static double getPanelPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return isMobile(width) ? 14 : 18;
  }

  /// Get adaptive grid spacing
  static double getGridSpacing(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (isMobile(width)) return 12;
    if (isTablet(width)) return 14;
    return 18;
  }

  /// Get adaptive number of columns for a grid
  static int getGridColumns(BuildContext context, double itemWidth) {
    final width = MediaQuery.of(context).size.width;
    final spacing = getGridSpacing(context);

    final availableWidth = width - (getPagePadding(context) * 2);
    final estimatedColumns =
        ((availableWidth + spacing) / (itemWidth + spacing)).floor();

    if (isMobile(width)) return 1;
    if (isTablet(width)) return estimatedColumns.clamp(1, 2);
    return estimatedColumns.clamp(1, 4);
  }

  // ── Typography Scaling ────────────────────────────────────────────────────────────

  /// Get font scale factor based on breakpoint and density
  static double getFontScale(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final densityFactor = getDensityFactor(context);

    double breakpointFactor;
    if (isMobile(width)) {
      breakpointFactor = 0.95;
    } else if (isTablet(width)) {
      breakpointFactor = 0.975;
    } else if (isDesktop(width)) {
      breakpointFactor = 1.0;
    } else if (isLargeDesktop(width)) {
      breakpointFactor = 1.025;
    } else {
      breakpointFactor = 1.05;
    }

    return breakpointFactor * densityFactor;
  }

  // ── Layout Helpers ───────────────────────────────────────────────────────────────

  /// Calculate item width for responsive grid
  static double calculateItemWidth({
    required BuildContext context,
    required int maxColumns,
    required double minItemWidth,
  }) {
    final width = MediaQuery.of(context).size.width;
    final padding = getPagePadding(context) * 2;
    final spacing = getGridSpacing(context);

    final availableWidth = width - padding;
    final maxItemWidth =
        (availableWidth - (spacing * (maxColumns - 1))) / maxColumns;

    return maxItemWidth.clamp(minItemWidth, double.infinity);
  }

  /// Get the maximum number of columns that fit in available space
  static int getMaxColumns({
    required BuildContext context,
    required double itemWidth,
    required int maxAllowedColumns,
  }) {
    final width = MediaQuery.of(context).size.width;
    final padding = getPagePadding(context) * 2;
    final spacing = getGridSpacing(context);

    final availableWidth = width - padding - spacing;
    final estimatedColumns = (availableWidth / (itemWidth + spacing)).floor();

    return estimatedColumns.clamp(1, maxAllowedColumns);
  }

  // ── Debug Utilities ────────────────────────────────────────────────────────────────

  /// Get debug information about current breakpoint
  static String debugInfo(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final orientation = MediaQuery.of(context).orientation;
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;

    String deviceType;
    if (isMobile(width)) {
      deviceType = 'Mobile';
    } else if (isTablet(width)) {
      deviceType = 'Tablet';
    } else if (isDesktop(width)) {
      deviceType = 'Desktop';
    } else if (isLargeDesktop(width)) {
      deviceType = 'Large Desktop';
    } else {
      deviceType = 'Ultra-Wide';
    }

    return 'AdminBreakpoints: '
        'type=$deviceType, '
        'size=${width.toStringAsFixed(1)}x${height.toStringAsFixed(1)}, '
        'orientation=${orientation.name}, '
        'pixelRatio=${pixelRatio.toStringAsFixed(2)}';
  }
}

// ── Extension for Convenience ────────────────────────────────────────────────────────

/// Extension on BuildContext for easy breakpoint access
extension AdminBreakpointsExtension on BuildContext {
  /// Check if current context is mobile
  bool get isMobile => AdminBreakpoints.isMobileContext(this);

  /// Check if current context is tablet
  bool get isTablet => AdminBreakpoints.isTabletContext(this);

  /// Check if current context is desktop
  bool get isDesktop => AdminBreakpoints.isDesktopContext(this);

  /// Check if current context is large desktop
  bool get isLargeDesktop => AdminBreakpoints.isLargeDesktopContext(this);

  /// Check if current context is ultra-wide
  bool get isUltraWide => AdminBreakpoints.isUltraWideContext(this);

  /// Check if sidebar should be persistent
  bool get hasPersistentSidebar =>
      AdminBreakpoints.shouldShowPersistentSidebar(this);

  /// Get screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Get screen height
  double get screenHeight => MediaQuery.of(this).size.height;
}
