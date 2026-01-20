import '../../../../core/usecases/usecase.dart';
import '../entities/regency.dart';
import '../repositories/location_repository.dart';

class GetRegency implements UseCase<List<Regency>, String> {
  final LocationRepository repository;
  const GetRegency(this.repository);

  @override
  Future<List<Regency>> call(String code) {
    return repository.getCity(code);
  }
}
