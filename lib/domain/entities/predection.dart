import 'package:equatable/equatable.dart';

class Prediction extends Equatable {
  final String id;
  final String modelType; // knn, lr, svm, lstm
  final Map<String, dynamic> inputData;
  final Map<String, dynamic> output;
  final double confidence;
  final DateTime timestamp;
  final String? droneId;
  
  const Prediction({
    required this.id,
    required this.modelType,
    required this.inputData,
    required this.output,
    required this.confidence,
    required this.timestamp,
    this.droneId,
  });
  
  @override
  List<Object?> get props => [id, modelType, inputData, output, confidence, timestamp, droneId];
  
  // Factory to create a prediction from raw data
  factory Prediction.fromMap(Map<String, dynamic> map) {
    return Prediction(
      id: map['id'],
      modelType: map['modelType'],
      inputData: Map<String, dynamic>.from(map['inputData']),
      output: Map<String, dynamic>.from(map['output']),
      confidence: map['confidence'].toDouble(),
      timestamp: DateTime.parse(map['timestamp']),
      droneId: map['droneId'],
    );
  }

  get details => null;

  get type => null;
  
  // Convert to map for serialization
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'modelType': modelType,
      'inputData': inputData,
      'output': output,
      'confidence': confidence,
      'timestamp': timestamp.toIso8601String(),
      'droneId': droneId,
    };
  }
}