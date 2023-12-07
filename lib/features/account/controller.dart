import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart' hide FormData, Response;
import 'package:leo_slice/common/until/enum/current_api_sign_status.dart';
import 'package:leo_slice/common/until/enum/sign_state.dart';
import 'package:leo_slice/common/until/shared_preferences/user_prefs.dart';
import 'package:leo_slice/features/shared/controller.dart';

import 'state.dart';

class ProfileController extends GetxController {
  final state = ProfileState();
  final userPrefs = UserPrefs();

  final sharedState = Get.find<SharedController>().state;

  final Dio dio = Dio();

  void resetToDefault() {
    state.currentApiSignStatus = CurrentApiSignStatus.stay;
    state.loginError = "";
    state.registerError = "";

    state.loginNameTextController.clear();
    state.loginPasswordTextController.clear();
    state.registerNameTextController.clear();
    state.registerPasswordTextController.clear();
  }

  void setSignStatus(SignState signState) {
    resetToDefault();
    state.signState = signState;
  }

  void userSignOut() async {
    state.signState = SignState.unknown;
    await userPrefs.deleteUserData();
    resetToDefault();
  }

  void userSignIn(String name, String password) async {
    const url = 'https://pizza-dev-k5af.onrender.com/auth/login';

    Map<String, dynamic> data = {
      "username": name.trim(),
      "password": password.trim(),
    };

    try {
      FocusManager.instance.primaryFocus?.unfocus();
      state.currentApiSignStatus = CurrentApiSignStatus.loading;

      final response = await dio.post(
        url,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          validateStatus: (_) => true,
        ),
        data: FormData.fromMap(data),
      );

      if (response.statusCode == 401 || response.statusCode == 422) {
        state.loginError = "Invalid Credentials";
      }
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        userPrefs.succesUserLogin(response.data);
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        state.loginError =
            "Connection problems, check your internet connection";
      } else {
        state.loginError = e.toString();
      }
    }

    state.loginNameTextController.clear();
    state.loginPasswordTextController.clear();
    state.currentApiSignStatus = CurrentApiSignStatus.stay;
  }

  void userSignUp(String name, String password) async {
    const url = 'https://pizza-dev-k5af.onrender.com/auth/register';

    Map<String, dynamic> data = {
      'username': name.trim(),
      "password": password.trim(),
    };

    try {
      FocusManager.instance.primaryFocus?.unfocus();
      state.currentApiSignStatus = CurrentApiSignStatus.loading;

      Response response = await dio.post(
        url,
        options: Options(
          validateStatus: (_) => true,
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
        data: data,
      );

      if (response.statusCode == 401 || response.statusCode == 422) {
        state.registerError = "Invalid Credentials";
      }

      if (response.statusCode == 500) {
        state.registerError = "This user already exists";
      }

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        userPrefs.succesUserLogin(response.data);
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        state.registerError =
            "Connection problems, check your internet connection";
      } else {
        state.registerError = e.toString();
      }
    }

    state.registerNameTextController.clear();
    state.registerPasswordTextController.clear();
    state.currentApiSignStatus = CurrentApiSignStatus.stay;
  }
}
