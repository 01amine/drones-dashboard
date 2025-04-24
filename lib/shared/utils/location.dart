import 'dart:math' as math;

class LocationUtils {
  // Converts degrees to radians
  static double degreesToRadians(double degrees) {
    return degrees * (math.pi / 180);
  }
  
  // Converts radians to degrees
  static double radiansToDegrees(double radians) {
    return radians * (180 / math.pi);
  }
  
  // Calculate distance between two points using Haversine formula
  static double calculateDistance(
    double lat1, 
    double lon1, 
    double lat2, 
    double lon2
  ) {
    const double earthRadius = 6371000; // meters
    
    double dLat = degreesToRadians(lat2 - lat1);
    double dLon = degreesToRadians(lon2 - lon1);
    
    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(degreesToRadians(lat1)) * math.cos(degreesToRadians(lat2)) *
        math.sin(dLon / 2) * math.sin(dLon / 2);
        
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }
  
  // Calculate new coordinate given start point, bearing and distance
  static Map<String, double> calculateNewPosition(
    double startLat, 
    double startLon, 
    double bearingDegrees, 
    double distanceMeters
  ) {
    const double earthRadius = 6371000; // meters
    
    double bearing = degreesToRadians(bearingDegrees);
    double lat1 = degreesToRadians(startLat);
    double lon1 = degreesToRadians(startLon);
    
    double angularDistance = distanceMeters / earthRadius;
    
    double lat2 = math.asin(
      math.sin(lat1) * math.cos(angularDistance) +
      math.cos(lat1) * math.sin(angularDistance) * math.cos(bearing)
    );
    
    double lon2 = lon1 + math.atan2(
      math.sin(bearing) * math.sin(angularDistance) * math.cos(lat1),
      math.cos(angularDistance) - math.sin(lat1) * math.sin(lat2)
    );
    
    return {
      'latitude': radiansToDegrees(lat2),
      'longitude': radiansToDegrees(lon2),
    };
  }
  
  // Calculate bearing between two points
  static double calculateBearing(
    double lat1, 
    double lon1, 
    double lat2, 
    double lon2
  ) {
    lat1 = degreesToRadians(lat1);
    lon1 = degreesToRadians(lon1);
    lat2 = degreesToRadians(lat2);
    lon2 = degreesToRadians(lon2);
    
    double y = math.sin(lon2 - lon1) * math.cos(lat2);
    double x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(lon2 - lon1);
    
    double bearing = math.atan2(y, x);
    return (radiansToDegrees(bearing) + 360) % 360;
  }
}