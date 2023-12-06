import 'package:leo_slice/common/until/model/pizza.dart';
import 'package:flutter/material.dart' hide MenuController;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:leo_slice/common/theme/app_colors.dart';
import 'package:leo_slice/features/cart/controller.dart';

class OrderPizzaWidget extends GetView<CartController> {
  final Pizza pizza;

  const OrderPizzaWidget({super.key, required this.pizza});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: AppColors.bluePlaceholder,
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(10),
            leading: const CircleAvatar(
              backgroundColor: AppColors.blue,
              child: Icon(
                Icons.local_pizza,
                color: Colors.white,
              ),
            ),
            title: Text(
              "${pizza.title.value} - \$${pizza.price.value.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Card(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Crust: ${pizza.crust.value}'),
                    const Divider(),
                    Text('Sauce: ${pizza.sauce.value}'),
                    const Divider(),
                    Text('Size: ${pizza.size.value}'),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 2.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.remove_shopping_cart,
                    color: AppColors.blue,
                  ),
                  onPressed: () => controller.removePizzaFromDraft(pizza),
                ),
                Obx(() => Text(
                      '${pizza.toCart}x',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                      ),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
