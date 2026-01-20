import '../entities/location_point.dart';
import '../entities/province.dart';
import '../entities/regency.dart';
import '../entities/district.dart';
import '../entities/village.dart';

abstract class LocationRepository {
  Future<LocationPoint> getCurrentLocation();
  Future<List<Province>> getProvince();
  Future<List<Regency>> getCity(String code);
  Future<List<District>> getDistrict(String code);
  Future<List<Village>> getVillage(String code);
  Future<List<String>> getPostal(String code);
}
