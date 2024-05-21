import 'package:flutter/material.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/text_theme.dart';

class FilterWidget extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onPress;
  const FilterWidget(
      {super.key,
      required this.title,
      required this.isSelected,
      required this.onPress});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        height: 36,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
              color: isSelected
                  ? ColorConstant.primaryColor
                  : ColorConstant.grayTextColor,
              width: 1.5),
        ),
        child: Center(
          child: Text(
            title,
            style: AppTextTheme.medium.copyWith(
                color: isSelected
                    ? ColorConstant.primaryColor
                    : ColorConstant.blackColor,
                fontSize: 13),
          ),
        ),
      ),
    );
  }
}
