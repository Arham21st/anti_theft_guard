import 'package:flutter/widgets.dart';

import '../auth/user_role.dart';
import '../auth/web_auth_state.dart';
import '../data/admin_mock_data.dart';
import '../models/admin_device.dart';
import '../state/admin_navigation_state.dart';

/// Resolves the "selected device" for a page, uniformly across the app.
///
/// - [UserRole.user]: their single owned device (`session.deviceId`).
/// - [UserRole.admin]: the device selected via the top-bar dropdown, held in
///   the shared [AdminNavigationState] (default: first mock device).
///
/// Centralizing this lets every go_router page builder resolve a device the
/// same way, without the old per-page wrapper boilerplate, and keeps admin
/// device switching consistent across pages.
class AdminDeviceResolver {
  AdminDeviceResolver._();

  /// Resolve the device for the current session. Falls back to the first mock
  /// device if the id is missing/unknown.
  static AdminDevice resolve(BuildContext context) {
    final auth = WebAuthProvider.of(context);
    if (auth.role == UserRole.user) {
      final deviceId = auth.userDeviceId ?? AdminMockData.devices.first.id;
      return AdminMockData.devices.firstWhere(
        (d) => d.id == deviceId,
        orElse: () => AdminMockData.devices.first,
      );
    }
    // Admin: read the dropdown selection from the shared nav state.
    final navState = AdminNavigationProvider.of(context);
    final deviceId = navState.selectedDeviceId ?? AdminMockData.devices.first.id;
    return AdminMockData.devices.firstWhere(
      (d) => d.id == deviceId,
      orElse: () => AdminMockData.devices.first,
    );
  }
}
