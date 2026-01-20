import '../../../../core/usecases/usecase.dart';
import '../entities/province.dart';
import '../repositories/location_repository.dart';

class GetProvince implements UseCaseNoParams<List<Province>> {
  final LocationRepository repository;
  const GetProvince(this.repository);

  @override
  Future<List<Province>> call() {
    return repository.getProvince();
  }
}
