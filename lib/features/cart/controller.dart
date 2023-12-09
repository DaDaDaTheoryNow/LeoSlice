import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide FormData, Response;
import 'package:leo_slice/common/until/enum/all_user_orders_state.dart';
import 'package:leo_slice/common/until/model/all_user_orders.dart';
import 'package:leo_slice/common/until/model/order_status_change_event.dart';
import 'package:leo_slice/common/until/model/pizza.dart';
import 'package:leo_slice/features/home/controller.dart';
import 'package:leo_slice/features/menu/controller.dart';
import 'package:leo_slice/features/shared/controller.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'state.dart';

class CartController extends GetxController {
  final state = CartState();
  final sharedState = Get.find<SharedController>().state;

  final dio = Dio();

  bool _firstFetchOrders = true;

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

  Future<void> cancelOrder({required int userId, required int orderId}) async {
    if (sharedState.tokenResponse == null ||
        sharedState.tokenResponse?.accessToken == null) {
      _setAllUserOrdersState(AllUserOrdersState.needLogin);
      return;
    }

    final url =
        "https://pizza-dev-k5af.onrender.com/order/change-status/$userId/$orderId?status=cancelled";

    try {
      Response response = await dio.post(
        url,
      );

      if (response.statusCode == 401 || response.statusCode == 422) {
        state.cartError = "Invalid Credentials";
        _setAllUserOrdersState(AllUserOrdersState.error);
      }
      if (response.statusCode == 200) {
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
        copy.insertAll(0, AllUserOrders.fromJson(response.data).orders);

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

  StreamSubscription<ConnectivityResult>? subscription;
  void listenInternetChanges() {
    subscription ??= Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.vpn) {
        if (!_firstFetchOrders) {
          debugPrint("reconnection");
          fetchUserOrders();
        } else {
          _firstFetchOrders = false;
        }
      }
    });
  }

  void listenChangedOrdersWebSocket() {
    final wsUrl = Uri.parse(
        'wss://pizza-dev-k5af.onrender.com/order/users-orders-ws?user_token=${sharedState.tokenResponse!.accessToken}');
    var channel = WebSocketChannel.connect(wsUrl);

    channel.stream.listen((data) {
      final Map<String, dynamic> jsonData = jsonDecode(data);
      if (jsonData["type"] == "change_status") {
        final OrderStatusChangeEvent event =
            OrderStatusChangeEvent.fromJson(jsonData);

        final List<Order> orders = List.from(state.allUserOrders.orders);
        orders
            .firstWhereOrNull((order) => order.orderId == event.orderId)
            ?.status = event.status;

        state.allUserOrders = AllUserOrders(orders: orders);
      }
    });
  }

  Future<void> fetchUserOrders() async {
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

        listenInternetChanges();
        listenChangedOrdersWebSocket();

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

  Future<void> repeatOrder(int orderId) async {
    if (sharedState.tokenResponse == null ||
        sharedState.tokenResponse?.accessToken == null) {
      _setAllUserOrdersState(AllUserOrdersState.needLogin);
      return;
    }

    final url =
        'https://pizza-dev-k5af.onrender.com/order/repeat-order/$orderId';

    try {
      _setAllUserOrdersState(AllUserOrdersState.loading);

      final response = await dio.post(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${sharedState.tokenResponse!.accessToken}',
          },
        ),
      );

      if (response.statusCode == 401 || response.statusCode == 422) {
        state.userOrdersError = "Invalid Credentials";
        _setAllUserOrdersState(AllUserOrdersState.error);
      }
      if (response.statusCode == 200) {
        final newOrder = AllUserOrders.fromJson(response.data);
        final List<Order> copy = List.from(state.allUserOrders.orders);

        copy.removeWhere(
            (element) => element.orderId == newOrder.orders.first.orderId);

        copy.insert(0, newOrder.orders.first);

        state.allUserOrders = AllUserOrders(orders: copy);

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
  }

  void _setAllUserOrdersState(AllUserOrdersState allUserOrdersState) {
    state.allUserOrdersState = allUserOrdersState;
  }

  void _setUserOrdersApiState(AllUserOrdersState allUserOrdersState) {
    state.userOrdersApiState = allUserOrdersState;
  }
}
