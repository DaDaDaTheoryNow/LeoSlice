import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leo_slice/common/until/model/all_user_orders.dart';

class OrderInfoWidget extends StatelessWidget {
  final Order order;

  const OrderInfoWidget({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        title: const Text('Order Information'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Address: г.Самара - д.28 - кв.123'),
            Text('User ID: ${order.userId}'),
            Text('Price: ${order.price.toStringAsFixed(2)}₽'),
            Text('Date: ${order.date.toString()}'),
            Text('Status: ${order.status}'),
          ],
        ),
      ),
    );
  }
}
