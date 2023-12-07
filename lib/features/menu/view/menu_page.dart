import 'package:flutter/material.dart' hide MenuController;
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                  return Obx(
                    () => Padding(
                      padding: EdgeInsets.only(
                          bottom:
                              (index == controller.state.pizzaList.length - 1 &&
                                      controller.cartController.state
                                          .cartPizzaList.isNotEmpty)
                                  ? 64.h
                                  : 0),
                      child: PizzaWidget(pizza: pizza),
                    ),
                  );
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
        child: SafeArea(
          child: Scaffold(
            body: buildScreenWithState(),
            floatingActionButton: Obx(
                () => (controller.cartController.state.cartPizzaList.isNotEmpty)
                    ? SizedBox(
                        height: 50.h,
                        width: 55.w,
                        child: FloatingActionButton(
                          onPressed: () => controller.jumpToCartPage(),
                          backgroundColor: AppColors.blue,
                          child: Icon(
                            Icons.shopping_cart,
                            size: 20.r,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : const SizedBox()),
          ),
        ));
  }
}
