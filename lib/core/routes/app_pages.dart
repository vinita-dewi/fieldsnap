import 'package:fieldsnap/core/routes/app_routes.dart';
import 'package:get/get.dart';

import '../../features/camera/presentation/bindings/camera_binding.dart';
import '../../features/camera/presentation/pages/camera_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/location/presentation/bindings/location_binding.dart';
import '../../features/location/presentation/pages/location_page.dart';
import '../../features/users/presentation/bindings/users_binding.dart';
import '../../features/users/presentation/pages/users_page.dart';

class AppPages {
  AppPages._();

  static final pages = <GetPage<dynamic>>[
    GetPage(name: AppRoutes.home, page: () => const HomePage()),
    GetPage(
      name: AppRoutes.camera,
      page: () => const CameraPage(),
      binding: CameraBinding(),
    ),
    GetPage(
      name: AppRoutes.location,
      page: () => const LocationPage(),
      binding: LocationBinding(),
    ),
    GetPage(
      name: AppRoutes.users,
      page: () => const UsersPage(),
      binding: UsersBinding(),
    ),
  ];
}
