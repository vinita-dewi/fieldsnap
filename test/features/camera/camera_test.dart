import 'dart:io';

import 'package:fieldsnap/core/enums/fetch_state.dart';
import 'package:fieldsnap/features/camera/data/datasources/camera_local_datasource.dart';
import 'package:fieldsnap/features/camera/data/repositories/camera_repository_impl.dart';
import 'package:fieldsnap/features/camera/domain/entities/captured_photo.dart';
import 'package:fieldsnap/features/camera/domain/repositories/camera_repository.dart';
import 'package:fieldsnap/features/camera/domain/usecases/capture_photo.dart';
import 'package:fieldsnap/features/camera/presentation/controller/camera_controller.dart';
import 'package:fieldsnap/core/usecases/usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:flutter/services.dart';

import '../../helpers/fakes.dart';

class _FakeCameraRepository implements CameraRepository {
  @override
  Future<CapturedPhoto> capturePhoto() async {
    return const CapturedPhoto('x');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Camera data/domain', () {
    test('CameraLocalDataSource throws', () async {
      final ds = CameraLocalDataSourceImpl(ImagePicker());
      await expectLater(ds.capturePath(), throwsUnimplementedError);
    });

    test('CameraRepositoryImpl throws', () async {
      final repo = CameraRepositoryImpl(
        CameraLocalDataSourceImpl(ImagePicker()),
      );
      await expectLater(repo.capturePhoto(), throwsUnimplementedError);
    });

    test('CapturePhoto usecase calls repository', () async {
      final usecase = CapturePhoto(_FakeCameraRepository());
      final photo = await usecase(const NoParams());
      expect(photo.path, 'x');
    });
  });

  group('CameraController', () {
    test('openCamera sets pic and state', () async {
      final tempFile = await createTempImageFile();
      ImagePickerPlatform.instance = FakeImagePickerPlatform(file: tempFile);
      PermissionHandlerPlatform.instance = FakePermissionHandlerPlatform(
        permissionStatus: PermissionStatus.granted,
      );

      final controller = CameraController();
      await controller.openCamera();

      expect(controller.fetchState, FetchState.idle);
      expect(controller.pic, isA<File>());
    });

    test('deletePicture resets pic', () {
      final controller = CameraController();
      controller.deletePicture();
      expect(controller.pic, isNull);
    });

    test('requestPermisison handles permanently denied', () async {
      ImagePickerPlatform.instance = FakeImagePickerPlatform(file: null);
      PermissionHandlerPlatform.instance = FakePermissionHandlerPlatform(
        permissionStatus: PermissionStatus.permanentlyDenied,
      );
      const channel = MethodChannel('com.spencerccf.app_settings/methods');
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async => null);

      final controller = CameraController();
      await controller.requestPermisison();
      expect(controller.fetchState, FetchState.idle);

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });
  });

}
