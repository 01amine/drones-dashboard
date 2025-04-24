import 'dart:math' as math;

import 'location.dart';


class PathUtils {
  // Generate circular path
  static List<Map<String, double>> generateCircularPath(
    double centerLat, 
    double centerLon, 
    double radiusMeters, 
    int numPoints
  ) {
    List<Map<String, double>> path = [];
    
    for (int i = 0; i < numPoints; i++) {
      double bearing = (i * 360 / numPoints) % 360;
      Map<String, double> point = LocationUtils.calculateNewPosition(
        centerLat, 
        centerLon, 
        bearing, 
        radiusMeters
      );
      path.add(point);
    }
    
    // Close the path
    path.add(path.first);
    
    return path;
  }
  
  // Generate grid pattern path
  static List<Map<String, double>> generateGridPath(
    double startLat, 
    double startLon, 
    double widthMeters, 
    double heightMeters, 
    int rows, 
    int cols
  ) {
    List<Map<String, double>> path = [];
    
    double rowSpacing = heightMeters / (rows - 1);
    double colSpacing = widthMeters / (cols - 1);
    
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        // Every other row, reverse the direction
        int effectiveCol = row % 2 == 0 ? col : cols - 1 - col;
        
        double northOffset = row * rowSpacing;
        double eastOffset = effectiveCol * colSpacing;
        
        // Calculate position north (90 degrees)
        Map<String, double> northPosition = LocationUtils.calculateNewPosition(
          startLat, 
          startLon, 
          0, // North
          northOffset
        );
        
        // Then calculate position east from there (90 degrees)
        Map<String, double> position = LocationUtils.calculateNewPosition(
          northPosition['latitude']!, 
          northPosition['longitude']!, 
          90, // East
          eastOffset
        );
        
        path.add(position);
      }
    }
    
    return path;
  }
  
  // Generate spiral path
  static List<Map<String, double>> generateSpiralPath(
    double centerLat, 
    double centerLon, 
    double radiusMeters, 
    int numTurns, 
    int pointsPerTurn
  ) {
    List<Map<String, double>> path = [];
    int totalPoints = numTurns * pointsPerTurn;
    
    for (int i = 0; i < totalPoints; i++) {
      double angle = (i * 2 * math.pi * numTurns) / totalPoints;
      double radiusFactor = i / totalPoints;
      double currentRadius = radiusMeters * radiusFactor;
      double bearing = (angle * 180 / math.pi) % 360;
      
      Map<String, double> point = LocationUtils.calculateNewPosition(
        centerLat, 
        centerLon, 
        bearing, 
        currentRadius
      );
      path.add(point);
    }
    
    return path;
  }
  
  // Generate random waypoints within a rectangle
  static List<Map<String, double>> generateRandomWaypoints(
    double minLat, 
    double minLon, 
    double maxLat, 
    double maxLon, 
    int numPoints
  ) {
    List<Map<String, double>> waypoints = [];
    final random = math.Random();
    
    for (int i = 0; i < numPoints; i++) {
      double lat = minLat + random.nextDouble() * (maxLat - minLat);
      double lon = minLon + random.nextDouble() * (maxLon - minLon);
      
      waypoints.add({
        'latitude': lat,
        'longitude': lon,
      });
    }
    
    return waypoints;
  }
}