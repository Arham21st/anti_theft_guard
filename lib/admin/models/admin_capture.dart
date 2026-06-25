import 'package:flutter/material.dart';

class AdminCapture {
  const AdminCapture({
    required this.id,
    required this.deviceId,
    required this.camera,
    required this.timestamp,
    required this.location,
    required this.confidence,
    required this.color,
  });

  final String id;
  final String deviceId;
  final String camera;
  final String timestamp;
  final String location;
  final String confidence;
  final Color color;
}

class AdminRecording {
  const AdminRecording({
    required this.id,
    required this.deviceId,
    required this.fileName,
    required this.camera,
    required this.duration,
    required this.size,
    required this.timestamp,
  });

  final String id;
  final String deviceId;
  final String fileName;
  final String camera;
  final String duration;
  final String size;
  final String timestamp;
}
