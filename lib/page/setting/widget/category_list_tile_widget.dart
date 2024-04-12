import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/text_theme.dart';

class CategoryListTileWidget extends StatelessWidget {
  final String title;
  final VoidCallback onPress;
  const CategoryListTileWidget({super.key, required this.title, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextTheme.medium
              .copyWith(fontSize: 14, color: ColorConstant.blackColor),
        ),
        GestureDetector(
          onTap: onPress,
          child: Container(
            width: Get.width * 0.2,
            height: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: ColorConstant.primaryColor,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AssetsConstant.editIcon,
                  height: 14,
                  width: 12,
                ),
                const SizedBox(width: 5),
                Text(
                  "Edit",
                  style: AppTextTheme.regular
                      .copyWith(color: ColorConstant.primaryColor, fontSize: 13),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
