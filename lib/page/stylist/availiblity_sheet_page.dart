import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/page/stylist/widget/set_availability_list_tile_widget.dart';
import 'package:salon/project_specific/button_widget.dart';

import '../../project_specific/text_theme.dart';

class AvailiblitySheetPage extends StatefulWidget {
  const AvailiblitySheetPage({super.key});

  @override
  State<AvailiblitySheetPage> createState() => _AvailiblitySheetPageState();
}

class _AvailiblitySheetPageState extends State<AvailiblitySheetPage> {
  bool isMonth = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.8,
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
                TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      "Cancel",
                      textScaler: const TextScaler.linear(0.85),
                      style: AppTextTheme.regular.copyWith(
                          color: ColorConstant.whiteColor, fontSize: 19),
                    )),
                Text(
                  "Your Approval",
                  textScaler: const TextScaler.linear(0.85),
                  style: AppTextTheme.bold
                      .copyWith(color: ColorConstant.whiteColor, fontSize: 19),
                ),
                const SizedBox(),
                const SizedBox()
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            height: 40,
            width: Get.width,
            color: ColorConstant.disAbleColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "Disable the Stylist For a ",
                      style: AppTextTheme.medium.copyWith(
                          fontSize: 14, color: ColorConstant.blackColor),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Month",
                      style: AppTextTheme.bold.copyWith(
                          fontSize: 14, color: ColorConstant.primaryColor),
                    ),
                  ],
                ),
                CupertinoSwitch(
                  value: isMonth,
                  activeColor: ColorConstant.primaryColor,
                  onChanged: (bool? value) {
                    setState(() {
                      isMonth = value ?? false;
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Set Availability",
              style: AppTextTheme.regular
                  .copyWith(fontSize: 14, color: ColorConstant.grayTextColor),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: 5,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return const SetAvailabilityListTileWidget();
                      }),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ButtonWidget(
                buttonTitleText: "Save",
                onPress: () {
                  Get.back();
                }),
          ),
        ],
      ),
    );
  }
}
