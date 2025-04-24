

import 'package:dartz/dartz.dart';

import '../../shared/utils/failure.dart';
import '../entities/predection.dart';

/// Repository interface for handling ML model predictions
abstract class PredictionRepository {
  /// Get predictions from a specific ML model type
  /// 
  /// [modelType] can be 'knn', 'lr', 'svm', or 'lstm'
  /// [inputData] contains the features to predict on
  Future<Either<Failure, Prediction>> getPrediction(String modelType, Map<String, dynamic> inputData);
  
  /// Get a list of all available prediction models
  Future<Either<Failure, List<String>>> getAvailableModels();
  
  /// Get the accuracy metrics for a specific model
  Future<Either<Failure, Map<String, dynamic>>> getModelMetrics(String modelType);
  
  /// Train or retrain a model with new data
  /// Returns success status and optional metrics
  Future<Either<Failure, Map<String, dynamic>>> trainModel(String modelType, List<Map<String, dynamic>> trainingData);
  
  /// Get prediction history for a specific drone
  Future<Either<Failure, List<Prediction>>> getPredictionHistory(String droneId);
}