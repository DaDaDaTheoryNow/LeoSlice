import 'package:get/get.dart';

class Pizza {
  final RxString title = ''.obs;
  final RxString crust = ''.obs;
  final RxString sauce = ''.obs;
  final RxList<String> toppings = <String>[].obs;
  final RxString size = ''.obs;
  final RxString picture = ''.obs;
  final RxInt id = 0.obs;
  final RxDouble price = 0.0.obs;
  final RxBool isCustom = false.obs;
  final RxInt toCart = 0.obs;

  Pizza({
    required String title,
    required String crust,
    required String sauce,
    required List<String> toppings,
    required String size,
    required String picture,
    required int id,
    required double price,
    required bool isCustom,
    required int toCart,
  }) {
    this.title(title);
    this.crust(crust);
    this.sauce(sauce);
    this.toppings.addAll(toppings);
    this.size(size);
    this.picture(picture);
    this.id(id);
    this.price(price);
    this.isCustom(isCustom);
    this.toCart(toCart);
  }

  factory Pizza.fromJson(Map<String, dynamic> json) {
    return Pizza(
      title: json['title'],
      crust: json['crust'],
      sauce: json['sauce'],
      toppings: List<String>.from(json['toppings']),
      size: json['size'],
      picture: json['picture'],
      id: json['id'],
      price: json['price'].toDouble(),
      isCustom: json['is_custom'],
      toCart: 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pizza_id': id.value,
      'amount': toCart.value,
    };
  }
}
