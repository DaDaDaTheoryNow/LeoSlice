import 'package:get/get.dart';
import 'package:leo_slice/features/account/controller.dart';
import 'package:leo_slice/features/menu/controller.dart';

import 'controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController());
    Get.put<MenuController>(MenuController());
    Get.put<ProfileController>(ProfileController());
  }
}
