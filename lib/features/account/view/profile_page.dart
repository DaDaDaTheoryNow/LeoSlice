import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leo_slice/common/until/enum/sign_state.dart';
import 'package:leo_slice/features/account/controller.dart';
import 'package:leo_slice/features/account/view/login_page.dart';
import 'package:leo_slice/features/account/view/register_page.dart';
import 'package:leo_slice/features/account/view/widgets/account_widget.dart';
import 'package:leo_slice/features/account/view/widgets/select_sign_state.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Obx(() => (controller.sharedState.tokenResponse != null)
            ? const AccountWidget()
            : (controller.state.signState == SignState.unknown)
                ? const SelectSignState()
                : (controller.state.signState == SignState.login)
                    ? const LoginPage()
                    : const RegisterPage()));
  }
}
