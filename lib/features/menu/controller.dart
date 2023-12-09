import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leo_slice/common/until/enum/current_api_menu_state.dart';
import 'package:leo_slice/common/until/model/pizza.dart';
import 'package:leo_slice/features/cart/controller.dart';
import 'package:leo_slice/features/home/controller.dart';
import 'package:leo_slice/features/menu/state.dart';
import 'package:leo_slice/features/shared/controller.dart';

class MenuController extends GetxController {
  final state = MenuState();

  final dio = Dio();
  final sharedState = Get.find<SharedController>().state;

  final cartController = Get.find<CartController>();

  void jumpToCartPage() {
    Get.find<HomeController>().onItemSelected(1, animated: true);
  }

  void addPizzaToFavorite(Pizza pizza) {
    switch (pizza.isFavorite.value) {
      case true:
        removeUserFavoritePizza(pizza.id.value);
        break;
      case false:
        addUserFavoritePizza(pizza.id.value);
        break;
    }

    sortByFavorite();
  }

  void sortByFavorite() {
    for (var pizza in state.pizzaList) {
      if (pizza.isFavorite.value) {
        state.pizzaList.remove(pizza);
        state.pizzaList.insert(0, pizza);
      }
    }
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

      await Future.delayed(const Duration(milliseconds: 300));

      if (response.statusCode == 401 || response.statusCode == 422) {
        state.menuError = "Validation Error";
        if (changeState) {
          _setMenuState(CurrentApiMenuState.error);
        }
      }
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;

        // get user favorites pizzas
        final favoriteUserPizzas = await fetchUserFavoritePizza();

        cartController.state.cartPizzaList.clear();
        state.pizzaList = data.map((json) => Pizza.fromJson(json)).toList();

        for (var favoritePizzaId in favoriteUserPizzas) {
          final pizzaToFavorite = state.pizzaList
              .firstWhereOrNull((pizza) => pizza.id.value == favoritePizzaId);

          pizzaToFavorite?.isFavorite.value = true;
        }

        if (state.pizzaList.isNotEmpty) {
          if (changeState) {
            _setMenuState(CurrentApiMenuState.done);
          }
        }

        sortByFavorite();
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

  Future<List<int>> fetchUserFavoritePizza() async {
    if (sharedState.tokenResponse == null ||
        sharedState.tokenResponse?.accessToken == null) {
      return [];
    }

    const url = 'https://pizza-dev-k5af.onrender.com/user/get-favorite-pizzas';

    try {
      final response = await dio.get(
        url,
        options: Options(
          contentType: "application/json",
          headers: {
            'Authorization': 'Bearer ${sharedState.tokenResponse!.accessToken}',
          },
        ),
      );

      if (response.statusCode == 401 || response.statusCode == 422) {
        state.menuError = "Validation Error";
        _setMenuState(CurrentApiMenuState.error);
      }
      if (response.statusCode == 200) {
        return response.data.map<int>((pizza) => pizza['id'] as int).toList();
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        state.menuError = "Connection problems, check your internet connection";
      } else {
        state.menuError = e.toString();
      }

      _setMenuState(CurrentApiMenuState.error);
    }

    return [];
  }

  Future<void> addUserFavoritePizza(int pizzaId) async {
    if (sharedState.tokenResponse == null ||
        sharedState.tokenResponse?.accessToken == null) {
      Get.find<HomeController>().onItemSelected(2, animated: true);
      return;
    }

    final url =
        'https://pizza-dev-k5af.onrender.com/user/add-favorite-pizza/$pizzaId';

    state.pizzaList
        .firstWhereOrNull((pizza) => pizza.id.value == pizzaId)
        ?.isFavorite
        .value = true;

    state.scrollController.animateTo(0,
        duration: const Duration(milliseconds: 400), curve: Curves.easeIn);

    try {
      final response = await dio.patch(
        url,
        options: Options(
          contentType: "application/json",
          headers: {
            'Authorization': 'Bearer ${sharedState.tokenResponse!.accessToken}',
          },
        ),
      );

      if (response.statusCode == 401 || response.statusCode == 422) {
        return;
      }

      if (response.statusCode == 200) {
        return;
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        state.menuError = "Connection problems, check your internet connection";
      } else {
        state.menuError = e.toString();
      }

      _setMenuState(CurrentApiMenuState.error);
    }
  }

  Future<void> removeUserFavoritePizza(int pizzaId) async {
    if (sharedState.tokenResponse == null ||
        sharedState.tokenResponse?.accessToken == null) {
      state.pizzaList
          .firstWhereOrNull((pizza) => pizza.id.value == pizzaId)
          ?.isFavorite
          .value = false;
      Get.find<HomeController>().onItemSelected(2, animated: true);
      return;
    }

    final url =
        'https://pizza-dev-k5af.onrender.com/user/delete-from-favorite-pizza?pizza_id=$pizzaId';

    state.pizzaList
        .firstWhereOrNull((pizza) => pizza.id.value == pizzaId)
        ?.isFavorite
        .value = false;

    state.scrollController.animateTo(0,
        duration: const Duration(milliseconds: 400), curve: Curves.easeIn);

    try {
      final response = await dio.delete(
        url,
        options: Options(
          contentType: "application/json",
          headers: {
            'Authorization': 'Bearer ${sharedState.tokenResponse!.accessToken}',
          },
        ),
      );

      if (response.statusCode == 401 || response.statusCode == 422) {
        return;
      }

      if (response.statusCode == 200) {
        return;
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        state.menuError = "Connection problems, check your internet connection";
      } else {
        state.menuError = e.toString();
      }

      _setMenuState(CurrentApiMenuState.error);
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
