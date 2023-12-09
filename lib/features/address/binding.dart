import 'package:get/get.dart';
import 'package:leo_slice/features/address/controller.dart';

class AddressBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddressController>(() => AddressController());
  }
}
