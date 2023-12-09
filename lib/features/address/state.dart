import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressState {
  final TextEditingController _cityTextController = TextEditingController();
  TextEditingController get cityTextController => _cityTextController;
  set cityTextController(value) => _cityTextController.value = value;

  final TextEditingController _streetTextController = TextEditingController();
  TextEditingController get streetTextController => _streetTextController;
  set streetTextController(value) => _streetTextController.value = value;

  final TextEditingController _houseTextController = TextEditingController();
  TextEditingController get houseTextController => _houseTextController;
  set houseTextController(value) => _houseTextController.value = value;

  final RxString _addressError = "".obs;
  String get addressError => _addressError.value;
  set addressError(value) => _addressError.value = value;
}
