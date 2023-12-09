import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:leo_slice/common/theme/app_colors.dart';
import 'package:leo_slice/common/until/model/all_user_orders.dart';
import 'package:leo_slice/features/cart/controller.dart';
import 'package:leo_slice/features/cart/view/widgets/in_order_pizza_widget.dart';

class OrderInfoWidget extends GetView<CartController> {
  final Order order;

  OrderInfoWidget({
    super.key,
    required this.order,
  });

  final GlobalKey<ExpansionTileCardState> _order = GlobalKey();

  final TextStyle _textStyle = const TextStyle(
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    String dateTime = DateFormat('yyyy-MM-dd - HH:mm').format(order.date);

    for (var pizzaOrder in order.pizzas) {
      pizzaOrder.pizza.toCart.value = pizzaOrder.amount;
    }

    return Card(
      elevation: 1,
      color: AppColors.bluePlaceholder,
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
      child: Center(
        child: ListTile(
          contentPadding: const EdgeInsets.all(15),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Order Information',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    margin: EdgeInsets.only(
                        top: 5.h, bottom: 3.h, left: 5.w, right: 5.w),
                    color: AppColors.blue,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      child: Text(
                        '${order.price.toStringAsFixed(0)}₽',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.only(
                        top: 5.h, bottom: 3.h, left: 5.w, right: 5.w),
                    color: AppColors.blue,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      child: Text(
                        'ID - ${order.orderId}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (order.address.isEmpty)
                Text('Address: г.Самара д.28 кв.123', style: _textStyle),
              if (order.address.isNotEmpty) Text('Address: ${order.address}'),
              Text('Date: $dateTime', style: _textStyle),
              Text('Status: ${order.status}', style: _textStyle),
              Padding(
                padding: EdgeInsets.only(top: 13.h),
                child: ExpansionTileCard(
                  baseColor: AppColors.bluePlaceholder,
                  expandedColor: AppColors.bluePlaceholder,
                  elevation: 5,
                  key: _order,
                  leading: const CircleAvatar(
                    backgroundColor: AppColors.blue,
                    child: Icon(
                      Icons.local_pizza,
                      color: Colors.white,
                    ),
                  ),
                  title: const Text('Pizzas'),
                  children: [
                    ...order.pizzas
                        .map(
                          (pizzaOrder) =>
                              InOrderPizzaWidget(pizza: pizzaOrder.pizza),
                        )
                        .toList(),
                  ],
                ),
              ),
              (order.status == "delivered" || order.status == "cancelled")
                  ? Container(
                      margin:
                          EdgeInsets.only(left: 15.w, right: 15.w, top: 13.h),
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () => controller.repeatOrder(order.orderId),
                        child: Text("Repeat this order",
                            style: Theme.of(context).textTheme.labelLarge),
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
