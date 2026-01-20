import '../../../../core/usecases/usecase.dart';
import '../entities/village.dart';
import '../repositories/location_repository.dart';

class GetVillage implements UseCase<List<Village>, String> {
  final LocationRepository repository;
  const GetVillage(this.repository);

  @override
  Future<List<Village>> call(String code) {
    return repository.getVillage(code);
  }
}
