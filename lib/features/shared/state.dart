import 'package:get/get.dart';
import 'package:leo_slice/common/until/model/address.dart';
import 'package:leo_slice/common/until/model/token_response.dart';
import 'package:leo_slice/features/cart/controller.dart';
import 'package:leo_slice/features/menu/controller.dart';

class SharedState {
  final Rx<TokenResponse?> _tokenResponse = Rx<TokenResponse?>(null);
  TokenResponse? get tokenResponse => _tokenResponse.value;
  set tokenResponse(TokenResponse? value) => _tokenResponse.value = value;

  final Rx<Address?> _address = Rx<Address?>(null);
  Address? get address => _address.value;
  set address(Address? value) => _address.value = value;

  SharedState() {
    ever(_tokenResponse, (_) {
      Get.find<CartController>().fetchUserOrders();
      Get.find<MenuController>().fetchPizza();
    });
  }
}
