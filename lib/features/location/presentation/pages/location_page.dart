import 'package:fieldsnap/core/enums/fetch_state.dart';
import 'package:fieldsnap/core/theme/app_colors.dart';
import 'package:fieldsnap/core/theme/app_text_styles.dart';
import 'package:fieldsnap/core/theme/app_theme.dart';
import 'package:fieldsnap/features/location/presentation/controllers/location_controller.dart';
import 'package:fieldsnap/features/location/presentation/widgets/dropdown.dart';
import 'package:fieldsnap/presentation/widgets/app_elevated_button.dart';
import 'package:fieldsnap/presentation/widgets/app_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import '../../../../core/utils/gap.dart';

class LocationPage extends GetView<LocationController> {
  const LocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Location')),
      body: Obx(
        () => LoadingOverlay(
          isLoading: controller.fetchState == FetchState.loading,
          child: Container(
            padding: EdgeInsets.all(20.px),
            decoration: BoxDecoration(color: AppTheme.light.canvasColor),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Gap.h(40),
                      Obx(
                        () => Row(
                          children: [
                            Expanded(
                              child: Dropdown(
                                hintText: 'Provinsi',
                                controller: controller.provinceController,
                                enabled:
                                    controller.provinceFetchState !=
                                        FetchState.loading &&
                                    controller.province.isNotEmpty,
                                dataSet: controller.province,
                                labelBuilder: (prov) => prov.name,
                                initialSelection: controller.selProvince,
                                onSelected: controller.onSelectProvince,
                              ),
                            ),
                            if (controller.provinceFetchState ==
                                FetchState.loading) ...[
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
                            Expanded(
                              child: Dropdown(
                                hintText: 'Kabupaten / Kota',
                                controller: controller.regencyController,
                                enabled:
                                    controller.regencyFetchState !=
                                        FetchState.loading &&
                                    controller.regency.isNotEmpty,
                                dataSet: controller.regency,
                                labelBuilder: (reg) => reg.name,
                                initialSelection: controller.selRegency,
                                onSelected: controller.onSelectRegency,
                              ),
                            ),
                            if (controller.regencyFetchState ==
                                FetchState.loading) ...[
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
                            Expanded(
                              child: Dropdown(
                                hintText: 'Kecamatan',
                                controller: controller.districtController,
                                enabled:
                                    controller.districtFetchState !=
                                        FetchState.loading &&
                                    controller.district.isNotEmpty,
                                dataSet: controller.district,
                                labelBuilder: (dis) => dis.name,
                                initialSelection: controller.selDistrict,
                                onSelected: controller.onSelectDistrict,
                              ),
                            ),
                            if (controller.districtFetchState ==
                                FetchState.loading) ...[
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
                            Expanded(
                              child: Dropdown(
                                hintText: 'Desa',
                                controller: controller.villageController,
                                enabled:
                                    controller.villageFetchState !=
                                        FetchState.loading &&
                                    controller.village.isNotEmpty,
                                dataSet: controller.village,
                                labelBuilder: (vil) => vil.name,
                                initialSelection: controller.selVillage,
                                onSelected: controller.onSelectVillage,
                              ),
                            ),
                            if (controller.villageFetchState ==
                                FetchState.loading) ...[
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
                            Expanded(
                              child: TextFormField(
                                controller: controller.postalController,
                                decoration: InputDecoration(
                                  hintText: 'Kode Pos',
                                  hintStyle: AppTextStyles.textTheme.bodyLarge!(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                style: AppTextStyles.textTheme.bodyLarge,
                                enabled:
                                    controller.postalFetchState !=
                                    FetchState.loading,
                              ),
                            ),
                            if (controller.postalFetchState ==
                                FetchState.loading) ...[
                              Padding(
                                padding: EdgeInsets.only(left: 20.px),
                                child: CircularProgressIndicator(),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Gap.h(60),
                    ],
                  ),
                ),

                AppElevatedButton(
                  label: 'Lacak Lokasi',
                  onPressed: () {
                    controller.autoFillForm();
                  },
                ),
                Gap.h(10),
                AppOutlinedButton(
                  label: 'Hapus',
                  onPressed: () {
                    controller.clearForm();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
