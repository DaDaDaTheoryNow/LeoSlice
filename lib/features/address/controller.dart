import 'package:get/get.dart';
import 'package:leo_slice/common/until/model/address.dart';
import 'package:leo_slice/common/until/shared_preferences/user_prefs.dart';
import 'package:leo_slice/features/address/state.dart';
import 'package:leo_slice/features/shared/controller.dart';

class AddressController extends GetxController {
  final state = AddressState();
  final sharedState = Get.find<SharedController>().state;

  final UserPrefs userPrefs = UserPrefs();

  void setAddress(Address address) async {
    await userPrefs.setAddress(Address(
        city: address.city, street: address.street, house: address.house));

    await Future.delayed(const Duration(milliseconds: 400));

    Get.close(1);
  }
}
