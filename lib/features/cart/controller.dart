import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, Response;
import 'package:leo_slice/common/until/enum/all_user_orders_state.dart';
import 'package:leo_slice/common/until/model/all_user_orders.dart';
import 'package:leo_slice/common/until/model/pizza.dart';
import 'package:leo_slice/features/home/controller.dart';
import 'package:leo_slice/features/menu/controller.dart';
import 'package:leo_slice/features/shared/controller.dart';

import 'state.dart';

class CartController extends GetxController {
  final state = CartState();
  final sharedState = Get.find<SharedController>().state;

  final dio = Dio();

  void jumpToAccountPage() {
    Get.find<HomeController>().onItemSelected(2, animated: true);
  }

  void jumpToMenuPage() {
    Get.find<HomeController>().onItemSelected(0, animated: true);
  }

  void countDraftPrice() {
    int draftPrice = 0;
    for (var pizza in state.cartPizzaList) {
      draftPrice += (pizza.toCart * pizza.price.value).toInt();
    }

    state.draftPrice = draftPrice;
  }

  void removePizzaFromDraft(Pizza pizza) {
    var pizzaToChange = state.cartPizzaList
        .firstWhere((pizzaValue) => pizzaValue.id.value == pizza.id.value);

    if (pizzaToChange.toCart.value > 0) {
      Get.find<MenuController>()
          .state
          .pizzaList
          .firstWhere((pizzaValue) => pizzaValue.id.value == pizza.id.value)
          .toCart
          .value--;
    }

    if (pizzaToChange.toCart.value <= 0) {
      state.cartPizzaList.remove(pizzaToChange);
    }

    countDraftPrice();
  }

  void deleteDraft() {
    final menuController = Get.find<MenuController>();
    state.cartPizzaList.clear();
    for (var element in menuController.state.pizzaList) {
      element.toCart.value = 0;
    }
  }

  void acceptDraft() async {
    await createNewOrder();

    final menuController = Get.find<MenuController>();
    state.cartPizzaList.clear();
    for (var element in menuController.state.pizzaList) {
      element.toCart.value = 0;
    }
  }

  Future<void> createNewOrder() async {
    if (sharedState.tokenResponse == null ||
        sharedState.tokenResponse?.accessToken == null) {
      _setAllUserOrdersState(AllUserOrdersState.needLogin);
      return;
    }

    const url = "https://pizza-dev-k5af.onrender.com/order/new-order";

    try {
      _setUserOrdersApiState(AllUserOrdersState.loading);

      Response response = await dio.post(
        url,
        options: Options(
          contentType: "application/json",
          headers: {
            'Authorization': 'Bearer ${sharedState.tokenResponse!.accessToken}',
          },
        ),
        data: {
          "pizzas": state.cartPizzaList.map((pizza) => pizza.toJson()).toList(),
          "address": '',
        },
      );

      if (response.statusCode == 401 || response.statusCode == 422) {
        state.userOrdersError = "Invalid Credentials";
        _setUserOrdersApiState(AllUserOrdersState.error);
      }
      if (response.statusCode == 200) {
        final List<Order> copy = List.from(state.allUserOrders.orders);
        copy.addAll(AllUserOrders.fromJson(response.data).orders);

        state.allUserOrders = AllUserOrders(orders: copy);
        _setUserOrdersApiState(AllUserOrdersState.done);
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        state.userOrdersError =
            "Connection problems, check your internet connection";
      } else {
        state.userOrdersError = e.toString();
      }

      _setUserOrdersApiState(AllUserOrdersState.error);
    }
  }

  Future<void> fetchAllUserOrders() async {
    if (sharedState.tokenResponse == null ||
        sharedState.tokenResponse?.accessToken == null) {
      _setAllUserOrdersState(AllUserOrdersState.needLogin);
      return;
    }

    const url =
        'https://pizza-dev-k5af.onrender.com/order/get-all-user-orders?page=1&per_page=20';

    try {
      _setAllUserOrdersState(AllUserOrdersState.loading);

      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${sharedState.tokenResponse!.accessToken}',
          },
        ),
      );

      if (response.statusCode == 401 || response.statusCode == 422) {
        state.cartError = "Invalid Credentials";
        _setAllUserOrdersState(AllUserOrdersState.error);
      }
      if (response.statusCode == 200) {
        state.allUserOrders = AllUserOrders.fromJson(response.data);
        _setAllUserOrdersState(AllUserOrdersState.done);
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        state.cartError = "Connection problems, check your internet connection";
      } else {
        state.cartError = e.toString();
      }

      _setAllUserOrdersState(AllUserOrdersState.error);
    }

    _setUserOrdersApiState(AllUserOrdersState.done);
  }

  void _setAllUserOrdersState(AllUserOrdersState allUserOrdersState) {
    state.allUserOrdersState = allUserOrdersState;
  }

  void _setUserOrdersApiState(AllUserOrdersState allUserOrdersState) {
    state.userOrdersApiState = allUserOrdersState;
  }
}
