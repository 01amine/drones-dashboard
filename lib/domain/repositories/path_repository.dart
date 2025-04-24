

import '../../data/models/path_model.dart';

abstract class PathRepository {
  Future<List<PathPoint>> getPath(String droneId);
  Future<void> setPath(String droneId, List<PathPoint> pathPoints);
  Future<List<PathPoint>> generatePath(
    String droneId, 
    double startLat, 
    double startLng, 
    double endLat, 
    double endLng, 
    List<Map<String, dynamic>> constraints
  );
  Future<void> clearPath(String droneId);
  Stream<List<PathPoint>> watchPath(String droneId);
}