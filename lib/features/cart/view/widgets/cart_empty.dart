import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:leo_slice/common/theme/app_colors.dart';
import 'package:leo_slice/features/cart/controller.dart';

class CartEmpty extends GetView<CartController> {
  const CartEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: AppColors.bluePlaceholder,
        margin: const EdgeInsets.all(15),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Do we place an order?",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15.w),
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () => controller.jumpToMenuPage(),
                  child: Text("Let's go",
                      style: Theme.of(context).textTheme.labelLarge),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
