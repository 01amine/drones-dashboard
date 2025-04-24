class TelemetryModel {
  final String id;
  final String droneId;
  final double batteryLevel;
  final double latitude;
  final double longitude;
  final String state;
  final DateTime timestamp;

  TelemetryModel({
    required this.id,
    required this.droneId,
    required this.batteryLevel,
    required this.latitude,
    required this.longitude,
    required this.state,
    required this.timestamp,
  });

  factory TelemetryModel.fromJson(Map<String, dynamic> json) {
    return TelemetryModel(
      id: json['id'],
      droneId: json['droneId'],
      batteryLevel: json['batteryLevel'].toDouble(),
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      state: json['state'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'droneId': droneId,
      'batteryLevel': batteryLevel,
      'latitude': latitude,
      'longitude': longitude,
      'state': state,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}