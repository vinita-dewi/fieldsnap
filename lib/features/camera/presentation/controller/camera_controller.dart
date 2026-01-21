import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:fieldsnap/core/enums/fetch_state.dart';
import 'package:fieldsnap/core/logging/app_logger.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraController extends GetxController {
  PermissionStatus? _cameraPermission;
  final _log = AppLogger.instance;

  bool _isRequestingPermission = false;

  final ImagePicker image = ImagePicker();

  final Rxn<File> _pic = Rxn<File>();
  File? get pic => _pic.value;

  final Rx<FetchState> _fetchState = FetchState.idle.obs;
  FetchState get fetchState => _fetchState.value;

  @override
  void onInit() {
    super.onInit();
    _log.i('[CAMERA CONTROLLER - onInit]');
    requestPermisison();
  }

  Future<void> requestPermisison() async {
    if (_isRequestingPermission) {
      return;
    }
    _isRequestingPermission = true;
    _cameraPermission = await Permission.camera.request();
    if (_cameraPermission == PermissionStatus.permanentlyDenied) {
      await AppSettings.openAppSettings();
    }
    _log.i(
      '[CAMERA CONTROLLER - requestPermission] _cameraPermission : $_cameraPermission',
    );
    _isRequestingPermission = false;
  }

  Future<void> openCamera() async {
    try {
      _fetchState.value = FetchState.loading;
      _log.i('[CAMERA CONTROLLER - openCamera]');
      await requestPermisison();
      XFile? file = await image.pickImage(source: ImageSource.camera);
      if (file != null) {
        _pic.value = File(file.path);
      }
    } catch (e) {
      _log.e('[CAMERA CONTROLLER - openCamera] ERROR : $e');
    } finally {
      _fetchState.value = FetchState.idle;
    }
  }

  deletePicture() {
    _pic.value = null;
  }
}
