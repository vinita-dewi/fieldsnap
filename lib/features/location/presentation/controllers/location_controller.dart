import 'package:app_settings/app_settings.dart';
import 'package:fieldsnap/core/logging/app_logger.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationController extends GetxController {
  PermissionStatus? _locPermission;
  final _log = AppLogger.instance;
  bool _isRequestingPermission = false;
  @override
  void onInit() {
    super.onInit();
    _log.i('[LOCATION CONTROLLER - onInit]');
    requestPermisison();
  }

  Future<void> requestPermisison() async {
    if (_isRequestingPermission) {
      return;
    }
    _isRequestingPermission = true;
    _locPermission = await Permission.location.request();
    if (_locPermission == PermissionStatus.permanentlyDenied) {
      await AppSettings.openAppSettings();
    }
    _log.i(
      '[LOCATION CONTROLLER - requestPermission] _cameraPermission : $_locPermission',
    );
    _isRequestingPermission = false;
  }
}
