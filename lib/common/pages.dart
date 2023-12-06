import 'package:get/get.dart';
import 'package:leo_slice/features/home/binding.dart';
import 'package:leo_slice/features/home/view/home_page.dart';

class AppPages {
  static const home = "/home";

  static final List<GetPage> pages = [
    GetPage(
      name: home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
  ];
}
