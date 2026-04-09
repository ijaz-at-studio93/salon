import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:get/get.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/text_theme.dart';

class ServiceCountListTileWidget extends StatelessWidget {
  const ServiceCountListTileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      decoration: BoxDecoration(
        color: ColorConstant.gray,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "ID : ",
                    style: AppTextTheme.regular
                        .copyWith(color: ColorConstant.idColor, fontSize: 16),
                  ),
                  Text(
                    "79828AH8918",
                    style: AppTextTheme.regular.copyWith(
                        color: ColorConstant.blackColor, fontSize: 16),
                  ),
                ],
              ),
              Text(
                "2:00 PM - 2:30 PM",
                style: AppTextTheme.regular
                    .copyWith(fontSize: 13, color: ColorConstant.grayTextColor),
              )
            ],
          ),
          const SizedBox(height: 15),
          Dash(
            direction: Axis.horizontal,
            length: Get.width * 0.78,
            dashLength: 2,
            dashColor: const Color(0xffCFCFCF),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        AssetsConstant.topRatedDoneIcon,
                        width: 15,
                        height: 15,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "Rated",
                        style: AppTextTheme.regular.copyWith(
                            color: ColorConstant.grayTextColor, fontSize: 13),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "4.3",
                        style: AppTextTheme.bold.copyWith(
                            fontSize: 13, color: ColorConstant.orangeContainer),
                      )
                    ],
                  ),
                  const SizedBox(width: 10),
                  Row(
                    children: [
                      Text(
                        "Done at",
                        style: AppTextTheme.regular.copyWith(
                            color: ColorConstant.grayTextColor, fontSize: 13),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "Home",
                        style: AppTextTheme.bold.copyWith(
                            fontSize: 13, color: ColorConstant.blackColor),
                      )
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: ColorConstant.viewDetailsColor,
                  borderRadius: BorderRadius.circular(36),
                ),
                child: Center(
                  child: Text(
                    "View Details",
                    style: AppTextTheme.medium.copyWith(
                        color: ColorConstant.blackColor, fontSize: 13),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
