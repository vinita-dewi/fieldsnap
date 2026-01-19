import '../../domain/entities/location_point.dart';

abstract class LocationLocalDataSource {
  Future<LocationPoint> getCurrent();
}

class LocationLocalDataSourceImpl implements LocationLocalDataSource {
  @override
  Future<LocationPoint> getCurrent() async {
    throw UnimplementedError('LocationLocalDataSourceImpl.getCurrent not implemented');
  }
}
