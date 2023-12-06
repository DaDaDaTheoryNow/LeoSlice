import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leo_slice/common/theme/app_colors.dart';

class MyErrorWidget extends StatelessWidget {
  final String error;
  const MyErrorWidget({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      padding: EdgeInsets.all(10.w),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: AppColors.placeholder,
          borderRadius: BorderRadius.circular(15)),
      child: Text(
        error,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 15.sp,
        ),
      ),
    );
  }
}
