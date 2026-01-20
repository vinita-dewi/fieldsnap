import 'package:fieldsnap/core/services/api_service.dart';
import 'package:fieldsnap/features/location/data/datasources/location_local_datasource.dart';
import 'package:fieldsnap/features/location/data/datasources/location_remote_datasource.dart';
import 'package:fieldsnap/features/location/data/repositories/location_repository_impl.dart';
import 'package:fieldsnap/features/location/domain/usecases/get_city.dart';
import 'package:fieldsnap/features/location/domain/usecases/get_district.dart';
import 'package:fieldsnap/features/location/domain/usecases/get_postal.dart';
import 'package:fieldsnap/features/location/domain/usecases/get_province.dart';
import 'package:fieldsnap/features/location/domain/usecases/get_village.dart';
import 'package:fieldsnap/features/location/presentation/controllers/location_controller.dart';
import 'package:get/get.dart';

class LocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() {
      final apiService = ApiService();
      final remoteDataSource = LocationRemoteDataSourceImpl(apiService);
      final localDataSource = LocationLocalDataSourceImpl();
      final repository = LocationRepositoryImpl(
        localDataSource: localDataSource,
        remoteDataSource: remoteDataSource,
      );

      return LocationController(
        getProvince: GetProvince(repository),
        getRegency: GetRegency(repository),
        getDistrict: GetDistrict(repository),
        getVillage: GetVillage(repository),
        getPostal: GetPostal(repository),
      );
    });
  }
}
