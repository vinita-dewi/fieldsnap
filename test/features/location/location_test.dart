import 'package:fieldsnap/core/enums/fetch_state.dart';
import 'package:fieldsnap/core/utils/gap.dart';
import 'package:fieldsnap/features/location/data/datasources/location_remote_datasource.dart';
import 'package:fieldsnap/features/location/data/datasources/location_local_datasource.dart';
import 'package:fieldsnap/features/location/data/repositories/location_repository_impl.dart';
import 'package:fieldsnap/features/location/domain/entities/district.dart';
import 'package:fieldsnap/features/location/domain/entities/location_point.dart';
import 'package:fieldsnap/features/location/domain/entities/province.dart';
import 'package:fieldsnap/features/location/domain/entities/regency.dart';
import 'package:fieldsnap/features/location/domain/entities/village.dart';
import 'package:fieldsnap/features/location/domain/models/postal_model.dart';
import 'package:fieldsnap/features/location/domain/models/district_model.dart';
import 'package:fieldsnap/features/location/domain/models/province_model.dart';
import 'package:fieldsnap/features/location/domain/models/regency_model.dart';
import 'package:fieldsnap/features/location/domain/models/village_model.dart';
import 'package:fieldsnap/features/location/domain/repositories/location_repository.dart';
import 'package:fieldsnap/features/location/domain/usecases/get_city.dart';
import 'package:fieldsnap/features/location/domain/usecases/get_district.dart';
import 'package:fieldsnap/features/location/domain/usecases/get_postal.dart';
import 'package:fieldsnap/features/location/domain/usecases/get_province.dart';
import 'package:fieldsnap/features/location/domain/usecases/get_village.dart';
import 'package:fieldsnap/features/location/presentation/controllers/location_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geocoding_platform_interface/geocoding_platform_interface.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:flutter/services.dart';

import '../../helpers/fakes.dart';

class _FakeLocationRepository implements LocationRepository {
  _FakeLocationRepository({
    required this.provinces,
    required this.regencies,
    required this.districts,
    required this.villages,
  });

  final List<Province> provinces;
  final Map<String, List<Regency>> regencies;
  final Map<String, List<District>> districts;
  final Map<String, List<Village>> villages;

  @override
  Future<List<Province>> getProvince() async => provinces;

  @override
  Future<List<Regency>> getCity(String code) async => regencies[code] ?? [];

  @override
  Future<List<District>> getDistrict(String code) async =>
      districts[code] ?? [];

  @override
  Future<List<Village>> getVillage(String code) async => villages[code] ?? [];

  @override
  Future<List<String>> getPostal(String code) async => <String>['12345'];

  @override
  Future<LocationPoint> getCurrentLocation() {
    throw UnimplementedError();
  }
}

class _ThrowingLocationRemoteDataSource implements LocationRemoteDataSource {
  @override
  Future<List<ProvinceModel>> getProvince() async {
    throw Exception('fail');
  }

  @override
  Future<List<RegencyModel>> getCity(String code) async {
    throw Exception('fail');
  }

  @override
  Future<List<DistrictModel>> getDistrict(String code) async {
    throw Exception('fail');
  }

  @override
  Future<List<VillageModel>> getVillage(String code) async {
    throw Exception('fail');
  }

