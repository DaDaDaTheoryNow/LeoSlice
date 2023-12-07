import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:leo_slice/common/widgets/sign_error.dart';
import 'package:leo_slice/features/cart/controller.dart';

class OrdersError extends GetView<CartController> {
  const OrdersError({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MyErrorWidget(
          error: "Unsuccessfully: ${controller.state.userOrdersError}",
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
