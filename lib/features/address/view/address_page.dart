import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:leo_slice/common/theme/app_colors.dart';
import 'package:leo_slice/common/until/model/address.dart';
import 'package:leo_slice/common/widgets/custom_text_input.dart';
import 'package:leo_slice/common/widgets/sign_error.dart';
import 'package:leo_slice/features/address/controller.dart';

class AddressPage extends GetView<AddressController> {
  const AddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          "Address",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        toolbarHeight: 45,
        backgroundColor: AppColors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextInput(
              textEditingController: controller.state.cityTextController,
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              hintText: "City",
              iconData: FontAwesomeIcons.mountainCity,
              textCapitalization: true,
            ),
            SizedBox(
              height: 5.h,
            ),
            CustomTextInput(
              textEditingController: controller.state.streetTextController,
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              hintText: "Street",
              iconData: FontAwesomeIcons.road,
              textCapitalization: true,
            ),
            SizedBox(
              height: 5.h,
            ),
            CustomTextInput(
              textEditingController: controller.state.houseTextController,
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              hintText: "House",
              iconData: FontAwesomeIcons.house,
            ),
            Container(
              margin: EdgeInsets.only(left: 15.w, right: 15.w, top: 15.h.h),
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();

                  final cityText =
                      controller.state.cityTextController.text.trim();
                  final streetText =
                      controller.state.streetTextController.text.trim();

                  final houseText =
                      controller.state.houseTextController.text.trim();

                  if (cityText.isNotEmpty &&
                      streetText.isNotEmpty &&
                      houseText.isNotEmpty) {
                    controller.state.addressError = "";
                    controller.setAddress(Address(
                        city: cityText, street: streetText, house: houseText));
                  } else {
                    controller.state.addressError =
                        "All fields must be filled in";
                  }
                },
                child: Text("Change Address",
                    style: Theme.of(context).textTheme.labelLarge),
              ),
            ),
            Obx(() => (controller.state.addressError.isNotEmpty)
                ? MyErrorWidget(error: controller.state.addressError)
                : const SizedBox())
          ],
        ),
      ),
    );
  }
}
