import 'package:fieldsnap/features/camera/presentation/bindings/camera_binding.dart';
import 'package:fieldsnap/features/location/presentation/bindings/location_binding.dart';
import 'package:fieldsnap/features/users/presentation/bindings/users_binding.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import '../helpers/test_setup.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(setupTestFonts);

  test('CameraBinding registers dependencies', () {
    Get.testMode = true;
    CameraBinding().dependencies();
  });

  test('LocationBinding registers dependencies', () {
    Get.testMode = true;
    LocationBinding().dependencies();
  });

  test('UsersBinding registers dependencies', () {
    Get.testMode = true;
    UsersBinding().dependencies();
  });
}
