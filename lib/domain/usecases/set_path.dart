import '../../data/models/path_model.dart';
import '../repositories/path_repository.dart';

class SetPath {
  final PathRepository repository;

  SetPath(this.repository);

  Future<void> call(String droneId, List<PathPoint> pathPoints) async {
    return await repository.setPath(droneId, pathPoints);
  }
}
