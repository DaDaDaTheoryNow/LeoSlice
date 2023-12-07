import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          () => (controller.state.cartPizzaList.isNotEmpty &&
                  controller.state.userOrdersApiState !=
                      AllUserOrdersState.loading)
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              TextButton(
                                style: flatButtonStyle,
                                onPressed: () {
                                  _draft.currentState?.collapse();
                                  controller.deleteDraft();
                                },
                                child: Column(
                                  children: <Widget>[
                                    const Icon(
                                      Icons.arrow_downward,
                                      color: Colors.red,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 2.h),
                                    ),
                                    const Text('Delete'),
                                  ],
                                ),
                              ),
                              Card(
                                color: AppColors.blue,
                                child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 40.w,
                                      vertical: 5.h,
                                    ),
                                    child: Obx(
                                      () => Text(
                                        "${controller.state.draftPrice}₽",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    )),
                              ),
                              TextButton(
                                style: flatButtonStyle,
                                onPressed: () {
                                  _draft.currentState?.collapse();
                                  controller.acceptDraft();
                                },
                                child: Column(
                                  children: <Widget>[
                                    const Icon(
                                      Icons.arrow_upward,
                                      color: Colors.green,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 2.h),
                                    ),
                                    const Text('Accept'),
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
              : (controller.state.userOrdersApiState ==
                      AllUserOrdersState.loading)
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
                        child: const CircularProgressIndicator(),
                      ),
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
