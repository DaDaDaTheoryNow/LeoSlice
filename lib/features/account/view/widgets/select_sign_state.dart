import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:leo_slice/common/theme/app_colors.dart';
import 'package:leo_slice/common/until/enum/sign_state.dart';
import 'package:leo_slice/features/account/controller.dart';

class SelectSignState extends GetView<ProfileController> {
  const SelectSignState({super.key});

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
              Text(
                "Account in LeoSlice",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15.w),
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () => controller.setSignStatus(SignState.login),
                  child: Text("Login",
                      style: Theme.of(context).textTheme.labelLarge),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1.h,
                      color: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    child: const Text(
                      "Or",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 1.h,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15.w),
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () => controller.setSignStatus(SignState.register),
                  child: Text("Register",
                      style: Theme.of(context).textTheme.labelLarge),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
