import '../../../../core/usecases/usecase.dart';
import '../entities/district.dart';
import '../repositories/location_repository.dart';

class GetDistrict implements UseCase<List<District>, String> {
  final LocationRepository repository;
  const GetDistrict(this.repository);

  @override
  Future<List<District>> call(String code) {
    return repository.getDistrict(code);
  }
}
