import '../entities/drone.dart';
import '../entities/telemetry.dart';

abstract class TelemetryRepository {
  Stream<List<Drone>> getDrones();
  Stream<Telemetry> getDroneTelemetry(String droneId);
  Future<List<Telemetry>> getDroneHistory(String droneId, DateTime startTime, DateTime endTime);
  Future<void> sendCommand(String droneId, String command, Map<String, dynamic> parameters);
}
