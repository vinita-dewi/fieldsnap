import 'package:app_settings/app_settings.dart';
import 'package:fieldsnap/core/logging/app_logger.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraController extends GetxController {
  PermissionStatus? _cameraPermission;
  final _log = AppLogger.instance;
  bool _isRequestingPermission = false;
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
    _log.i('[CAMERA CONTROLLER - openCamera]');
    requestPermisison();
  }
}
