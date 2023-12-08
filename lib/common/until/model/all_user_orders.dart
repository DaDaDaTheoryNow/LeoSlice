import 'package:leo_slice/common/until/model/pizza.dart';

class AllUserOrders {
  final List<Order> orders;

  AllUserOrders({required this.orders});

  factory AllUserOrders.fromJson(dynamic json) {
    if (json is List) {
      List<Order> orders = json.map((order) => Order.fromJson(order)).toList();
      return AllUserOrders(orders: orders);
    } else if (json is Map<String, dynamic>) {
      Order order = Order.fromJson(json);
      return AllUserOrders(orders: [order]);
    } else {
      throw ArgumentError("Invalid JSON format for AllUserOrders");
    }
  }
}

class Order {
  final List<PizzaOrder> pizzas;
  final String address;
  final int userId;
  final int orderId;
  final double price;
  final DateTime date;
  final String status;

  Order({
    required this.pizzas,
    required this.address,
    required this.userId,
    required this.orderId,
    required this.price,
    required this.date,
    required this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    List<PizzaOrder> pizzas = (json['pizzas'] as List)
        .map((pizza) => PizzaOrder.fromJson(pizza))
        .toList();

    return Order(
      pizzas: pizzas,
      address: json['address'] ?? "",
      userId: json['user_id'],
      orderId: json["id"],
      price: json['price'].toDouble(),
      date: DateTime.parse(json['date']),
      status: json['status'] ?? "",
    );
  }
}

class PizzaOrder {
  final Pizza pizza;
  final int amount;

  PizzaOrder({required this.pizza, required this.amount});

  factory PizzaOrder.fromJson(Map<String, dynamic> json) {
    return PizzaOrder(
      pizza: Pizza.fromJson(json['pizza']),
      amount: json['amount'],
    );
  }
}
