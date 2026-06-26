import '../models/admin_capture.dart';
import '../models/admin_device.dart';
import '../models/admin_event.dart';
import '../models/admin_misc_models.dart';

/// Repository interface for admin module data operations.
/// Provides abstraction for data sources, enabling easy switching between
/// mock data and real API implementations.
abstract class AdminRepository {
  // ── Device Operations ────────────────────────────────────────────────────────────

  /// Get all devices in the fleet
  Future<List<AdminDevice>> getDevices();

  /// Get a specific device by ID
  Future<AdminDevice?> getDeviceById(String id);

  /// Stream of devices for real-time updates
  Stream<List<AdminDevice>> watchDevices();

  /// Stream of a specific device for real-time updates
  Stream<AdminDevice?> watchDevice(String id);

  /// Search devices by name or owner
  Future<List<AdminDevice>> searchDevices(String query);

  /// Get devices filtered by status
  Future<List<AdminDevice>> getDevicesByStatus(DeviceProtectionStatus status);

  // ── Event Operations ───────────────────────────────────────────────────────────────

  /// Get all events, optionally filtered by device ID and event type
  Future<List<AdminEvent>> getEvents({
    String? deviceId,
    AdminEventType? type,
    int? limit,
    int? offset,
  });

  /// Stream of events for real-time updates
  Stream<List<AdminEvent>> watchEvents({
    String? deviceId,
    AdminEventType? type,
  });

  /// Get a specific event by ID
  Future<AdminEvent?> getEventById(String id);

  /// Get events within a time range
  Future<List<AdminEvent>> getEventsByTimeRange({
    required DateTime start,
    required DateTime end,
    String? deviceId,
  });

  /// Get event count by type for statistics
  Future<Map<AdminEventType, int>> getEventCounts({
    String? deviceId,
    DateTime? since,
  });

  // ── Capture Operations ────────────────────────────────────────────────────────────

  /// Get all captures, optionally filtered by device ID
  Future<List<AdminCapture>> getCaptures({
    String? deviceId,
    int? limit,
    int? offset,
  });

  /// Get a specific capture by ID
  Future<AdminCapture?> getCaptureById(String id);

  /// Get captures within a time range
  Future<List<AdminCapture>> getCapturesByTimeRange({
    required DateTime start,
    required DateTime end,
    String? deviceId,
  });

  /// Stream of captures for real-time updates
  Stream<List<AdminCapture>> watchCaptures({
    String? deviceId,
  });

  // ── Location Operations ───────────────────────────────────────────────────────────

  /// Get location history for devices
  Future<List<AdminLocationPoint>> getLocations({
    String? deviceId,
    int? limit,
    int? offset,
  });

  /// Get locations within a time range
  Future<List<AdminLocationPoint>> getLocationsByTimeRange({
    required DateTime start,
    required DateTime end,
    String? deviceId,
  });

  /// Stream of locations for real-time updates
  Stream<List<AdminLocationPoint>> watchLocations({
    String? deviceId,
  });

  /// Get the most recent location for a device
  Future<AdminLocationPoint?> getLatestLocation(String deviceId);

  // ── Contact Operations ────────────────────────────────────────────────────────────

  /// Get emergency contacts for devices
  Future<List<AdminContact>> getContacts({
    String? deviceId,
  });

  /// Update contact information
  Future<bool> updateContact(String deviceId, String contactId, AdminContact contact);

  /// Add a new contact
  Future<bool> addContact(String deviceId, AdminContact contact);

  /// Delete a contact
  Future<bool> deleteContact(String deviceId, String contactId);

  // ── Battery Operations ───────────────────────────────────────────────────────────

  /// Get battery history samples
  Future<List<BatterySample>> getBatterySamples({
    String? deviceId,
    int? limit,
  });

  /// Get battery samples within a time range
  Future<List<BatterySample>> getBatterySamplesByTimeRange({
    required DateTime start,
    required DateTime end,
    String? deviceId,
  });

  /// Get current battery level for a device
  Future<int> getBatteryLevel(String deviceId);

