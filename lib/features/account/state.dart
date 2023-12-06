import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leo_slice/common/until/enum/current_api_sign_status.dart';
import 'package:leo_slice/common/until/enum/sign_state.dart';

class ProfileState {
  final Rx<SignState> _signState = SignState.unknown.obs;
  SignState get signState => _signState.value;
  set signState(value) => _signState.value = value;

  final Rx<CurrentApiSignStatus> _currentApiSignStatus =
      CurrentApiSignStatus.stay.obs;
  CurrentApiSignStatus get currentApiSignStatus => _currentApiSignStatus.value;
  set currentApiSignStatus(value) => _currentApiSignStatus.value = value;

  // login variables
  final RxString _loginError = "".obs;
  String get loginError => _loginError.value;
  set loginError(value) => _loginError.value = value;

  final TextEditingController _loginNameTextController =
      TextEditingController();
  TextEditingController get loginNameTextController => _loginNameTextController;
  set loginNameTextController(value) => _loginNameTextController.value = value;

  final TextEditingController _loginPasswordTextController =
      TextEditingController();
  TextEditingController get loginPasswordTextController =>
      _loginPasswordTextController;
  set loginPasswordTextController(value) =>
      _loginPasswordTextController.value = value;

  // register variables
  final RxString _registerError = "".obs;
  String get registerError => _registerError.value;
  set registerError(value) => _registerError.value = value;

  final TextEditingController _registerNameTextController =
      TextEditingController();
  TextEditingController get registerNameTextController =>
      _registerNameTextController;
  set registerNameTextController(value) =>
      _registerNameTextController.value = value;

  final TextEditingController _registerPasswordTextController =
      TextEditingController();
  TextEditingController get registerPasswordTextController =>
      _registerPasswordTextController;
  set registerPasswordTextController(value) =>
      _registerPasswordTextController.value = value;
}
