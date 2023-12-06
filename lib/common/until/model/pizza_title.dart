class PizzaTitle {
  int pizzaId;
  int amount;

  PizzaTitle({
    required this.pizzaId,
    required this.amount,
  });

  factory PizzaTitle.fromJson(Map<String, dynamic> json) {
    return PizzaTitle(
      pizzaId: json['pizza_id'],
      amount: json['amount'],
    );
  }
}
