import 'package:leo_slice/common/until/model/pizza.dart';

class AllUserOrders {
  List<Order> orders;

  AllUserOrders({required this.orders});

  factory AllUserOrders.fromJson(dynamic json) {
    if (json is List) {
      List<Order> orders = json.map((order) => Order.fromJson(order)).toList();
      return AllUserOrders(orders: orders);
    } else if (json is Map<String, dynamic>) {
      List<Order> orders = [
        Order.fromJson({
          'pizzas': json['pizzas'],
          'address': json['address'] ?? '',
          'user_id': json['user_id'],
          'price': json['price'].toDouble(),
          'date': json['date'],
          'status': json['status'],
        })
      ];
      return AllUserOrders(orders: orders);
    } else {
      throw FormatException(
          'Invalid JSON format for AllUserOrders: ${json.runtimeType}');
    }
  }
}

class Order {
  List<Pizza> pizzas;
  String address;
  int userId;
  double price;
  DateTime date;
  String status;

  Order({
    required this.pizzas,
    required this.address,
    required this.userId,
    required this.price,
    required this.date,
    required this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    List<Pizza> pizzas =
        (json['pizzas'] as List).map((pizza) => Pizza.fromJson(pizza)).toList();

    return Order(
      pizzas: pizzas,
      address: json['address'],
      userId: json['user_id'],
      price: json['price'].toDouble(),
      date: DateTime.parse(json['date']),
      status: json['status'],
    );
  }
}
