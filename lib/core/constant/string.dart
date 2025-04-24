class AppConstants {
  // API Base URL
  static const String apiBaseUrl = 'https://api.dronesimulation.com/v1';
  
  // API Endpoints
  static const String droneEndpoint = '/drones';
  static const String telemetryEndpoint = '/telemetry';
  static const String simulationEndpoint = '/simulation';
  static const String predictionEndpoint = '/predictions';
  static const String pathEndpoint = '/paths';
  static const String pathGenerationEndpoint = '/paths/generate';
  
  // ML Model Types
  static const String modelKNN = 'knn';
  static const String modelLR = 'lr';
  static const String modelSVM = 'svm';
  static const String modelLSTM = 'lstm';
  
  // ML Model Names for UI Display
  static const Map<String, String> modelNames = {
    modelKNN: 'K-Nearest Neighbors (KNN)',
    modelLR: 'Linear Regression (LR)',
    modelSVM: 'Support Vector Machine (SVM)',
    modelLSTM: 'Long Short-Term Memory (LSTM)',
  };
  
  // App Name
  static const String appName = 'XCTL';
  
  // Map Constants
  static const double defaultZoom = 14.0;
  static const double defaultLatitude = 30.5; // Default center
  static const double defaultLongitude = -97.7; // Default center
  
  // Signal Radius Display (in meters)
  static const double defaultSignalRadius = 300.0;
}