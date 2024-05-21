import 'package:flutter/material.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/text_theme.dart';

class ServiceCountRowWidget extends StatelessWidget {
  final String image;
  final String title;
  final String titleValue;
  const ServiceCountRowWidget(
      {super.key,
      required this.image,
      required this.title,
      required this.titleValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7), color: ColorConstant.gray),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: ColorConstant.serviceColor),
            child: Center(
              child: Image.asset(
                image,
                width: 26,
                height: 26,
              ),
            ),
          ),
          const SizedBox(width: 13),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                textScaler: const TextScaler.linear(0.85),
                style: AppTextTheme.medium
                    .copyWith(color: ColorConstant.blackColor),
              ),
              Text(
                titleValue,
                textScaler: const TextScaler.linear(0.85),
                style: AppTextTheme.bold
                    .copyWith(color: ColorConstant.blueGrayColor),
              ),
            ],
          )
        ],
      ),
    );
  }
}
