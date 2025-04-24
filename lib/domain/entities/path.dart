class PathPoint {
  final String id;
  final double latitude;
  final double longitude;
  final double altitude;
  final Duration? estimatedTimeToReach;
  final String actionType; // 'waypoint', 'hover', 'land', 'takeoff', etc.
  final Map<String, dynamic>? actionParameters;

  PathPoint({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.altitude,
    this.estimatedTimeToReach,
    required this.actionType,
    this.actionParameters,
  });

  PathPoint copyWith({
    String? id,
    double? latitude,
    double? longitude,
    double? altitude,
    Duration? estimatedTimeToReach,
    String? actionType,
    Map<String, dynamic>? actionParameters,
  }) {
    return PathPoint(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      altitude: altitude ?? this.altitude,
      estimatedTimeToReach: estimatedTimeToReach ?? this.estimatedTimeToReach,
      actionType: actionType ?? this.actionType,
      actionParameters: actionParameters ?? this.actionParameters,
    );
  }
}