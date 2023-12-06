import 'dart:convert';

import 'package:get/get.dart';
import 'package:leo_slice/common/until/model/token_response.dart';
import 'package:leo_slice/features/shared/controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPrefs {
  final _sharedState = Get.find<SharedController>().state;

  Future<void> succesUserLogin(Map<String, dynamic> responseData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    _sharedState.tokenResponse = TokenResponse.fromJson(responseData);

    String jsonData = jsonEncode(responseData);
    prefs.setString("user", jsonData);
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

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("user");
  }
}
