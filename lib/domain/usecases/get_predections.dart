

import 'package:dartz/dartz.dart';
import 'package:drones_dashboard/domain/repositories/prediction_repository.dart';
import 'package:drones_dashboard/shared/utils/failure.dart';

import '../entities/predection.dart';

class GetPredictions {
  final PredictionRepository repository;

  GetPredictions(this.repository);

  Future<Either<Failure, Prediction>> call(String droneId, String predictionType) async {
    return await repository.getPrediction(droneId, predictionType as Map<String, dynamic>);
  }
}