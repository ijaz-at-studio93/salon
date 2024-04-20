import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';

import '../../project_specific/text_theme.dart';
import '../stylist/stylist_page.dart';
import 'add_service_page.dart';

class AddServiceBottomSheetPage extends StatefulWidget {
  const AddServiceBottomSheetPage({super.key});

  @override
  State<AddServiceBottomSheetPage> createState() =>
      _AddServiceBottomSheetPageState();
}

class _AddServiceBottomSheetPageState extends State<AddServiceBottomSheetPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.36,
      width: Get.width,
      decoration: const BoxDecoration(
        color: ColorConstant.whiteColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          topLeft: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 71,
            width: Get.width,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(
              color: ColorConstant.primaryColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16),
                topLeft: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                Text(
                  "What you want to add?",
                  textScaler: const TextScaler.linear(0.85),
                  style: AppTextTheme.bold
                      .copyWith(color: ColorConstant.whiteColor, fontSize: 19),
                ),
                IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      CupertinoIcons.xmark,
                      color: ColorConstant.whiteColor,
                    ))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: (){
                    Get.back();
                    Get.to(()=>const StylistPage());
                  },
                  child: Container(
                    width: 170,
                    padding: const EdgeInsets.all(50),
                    decoration: BoxDecoration(
                        color: ColorConstant.whiteColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: ColorConstant.addServiceBorderColor)),
                    child: Column(
                      children: [
                        Image.asset(
                          AssetsConstant.stylist,
                          height: 54,
                          width: 54,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "Stylist",
                          style: AppTextTheme.regular
                              .copyWith(color: ColorConstant.blackColor, fontSize: 14),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Get.back();
                    Get.to(()=> const AddServicePage());
                  },
                  child: Container(
                    width: 170,
                    padding: const EdgeInsets.all(50),
                    decoration: BoxDecoration(
                        color: ColorConstant.whiteColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: ColorConstant.addServiceBorderColor)),
                    child: Column(
                      children: [
                        Image.asset(
                          AssetsConstant.service,
                          height: 54,
                          width: 54,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "Service",
                          style: AppTextTheme.regular
                              .copyWith(color: ColorConstant.blackColor, fontSize: 14),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )

        ],
      ),
    );
  }
}
