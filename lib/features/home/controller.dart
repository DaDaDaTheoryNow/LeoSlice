import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:leo_slice/common/until/shared_preferences/user_prefs.dart';

import 'state.dart';

class HomeController extends GetxController {
  final state = HomeState();
  final userPrefs = UserPrefs();

  void onItemSelected(int index, {bool animated = false}) {
    state.selectedIndex = index;
    FocusManager.instance.primaryFocus?.unfocus();

    if (animated) {
      state.pageController.animateToPage(index,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutQuint);
    } else {
      state.pageController.jumpToPage(index);
    }
  }

  Future<void> loadUserData() async {
    await userPrefs.loadUserData();
  }
}
