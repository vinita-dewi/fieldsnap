import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fieldsnap/core/enums/api_method.dart';
import 'package:fieldsnap/core/services/api_service.dart';
import 'package:geocoding_platform_interface/geocoding_platform_interface.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart'
    as ph;

class FakeApiService extends ApiService {
  FakeApiService(this.data, {this.throwError = false});

  final dynamic data;
  final bool throwError;

  @override
  Future<Response<T>> request<T>({
    required String path,
    ApiMethod method = ApiMethod.GET,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool useApiKey = false,
  }) async {
    if (throwError) {
      throw DioException(
        requestOptions: RequestOptions(path: path),
        error: 'fake error',
        type: DioExceptionType.unknown,
      );
    }
    return Response<T>(
      requestOptions: RequestOptions(path: path),
      data: data as T,
    );
  }
}

class FakeGeolocatorPlatform extends GeolocatorPlatform {
  FakeGeolocatorPlatform({
    LocationPermission permission = LocationPermission.whileInUse,
    Position? position,
  })  : _permission = permission,
        _position = position ??
            Position(
              latitude: -6.2,
              longitude: 106.8,
              timestamp: DateTime.fromMillisecondsSinceEpoch(0),
              accuracy: 1,
              altitude: 0,
              altitudeAccuracy: 0,
              heading: 0,
              headingAccuracy: 0,
              speed: 0,
              speedAccuracy: 0,
            );

  final LocationPermission _permission;
  final Position _position;

  @override
  Future<LocationPermission> checkPermission() async => _permission;

  @override
  Future<LocationPermission> requestPermission() async => _permission;

  @override
  Future<bool> isLocationServiceEnabled() async => true;

  @override
  Future<Position> getCurrentPosition({
    LocationSettings? locationSettings,
  }) async =>
      _position;
}

class FakeGeocodingPlatform extends GeocodingPlatform {
  FakeGeocodingPlatform({List<Placemark>? placemarks})
      : _placemarks = placemarks ?? <Placemark>[];

  final List<Placemark> _placemarks;

  @override
  Future<void> setLocaleIdentifier(String localeIdentifier) async {}

  @override
  Future<bool> isPresent() async => true;

  @override
  Future<List<Placemark>> placemarkFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    return _placemarks;
  }

  @override
  Future<List<Placemark>> placemarkFromAddress(String address) async {
    return _placemarks;
  }

  @override
  Future<List<Location>> locationFromAddress(String address) async {
    return <Location>[];
  }
}

class FakePermissionHandlerPlatform extends ph.PermissionHandlerPlatform {
  FakePermissionHandlerPlatform({
    this.permissionStatus = ph.PermissionStatus.granted,
  });

  final ph.PermissionStatus permissionStatus;

  @override
  Future<ph.PermissionStatus> checkPermissionStatus(
    ph.Permission permission,
  ) async {
    return permissionStatus;
  }

  @override
  Future<Map<ph.Permission, ph.PermissionStatus>> requestPermissions(
    List<ph.Permission> permissions,
  ) async {
    return {
      for (final permission in permissions) permission: permissionStatus,
    };
  }

  @override
  Future<bool> openAppSettings() async => true;

  @override
  Future<ph.ServiceStatus> checkServiceStatus(ph.Permission permission) async {
    return ph.ServiceStatus.enabled;
  }

  @override
  Future<bool> shouldShowRequestPermissionRationale(
    ph.Permission permission,
  ) async {
    return false;
  }
}

class FakeImagePickerPlatform extends ImagePickerPlatform {
  FakeImagePickerPlatform({required this.file});

  final XFile? file;

  @override
  Future<XFile?> getImageFromSource({
    required ImageSource source,
    ImagePickerOptions options = const ImagePickerOptions(),
  }) async {
    return file;
  }
}

Future<XFile> createTempImageFile() async {
  final dir = await Directory.systemTemp.createTemp('fieldsnap_test_');
  final file = File('${dir.path}/temp.png');
  await file.writeAsBytes(<int>[0, 1, 2, 3]);
  return XFile(file.path);
}
