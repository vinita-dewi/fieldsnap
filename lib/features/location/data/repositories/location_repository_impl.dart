import 'package:fieldsnap/core/logging/app_logger.dart';

import '../../domain/entities/location_point.dart';
import '../../domain/entities/province.dart';
import '../../domain/entities/regency.dart';
import '../../domain/entities/district.dart';
import '../../domain/entities/village.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/location_local_datasource.dart';
import '../datasources/location_remote_datasource.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationLocalDataSource localDataSource;
  final LocationRemoteDataSource remoteDataSource;
  final _log = AppLogger.instance;
  LocationRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<LocationPoint> getCurrentLocation() {
    throw UnimplementedError(
      'LocationRepositoryImpl.getCurrentLocation not implemented',
    );
  }

  @override
  Future<List<Province>> getProvince() async {
    try {
      final models = await remoteDataSource.getProvince();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      _log.e('[LocationRepositoryImpl.getProvince] $e');
      rethrow;
    }
  }

  @override
  Future<List<Regency>> getCity(String code) async {
    try {
      final models = await remoteDataSource.getCity(code);
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      _log.e('[LocationRepositoryImpl.getCity] $e');
      rethrow;
    }
  }

  @override
  Future<List<District>> getDistrict(String code) async {
    try {
      final models = await remoteDataSource.getDistrict(code);
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      _log.e('[LocationRepositoryImpl.getDistrict] $e');
      rethrow;
    }
  }

  @override
  Future<List<Village>> getVillage(String code) async {
    try {
      final models = await remoteDataSource.getVillage(code);
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      _log.e('[LocationRepositoryImpl.getVillage] $e');
      rethrow;
    }
  }

  @override
  Future<List<String>> getPostal(String code) {
    return remoteDataSource.getPostal(code).catchError((e) {
      _log.e('[LocationRepositoryImpl.getPostal] $e');
      throw e;
    });
  }
}
