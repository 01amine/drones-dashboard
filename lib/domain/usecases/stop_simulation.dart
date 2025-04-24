import '../repositories/simulation_repository.dart';

class StopSimulation {
  final SimulationRepository repository;

  StopSimulation(this.repository);

  Future<void> call() async {
    return await repository.stopSimulation();
  }
}