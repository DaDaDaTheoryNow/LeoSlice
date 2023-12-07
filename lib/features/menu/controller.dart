import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:leo_slice/common/until/enum/current_api_menu_state.dart';
import 'package:leo_slice/common/until/model/pizza.dart';
import 'package:leo_slice/features/cart/controller.dart';
import 'package:leo_slice/features/home/controller.dart';
import 'package:leo_slice/features/menu/state.dart';

class MenuController extends GetxController {
  final state = MenuState();

  final dio = Dio();

  final cartController = Get.find<CartController>();

  void jumpToCartPage() {
    Get.find<HomeController>().onItemSelected(1, animated: true);
  }

  void addPizzaToCart(Pizza pizza) {
    state.pizzaList
        .where((pizzaValue) => pizzaValue.id.value == pizza.id.value)
        .first
        .toCart
        .value++;

    final List<Pizza> pizzaToCart = List.from(state.pizzaList);

    pizzaToCart.removeWhere((element) => element.toCart.value == 0);

    cartController.state.cartPizzaList = pizzaToCart;
    cartController.countDraftPrice();
  }

  void removePizzaFromCart(Pizza pizza) {
    var pizzaChange = state.pizzaList
        .firstWhere((pizzaValue) => pizzaValue.id.value == pizza.id.value);

    if (pizzaChange.toCart.value > 0) {
      pizzaChange.toCart.value--;
    }

    final List<Pizza> pizzaToCart = List.from(state.pizzaList);

    pizzaToCart.removeWhere((element) => element.toCart.value == 0);

    cartController.state.cartPizzaList = pizzaToCart;

    final Pizza? pizzaToDeleteDraft = cartController.state.cartPizzaList
        .firstWhereOrNull((element) => element.toCart > 0);
    if (pizzaToDeleteDraft == null) {
      cartController.state.cartPizzaList.clear();
    }

    cartController.countDraftPrice();
  }

  Future<void> fetchPizza({bool changeState = true}) async {
    const url =
        'https://pizza-dev-k5af.onrender.com/pizza/get_pizzas?page=1&per_page=20';

    try {
      if (changeState) {
        _setMenuState(CurrentApiMenuState.loading);
      }

      final response = await dio.get(
        url,
      );

      if (response.statusCode == 401 || response.statusCode == 422) {
        state.menuError = "Validation Error";
        if (changeState) {
          _setMenuState(CurrentApiMenuState.loading);
        }
      }
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        cartController.state.cartPizzaList.clear();

        state.pizzaList = data.map((json) => Pizza.fromJson(json)).toList();
        if (state.pizzaList.isNotEmpty) {
          if (changeState) {
            _setMenuState(CurrentApiMenuState.done);
          }
        }
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        state.menuError = "Connection problems, check your internet connection";
      } else {
        state.menuError = e.toString();
      }

      if (changeState) {
        _setMenuState(CurrentApiMenuState.error);
      }
    }
  }

  void _setMenuState(CurrentApiMenuState menuState) {
    state.menuState = menuState;
  }

  @override
  void onInit() {
    fetchPizza();
    super.onInit();
  }
}
