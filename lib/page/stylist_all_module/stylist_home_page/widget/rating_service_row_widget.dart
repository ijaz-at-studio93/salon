import 'package:flutter/material.dart';
import 'package:salon/constant/color_constant.dart';

import '../../../../project_specific/text_theme.dart';

class RatingServicesRowWidget extends StatelessWidget {
  final String image;
  final String title;
  final Color color;
  final String titleValue;
  final String subTitleValue;
  const RatingServicesRowWidget(
      {super.key,
      required this.image,
      required this.title,
      required this.color,
      required this.titleValue,
      required this.subTitleValue});

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
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 3)),
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
                textScaler: const TextScaler.linear(0.80),
                style: AppTextTheme.medium
                    .copyWith(color: ColorConstant.blackColor),
              ),
              Text(
                titleValue,
                textScaler: const TextScaler.linear(0.80),
                style: AppTextTheme.bold.copyWith(color: color),
              ),
            ],
          )
        ],
      ),
    );
  }
}
