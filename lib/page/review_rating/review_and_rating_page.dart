import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/page/review_rating/widget/by_stylist_card_widget.dart';
import 'package:salon/page/review_rating/widget/overall_rating_card_widget.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';

class ReviewAndRatingPage extends StatefulWidget {
  const ReviewAndRatingPage({super.key});

  @override
  State<ReviewAndRatingPage> createState() => _ReviewAndRatingPageState();
}

class _ReviewAndRatingPageState extends State<ReviewAndRatingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      appBar: const AppBarWidget(
        nameOfScreen: "Complete Profile",
        isBackIcon: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          _stylistAndSalon(),
          const SizedBox(height: 5),
          SizedBox(
            height: 45,
            child: ListView.builder(
                itemCount: 10,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: filterCategory(),
                  );
                }),
          ),
          const SizedBox(height: 20),
          Expanded(
              child: SingleChildScrollView(
            child: Column(children: [
              overall == "0" ?  ListView.separated(
                  separatorBuilder: (context, index) {
                    return Column(
                      children: [
                        const SizedBox(height: 10),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          height: 1,
                          width: Get.width,
                          decoration: const BoxDecoration(
                              color: ColorConstant.grayTextColor),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  },
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 10),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return const OverAllRatingCardWidget();
                  }) : ListView.separated(
                  separatorBuilder: (context, index) {
                    return Column(
                      children: [
                        const SizedBox(height: 10),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          height: 1,
                          width: Get.width,
                          decoration: const BoxDecoration(
                              color: ColorConstant.grayTextColor),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  },
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 10),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return const ByStylistCardWidget();
                  }) ,
            ]),
          )),
        ],
      ),
    );
  }

  /*----------- Tab Bar variable  ----------- */
  String? overall = "0";

  /*------------------- Switch Tab Stylist & Salon -------------------*/
  _stylistAndSalon() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
          color: ColorConstant.whiteColor,
          border: Border.all(color: ColorConstant.primaryColor, width: 2),
          borderRadius: BorderRadius.circular(15)),
      width: Get.width,
      padding: const EdgeInsets.all(2),
      child: CupertinoSlidingSegmentedControl(
          groupValue: overall,
          thumbColor: ColorConstant.whiteColor,
          children: {
            "0": SizedBox(
              width: Get.width,
              height: Get.height * 0.06,
              child: Center(
                child: Text(
                  "Overall",
                  style: AppTextTheme.medium.copyWith(
                      fontSize: 16,
                      color: overall == "0"
                          ? ColorConstant.blackColor
                          : ColorConstant.grayTextColor),
                ),
              ),
            ),
            "1": Text(
              "By Stylist",
              style: AppTextTheme.medium.copyWith(
                  fontSize: 16,
                  color: overall == "1"
                      ? ColorConstant.blackColor
                      : ColorConstant.grayTextColor),
            ),
          },
          onValueChanged: (dynamic value) {
            setState(() {
              overall = value;
            });
          }),
    );
  }

  /*--------------- Filter Category ------------*/
  filterCategory() {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: ColorConstant.whiteColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: ColorConstant.borderColor2),
      ),
      child: Center(
        child: Text(
          "High To Low",
          style: AppTextTheme.medium
              .copyWith(color: ColorConstant.blackColor, fontSize: 13),
        ),
      ),
    );
  }
}
