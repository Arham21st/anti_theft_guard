import 'package:flutter/material.dart';

/// Touch target sizing utilities for the admin module.
/// Ensures accessible touch target sizes following Material Design guidelines.
class AdminTouchTargets {
  AdminTouchTargets._();

  // ── Material Design Touch Target Standards ─────────────────────────────────────────
  /// Minimum touch target for mobile devices (44px) - Android accessibility standard
  static const double minMobile = 44.0;

  /// Minimum touch target for desktop (38px) - Mouse-friendly minimum
  static const double minDesktop = 38.0;

  /// Recommended touch target (48px) - WCAG AAA accessibility standard
  static const double recommended = 48.0;

  /// Comfortable touch target (56px) - Enhanced accessibility
  static const double comfortable = 56.0;

  // ── Component-Specific Sizes ───────────────────────────────────────────────────────

  /// Icon button size
  static const double iconButtonMobile = minMobile;
  static const double iconButtonDesktop = minDesktop;

  /// Switch/toggle height constant
  static const double switchHeightConstant = recommended;

  /// Checkbox size
  static const double checkboxSize = recommended;

  /// Radio button size
  static const double radioSize = recommended;

  /// Dropdown/select height constant
  static const double dropdownHeightConstant = recommended;

  /// Text field height
  static const double textFieldHeight = recommended;

  /// Button height (medium)
  static const double buttonHeightMedium = comfortable;

  /// Button height (small)
  static const double buttonHeightSmall = recommended;

  /// FAB size (minimum)
  static const double fabSize = 56.0;

  /// List tile height
  static const double listTileHeight = comfortable;

  // ── Adaptive Sizing Methods ─────────────────────────────────────────────────────────

  /// Get adaptive touch target size based on device type
  static double getAdaptiveSize(BuildContext context, {bool preferLarge = false}) {
    final isTouchDevice = _isTouchDevice(context);
    final isMobile = _isMobileSize(context);

    if (isTouchDevice || isMobile) {
      return preferLarge ? comfortable : minMobile;
    }
    return preferLarge ? recommended : minDesktop;
  }

  /// Get icon button size for current device
  static double iconButton(BuildContext context) {
    return getAdaptiveSize(context);
  }

  /// Get switch height for current device
  static double getSwitchHeight(BuildContext context) {
    return getAdaptiveSize(context, preferLarge: true);
  }

  /// Get dropdown height for current device
  static double getDropdownHeight(BuildContext context) {
    return getAdaptiveSize(context, preferLarge: true);
  }

  /// Get button height for current device
  static double buttonHeight(BuildContext context, {bool large = false}) {
    return getAdaptiveSize(context, preferLarge: large);
  }

  // ── Layout Utilities ───────────────────────────────────────────────────────────────

  /// Calculate padding to achieve minimum touch target
  /// Use this to add padding around small icons or elements
  static EdgeInsets paddingForTarget({
    required double contentSize,
    double minSize = minMobile,
  }) {
    final padding = (minSize - contentSize) / 2;
    return EdgeInsets.symmetric(
      horizontal: padding.clamp(0, double.infinity),
      vertical: padding.clamp(0, double.infinity),
    );
  }

  /// Calculate padding for icon button
  static EdgeInsets iconButtonPadding({
    required double iconSize,
    double minSize = minMobile,
  }) {
    return paddingForTarget(contentSize: iconSize, minSize: minSize);
  }

  // ── Detection Helpers ──────────────────────────────────────────────────────────────

  /// Check if device is touch-based
  static bool _isTouchDevice(BuildContext context) {
    // Simple heuristic: mobile/tablet or high pixel ratio indicates touch
    return _isMobileSize(context) ||
        MediaQuery.of(context).devicePixelRatio > 1.5;
  }

  /// Check if screen size is mobile
  static bool _isMobileSize(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  /// Check if screen is tablet size
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 904;
  }

