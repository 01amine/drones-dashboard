/// Exception thrown when there is server failure
class ServerException implements Exception {
  final String message;
  final int statusCode;

  ServerException({
    required this.message,
    required this.statusCode,
  });

  @override
  String toString() {
    return 'ServerException: $message (Status Code: $statusCode)';
  }
}

/// Exception thrown when there is cache failure
class CacheException implements Exception {
  final String message;

  CacheException({
    required this.message,
  });

  @override
  String toString() {
    return 'CacheException: $message';
  }
}

/// Exception thrown when there is location service failure
class LocationException implements Exception {
  final String message;

  LocationException({
    required this.message,
  });

  @override
  String toString() {
    return 'LocationException: $message';
  }
}

/// Exception thrown when there is map service failure
class MapException implements Exception {
  final String message;

  MapException({
    required this.message,
  });

  @override
  String toString() {
    return 'MapException: $message';
  }
}