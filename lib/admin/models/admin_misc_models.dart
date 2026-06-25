class AdminLocationPoint {
  const AdminLocationPoint({
    required this.deviceId,
    required this.time,
    required this.address,
    required this.coordinates,
    required this.accuracy,
    required this.speed,
    required this.distance,
  });

  final String deviceId;
  final String time;
  final String address;
  final String coordinates;
  final String accuracy;
  final String speed;
  final String distance;
}

class AdminContact {
  const AdminContact({
    required this.deviceId,
    required this.name,
    required this.relationship,
    required this.phone,
    required this.enabled,
  });

  final String deviceId;
  final String name;
  final String relationship;
  final String phone;
  final bool enabled;
}

class BatterySample {
  const BatterySample({required this.label, required this.value});

  final String label;
  final int value;
}
