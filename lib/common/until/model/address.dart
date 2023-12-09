class Address {
  final String city;
  final String street;
  final String house;

  Address({required this.city, required this.street, required this.house});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      city: json['city'],
      street: json['street'],
      house: json['house'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'street': street,
      'house': house,
    };
  }
}
