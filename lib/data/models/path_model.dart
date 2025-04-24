class PathPoint {
  final double latitude;
  final double longitude;
  final double altitude;
  final int sequenceNumber;

  PathPoint({
    required this.latitude,
    required this.longitude,
    required this.altitude,
    required this.sequenceNumber,
  });

  factory PathPoint.fromJson(Map<String, dynamic> json) {
    return PathPoint(
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      altitude: json['altitude'].toDouble(),
      sequenceNumber: json['sequenceNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'altitude': altitude,
      'sequenceNumber': sequenceNumber,
    };
  }
}

class PathModel {
  final String id;
  final String droneId;
  final String name;
  final List<PathPoint> points;
  final DateTime createdAt;

  PathModel({
    required this.id,
    required this.droneId,
    required this.name,
    required this.points,
    required this.createdAt,
  });

  factory PathModel.fromJson(Map<String, dynamic> json) {
    return PathModel(
      id: json['id'],
      droneId: json['droneId'],
      name: json['name'],
      points: (json['points'] as List)
          .map((point) => PathPoint.fromJson(point))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'droneId': droneId,
      'name': name,
      'points': points.map((point) => point.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}