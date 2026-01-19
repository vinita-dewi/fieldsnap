import 'package:fieldsnap/features/camera/presentation/controller/camera_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class CameraPage extends GetView<CameraController> {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera')),
      body: Container(
        child: InkWell(
          onTap: () {
            controller.openCamera();
          },
          child: Text('OPEN CAMERA'),
        ),
      ),
    );
  }
}
