import 'package:fieldsnap/core/logging/app_logger.dart';
import 'package:fieldsnap/core/services/api_service.dart';
import 'package:fieldsnap/core/utils/api_constants.dart';
import '../../domain/models/district_model.dart';
import '../../domain/models/province_model.dart';
import '../../domain/models/regency_model.dart';
import '../../domain/models/village_model.dart';

abstract class LocationRemoteDataSource {
  Future<List<ProvinceModel>> getProvince();
  Future<List<RegencyModel>> getCity(String code);
  Future<List<DistrictModel>> getDistrict(String code);
  Future<List<VillageModel>> getVillage(String code);
  Future<List<String>> getPostal(String code);
}

class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  final ApiService apiService;
  final _log = AppLogger.instance;
  LocationRemoteDataSourceImpl(this.apiService);

  @override
  Future<List<ProvinceModel>> getProvince() async {
    try {
      final response = await apiService.request(
        path: ApiConstants.getProvince,
        useApiKey: true,
      );
      final data = (response.data as Map<String, dynamic>?)?['data'];
      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map(ProvinceModel.fromJson)
            .toList();
      }
      return const [];
    } catch (e) {
      _log.e('[LocationRemoteDataSource.getProvince] $e');
      rethrow;
    }
  }

  @override
  Future<List<RegencyModel>> getCity(String code) async {
    try {
      final path = ApiConstants.getCity;
      final response = await apiService.request(
        path: path,
        useApiKey: true,
        queryParameters: {"province_code": code},
      );
      final data = (response.data as Map<String, dynamic>?)?['data'];
      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map(RegencyModel.fromJson)
            .toList();
      }
      return const [];
    } catch (e) {
      _log.e('[LocationRemoteDataSource.getCity] $e');
      rethrow;
    }
  }

  @override
  Future<List<DistrictModel>> getDistrict(String code) async {
    try {
      final path = ApiConstants.getDistrict.replaceAll(':code:', code);
      final response = await apiService.request(
        path: path,
        useApiKey: true,
        queryParameters: {"regency_code": code},
      );
      final data = (response.data as Map<String, dynamic>?)?['data'];
      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map(DistrictModel.fromJson)
            .toList();
      }
      return const [];
    } catch (e) {
      _log.e('[LocationRemoteDataSource.getDistrict] $e');
      rethrow;
    }
  }

  @override
  Future<List<VillageModel>> getVillage(String code) async {
    try {
      final path = ApiConstants.getVillage.replaceAll(':code:', code);
      final response = await apiService.request(
        path: path,
        useApiKey: true,
        queryParameters: {"district_code": code},
      );
      final data = (response.data as Map<String, dynamic>?)?['data'];
      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map(VillageModel.fromJson)
            .toList();
      }
      return const [];
    } catch (e) {
      _log.e('[LocationRemoteDataSource.getVillage] $e');
      rethrow;
    }
  }

  @override
  Future<List<String>> getPostal(String villageName) async {
    try {
      final path = ApiConstants.getPostal;
      final response = await apiService.request(
        path: path,
        useApiKey: true,
        queryParameters: {'search': villageName},
      );
      final data = (response.data as Map<String, dynamic>?)?['data'];
      final postalCodes = (data as Map<String, dynamic>?)?['postalCodes'];
      if (postalCodes is List) {
        return postalCodes
            .whereType<Map<String, dynamic>>()
            .map((item) => item['code'].toString())
            .toList();
      }
      return const [];
    } catch (e) {
      _log.e('[LocationRemoteDataSource.getPostal] $e');
      rethrow;
    }
  }
}
