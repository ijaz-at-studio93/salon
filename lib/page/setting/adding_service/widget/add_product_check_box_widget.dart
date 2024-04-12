import 'package:flutter/material.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/text_theme.dart';

class AddProductCheckBoxWidget extends StatefulWidget {
  const AddProductCheckBoxWidget({super.key});

  @override
  State<AddProductCheckBoxWidget> createState() => _AddProductCheckBoxWidgetState();
}

class _AddProductCheckBoxWidgetState extends State<AddProductCheckBoxWidget> {
  bool isCheckMark = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 22,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Underarm shaving",
            style: AppTextTheme.medium
                .copyWith(color: ColorConstant.blackColor, fontSize: 16),
          ),
          Checkbox(
              value: isCheckMark,
              activeColor: ColorConstant.primaryColor,
              onChanged: (val) {
                setState(() {
                  isCheckMark = val ?? false;
                });
              })
        ],
      ),
    );
  }
}
