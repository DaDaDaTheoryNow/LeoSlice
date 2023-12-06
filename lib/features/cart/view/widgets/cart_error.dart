import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:leo_slice/common/widgets/sign_error.dart';
import 'package:leo_slice/features/cart/controller.dart';

class CartError extends GetView<CartController> {
  const CartError({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MyErrorWidget(
          error: controller.state.cartError,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15.w),
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            onPressed: () => controller.fetchAllUserOrders(),
            child:
                Text("Refresh", style: Theme.of(context).textTheme.labelLarge),
          ),
        ),
      ],
    ));
  }
}
