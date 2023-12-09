import 'package:flutter/material.dart';
import 'package:leo_slice/common/theme/app_colors.dart';

class CustomTextInput extends StatelessWidget {
  final String hintText;
  final EdgeInsets padding;
  final IconData iconData;
  final TextEditingController textEditingController;
  final bool textCapitalization;

  const CustomTextInput(
      {super.key,
      required this.hintText,
      required this.padding,
      required this.iconData,
      required this.textEditingController,
      this.textCapitalization = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: TextField(
        textCapitalization: textCapitalization
            ? TextCapitalization.sentences
            : TextCapitalization.none,
        controller: textEditingController,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none),
          fillColor: AppColors.placeholder,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
          prefixStyle: const TextStyle(
            color: Colors.white,
          ),
          prefixIcon: Icon(
            iconData,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }
}
