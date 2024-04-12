import 'package:flutter/material.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/text_theme.dart';

class AddServiceCheckBoxListTileWidget extends StatefulWidget {
  const AddServiceCheckBoxListTileWidget({super.key});

  @override
  State<AddServiceCheckBoxListTileWidget> createState() =>
      _AddServiceCheckBoxListTileWidgetState();
}

class _AddServiceCheckBoxListTileWidgetState
    extends State<AddServiceCheckBoxListTileWidget> {
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
