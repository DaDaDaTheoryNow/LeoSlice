import 'package:get/get.dart';
import 'package:leo_slice/common/until/enum/all_user_orders_state.dart';
import 'package:leo_slice/common/until/model/all_user_orders.dart';
import 'package:leo_slice/common/until/model/pizza.dart';

class CartState {
  final RxString _cartError = "".obs;
  String get cartError => _cartError.value;
  set cartError(value) => _cartError.value = value;

  final Rx<AllUserOrders> _allUserOrders = AllUserOrders(orders: []).obs;
  AllUserOrders get allUserOrders => _allUserOrders.value;
  set allUserOrders(AllUserOrders value) => _allUserOrders.value = value;

  final Rx<AllUserOrdersState> _allUserOrdersState =
      AllUserOrdersState.needLogin.obs;
  AllUserOrdersState get allUserOrdersState => _allUserOrdersState.value;
  set allUserOrdersState(value) => _allUserOrdersState.value = value;

  final RxList<Pizza> _cartPizzaList = <Pizza>[].obs;
  List<Pizza> get cartPizzaList => _cartPizzaList;
  set cartPizzaList(List<Pizza> value) => _cartPizzaList.value = value;
}
