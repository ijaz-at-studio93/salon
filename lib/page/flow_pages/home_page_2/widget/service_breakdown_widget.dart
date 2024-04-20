import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/text_theme.dart';

class ServiceBreakdownWidget extends StatelessWidget {
  final String imageUrl;
  final String count;
  final String name;
  const ServiceBreakdownWidget(
      {super.key,
      required this.imageUrl,
      required this.count,
      required this.name});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Image.asset(
          imageUrl,
          height: 52,
          width: 52,
        ),
        Positioned(
          bottom: -15,
          child: Column(
            children: [
              Text(
                count,
                style: AppTextTheme.bold
                    .copyWith(color: ColorConstant.blackColor, fontSize: 15),
              ),
              SizedBox(
                width: Get.width * 0.16,
                child: Center(
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextTheme.medium.copyWith(
                        fontSize: 15, color: ColorConstant.grayTextColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
