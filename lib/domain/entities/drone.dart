class Drone {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final double altitude;
  final double batteryLevel;
  final String status; // 'armed', 'offline', 'error', etc.
  final double signalStrength;
  final double speed;
  final double heading;

  Drone({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.altitude,
    required this.batteryLevel,
    required this.status,
    required this.signalStrength,
    required this.speed,
    required this.heading,
  });

  Drone copyWith({
    String? id,
    String? name,
    double? latitude,
    double? longitude,
    double? altitude,
    double? batteryLevel,
    String? status,
    double? signalStrength,
    double? speed,
    double? heading,
  }) {
    return Drone(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      altitude: altitude ?? this.altitude,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      status: status ?? this.status,
      signalStrength: signalStrength ?? this.signalStrength,
      speed: speed ?? this.speed,
      heading: heading ?? this.heading,
    );
  }
}