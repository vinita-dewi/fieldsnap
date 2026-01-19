import 'package:fieldsnap/features/camera/presentation/controller/camera_controller.dart';
import 'package:get/get.dart';

class CameraBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CameraController());
  }
}
