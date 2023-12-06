import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leo_slice/common/until/enum/all_user_orders_state.dart';
import 'package:leo_slice/features/cart/controller.dart';
import 'package:leo_slice/features/cart/view/widgets/cart_done.dart';
import 'package:leo_slice/features/cart/view/widgets/cart_error.dart';
import 'package:leo_slice/features/cart/view/widgets/cart_need_login.dart';

class CartPage extends GetView<CartController> {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget buildScreenWithState() {
      return Obx(() {
        switch (controller.state.allUserOrdersState) {
          case AllUserOrdersState.loading:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case AllUserOrdersState.needLogin:
            return const CartNeedLogin();
          case AllUserOrdersState.error:
            return const CartError();
          case AllUserOrdersState.done:
            return ListView(
              children: const [
                CartDone(),
              ],
            );
        }
      });
    }

    return SafeArea(child: buildScreenWithState());
  }
}
