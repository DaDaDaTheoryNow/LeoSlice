import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:leo_slice/common/theme/app_colors.dart';
import 'package:leo_slice/common/until/enum/current_api_sign_status.dart';
import 'package:leo_slice/common/until/enum/sign_state.dart';
import 'package:leo_slice/features/account/controller.dart';
import 'package:leo_slice/features/account/view/widgets/custom_text_input.dart';
import 'package:leo_slice/common/widgets/sign_error.dart';

class RegisterPage extends GetView<ProfileController> {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(15),
        color: AppColors.bluePlaceholder,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextInput(
                textEditingController:
                    controller.state.registerNameTextController,
                padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 10.h),
                hintText: "Name",
                iconData: Icons.account_circle,
              ),
              SizedBox(
                height: 5.h,
              ),
              CustomTextInput(
                textEditingController:
                    controller.state.registerPasswordTextController,
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                hintText: "Password",
                iconData: Icons.password,
              ),
              Container(
                margin: EdgeInsets.only(left: 15.w, right: 15.w, top: 15.h.h),
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();

                    final nameText =
                        controller.state.registerNameTextController.text;
                    final passwordText =
                        controller.state.registerPasswordTextController.text;

                    if (nameText.isNotEmpty & passwordText.isNotEmpty) {
                      controller.state.registerError = "";
                      controller.userSignUp(nameText, passwordText);
                    } else {
                      controller.state.registerError =
                          "All fields must be filled in";
                    }
                  },
                  child: Text("Register",
                      style: Theme.of(context).textTheme.labelLarge),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15.w, right: 15.w, bottom: 5.h),
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    controller.setSignStatus(SignState.unknown);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  child: Text("Back",
                      style: Theme.of(context).textTheme.labelLarge),
                ),
              ),
              Obx(() => (controller.state.currentApiSignStatus ==
                      CurrentApiSignStatus.loading)
                  ? Container(
                      margin: const EdgeInsets.all(10),
                      child: const CircularProgressIndicator(),
                    )
                  : const SizedBox()),
              Obx(() => (controller.state.registerError.isNotEmpty)
                  ? MyErrorWidget(error: controller.state.registerError)
                  : const SizedBox())
            ],
          ),
        ),
      ),
    );
  }
}
