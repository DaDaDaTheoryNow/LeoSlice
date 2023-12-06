import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leo_slice/common/theme/app_colors.dart';
import 'package:leo_slice/common/until/enum/all_user_orders_state.dart';
import 'package:leo_slice/common/until/model/pizza.dart';
import 'package:leo_slice/common/widgets/sign_error.dart';
import 'package:leo_slice/features/cart/controller.dart';
import 'package:leo_slice/features/cart/view/widgets/cart_empty.dart';
import 'package:leo_slice/features/cart/view/widgets/order_info_widget.dart';
import 'package:leo_slice/features/cart/view/widgets/order_pizza_widget.dart';

class CartDone extends GetView<CartController> {
  CartDone({super.key});

  final GlobalKey<ExpansionTileCardState> _draft = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
    );

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
                        key: _draft,
                        leading: const CircleAvatar(
                          backgroundColor: AppColors.blue,
                          child: Icon(
                            Icons.local_pizza,
                            color: Colors.white,
                          ),
                        ),
                        title: const Text('Draft!'),
                        children: [
                          ...controller.state.cartPizzaList.map((Pizza pizza) {
                            return OrderPizzaWidget(pizza: pizza);
                          }).toList(),
                          ButtonBar(
                            alignment: MainAxisAlignment.spaceAround,
                            buttonHeight: 52.0,
                            buttonMinWidth: 90.0,
                            children: <Widget>[
                              TextButton(
                                style: flatButtonStyle,
                                onPressed: () {
                                  _draft.currentState?.collapse();
                                  controller.deleteDraft();
                                },
                                child: const Column(
                                  children: <Widget>[
                                    Icon(
                                      Icons.arrow_downward,
                                      color: Colors.red,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 2.0),
                                    ),
                                    Text('Delete'),
                                  ],
                                ),
                              ),
                              TextButton(
                                style: flatButtonStyle,
                                onPressed: () {
                                  _draft.currentState?.collapse();
                                  controller.acceptDraft();
                                },
                                child: const Column(
                                  children: <Widget>[
                                    Icon(
                                      Icons.arrow_upward,
                                      color: Colors.green,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 2.0),
                                    ),
                                    Text('Accept'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                  ],
                )
              : const SizedBox(),
        ),
        // error
        Obx(() =>
            (controller.state.userOrdersApiState == AllUserOrdersState.error)
                ? MyErrorWidget(error: controller.state.userOrdersError)
                : const SizedBox()),
        // empty cart
        Obx(() => (controller.state.allUserOrders.orders.isEmpty &&
                controller.state.cartPizzaList.isEmpty &&
                controller.state.userOrdersApiState == AllUserOrdersState.done)
            ? Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 2.85),
                child: const CartEmpty(),
              )
            : const SizedBox()),
        // all user orders
        Obx(() => (controller.state.allUserOrders.orders.isNotEmpty)
            ? Column(
                children: controller.state.allUserOrders.orders.map((order) {
                  return OrderInfoWidget(order: order);
                }).toList(),
              )
            : const SizedBox())
      ],
    );
  }
}
