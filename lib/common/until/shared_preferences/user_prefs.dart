import 'dart:convert';

import 'package:get/get.dart';
import 'package:leo_slice/common/until/model/address.dart';
import 'package:leo_slice/common/until/model/token_response.dart';
import 'package:leo_slice/features/shared/controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPrefs {
  final _sharedState = Get.find<SharedController>().state;

  Future<void> setAddress(Address address) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    _sharedState.address = address;

    String addressJson = jsonEncode(address.toJson());

    await prefs.setString("address", addressJson);
  }

  Future<void> loadAddress() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? encodedUserData = prefs.getString("address");
    if (encodedUserData != null) {
      _sharedState.address = Address.fromJson(jsonDecode(encodedUserData));
    }
  }

  Future<void> succesUserLogin(Map<String, dynamic> responseData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    _sharedState.tokenResponse = TokenResponse.fromJson(responseData);

    String jsonData = jsonEncode(responseData);
    await prefs.setString("user", jsonData);
  }

  Future<void> loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? encodedUserData = prefs.getString("user");
    if (encodedUserData != null) {
      _sharedState.tokenResponse =
          TokenResponse.fromJson(jsonDecode(encodedUserData));
    }
  }

  Future<void> deleteUserData() async {
    _sharedState.tokenResponse = null;
    _sharedState.address = null;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("user");
    await prefs.remove("address");
  }
}
