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
            return const SafeArea(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case CurrentApiMenuState.done:
            return RefreshIndicator(
              displacement: 50.h,
              color: AppColors.blue,
              onRefresh: () => controller.fetchPizza(changeState: false),
              child: CustomScrollView(
                controller: controller.state.scrollController,
                slivers: [
                  SliverAppBar(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(25.r),
                      ),
                    ),
                    centerTitle: true,
                    automaticallyImplyLeading: false,
                    title: const Text(
                      "Menu",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    toolbarHeight: 45.h,
                    backgroundColor: AppColors.blue,
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(top: 5.h),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          Pizza pizza = controller.state.pizzaList[index];
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: (index ==
                                          controller.state.pizzaList.length -
                                              1 &&
                                      controller.cartController.state
                                          .cartPizzaList.isNotEmpty)
                                  ? 64.h
                                  : 0,
                            ),
                            child: PizzaWidget(pizza: pizza),
                          );
                        },
                        childCount: controller.state.pizzaList.length,
                      ),
                    ),
                  ),
                ],
              ),
            );
          case CurrentApiMenuState.error:
            return const SafeArea(child: MenuError());
        }
      });
    }

    return Scaffold(
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
            : const SizedBox(),
      ),
    );
  }
}
