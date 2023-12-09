class OrderStatusChangeEvent {
  final String type;
  final String status;
  final int orderId;

  OrderStatusChangeEvent({
    required this.type,
    required this.status,
    required this.orderId,
  });

  factory OrderStatusChangeEvent.fromJson(Map<String, dynamic> json) {
    return OrderStatusChangeEvent(
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      orderId: json['order_id'] ?? '',
    );
  }
}
