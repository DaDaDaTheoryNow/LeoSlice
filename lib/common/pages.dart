import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:leo_slice/features/address/binding.dart';
import 'package:leo_slice/features/address/view/address_page.dart';
import 'package:leo_slice/features/home/binding.dart';
import 'package:leo_slice/features/home/view/home_page.dart';

class AppPages {
  static const home = "/home";
  static const address = "/address";

  static final List<GetPage> pages = [
    GetPage(
      name: home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: address,
      page: () => const AddressPage(),
      binding: AddressBinding(),
      curve: Curves.fastEaseInToSlowEaseOut,
      transitionDuration: const Duration(milliseconds: 700),
    ),
  ];
}
