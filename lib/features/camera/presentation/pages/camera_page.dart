import 'package:fieldsnap/core/enums/fetch_state.dart';
import 'package:fieldsnap/core/theme/app_colors.dart';
import 'package:fieldsnap/core/theme/app_text_styles.dart';
import 'package:fieldsnap/core/utils/gap.dart';
import 'package:fieldsnap/features/camera/presentation/controller/camera_controller.dart';
import 'package:fieldsnap/presentation/widgets/app_elevated_button.dart';
import 'package:fieldsnap/presentation/widgets/app_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class CameraPage extends GetView<CameraController> {
  const CameraPage({super.key});

  Widget _buildCameraWidget() {
    return InkWell(
      onTap: controller.openCamera,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.onPrimary,
              boxShadow: [
                BoxShadow(
                  color: AppColors.textSecondary.withAlpha(70),
                  blurRadius: 5,
                  spreadRadius: 2,
                  offset: Offset(0, 0),
                ),
              ],
            ),

            child: Padding(
              padding: EdgeInsets.all(40.px),
              child: Icon(
                Icons.camera_alt,
                size: 40.px,
                color: AppColors.primary,
              ),
            ),
          ),
          Gap.h(20.px),
          Text(
            'Take Picture',
            style: AppTextStyles.textTheme.titleLarge!(
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPictureWidget() {
    return Padding(
      padding: EdgeInsets.all(20.px),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Obx(
              () => Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8.px),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.textSecondary.withAlpha(70),
                      blurRadius: 5,
                      spreadRadius: 2,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(12.px),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.px),
                  child: Image.file(controller.pic!),
                ),
              ),
            ),
          ),
          Column(
            children: [
              AppElevatedButton(
                label: 'Retake Picture',
                onPressed: () {
                  controller.openCamera();
                },
              ),
              Gap.h(10),
              AppOutlinedButton(
                label: 'Delete Picture',
                onPressed: controller.deletePicture,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera')),
      body: Container(
        color: AppColors.onPrimary,
        child: Obx(
          () => controller.fetchState == FetchState.loading
              ? Center(child: CircularProgressIndicator())
              : controller.pic == null
              ? _buildCameraWidget()
              : _buildPictureWidget(),
        ),
      ),
    );
  }
}
