class DroneModel {
  final String id;
  final String name;
  final String model;
  final double latitude;
  final double longitude;
  final double batteryLevel;
  final String status;

  DroneModel({
    required this.id,
    required this.name,
    required this.model,
    required this.latitude,
    required this.longitude,
    required this.batteryLevel,
    required this.status,
  });

  factory DroneModel.fromJson(Map<String, dynamic> json) {
    return DroneModel(
      id: json['id'],
      name: json['name'],
      model: json['model'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      batteryLevel: json['batteryLevel'].toDouble(),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'model': model,
      'latitude': latitude,
      'longitude': longitude,
      'batteryLevel': batteryLevel,
      'status': status,
    };
  }
}