  /// Stream of battery samples for real-time monitoring
  Stream<List<BatterySample>> watchBatterySamples({
    String? deviceId,
  });

  // ── Statistics and Analytics ───────────────────────────────────────────────────────

  /// Get fleet statistics
  Future<Map<String, dynamic>> getFleetStatistics();

  /// Get device statistics for a specific device
  Future<Map<String, dynamic>> getDeviceStatistics(String deviceId);

  /// Get alert counts by severity
  Future<Map<String, int>> getAlertCounts({
    String? deviceId,
    DateTime? since,
  });

  /// Get activity summary for time period
  Future<Map<String, dynamic>> getActivitySummary({
    required DateTime start,
    required DateTime end,
    String? deviceId,
  });

  // ── Settings and Configuration ─────────────────────────────────────────────────────

  /// Get admin settings
  Future<Map<String, dynamic>> getSettings();

  /// Update admin settings
  Future<bool> updateSettings(Map<String, dynamic> settings);

  /// Get device settings
  Future<Map<String, dynamic>> getDeviceSettings(String deviceId);

  /// Update device settings
  Future<bool> updateDeviceSettings(
    String deviceId,
    Map<String, dynamic> settings,
  );

  // ── Real-time and Push Notifications ───────────────────────────────────────────────

  /// Stream of all admin events for real-time updates
  Stream<AdminEvent> getEventStream();

  /// Stream of device status changes
  Stream<DeviceStatusChange> getDeviceStatusStream();

  /// Subscribe to push notifications for device events
  Future<bool> subscribeToDeviceEvents(String deviceId);

  /// Unsubscribe from push notifications
  Future<bool> unsubscribeFromDeviceEvents(String deviceId);

  // ── Authentication and Authorization (Future) ─────────────────────────────────────

  /// Check if current user has admin access
  Future<bool> hasAdminAccess();

  /// Check if current user can access specific device
  Future<bool> canAccessDevice(String deviceId);

  /// Check if current user can perform action
  Future<bool> canPerformAction(String action, {String? deviceId});
}

/// Device status change event for real-time updates
class DeviceStatusChange {
  const DeviceStatusChange({
    required this.deviceId,
    required this.oldStatus,
    required this.newStatus,
    required this.timestamp,
  });

  final String deviceId;
  final DeviceProtectionStatus oldStatus;
  final DeviceProtectionStatus newStatus;
  final DateTime timestamp;
}

/// Repository exception for data layer errors
class RepositoryException implements Exception {
  const RepositoryException(
    this.message, {
    this.code,
    this.originalError,
  });

  final String message;
  final String? code;
  final Object? originalError;

  @override
  String toString() {
    if (code != null) {
      return 'RepositoryException [$code]: $message';
    }
    return 'RepositoryException: $message';
  }
}

/// Result type for repository operations
class RepositoryResult<T> {
  const RepositoryResult.success(this.data)
      : error = null,
        isSuccess = true;

  const RepositoryResult.failure(this.error)
      : data = null,
        isSuccess = false;

  final T? data;
  final RepositoryException? error;
  final bool isSuccess;

  /// Create a successful result
  factory RepositoryResult.ok(T data) {
    return RepositoryResult.success(data);
  }

  /// Create a failed result
  factory RepositoryResult.error(
    String message, {
    String? code,
    Object? originalError,
  }) {
    return RepositoryResult.failure(
      RepositoryException(
        message,
        code: code,
        originalError: originalError,
      ),
    );
  }

  /// Get data or throw exception if failed
  T getOrThrow() {
    if (isSuccess && data != null) {
      return data!;
    }
    throw error ?? const RepositoryException('Unknown error');
  }

  /// Execute callback based on success/failure
  R fold<R>(
    R Function(T data) onSuccess,
    R Function(RepositoryException error) onFailure,
  ) {
    if (isSuccess && data != null) {
      return onSuccess(data as T);
    }
    return onFailure(error ?? const RepositoryException('Unknown error'));
  }
}