  /// Check if screen is desktop size
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 904;
  }

  // ── Validation Utilities ────────────────────────────────────────────────────────────

  /// Check if a size meets minimum touch target requirements
  static bool meetsMinimumRequirement(double size, {bool isMobile = true}) {
    final minimum = isMobile ? minMobile : minDesktop;
    return size >= minimum;
  }

  /// Get the minimum size for a component type
  static double getMinimumFor(AdminTouchTargetComponent component,
      {bool isMobile = true}) {
    final baseMinimum = isMobile ? minMobile : minDesktop;

    switch (component) {
      case AdminTouchTargetComponent.iconButton:
        return baseMinimum;
      case AdminTouchTargetComponent.switch_:
        return recommended;
      case AdminTouchTargetComponent.checkbox:
        return recommended;
      case AdminTouchTargetComponent.radio:
        return recommended;
      case AdminTouchTargetComponent.button:
        return comfortable;
      case AdminTouchTargetComponent.dropdown:
        return recommended;
      case AdminTouchTargetComponent.textField:
        return recommended;
      case AdminTouchTargetComponent.fab:
        return fabSize;
      case AdminTouchTargetComponent.listTile:
        return comfortable;
    }
  }

  /// Validate that a widget meets accessibility standards
  static bool isAccessible(Size size, AdminTouchTargetComponent component) {
    final minSize = getMinimumFor(component, isMobile: true);
    return size.width >= minSize && size.height >= minSize;
  }

  // ── Debug Information ─────────────────────────────────────────────────────────────

  /// Get debug string showing touch target info for current device
  static String debugInfo(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final isTouch = _isTouchDevice(context);
    final adaptiveSize = getAdaptiveSize(context);

    return 'AdminTouchTargets: '
        'width=${size.width.toStringAsFixed(1)}, '
        'pixelRatio=${pixelRatio.toStringAsFixed(2)}, '
        'isTouch=$isTouch, '
        'adaptiveSize=$adaptiveSize';
  }
}

// ── Component Types ──────────────────────────────────────────────────────────────────

/// Types of touch targets for size validation
enum AdminTouchTargetComponent {
  /// Icon button
  iconButton,

  /// Switch/toggle
  switch_,

  /// Checkbox
  checkbox,

  /// Radio button
  radio,

  /// Standard button
  button,

  /// Dropdown/select
  dropdown,

  /// Text input field
  textField,

  /// Floating action button
  fab,

  /// List tile
  listTile,
}

// ── Extension for Context ───────────────────────────────────────────────────────────

/// Extension on BuildContext for easy touch target access
extension AdminTouchTargetsExtension on BuildContext {
  /// Get adaptive touch target size
  double adaptiveTouchTarget({bool preferLarge = false}) {
    return AdminTouchTargets.getAdaptiveSize(this, preferLarge: preferLarge);
  }

  /// Get icon button size
  double get iconButtonSize =>
      AdminTouchTargets.iconButton(this);

  /// Get switch height
  double get switchHeight =>
      AdminTouchTargets.getSwitchHeight(this);

  /// Get button height
  double buttonHeight({bool large = false}) =>
      AdminTouchTargets.buttonHeight(this, large: large);

  /// Check if touch device
  bool get isTouchDevice => AdminTouchTargets._isTouchDevice(this);
}

// ── Widget Builder Helper ───────────────────────────────────────────────────────────

/// Helper widget to ensure minimum touch target size
class TouchTargetWrapper extends StatelessWidget {
  const TouchTargetWrapper({
    super.key,
    required this.child,
    this.minSize,
    this.padding,
  });

  final Widget child;
  final double? minSize;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final effectiveMinSize =
        minSize ?? AdminTouchTargets.getAdaptiveSize(context);

    return Container(
      constraints: BoxConstraints(
        minWidth: effectiveMinSize,
        minHeight: effectiveMinSize,
      ),
      padding: padding ??
          AdminTouchTargets.paddingForTarget(
            contentSize: effectiveMinSize,
            minSize: effectiveMinSize,
          ),
      child: child,
    );
  }
}
