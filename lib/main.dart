import 'package:fieldsnap/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_pages.dart';
import 'features/home/presentation/controllers/home_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  runApp(const FieldSnapApp());
}

class FieldSnapApp extends StatelessWidget {
  const FieldSnapApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());

    return GetMaterialApp(
      title: 'FieldSnap',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.home,
      getPages: AppPages.pages,
    );
  }
}
