import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/page/stylist/add_stylist/widget/stylist_product_list_widget.dart';
import 'package:salon/project_specific/button_widget.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';

class AddStylistReviewPage extends StatefulWidget {
  const AddStylistReviewPage({super.key});

  @override
  State<AddStylistReviewPage> createState() => _AddStylistReviewPageState();
}

class _AddStylistReviewPageState extends State<AddStylistReviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.whiteColor,
      appBar: const AppBarWidget(
        nameOfScreen: "Review",
        isBackIcon: true,
      ),
      body: Column(
        children: [
          _countRowWidget(),
          Expanded(
              child: ListView(
            children: [
              _stylistProfilePhoto(),
              _headerWidget(
                  color: Colors.transparent,
                  title: "Unique Scuts ID",
                  titleValue: "AJHUID7686"),
              _headerWidget(
                  color: ColorConstant.review,
                  title: "Name",
                  titleValue: "Daniel William"),
              _headerWidget(
                  color: ColorConstant.review,
                  title: "Whatsapp Number",
                  titleValue: "+91 9009566516"),
              _headerWidget(
                  color: Colors.transparent,
                  title: "Contact Number",
                  titleValue: "+91 9009566516"),
              _headerWidget(
                  color: ColorConstant.review,
                  title: "Service offer",
                  titleValue: "5 Service"),
              ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  separatorBuilder: (context, index) {
                    return const Divider(
                      color: ColorConstant.dividerColor,
                      indent: 20,
                      endIndent: 20,
                    );
                  },
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return StylistProductListWidget(
                      onPress: () {},
                    );
                  })
            ],
          )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: ButtonWidget(
                buttonTitleText: "Done",
                onPress: () {
                  Get.back();
                  Get.back();
                  Get.back();
                  Get.back();
                }),
          ),
        ],
      ),
    );
  }

  /*---------------- Count Row Widget -------------*/
  _countRowWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 20,
                width: 20,
                decoration: const BoxDecoration(
                    color: ColorConstant.primaryColor, shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    "1",
                    textScaler: const TextScaler.linear(0.85),
                    style: AppTextTheme.bold.copyWith(
                        color: ColorConstant.whiteColor, fontSize: 16),
                  ),
                ),
              ),
              Container(
                height: 2,
                width: 80,
                color: ColorConstant.primaryColor,
              ),
              Container(
                height: 20,
                width: 20,
                decoration: const BoxDecoration(
                    color: ColorConstant.primaryColor, shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    "2",
                    textScaler: const TextScaler.linear(0.85),
                    style: AppTextTheme.bold.copyWith(
                        color: ColorConstant.whiteColor, fontSize: 16),
                  ),
                ),
              ),
              Container(
                height: 2,
                width: 80,
                color: ColorConstant.primaryColor,
              ),
              Container(
                height: 20,
                width: 20,
                decoration: const BoxDecoration(
                    color: ColorConstant.primaryColor, shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    "3",
                    textScaler: const TextScaler.linear(0.85),
                    style: AppTextTheme.bold.copyWith(
                        color: ColorConstant.whiteColor, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(right: 60, left: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "basic info",
                  textScaler: const TextScaler.linear(0.85),
                  style: AppTextTheme.regular.copyWith(
                      color: ColorConstant.grayTextColor, fontSize: 12),
                ),
                Text(
                  "Select  Service",
                  textScaler: const TextScaler.linear(0.85),
                  style: AppTextTheme.regular.copyWith(
                      color: ColorConstant.grayTextColor, fontSize: 12),
                ),
                const SizedBox(width: 5),
                Text(
                  "Review",
                  textScaler: const TextScaler.linear(0.85),
                  style: AppTextTheme.regular.copyWith(
                      color: ColorConstant.grayTextColor, fontSize: 12),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  /*----------- Profile Photo -------------*/

  _stylistProfilePhoto() {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: ColorConstant.grayTextColor.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
    );
  }

  /*--------------- Row  Widget -------------*/
  _headerWidget(
      {required Color color,
      required String title,
      required String titleValue}) {
    return Container(
      color: color,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 36,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextTheme.regular
                .copyWith(color: ColorConstant.blackColor, fontSize: 14),
          ),
          Text(
            titleValue,
            style: AppTextTheme.bold
                .copyWith(color: ColorConstant.blackColor, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
