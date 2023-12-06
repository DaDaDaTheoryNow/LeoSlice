import 'package:get/get.dart';
import 'package:leo_slice/common/until/enum/current_api_menu_state.dart';
import 'package:leo_slice/common/until/model/pizza.dart';

class MenuState {
  final RxString _menuError = "".obs;
  String get menuError => _menuError.value;
  set menuError(value) => _menuError.value = value;

  final RxList<Pizza> _pizzaList = <Pizza>[].obs;
  List<Pizza> get pizzaList => _pizzaList;
  set pizzaList(List<Pizza> value) => _pizzaList.value = value;

  final Rx<CurrentApiMenuState> _menuState = CurrentApiMenuState.loading.obs;
  CurrentApiMenuState get menuState => _menuState.value;
  set menuState(value) => _menuState.value = value;
}
