import '../../domain/entities/drone.dart';
import '../../domain/entities/telemetry.dart';
import '../../domain/repositories/telemtry_repository.dart';

class TelemetryRepositoryImpl implements TelemetryRepository {
  @override
  Stream<List<Drone>> getDrones() => const Stream.empty();
  
  @override
  Stream<Telemetry> getDroneTelemetry(String droneId) => const Stream.empty();
  
  @override
  Future<void> sendCommand(String droneId, String command, Map<String, dynamic> parameters) => Future.value();
  
  @override
  Future<List<Telemetry>> getDroneHistory(String droneId, DateTime startTime, DateTime endTime) {
    // TODO: implement getDroneHistory
    throw UnimplementedError();
  }
}