enum DeviceProtectionStatus { protected, warning, offline, stolen }

class AdminDevice {
  const AdminDevice({
    required this.id,
    required this.ownerName,
    required this.ownerEmail,
    required this.deviceName,
    required this.model,
    required this.status,
    required this.batteryLevel,
    required this.location,
    required this.coordinates,
    required this.lastSeen,
    required this.stealthEnabled,
    required this.autoStartEnabled,
    required this.triggerMethod,
    required this.capturedPhotos,
    required this.recordings,
    required this.smsAlerts,
  });

  final String id;
  final String ownerName;
  final String ownerEmail;
  final String deviceName;
  final String model;
  final DeviceProtectionStatus status;
  final int batteryLevel;
  final String location;
  final String coordinates;
  final String lastSeen;
  final bool stealthEnabled;
  final bool autoStartEnabled;
  final String triggerMethod;
  final int capturedPhotos;
  final int recordings;
  final int smsAlerts;
}
