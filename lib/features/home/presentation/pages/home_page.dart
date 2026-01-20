import 'package:fieldsnap/core/routes/app_routes.dart';
import 'package:fieldsnap/core/theme/app_text_styles.dart';
import 'package:fieldsnap/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/routes/app_pages.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/gap.dart';
import '../controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  Widget _buildMenu({
    required IconData icon,
    required String title,
    required String route,
  }) {
    return InkWell(
      onTap: () {
        Get.toNamed(route);
      },
      child: Container(
        width: MediaQuery.of(Get.context!).size.width * 0.5,
        padding: EdgeInsets.all(40.px),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.px),
          color: AppTheme.light.colorScheme.primary,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40.px,
              color: AppTheme.light.colorScheme.onPrimary,
            ),
            Gap.h(12.px),
            Text(
              title,
              style: AppTextStyles.textTheme.titleLarge!(
                color: AppColors.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FieldSnap')),
      body: Container(
        width: double.infinity,
        color: AppTheme.light.canvasColor,
        child: Padding(
          padding: EdgeInsets.all(20.px),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildMenu(
                icon: Icons.people_outline,
                title: 'Users',
                route: AppRoutes.users,
              ),

              Gap.h(20),
              _buildMenu(
                icon: Icons.camera_alt_outlined,
                title: 'Camera',
                route: AppRoutes.camera,
              ),
              Gap.h(20),

              _buildMenu(
                icon: Icons.location_on_outlined,
                title: 'Location',
                route: AppRoutes.location,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
