enum AdminEventType { capture, location, sms, system, security, battery }

enum AdminSeverity { info, success, warning, critical }

class AdminEvent {
  const AdminEvent({
    required this.id,
    required this.deviceId,
    required this.title,
    required this.description,
    required this.time,
    required this.type,
    required this.severity,
  });

  final String id;
  final String deviceId;
  final String title;
  final String description;
  final String time;
  final AdminEventType type;
  final AdminSeverity severity;
}
