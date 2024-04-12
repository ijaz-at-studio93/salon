import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/page/adding_service/widget/reset_and_add_row_widget.dart';
import 'package:salon/page/adding_service/widget/service_product_list_title_widget.dart';
import 'package:salon/page/auth/login_page.dart';

import '../../project_specific/button_widget.dart';
import '../../project_specific/text_theme.dart';

class ServicePreviewPage extends StatefulWidget {
  const ServicePreviewPage({super.key});

  @override
  State<ServicePreviewPage> createState() => _ServicePreviewPageState();
}

class _ServicePreviewPageState extends State<ServicePreviewPage> {
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
                  "Preview",
                  textScaler: const TextScaler.linear(0.85),
                  style: AppTextTheme.bold
                      .copyWith(color: ColorConstant.whiteColor, fontSize: 19),
                ),
                const SizedBox(),
                const SizedBox()
              ],
            ),
          ),
          _countRowWidget(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _headerWidget(
                      color: ColorConstant.review,
                      titleValue: "Hair Spa",
                      title: "Service Name"),
                  _headerWidget(
                      color: Colors.transparent,
                      titleValue: "Hair",
                      title: "Category"),
                  _headerWidget(
                      color: ColorConstant.review,
                      titleValue: "₹3988/-",
                      title: "Service Price"),
                  const SizedBox(height: 5),
                  _headerWidthImageWidget(
                      image:
                          "https://images.unsplash.com/photo-1633332755192-727a05c4013d?q=80&w=2080&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                      title: "Services Image"),
                  const SizedBox(height: 5),
                  _headerWidget(
                      color: ColorConstant.review,
                      titleValue: "3 Added",
                      title: "Product"),
                  ListView.separated(
                      separatorBuilder: (context, index) {
                        return const Divider(
                          color: ColorConstant.dividerColor,
                          indent: 20,
                          endIndent: 20,
                        );
                      },
                      padding: EdgeInsets.zero,
                      itemCount: 5,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: ServiceProductListTileWidget(
                            onPress: () {},
                          ),
                        );
                      }),
                ],
              ),
            ),
          ),
          ResetAndAddRowWidget(
            buttonRest: "Edit",
            buttonAdd: "Save",
            reset: () {
              Get.back();
            },
            add: () {
              Get.back();
              Get.offAll(() => const LoginPage());
            },
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
                height: 30,
                width: 30,
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
                height: 30,
                width: 30,
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
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(right: 60, left: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Details",
                  textScaler: const TextScaler.linear(0.85),
                  style: AppTextTheme.regular.copyWith(
                      color: ColorConstant.grayTextColor, fontSize: 12),
                ),
                Text(
                  "Preview",
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

  /*-----------------  header With  Image ---------------*/
  _headerWidthImageWidget({required String title, required String image}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextTheme.regular
                .copyWith(color: ColorConstant.blackColor, fontSize: 14),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.network(
              image,
              height: 41,
              width: 41,
            ),
          ),
        ],
      ),
    );
  }
}
