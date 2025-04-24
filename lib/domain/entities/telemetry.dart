class Telemetry {
  final String droneId;
  final double latitude;
  final double longitude;
  final double altitude;
  final double speed;
  final double heading;
  final double batteryLevel;
  final double signalStrength;
  final DateTime timestamp;

  Telemetry({
    required this.droneId,
    required this.latitude,
    required this.longitude,
    required this.altitude,
    required this.speed,
    required this.heading,
    required this.batteryLevel,
    required this.signalStrength,
    required this.timestamp,
  });
}