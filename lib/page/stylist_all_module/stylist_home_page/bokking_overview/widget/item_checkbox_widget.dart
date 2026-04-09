import 'package:flutter/material.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/text_theme.dart';

class ItemCheckBoxWidget extends StatefulWidget {
  const ItemCheckBoxWidget({super.key});

  @override
  State<ItemCheckBoxWidget> createState() => _ItemCheckBoxWidgetState();
}

class _ItemCheckBoxWidgetState extends State<ItemCheckBoxWidget> {
  bool isCheckMark = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 22,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Hair Cut",
            style: AppTextTheme.medium
                .copyWith(color: ColorConstant.grayTextColor, fontSize: 16),
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
