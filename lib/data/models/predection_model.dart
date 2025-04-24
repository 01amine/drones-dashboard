class PredictionModel {
  final String id;
  final String droneId;
  final String modelType; // knn, lr, svm, lstm
  final double predictedValue;
  final double confidence;
  final Map<String, dynamic> additionalData;
  final DateTime timestamp;

  PredictionModel({
    required this.id,
    required this.droneId,
    required this.modelType,
    required this.predictedValue,
    required this.confidence,
    required this.additionalData,
    required this.timestamp,
  });

  factory PredictionModel.fromJson(Map<String, dynamic> json) {
    return PredictionModel(
      id: json['id'],
      droneId: json['droneId'],
      modelType: json['modelType'],
      predictedValue: json['predictedValue'].toDouble(),
      confidence: json['confidence'].toDouble(),
      additionalData: json['additionalData'] ?? {},
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'droneId': droneId,
      'modelType': modelType,
      'predictedValue': predictedValue,
      'confidence': confidence,
      'additionalData': additionalData,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}