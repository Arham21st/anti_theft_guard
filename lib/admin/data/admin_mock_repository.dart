import 'dart:async';
import 'admin_mock_data.dart' as mock_data;
import 'admin_repository.dart';
import '../models/admin_capture.dart';
import '../models/admin_device.dart';
import '../models/admin_event.dart';
import '../models/admin_misc_models.dart';

/// Mock implementation of AdminRepository for demo and testing purposes.
/// Wraps the existing AdminMockData and provides the repository interface.
class AdminMockRepository implements AdminRepository {
  AdminMockRepository._() : _networkDelay = const Duration(milliseconds: 300);

  /// Singleton instance
  static final AdminMockRepository instance = AdminMockRepository._();

  /// Simulated network delay for realistic behavior
  final Duration _networkDelay;

  // ── Device Operations ────────────────────────────────────────────────────────────

  @override
  Future<List<AdminDevice>> getDevices() async {
    await _simulateNetwork();
    return mock_data.AdminMockData.devices;
  }

  @override
  Future<AdminDevice?> getDeviceById(String id) async {
    await _simulateNetwork();
    try {
      return mock_data.AdminMockData.devices.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Stream<List<AdminDevice>> watchDevices() {
    // Simulate periodic updates
    return Stream.periodic(
      const Duration(seconds: 30),
      (_) => mock_data.AdminMockData.devices,
    ).asyncMap((devices) async {
      await _simulateNetwork();
      return devices;
    });
  }

  @override
  Stream<AdminDevice?> watchDevice(String id) {
    return watchDevices().map((devices) {
      try {
        return devices.firstWhere((d) => d.id == id);
      } catch (_) {
        return null;
      }
    });
  }

  @override
  Future<List<AdminDevice>> searchDevices(String query) async {
    await _simulateNetwork();
    final lowercaseQuery = query.toLowerCase();
    return mock_data.AdminMockData.devices.where((device) {
      return device.deviceName.toLowerCase().contains(lowercaseQuery) ||
          device.ownerName.toLowerCase().contains(lowercaseQuery) ||
          device.model.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  @override
  Future<List<AdminDevice>> getDevicesByStatus(
      DeviceProtectionStatus status) async {
    await _simulateNetwork();
    return mock_data.AdminMockData.devices
        .where((device) => device.status == status)
        .toList();
  }

  // ── Event Operations ────────────────────────────────────────────────────────────

  @override
  Future<List<AdminEvent>> getEvents({
    String? deviceId,
    AdminEventType? type,
    int? limit,
    int? offset,
  }) async {
    await _simulateNetwork();
    var events = mock_data.AdminMockData.events;

    if (deviceId != null) {
      events = events.where((e) => e.deviceId == deviceId).toList();
    }

    if (type != null) {
      events = events.where((e) => e.type == type).toList();
    }

    if (offset != null && offset > 0) {
      if (events.length > offset) {
        events = events.sublist(offset);
      } else {
        events = [];
      }
    }

    if (limit != null && limit > 0) {
      if (events.length > limit) {
        events = events.sublist(0, limit);
      }
    }

    return events;
  }

  @override
  Stream<List<AdminEvent>> watchEvents({
    String? deviceId,
    AdminEventType? type,
  }) {
    return Stream.periodic(
      const Duration(seconds: 15),
      (_) => getEvents(deviceId: deviceId, type: type),
    ).asyncMap((future) async {
      final events = await future;
      await _simulateNetwork();
      return events;
    });
  }

  @override
  Future<AdminEvent?> getEventById(String id) async {
    await _simulateNetwork();
    try {
      return mock_data.AdminMockData.events.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<AdminEvent>> getEventsByTimeRange({
    required DateTime start,
    required DateTime end,
    String? deviceId,
  }) async {
    await _simulateNetwork();
    // For mock data, we'll just return all events since time parsing isn't available
    return getEvents(deviceId: deviceId);
  }

  @override
  Future<Map<AdminEventType, int>> getEventCounts({
    String? deviceId,
    DateTime? since,
  }) async {
    final events = await getEvents(deviceId: deviceId);

    final counts = <AdminEventType, int>{};
    for (final event in events) {
      counts[event.type] = (counts[event.type] ?? 0) + 1;
    }

    return counts;
  }

  // ── Capture Operations ───────────────────────────────────────────────────────────

  @override
  Future<List<AdminCapture>> getCaptures({
    String? deviceId,
    int? limit,
    int? offset,
  }) async {
    await _simulateNetwork();
    var captures = mock_data.AdminMockData.captures;

    if (deviceId != null) {
      captures = captures.where((c) => c.deviceId == deviceId).toList();
    }

    if (limit != null) {
      captures = captures.take(limit).toList();
    }

    return captures;
  }

  @override
  Future<AdminCapture?> getCaptureById(String id) async {
    await _simulateNetwork();
    try {
      return mock_data.AdminMockData.captures.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<AdminCapture>> getCapturesByTimeRange({
    required DateTime start,
    required DateTime end,
    String? deviceId,
  }) async {
    return getCaptures(deviceId: deviceId);
  }

  @override
  Stream<List<AdminCapture>> watchCaptures({String? deviceId}) {
    return Stream.periodic(
      const Duration(seconds: 20),
      (_) => getCaptures(deviceId: deviceId),
    ).asyncMap((future) async {
      final captures = await future;
      await _simulateNetwork();
      return captures;
    });
  }

  // ── Location Operations ─────────────────────────────────────────────────────────

  @override
  Future<List<AdminLocationPoint>> getLocations({
    String? deviceId,
    int? limit,
    int? offset,
  }) async {
    await _simulateNetwork();
    var locations = mock_data.AdminMockData.locations;

    if (deviceId != null) {
      locations = locations.where((l) => l.deviceId == deviceId).toList();
    }

    if (limit != null) {
      locations = locations.take(limit).toList();
    }

    return locations;
  }

  @override
  Future<List<AdminLocationPoint>> getLocationsByTimeRange({
    required DateTime start,
    required DateTime end,
    String? deviceId,
  }) async {
    return getLocations(deviceId: deviceId);
  }

  @override
  Stream<List<AdminLocationPoint>> watchLocations({String? deviceId}) {
    return Stream.periodic(
      const Duration(seconds: 10),
      (_) => getLocations(deviceId: deviceId),
    ).asyncMap((future) async {
      final locations = await future;
      await _simulateNetwork();
      return locations;
    });
  }

  @override
  Future<AdminLocationPoint?> getLatestLocation(String deviceId) async {
    final locations = await getLocations(deviceId: deviceId);
    if (locations.isEmpty) return null;
    return locations.first;
  }

  // ── Contact Operations ───────────────────────────────────────────────────────────

  @override
  Future<List<AdminContact>> getContacts({String? deviceId}) async {
    await _simulateNetwork();
    // Return empty list for mock data
    return [];
  }

  @override
  Future<bool> updateContact(
    String deviceId,
    String contactId,
    AdminContact contact,
  ) async {
    await _simulateNetwork();
    // Mock always returns success
    return true;
  }

  @override
  Future<bool> addContact(String deviceId, AdminContact contact) async {
    await _simulateNetwork();
    // Mock always returns success
    return true;
  }

  @override
  Future<bool> deleteContact(String deviceId, String contactId) async {
    await _simulateNetwork();
    // Mock always returns success
    return true;
  }

  // ── Battery Operations ───────────────────────────────────────────────────────────

  @override
  Future<List<BatterySample>> getBatterySamples({String? deviceId, int? limit}) async {
    await _simulateNetwork();
    return mock_data.AdminMockData.batterySamples;
  }

  @override
  Future<List<BatterySample>> getBatterySamplesByTimeRange({
    required DateTime start,
    required DateTime end,
    String? deviceId,
  }) async {
    return getBatterySamples(deviceId: deviceId);
  }

  @override
  Future<int> getBatteryLevel(String deviceId) async {
    await _simulateNetwork();
    final device = await getDeviceById(deviceId);
    return device?.batteryLevel ?? 0;
  }

  @override
  Stream<List<BatterySample>> watchBatterySamples({String? deviceId}) {
    return Stream.periodic(
      const Duration(seconds: 5),
      (_) => getBatterySamples(deviceId: deviceId),
    ).asyncMap((future) async {
      final samples = await future;
      await _simulateNetwork();
      return samples;
    });
  }

  // ── Statistics and Analytics ─────────────────────────────────────────────────────

  @override
  Future<Map<String, dynamic>> getFleetStatistics() async {
    await _simulateNetwork();
    final devices = mock_data.AdminMockData.devices;

    final protectedCount =
        devices.where((d) => d.status == DeviceProtectionStatus.protected).length;
    final warningCount =
        devices.where((d) => d.status == DeviceProtectionStatus.warning).length;
    final stolenCount =
        devices.where((d) => d.status == DeviceProtectionStatus.stolen).length;
    final offlineCount =
        devices.where((d) => d.status == DeviceProtectionStatus.offline).length;

    final avgBattery = devices.isEmpty
        ? 0
        : devices.fold<int>(0, (sum, d) => sum + d.batteryLevel) /
            devices.length;

    return {
      'totalDevices': devices.length,
      'protectedCount': protectedCount,
      'warningCount': warningCount,
      'stolenCount': stolenCount,
      'offlineCount': offlineCount,
      'averageBattery': avgBattery.round(),
      'totalCaptures': devices.fold<int>(0, (sum, d) => sum + d.capturedPhotos),
      'totalRecordings': devices.fold<int>(0, (sum, d) => sum + d.recordings),
      'totalSmsAlerts': devices.fold<int>(0, (sum, d) => sum + d.smsAlerts),
    };
  }

  @override
  Future<Map<String, dynamic>> getDeviceStatistics(String deviceId) async {
    await _simulateNetwork();
    final device = await getDeviceById(deviceId);

    if (device == null) {
      throw RepositoryException('Device not found', code: 'DEVICE_NOT_FOUND');
    }

    return {
      'deviceId': device.id,
      'deviceName': device.deviceName,
      'batteryLevel': device.batteryLevel,
      'status': device.status.name,
      'stealthEnabled': device.stealthEnabled,
      'autoStartEnabled': device.autoStartEnabled,
      'capturedPhotos': device.capturedPhotos,
      'recordings': device.recordings,
      'smsAlerts': device.smsAlerts,
    };
  }

  @override
  Future<Map<String, int>> getAlertCounts({String? deviceId, DateTime? since}) async {
    final events = await getEvents(deviceId: deviceId);

    final counts = <String, int>{'critical': 0, 'warning': 0, 'info': 0};

    for (final event in events) {
      switch (event.severity) {
        case AdminSeverity.critical:
          counts['critical'] = (counts['critical'] ?? 0) + 1;
          break;
        case AdminSeverity.warning:
          counts['warning'] = (counts['warning'] ?? 0) + 1;
          break;
        case AdminSeverity.info:
        case AdminSeverity.success:
          counts['info'] = (counts['info'] ?? 0) + 1;
          break;
      }
    }

    return counts;
  }

  @override
  Future<Map<String, dynamic>> getActivitySummary({
    required DateTime start,
    required DateTime end,
    String? deviceId,
  }) async {
    await _simulateNetwork();

    return {
      'eventCount': mock_data.AdminMockData.events.length,
      'captureCount': mock_data.AdminMockData.captures.length,
      'locationUpdates': mock_data.AdminMockData.locations.length,
    };
  }

  // ── Settings and Configuration ─────────────────────────────────────────────────────

  @override
  Future<Map<String, dynamic>> getSettings() async {
    await _simulateNetwork();
    return {
      'notificationsEnabled': true,
      'autoRefreshInterval': 30,
      'theme': 'dark',
      'mapStyle': 'satellite',
      'alertThreshold': 20,
    };
  }

  @override
  Future<bool> updateSettings(Map<String, dynamic> settings) async {
    await _simulateNetwork();
    // Mock always returns success
    return true;
  }

  @override
  Future<Map<String, dynamic>> getDeviceSettings(String deviceId) async {
    await _simulateNetwork();
    return {
      'deviceId': deviceId,
      'stealthModeEnabled': true,
      'autoStartEnabled': true,
      'batteryThreshold': 20,
      'locationTrackingEnabled': true,
      'captureOnTrigger': true,
    };
  }

  @override
  Future<bool> updateDeviceSettings(
    String deviceId,
    Map<String, dynamic> settings,
  ) async {
    await _simulateNetwork();
    // Mock always returns success
    return true;
  }

  // ── Real-time and Push Notifications ─────────────────────────────────────────────

  final StreamController<AdminEvent> _eventController =
      StreamController<AdminEvent>.broadcast();
  final StreamController<DeviceStatusChange> _statusController =
      StreamController<DeviceStatusChange>.broadcast();

  @override
  Stream<AdminEvent> getEventStream() {
    // Simulate random events
    return Stream.periodic(
      const Duration(seconds: 45),
      (count) => mock_data.AdminMockData.events[
          count % mock_data.AdminMockData.events.length],
    );
  }

  @override
  Stream<DeviceStatusChange> getDeviceStatusStream() {
    // Simulate status changes
    return Stream.periodic(
      const Duration(minutes: 5),
      (count) => DeviceStatusChange(
        deviceId: mock_data.AdminMockData.devices[
            count % mock_data.AdminMockData.devices.length].id,
        oldStatus: DeviceProtectionStatus.protected,
        newStatus: DeviceProtectionStatus.warning,
        timestamp: DateTime.now(),
      ),
    );
  }

  @override
  Future<bool> subscribeToDeviceEvents(String deviceId) async {
    await _simulateNetwork();
    // Mock always returns success
    return true;
  }

  @override
  Future<bool> unsubscribeFromDeviceEvents(String deviceId) async {
    await _simulateNetwork();
    // Mock always returns success
    return true;
  }

  // ── Authentication and Authorization ───────────────────────────────────────────────

  @override
  Future<bool> hasAdminAccess() async {
    await _simulateNetwork();
    // Mock always returns true for demo
    return true;
  }

  @override
  Future<bool> canAccessDevice(String deviceId) async {
    await _simulateNetwork();
    // Mock always returns true for demo
    return true;
  }

  @override
  Future<bool> canPerformAction(String action, {String? deviceId}) async {
    await _simulateNetwork();
    // Mock always returns true for demo
    return true;
  }

  // ── Utility Methods ────────────────────────────────────────────────────────────────

  /// Simulate network delay
  Future<void> _simulateNetwork() async {
    if (_networkDelay > Duration.zero) {
      await Future.delayed(_networkDelay);
    }
  }

  /// Dispose of resources
  void dispose() {
    _eventController.close();
    _statusController.close();
  }
}
