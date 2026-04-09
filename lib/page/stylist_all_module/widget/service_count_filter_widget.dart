import 'package:flutter/material.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/text_theme.dart';

class ServiceCountFilterWidget extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onPress;
  const ServiceCountFilterWidget(
      {super.key, required this.isSelected, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
       height: 36,
        padding: const EdgeInsets.only(left: 10,right: 10),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
            border: Border.all(
                color: !isSelected
                    ? ColorConstant.grayTextColor
                    : Colors.transparent),
            borderRadius: BorderRadius.circular(6),
            color: isSelected
                ? ColorConstant.primaryColor
                : ColorConstant.whiteColor),
        child: Row(
          children: [
            Text(
              "Hair Cut",
              style: AppTextTheme.medium.copyWith(
                  color: isSelected
                      ? ColorConstant.whiteColor
                      : ColorConstant.blackColor,
                  fontSize: 13),
            ),
            const SizedBox(width: 6),
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: isSelected
                    ? ColorConstant.whiteColor
                    : const Color(0xff787878),
                borderRadius: BorderRadius.circular(65),
              ),
              child: Center(
                child: Text(
                  "50",
                  style: AppTextTheme.medium.copyWith(
                      color: isSelected
                          ? ColorConstant.primaryColor
                          : ColorConstant.whiteColor,
                      fontSize: 11),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
