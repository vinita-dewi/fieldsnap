import 'package:get/get.dart';

import '../../features/camera/presentation/bindings/camera_binding.dart';
import '../../features/camera/presentation/pages/camera_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/location/presentation/bindings/location_binding.dart';
import '../../features/location/presentation/pages/location_page.dart';
import '../../features/users/presentation/bindings/users_binding.dart';
import '../../features/users/presentation/pages/users_page.dart';

class AppRoutes {
  AppRoutes._();

  static const home = '/';
  static const camera = '/camera';
  static const location = '/location';
  static const users = '/users';

  static final pages = <GetPage<dynamic>>[
    GetPage(
      name: home,
      page: () => const HomePage(),
    ),
    GetPage(
      name: camera,
      page: () => const CameraPage(),
      binding: CameraBinding(),
    ),
    GetPage(
      name: location,
      page: () => const LocationPage(),
      binding: LocationBinding(),
    ),
    GetPage(
      name: users,
      page: () => const UsersPage(),
      binding: UsersBinding(),
    ),
  ];
}
