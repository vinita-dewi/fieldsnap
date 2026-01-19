import '../../../../core/usecases/usecase.dart';
import '../entities/location_point.dart';
import '../repositories/location_repository.dart';

class GetCurrentLocation implements UseCase<LocationPoint, NoParams> {
  final LocationRepository repository;
  const GetCurrentLocation(this.repository);

  @override
  Future<LocationPoint> call(NoParams params) {
    return repository.getCurrentLocation();
  }
}