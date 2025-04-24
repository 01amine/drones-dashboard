import '../../data/models/path_model.dart';
import '../repositories/path_repository.dart';

class GeneratePath {
  final PathRepository repository;

  GeneratePath(this.repository);

  Future<List<PathPoint>> call(
    String droneId, 
    double startLat, 
    double startLng, 
    double endLat, 
    double endLng, 
    List<Map<String, dynamic>> constraints
  ) async {
    return await repository.generatePath(
      droneId, 
      startLat, 
      startLng, 
      endLat, 
      endLng, 
      constraints
    );
  }
}