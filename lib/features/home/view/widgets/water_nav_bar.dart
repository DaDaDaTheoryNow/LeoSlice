import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:leo_slice/features/home/controller.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';

class WaterNavBar extends GetView<HomeController> {
  const WaterNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => WaterDropNavBar(
        bottomPadding: 15.h,
        backgroundColor: Colors.white,
        onItemSelected: controller.onItemSelected,
        selectedIndex: controller.state.selectedIndex,
        barItems: <BarItem>[
          BarItem(
            filledIcon: FontAwesomeIcons.utensils,
            outlinedIcon: FontAwesomeIcons.utensils,
          ),
          BarItem(
              filledIcon: Icons.shopping_cart,
              outlinedIcon: Icons.shopping_cart),
          BarItem(
            filledIcon: Icons.account_circle,
            outlinedIcon: Icons.account_circle,
          ),
        ],
      ),
    );
  }
}
