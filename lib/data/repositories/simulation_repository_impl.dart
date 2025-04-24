import '../../domain/repositories/simulation_repository.dart';

class SimulationRepositoryImpl implements SimulationRepository {
  @override
  Stream<bool> get simulationStatus => const Stream.empty();
  
  @override
  Future<void> pauseSimulation() => Future.value();
  
  @override
  Future<void> resumeSimulation() => Future.value();
  
  @override
  Future<void> startSimulation(String modelType, Map<String, dynamic> parameters) {
    // TODO: implement startSimulation
    throw UnimplementedError();
  }
  
  @override
  Future<void> stopSimulation() {
    // TODO: implement stopSimulation
    throw UnimplementedError();
  }
}