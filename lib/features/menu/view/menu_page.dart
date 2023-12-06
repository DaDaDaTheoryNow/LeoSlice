import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';
import 'package:leo_slice/common/theme/app_colors.dart';
import 'package:leo_slice/common/until/enum/current_api_menu_state.dart';
import 'package:leo_slice/common/until/model/pizza.dart';
import 'package:leo_slice/features/menu/controller.dart';
import 'package:leo_slice/features/menu/view/widgets/menu_error.dart';
import 'package:leo_slice/features/menu/view/widgets/pizza_widget.dart';

class MenuPage extends GetView<MenuController> {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget buildScreenWithState() {
      return Obx(() {
        switch (controller.state.menuState) {
          case CurrentApiMenuState.loading:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case CurrentApiMenuState.done:
            return Obx(
              () => ListView.builder(
                itemCount: controller.state.pizzaList.length,
                itemBuilder: (context, index) {
                  Pizza pizza = controller.state.pizzaList[index];
                  return PizzaWidget(pizza: pizza);
                },
              ),
            );
          case CurrentApiMenuState.error:
            return const MenuError();
        }
      });
    }

    return RefreshIndicator(
        color: AppColors.blue,
        onRefresh: () => controller.fetchPizza(changeState: false),
        child: SafeArea(child: buildScreenWithState()));
  }
}
