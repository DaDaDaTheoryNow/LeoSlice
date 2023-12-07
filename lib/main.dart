import 'package:flutter/material.dart' hide MenuController;
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:leo_slice/common/pages.dart';
import 'package:leo_slice/common/theme/theme.dart';
import 'package:leo_slice/features/cart/controller.dart';
import 'package:leo_slice/features/home/controller.dart';
import 'package:leo_slice/features/shared/controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  Get.put<SharedController>(SharedController());
  Get.put<CartController>(CartController());

  await Get.put<HomeController>(HomeController()).loadUserData();

  return runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (_, child) {
        return GetMaterialApp(
          theme: AppTheme.themeData,
          themeMode: ThemeMode.light,
          debugShowCheckedModeBanner: false,
          initialRoute: AppPages.home,
          getPages: AppPages.pages,
        );
      },
    );
  }
}
