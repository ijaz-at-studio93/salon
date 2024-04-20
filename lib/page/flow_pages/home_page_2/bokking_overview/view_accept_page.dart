import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/page/flow_pages/home_page_2/bokking_overview/after_accepcting_page.dart';
import 'package:salon/project_specific/button_widget.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';

import '../../../../constant/assetsconstant.dart';

class ViewAcceptPage extends StatefulWidget {
  const ViewAcceptPage({super.key});

  @override
  State<ViewAcceptPage> createState() => _ViewAcceptPageState();
}

class _ViewAcceptPageState extends State<ViewAcceptPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.whiteColor,
      appBar: const AppBarWidget(
        nameOfScreen: "Booking Overview",
        isBackIcon: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: ColorConstant.bgColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Opted For",
                        style: AppTextTheme.medium.copyWith(
                            color: ColorConstant.grayTextColor, fontSize: 16),
                      ),
                      Text(
                        "Home Service",
                        style: AppTextTheme.bold.copyWith(
                            color: ColorConstant.primaryColor, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Container(
                  color: ColorConstant.whiteColor,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Booking ID",
                                style: AppTextTheme.regular.copyWith(
                                    fontSize: 13,
                                    color: ColorConstant.grayTextColor),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "AGSDG765657",
                                style: AppTextTheme.bold.copyWith(
                                    fontSize: 16,
                                    color: ColorConstant.blackColor),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Date",
                                style: AppTextTheme.regular.copyWith(
                                    fontSize: 13,
                                    color: ColorConstant.grayTextColor),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "AGSDG765657",
                                style: AppTextTheme.bold.copyWith(
                                    fontSize: 16,
                                    color: ColorConstant.blackColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Slot Time",
                                style: AppTextTheme.regular.copyWith(
                                    fontSize: 13,
                                    color: ColorConstant.grayTextColor),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(
                                    "2:00-4:00 PM",
                                    style: AppTextTheme.bold.copyWith(
                                        fontSize: 16,
                                        color: ColorConstant.blackColor),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Status",
                                style: AppTextTheme.regular.copyWith(
                                    fontSize: 13,
                                    color: ColorConstant.grayTextColor),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Pending",
                                style: AppTextTheme.bold.copyWith(
                                    fontSize: 16,
                                    color: const Color(0xff92AD25)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 1.5,
                  width: Get.width,
                  color: ColorConstant.bgColor,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Customer Details",
                        style: AppTextTheme.medium.copyWith(
                            color: ColorConstant.grayTextColor, fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Name",
                            style: AppTextTheme.medium.copyWith(
                                color: ColorConstant.grayTextColor,
                                fontSize: 16),
                          ),
                          Text(
                            "Tilak Chauhan",
                            style: AppTextTheme.bold.copyWith(
                                color: ColorConstant.blackColor, fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Phone",
                            style: AppTextTheme.medium.copyWith(
                                color: ColorConstant.grayTextColor,
                                fontSize: 16),
                          ),
                          Text(
                            "900-XX-XXXX",
                            style: AppTextTheme.bold.copyWith(
                                color: ColorConstant.blackColor, fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Address",
                        style: AppTextTheme.medium.copyWith(
                            color: ColorConstant.grayTextColor, fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: Get.width * 0.4,
                            child: Text(
                              "Akshya Nagar 1st Block 1st Cross, Rammurthy nagar, Bangalore-560016",
                              style: AppTextTheme.bold.copyWith(
                                  color: ColorConstant.blackColor,
                                  fontSize: 16),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: ColorConstant.lightColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(
                                "3.5 Km Away",
                                style: AppTextTheme.medium.copyWith(
                                    color: ColorConstant.primaryColor,
                                    fontSize: 12),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 50,
                  width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(
                      color: ColorConstant.primaryColor,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                            color: ColorConstant.primaryColor,
                            shape: BoxShape.circle),
                        child: Center(
                          child: Image.asset(
                            AssetsConstant.map,
                            height: 10,
                            width: 10,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Get Direction",
                        style: AppTextTheme.medium.copyWith(
                            color: ColorConstant.primaryColor, fontSize: 16),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 1.5,
                  width: Get.width,
                  color: ColorConstant.bgColor,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Underarm shaving",
                        style: AppTextTheme.medium.copyWith(
                            color: ColorConstant.blackColor, fontSize: 16),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: ColorConstant.lightColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Icon(
                              Icons.add,
                              color: ColorConstant.primaryColor,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "Add Category",
                              style: AppTextTheme.regular.copyWith(
                                  color: ColorConstant.primaryColor,
                                  fontSize: 14),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                _headerWidget(
                    color: ColorConstant.review,
                    title: "2 Products",
                    titleValue: "Hair Cut"),
                _headerValueWidget(title: "Hair Cut", titleValue: ""),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: ButtonWidget(
              buttonTitleText: "Accept ",
              onPress: () {
                Get.to(()=> const AfterAcceptingPage());
              },
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
            titleValue,
            style: AppTextTheme.bold
                .copyWith(color: ColorConstant.blackColor, fontSize: 14),
          ),
          Text(
            title,
            style: AppTextTheme.regular
                .copyWith(color: ColorConstant.blackColor, fontSize: 14),
          ),
        ],
      ),
    );
  }

  /*---------------- Header Value Widget ----------- */
  _headerValueWidget({required String title, required String titleValue}) {
    return Container(
      color: Colors.transparent,
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
