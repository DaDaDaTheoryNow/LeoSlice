import 'package:get/get.dart';
import 'package:leo_slice/common/until/model/token_response.dart';
import 'package:leo_slice/features/cart/controller.dart';
import 'package:leo_slice/features/menu/controller.dart';

class SharedState {
  final Rx<TokenResponse?> _tokenResponse = Rx<TokenResponse?>(null);
  TokenResponse? get tokenResponse => _tokenResponse.value;
  set tokenResponse(TokenResponse? value) => _tokenResponse.value = value;

  SharedState() {
    ever(_tokenResponse, (_) {
      Get.find<CartController>().fetchAllUserOrders();
      Get.find<MenuController>().fetchPizza();
    });
  }
}
