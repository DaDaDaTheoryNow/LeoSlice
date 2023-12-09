import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide MenuController;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:leo_slice/common/theme/app_colors.dart';
import 'package:leo_slice/common/until/model/pizza.dart';
import 'package:leo_slice/features/menu/controller.dart';

class PizzaWidget extends GetView<MenuController> {
  final Pizza pizza;

  const PizzaWidget({super.key, required this.pizza});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.fromLTRB(15.w, 8.h, 15.w, 0),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 130.w,
                height: 120.h,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: pizza.picture.value,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Text(
                        pizza.title.value,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Divider(
                      height: 5.h,
                      indent: 0,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Text(
                        'Sauce - ${pizza.sauce.value}',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Divider(
                      height: 5.h,
                      indent: 0,
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Toppings:',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          for (String topping in pizza.toppings)
                            Text('- $topping'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(bottom: 2.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  color: AppColors.blue,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 5.h,
                    ),
                    child: Text(
                      "${pizza.price.value.toStringAsFixed(0)}₽",
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.remove_shopping_cart,
                    color: AppColors.blue,
                  ),
                  onPressed: () => controller.removePizzaFromCart(pizza),
                ),
                Obx(
                  () => Text(
                    '${pizza.toCart}x',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.add_shopping_cart,
                    color: AppColors.blue,
                  ),
                  onPressed: () => controller.addPizzaToCart(pizza),
                ),
                Container(
                  margin: EdgeInsets.only(left: 5.w),
                  height: 20.h,
                  width: 1.w,
                  color: Colors.grey,
                ),
                Tooltip(
                  message: "add to favorite",
                  waitDuration: const Duration(milliseconds: 400),
                  margin: EdgeInsets.all(5.r),
                  child: Padding(
                    padding: EdgeInsets.only(left: 5.w),
                    child: Obx(
                      () => IconButton(
                        onPressed: () => controller.addPizzaToFavorite(pizza),
                        icon: (pizza.isFavorite.value)
                            ? const Icon(
                                Icons.star,
                                shadows: [
                                  Shadow(
                                    color: Colors.black,
                                    offset: Offset(1, 1),
                                    blurRadius: 3,
                                  )
                                ],
                                color: Colors.yellow,
                              )
                            : const Icon(
                                Icons.star_border,
                                color: Colors.black,
                              ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
