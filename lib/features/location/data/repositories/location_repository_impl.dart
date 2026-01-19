import '../../domain/entities/location_point.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/location_local_datasource.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationLocalDataSource localDataSource;
  const LocationRepositoryImpl(this.localDataSource);

  @override
  Future<LocationPoint> getCurrentLocation() {
    throw UnimplementedError('LocationRepositoryImpl.getCurrentLocation not implemented');
  }
}
