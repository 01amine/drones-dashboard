import 'package:dartz/dartz.dart';

import '../../domain/entities/predection.dart';
import '../../domain/repositories/prediction_repository.dart';
import '../../shared/utils/failure.dart';

class PredictionRepositoryImpl implements PredictionRepository {
  @override
  Future<Either<Failure, Prediction>> getPrediction(String modelType, Map<String, dynamic> inputData) => Future.value();
  
  @override
  Future<Either<Failure, List<String>>> getAvailableModels() => Future.value();
  
  @override
  Future<Either<Failure, Map<String, dynamic>>> getModelMetrics(String modelType) => Future.value();
  
  @override
  Future<Either<Failure, Map<String, dynamic>>> trainModel(String modelType, List<Map<String, dynamic>> trainingData) => Future.value();
  
  @override
  Future<Either<Failure, List<Prediction>>> getPredictionHistory(String droneId) => Future.value();
}