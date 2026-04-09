import 'package:flutter/material.dart';
import 'package:salon/constant/color_constant.dart';

import '../../../project_specific/text_theme.dart';

class FilterWidget extends StatelessWidget {
  final VoidCallback onPress;
  final bool  isSelected;
  final String  title;
  const FilterWidget({super.key, required this.onPress, required this.isSelected, required this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: isSelected
              ? ColorConstant.primaryColor
              : ColorConstant.whiteColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: ColorConstant.borderColor2),
        ),
        child: Center(
          child: Text(
            title,
            style: AppTextTheme.medium.copyWith(
                color:isSelected
                    ? ColorConstant.whiteColor
                    : ColorConstant.blackColor,
                fontSize: 13),
          ),
        ),
      ),
    );
  }
}