  @override
  Future<List<String>> getPostal(String code) async {
    throw Exception('fail');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Location models', () {
    test('ProvinceModel maps to entity', () {
      final model = ProvinceModel.fromJson({'code': '31', 'name': 'DKI'});
      expect(model.toEntity().name, 'DKI');
    });

    test('RegencyModel maps to entity', () {
      final model = RegencyModel.fromJson({'code': '01', 'name': 'City'});
      expect(model.toEntity().name, 'City');
    });

    test('DistrictModel maps to entity', () {
      final model = DistrictModel.fromJson({'code': '01', 'name': 'District'});
      expect(model.toEntity().name, 'District');
    });

    test('VillageModel maps to entity', () {
      final model = VillageModel.fromJson({'code': '01', 'name': 'Village'});
      expect(model.toEntity().name, 'Village');
    });

    test('PostalModel maps to entity', () {
      final model = PostalModel();
      expect(model.toEntity(), isNotNull);
    });
  });

  group('LocationRemoteDataSource', () {
    test('parses province list', () async {
      final api = FakeApiService({
        'data': [
          {'code': '31', 'name': 'DKI'},
        ],
      });
      final ds = LocationRemoteDataSourceImpl(api);
      final provinces = await ds.getProvince();
      expect(provinces.first.name, 'DKI');
    });

    test('parses postal codes', () async {
      final api = FakeApiService({
        'data': {
          'postalCodes': [
            {
              'code': '12345',
              'village': {'name': 'Cilandak'},
            },
          ],
        },
      });
      final ds = LocationRemoteDataSourceImpl(api);
      final postal = await ds.getPostal('Cilandak');
      expect(postal, ['12345']);
    });

    test('parses regency list', () async {
      final api = FakeApiService({
        'data': [
          {'code': '01', 'name': 'City'},
        ],
      });
      final ds = LocationRemoteDataSourceImpl(api);
      final cities = await ds.getCity('31');
      expect(cities.first.name, 'City');
    });

    test('parses district list', () async {
      final api = FakeApiService({
        'data': [
          {'code': '01', 'name': 'District'},
        ],
      });
      final ds = LocationRemoteDataSourceImpl(api);
      final districts = await ds.getDistrict('01');
      expect(districts.first.name, 'District');
    });

    test('parses village list', () async {
      final api = FakeApiService({
        'data': [
          {'code': '01', 'name': 'Village'},
        ],
      });
      final ds = LocationRemoteDataSourceImpl(api);
      final villages = await ds.getVillage('01');
      expect(villages.first.name, 'Village');
    });
  });

  group('LocationRepositoryImpl', () {
    test('maps provinces from remote', () async {
      final remote = LocationRemoteDataSourceImpl(
        FakeApiService({
          'data': [
            {'code': '31', 'name': 'DKI'},
          ],
        }),
      );
      final repo = LocationRepositoryImpl(
        localDataSource: _FakeLocationLocalDataSource(),
        remoteDataSource: remote,
      );
      final result = await repo.getProvince();
      expect(result.first.name, 'DKI');
    });

    test('maps cities from remote', () async {
      final remote = LocationRemoteDataSourceImpl(
        FakeApiService({
          'data': [
            {'code': '01', 'name': 'City'},
          ],
        }),
      );
      final repo = LocationRepositoryImpl(
        localDataSource: _FakeLocationLocalDataSource(),
        remoteDataSource: remote,
      );
      final result = await repo.getCity('31');
      expect(result.first.name, 'City');
    });

    test('getCurrentLocation throws', () {
      final repo = LocationRepositoryImpl(
        localDataSource: _FakeLocationLocalDataSource(),
        remoteDataSource: LocationRemoteDataSourceImpl(FakeApiService({})),
      );
      expect(() => repo.getCurrentLocation(), throwsUnimplementedError);
    });

    test('rethrows errors from remote', () async {
      final repo = LocationRepositoryImpl(
        localDataSource: _FakeLocationLocalDataSource(),
        remoteDataSource: _ThrowingLocationRemoteDataSource(),
      );
      await expectLater(
        repo.getProvince(),
        throwsA(isA<Exception>()),
      );
      await expectLater(
        repo.getCity('31'),
        throwsA(isA<Exception>()),
      );
      await expectLater(
        repo.getDistrict('01'),
        throwsA(isA<Exception>()),
      );
      await expectLater(
        repo.getVillage('01'),
        throwsA(isA<Exception>()),
      );
      await expectLater(
        repo.getPostal('x'),
        throwsA(isA<Exception>()),
      );
    });
  });

  test('LocationLocalDataSourceImpl throws', () async {
    final local = LocationLocalDataSourceImpl();
    await expectLater(local.getCurrent(), throwsUnimplementedError);
  });

  group('Location usecases', () {
    test('GetProvince calls repository', () async {
      final repo = _FakeLocationRepository(
        provinces: const [Province(code: '31', name: 'DKI')],
        regencies: const {},
        districts: const {},
        villages: const {},
      );
      final usecase = GetProvince(repo);
      final result = await usecase();
      expect(result.first.name, 'DKI');
    });

    test('GetPostal calls repository', () async {
      final repo = _FakeLocationRepository(
        provinces: const [],
        regencies: const {},
        districts: const {},
        villages: const {},
      );
      final usecase = GetPostal(repo);
      final result = await usecase('Cilandak');
      expect(result.first, '12345');
    });

    test('GetRegency calls repository', () async {
      final repo = _FakeLocationRepository(
        provinces: const [],
        regencies: const {
          '31': [Regency(code: '01', name: 'City')],
        },
        districts: const {},
        villages: const {},
      );
      final usecase = GetRegency(repo);
      final result = await usecase('31');
      expect(result.first.name, 'City');
    });

    test('GetDistrict calls repository', () async {
      final repo = _FakeLocationRepository(
        provinces: const [],
        regencies: const {},
        districts: const {
          '01': [District(code: '02', name: 'District')],
        },
        villages: const {},
      );
      final usecase = GetDistrict(repo);
      final result = await usecase('01');
      expect(result.first.name, 'District');
    });

    test('GetVillage calls repository', () async {
      final repo = _FakeLocationRepository(
        provinces: const [],
        regencies: const {},
        districts: const {},
        villages: const {
          '02': [Village(code: '03', name: 'Village')],
        },
      );
      final usecase = GetVillage(repo);
      final result = await usecase('02');
      expect(result.first.name, 'Village');
    });
  });

  group('LocationController', () {
    test('autoFillForm selects matching locations', () async {
      GeolocatorPlatform.instance = FakeGeolocatorPlatform();
      GeocodingPlatform.instance = FakeGeocodingPlatform(
        placemarks: [
          Placemark(
            administrativeArea: 'Daerah Khusus Ibukota',
            subAdministrativeArea: 'Kota Jakarta Selatan',
            locality: 'Kecamatan Cilandak',
            subLocality: 'Cilandak Barat',
            postalCode: '12345',
          ),
        ],
      );

      final repo = _FakeLocationRepository(
        provinces: const [Province(code: '31', name: 'DKI Jakarta')],
        regencies: const {
          '31': [Regency(code: '3171', name: 'Kota Jakarta Selatan')],
        },
        districts: const {
          '3171': [District(code: '3171010', name: 'Cilandak')],
        },
        villages: const {
          '3171010': [Village(code: '3171010001', name: 'Cilandak Barat')],
        },
      );

      final controller = LocationController(
        getProvince: GetProvince(repo),
        getRegency: GetRegency(repo),
        getDistrict: GetDistrict(repo),
        getVillage: GetVillage(repo),
        getPostal: GetPostal(repo),
      );

      await controller.fetchProvinces();
      await controller.autoFillForm();

      expect(controller.selProvince?.name, 'DKI Jakarta');
      expect(controller.selRegency?.name, 'Kota Jakarta Selatan');
      expect(controller.selDistrict?.name, 'Cilandak');
      expect(controller.selVillage?.name, 'Cilandak Barat');
      expect(controller.postalController.text, '12345');
      expect(controller.fetchState, FetchState.idle);
    });

    test('autoFillForm prefers type and direction matches', () async {
      GeolocatorPlatform.instance = FakeGeolocatorPlatform();
      GeocodingPlatform.instance = FakeGeocodingPlatform(
        placemarks: [
          Placemark(
            administrativeArea: 'Banten',
            subAdministrativeArea: 'Kabupaten Tangerang Selatan',
            locality: 'Kecamatan Ciputat',
            subLocality: 'Ciputat Timur',
            postalCode: '55555',
          ),
        ],
      );

      final repo = _FakeLocationRepository(
        provinces: const [Province(code: '36', name: 'Banten')],
        regencies: const {
          '36': [
            Regency(code: '3601', name: 'Kabupaten Tangerang'),
            Regency(code: '3671', name: 'Kota Tangerang'),
            Regency(code: '3674', name: 'Tangerang Selatan'),
          ],
        },
        districts: const {
          '3674': [District(code: '3674010', name: 'Ciputat')],
        },
        villages: const {
          '3674010': [Village(code: '3674010001', name: 'Ciputat Timur')],
        },
      );

      final controller = LocationController(
        getProvince: GetProvince(repo),
        getRegency: GetRegency(repo),
        getDistrict: GetDistrict(repo),
        getVillage: GetVillage(repo),
        getPostal: GetPostal(repo),
      );

      await controller.fetchProvinces();
      await controller.autoFillForm();

      expect(controller.selRegency?.name, 'Tangerang Selatan');
      expect(controller.selDistrict?.name, 'Ciputat');
      expect(controller.selVillage?.name, 'Ciputat Timur');
    });

    test('clearForm resets selections', () {
      final controller = LocationController(
        getProvince: GetProvince(_FakeLocationRepository(
          provinces: const [],
          regencies: const {},
          districts: const {},
          villages: const {},
        )),
        getRegency: GetRegency(_FakeLocationRepository(
          provinces: const [],
          regencies: const {},
          districts: const {},
          villages: const {},
        )),
        getDistrict: GetDistrict(_FakeLocationRepository(
          provinces: const [],
          regencies: const {},
          districts: const {},
          villages: const {},
        )),
        getVillage: GetVillage(_FakeLocationRepository(
          provinces: const [],
          regencies: const {},
          districts: const {},
          villages: const {},
        )),
        getPostal: GetPostal(_FakeLocationRepository(
          provinces: const [],
          regencies: const {},
          districts: const {},
          villages: const {},
        )),
      );
      controller.clearForm();
      expect(controller.selProvince, isNull);
      expect(controller.provinceController.text, '');
    });

    test('requestPermisison handles denied forever', () async {
      GeolocatorPlatform.instance = FakeGeolocatorPlatform(
        permission: LocationPermission.deniedForever,
      );
      GeocodingPlatform.instance = FakeGeocodingPlatform();
      const channel = MethodChannel('com.spencerccf.app_settings/methods');
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async => null);

      final repo = _FakeLocationRepository(
        provinces: const [],
        regencies: const {},
        districts: const {},
        villages: const {},
      );
      final controller = LocationController(
        getProvince: GetProvince(repo),
        getRegency: GetRegency(repo),
        getDistrict: GetDistrict(repo),
        getVillage: GetVillage(repo),
        getPostal: GetPostal(repo),
      );
      await controller.requestPermisison();

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });
  });

}

class _FakeLocationLocalDataSource implements LocationLocalDataSource {
  @override
  Future<LocationPoint> getCurrent() async {
    throw UnimplementedError();
  }
}
