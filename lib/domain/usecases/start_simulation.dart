import '../repositories/simulation_repository.dart';

class StartSimulation {
  final SimulationRepository repository;

  StartSimulation(this.repository);

  Future<void> call(String modelType, Map<String, dynamic> parameters) async {
    return await repository.startSimulation(modelType, parameters);
  }
}
