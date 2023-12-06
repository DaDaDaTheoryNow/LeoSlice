import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leo_slice/common/theme/app_colors.dart';
import 'package:leo_slice/common/until/model/pizza.dart';
import 'package:leo_slice/features/cart/controller.dart';
import 'package:leo_slice/features/cart/view/widgets/cart_empty.dart';
import 'package:leo_slice/features/cart/view/widgets/order_pizza_widget.dart';

class CartDone extends GetView<CartController> {
  const CartDone({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => (controller.state.cartPizzaList.isNotEmpty)
              ? Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(15),
                      child: ExpansionTileCard(
                        baseColor: AppColors.bluePlaceholder,
                        expandedColor: AppColors.bluePlaceholder,
                        elevation: 5,
                        key: UniqueKey(),
                        leading: const CircleAvatar(
                          backgroundColor: AppColors.blue,
                          child: Icon(
                            Icons.local_pizza,
                            color: Colors.white,
                          ),
                        ),
                        title: const Text('Draft!'),
                        children:
                            controller.state.cartPizzaList.map((Pizza pizza) {
                          return OrderPizzaWidget(pizza: pizza);
                        }).toList(),
                      ),
                    ),
                    const Divider(),
                  ],
                )
              : const SizedBox(),
        ),
        Obx(() => (controller.state.allUserOrders.orders.isNotEmpty)
            ? const SizedBox()
            : const CartEmpty())
      ],
    );
  }
}
