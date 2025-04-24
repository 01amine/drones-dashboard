abstract class SimulationRepository {
  Future<void> startSimulation(String modelType, Map<String, dynamic> parameters);
  Future<void> pauseSimulation();
  Future<void> resumeSimulation();
  Future<void> stopSimulation();
  Stream<bool> get simulationStatus;
}