import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:leo_slice/common/theme/app_colors.dart';
import 'package:leo_slice/features/account/controller.dart';

class AccountWidget extends GetView<ProfileController> {
  const AccountWidget({super.key});

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
                "You are logged in",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15.w),
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () => controller.goToAddressPage(),
                  child: Text("Change Address",
                      style: Theme.of(context).textTheme.labelLarge),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 35.w),
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () => controller.userSignOut(),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text("Leave",
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
