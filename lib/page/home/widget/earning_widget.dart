import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/text_theme.dart';

class EarningWidget extends StatelessWidget {
  final Color color;
  final String title;
  final String amount;
  final String subTitle;
  final VoidCallback callback;
  const EarningWidget(
      {super.key,
      required this.color,
      required this.title,
      required this.amount,
      required this.subTitle, required this.callback});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(7),
        ),
        padding: const EdgeInsets.only(left: 18, right: 18, top: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextTheme.medium
                  .copyWith(color: ColorConstant.whiteColor, fontSize: 14),
            ),
            const SizedBox(height: 10),
            Text(
              amount,
              style: AppTextTheme.bold
                  .copyWith(color: ColorConstant.whiteColor, fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              subTitle,
              textScaler: const TextScaler.linear(0.85),
              style: AppTextTheme.medium
                  .copyWith(color: ColorConstant.whiteColor, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
