import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leo_slice/features/account/view/profile_page.dart';
import 'package:leo_slice/features/cart/view/cart_page.dart';
import 'package:leo_slice/features/home/controller.dart';
import 'package:leo_slice/features/menu/view/menu_page.dart';

import 'widgets/water_nav_bar.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller.state.pageController,
        children: const <Widget>[
          MenuPage(),
          CartPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: const WaterNavBar(),
      ),
    );
  }
}
