import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/text_theme.dart';

class BookingWidget extends StatelessWidget {
  final Color color;
  final Color imageColor;
  final Color valueColor;
  final String imageUrl;
  final String title;
  final String amount;
  final String total;
  final VoidCallback callback;
  const BookingWidget(
      {super.key,
      required this.color,
      required this.imageColor,
      required this.valueColor,
      required this.imageUrl,
      required this.title,
      required this.amount,
      required this.total, required this.callback});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        width: Get.width,
        padding: const EdgeInsets.only(left: 17, right: 18, top: 16,bottom: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(7)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: 48,
                height: 48,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: imageColor),
                child: Center(
                  child: Image.asset(
                    imageUrl,
                    width: 26,
                    height: 26,
                    fit: BoxFit.cover,
                  ),
                )),
            const SizedBox(height: 13),
            Text(
              title,
              style: AppTextTheme.medium
                  .copyWith(fontSize: 14, color: ColorConstant.blackColor),
            ),
            const SizedBox(height: 12),
            Text(
              amount,
              style: AppTextTheme.bold.copyWith(
                color: imageColor,
                fontSize: 20,
              ),
            ),


          ],
        ),
      ),
    );
  }
}
