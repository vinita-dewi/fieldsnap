import 'package:fieldsnap/core/enums/fetch_state.dart';
import 'package:fieldsnap/core/theme/app_colors.dart';
import 'package:fieldsnap/core/theme/app_text_styles.dart';
import 'package:fieldsnap/core/theme/app_theme.dart';
import 'package:fieldsnap/features/location/presentation/controllers/location_controller.dart';
import 'package:fieldsnap/features/location/presentation/widgets/dropdown.dart';
import 'package:fieldsnap/presentation/widgets/app_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/utils/gap.dart';

class LocationPage extends GetView<LocationController> {
  const LocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Location')),
      body: Container(
        padding: EdgeInsets.all(20.px),
        decoration: BoxDecoration(color: AppTheme.light.canvasColor),
        child: Column(
          children: [
            Obx(
              () => Row(
                children: [
                  Dropdown(
                    enabled:
                        controller.provinceFetchState != FetchState.loading &&
                        controller.province.isNotEmpty,
                    dataSet: controller.province,
                    labelBuilder: (prov) => prov.name,
                    initialSelection: controller.selProvince,
                    onSelected: controller.onSelectProvince,
                  ),
                  if (controller.provinceFetchState == FetchState.loading) ...[
                    Padding(
                      padding: EdgeInsets.only(left: 20.px),
                      child: CircularProgressIndicator(),
                    ),
                  ],
                ],
              ),
            ),
            Gap.h(20),
            Obx(
              () => Row(
                children: [
                  Dropdown(
                    enabled:
                        controller.regencyFetchState != FetchState.loading &&
                        controller.regency.isNotEmpty,
                    dataSet: controller.regency,
                    labelBuilder: (reg) => reg.name,
                    initialSelection: controller.selRegency,
                    onSelected: controller.onSelectRegency,
                  ),
                ],
              ),
            ),

            Gap.h(20),
            Obx(
              () => Row(
                children: [
                  Dropdown(
                    enabled:
                        controller.districtFetchState != FetchState.loading &&
                        controller.district.isNotEmpty,
                    dataSet: controller.district,
                    labelBuilder: (dis) => dis.name,
                    initialSelection: controller.selDistrict,
                    onSelected: controller.onSelectDistrict,
                  ),
                ],
              ),
            ),

            Gap.h(20),
            Obx(
              () => Row(
                children: [
                  Dropdown(
                    enabled:
                        controller.villageFetchState != FetchState.loading &&
                        controller.village.isNotEmpty,
                    dataSet: controller.village,
                    labelBuilder: (vil) => vil.name,
                    initialSelection: controller.selVillage,
                    onSelected: controller.onSelectVillage,
                  ),
                ],
              ),
            ),
            Gap.h(20),
            TextField(controller: controller.postalController),
            Gap.h(20),
            Text(
              'OR',
              style: AppTextStyles.textTheme.bodyLarge!(
                color: AppColors.primary,
              ),
            ),
            Gap.h(20),
            AppElevatedButton(label: 'Detect My Location!', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
