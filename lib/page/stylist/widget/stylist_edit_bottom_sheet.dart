import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/page/stylist/add_stylist/add_stylist_page.dart';
import 'package:salon/page/stylist/add_stylist/select_service_page.dart';
import '../../../project_specific/text_theme.dart';

class StylistEditBottomSheet extends StatefulWidget {
  final String artistId;
  const StylistEditBottomSheet({super.key, required this.artistId});

  @override
  State<StylistEditBottomSheet> createState() => _StylistEditBottomSheetState();
}

class _StylistEditBottomSheetState extends State<StylistEditBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.27,
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
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    textScaler: const TextScaler.linear(0.85),
                    style: AppTextTheme.regular.copyWith(
                        color: ColorConstant.whiteColor, fontSize: 19),
                  ),
                ),
                Text(
                  "Edit",
                  textScaler: const TextScaler.linear(0.85),
                  style: AppTextTheme.bold
                      .copyWith(color: ColorConstant.whiteColor, fontSize: 19),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(CupertinoIcons.xmark_circle,
                  color: Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          editRowCustomWidget(
              title: "Service",
              onTap: () {
                Navigator.pop(context);
                Get.to(() => SelectServicePage(
                      isUpdate: true,
                      artistId: widget.artistId,
                      name: "",
                      phone: "",
                      experience: "",
                      whatsappNo: "",
                      password: "",
                      isHomeService: false,
                      gender: "",
                      image: File(""),
                    ));
              }),
          const Divider(
            thickness: 1,
            color: ColorConstant.blackColor,
          ),
          editRowCustomWidget(
              title: "Basic Info",
              onTap: () {
                Navigator.pop(context);
                Get.to(() => AddStylistPage(
                      isBasicInfoUpdate: true,
                      artistId: widget.artistId,
                    ));
              }),
        ],
      ),
    );
  }

  /*------------ Edit Row  List Tile ---------------*/
  editRowCustomWidget({required String title, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 50,
          width: Get.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTextTheme.medium
                    .copyWith(color: ColorConstant.blackColor, fontSize: 16),
              ),
              const Icon(Icons.arrow_forward_ios_sharp),
            ],
          ),
        ),
      ),
    );
  }
}
