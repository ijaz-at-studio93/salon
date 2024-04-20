import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:get/get.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/page/flow_pages/home_page_2/blog/bloag_add_sheet_page.dart';
import 'package:salon/page/flow_pages/home_page_2/bokking_overview/booking_overview_widget.dart';
import 'package:salon/page/flow_pages/home_page_2/widget/rating_service_row_widget.dart';
import 'package:salon/page/flow_pages/home_page_2/widget/service_breakdown_widget.dart';

import '../../../constant/assetsconstant.dart';
import '../../../project_specific/status_bar_color_appbar.dart';
import '../../../project_specific/text_theme.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.whiteColor,
      appBar: statusBarTheme(context),
      body: Column(
        children: [
          _headerWidget(),
          Container(height: 1, color: ColorConstant.bgColor),
          Expanded(
            child: ListView(
              children: [
                _dashBoardTabBar(),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: RatingServicesRowWidget(
                          image: AssetsConstant.overallDoneIcon,
                          title: "Overall Rating",
                          titleValue: "4.2",
                          color: ColorConstant.primaryColor,
                          subTitleValue: "+2.1 % Today",
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: RatingServicesRowWidget(
                          image: AssetsConstant.serviceDoneIcon,
                          title: "Service Done ",
                          titleValue: "12",
                          color: ColorConstant.totalRevenueContainer,
                          subTitleValue: "+10 Today",
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        )),
                        context: context,
                        builder: (context) {
                          return const BlogAddSheetPage();
                        });
                  },
                  child: Container(
                    width: Get.width,
                    height: Get.height * 0.16,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        color: ColorConstant.gray),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: Text(
                            "Service Breakdown",
                            style: AppTextTheme.bold.copyWith(
                                color: ColorConstant.blackColor, fontSize: 13),
                          ),
                        ),
                        const Row(
                          children: [
                            Expanded(
                              child: ServiceBreakdownWidget(
                                imageUrl: AssetsConstant.haircutImage,
                                count: '5',
                                name: 'Haircut',
                              ),
                            ),
                            Expanded(
                              child: ServiceBreakdownWidget(
                                imageUrl: AssetsConstant.facialImage,
                                count: '5',
                                name: 'Facia...',
                              ),
                            ),
                            Expanded(
                              child: ServiceBreakdownWidget(
                                imageUrl: AssetsConstant.haircImage,
                                count: '5',
                                name: 'Hairc...',
                              ),
                            ),
                            Expanded(
                              child: ServiceBreakdownWidget(
                                imageUrl: AssetsConstant.reboImage,
                                count: '2',
                                name: 'Rebo...',
                              ),
                            ),
                            Expanded(
                              child: ServiceBreakdownWidget(
                                imageUrl: AssetsConstant.maniImage,
                                count: '1',
                                name: 'Mani...',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                /*---------------- Booking Overview --------------*/
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Bookings Overview",
                        textScaler: const TextScaler.linear(0.85),
                        style: AppTextTheme.medium.copyWith(
                            color: ColorConstant.grayTextColor, fontSize: 23),
                      ),
                    ),
                    const SizedBox(height: 15),
                    _bookingOverView(),
                    bookingOverView == "0"
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: 5,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                child: BookingOverviewWidget(isAccepted: false),
                              );
                            })
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: 5,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                child: BookingOverviewWidget(isAccepted: true),
                              );
                            })
                  ],
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: ColorConstant.whiteColor,
                    border:
                        Border.all(color: ColorConstant.grayColor, width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network(
                              "https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                              height: 46,
                              width: 46,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Anirudh Tiwari",
                                style: AppTextTheme.bold.copyWith(
                                    color: ColorConstant.blackColor,
                                    fontSize: 19),
                              ),
                              Text(
                                "2.5 Km Away",
                                style: AppTextTheme.medium.copyWith(
                                    color: ColorConstant.grayTextColor,
                                    fontSize: 13),
                              ),
                            ],
                          )
                        ],
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: ColorConstant.callColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: ColorConstant.primaryColor,
                            ),
                          ),
                          child: Center(
                            child: Image.asset(
                              AssetsConstant.callIcon,
                              width: 20,
                              height: 20,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: ColorConstant.callColor,
                            borderRadius: BorderRadius.circular(65),
                            border: Border.all(
                              color: ColorConstant.primaryColor,
                            ),
                          ),
                          child: Center(
                              child: Text(
                            "Get Direction",
                            style: AppTextTheme.medium
                                .copyWith(color: ColorConstant.primaryColor),
                          )),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  /*--------------- Header Widget ------------*/
  _headerWidget() {
    return Container(
      height: 60,
      color: ColorConstant.whiteColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "My Dashboard",
              style: AppTextTheme.bold
                  .copyWith(color: ColorConstant.blackColor, fontSize: 19),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 46,
                    width: 46,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorConstant.primaryColor.withOpacity(0.2),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Image.asset(
                            AssetsConstant.notificationIcon,
                            height: 20,
                            width: 20,
                          ),
                        ),
                        Positioned(
                          top: 10,
                          left: 23,
                          child: Container(
                            height: 10,
                            width: 10,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: ColorConstant.orangeDotColor),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 46,
                    width: 46,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorConstant.redColor,
                    ),
                    child: Center(
                      child: Image.asset(
                        AssetsConstant.sosIcon,
                        height: 20,
                        width: 20,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  /*----------- Tab Bar variable  ----------- */
  String? dashboard = "0";

  /*------------------- Switch Tab Stylist & Salon -------------------*/
  _dashBoardTabBar() {
    return Container(
      height: 81,
      color: ColorConstant.whiteColor,
      width: Get.width,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: CupertinoSlidingSegmentedControl(
          backgroundColor: ColorConstant.gray,
          padding: const EdgeInsets.all(6),
          groupValue: dashboard,
          thumbColor: ColorConstant.whiteColor,
          children: {
            "0": SizedBox(
              width: Get.width,
              height: Get.height * 0.05,
              child: Center(
                child: Text(
                  "All",
                  style: dashboard == "0"
                      ? AppTextTheme.bold.copyWith(
                          fontSize: 14, color: ColorConstant.blackColor)
                      : AppTextTheme.medium.copyWith(
                          fontSize: 13, color: ColorConstant.grayTextColor),
                ),
              ),
            ),
            "1": Text(
              "Today",
              style: dashboard == "1"
                  ? AppTextTheme.bold
                      .copyWith(fontSize: 14, color: ColorConstant.blackColor)
                  : AppTextTheme.medium.copyWith(
                      fontSize: 13, color: ColorConstant.grayTextColor),
            ),
            "2": Text(
              "This Week",
              style: dashboard == "2"
                  ? AppTextTheme.bold
                      .copyWith(fontSize: 14, color: ColorConstant.blackColor)
                  : AppTextTheme.medium.copyWith(
                      fontSize: 13, color: ColorConstant.grayTextColor),
            ),
            "3": Text(
              "This Month",
              style: dashboard == "3"
                  ? AppTextTheme.bold
                      .copyWith(fontSize: 14, color: ColorConstant.blackColor)
                  : AppTextTheme.medium.copyWith(
                      fontSize: 13, color: ColorConstant.grayTextColor),
            ),
          },
          onValueChanged: (dynamic value) {
            setState(() {
              dashboard = value;
            });
          }),
    );
  }

  /*----------- Tab Bar variable  ----------- */
  String? bookingOverView = "0";

  /*------------------- Switch Tab Stylist & Salon -------------------*/
  _bookingOverView() {
    return Container(
      height: 81,
      color: ColorConstant.whiteColor,
      width: Get.width,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: CupertinoSlidingSegmentedControl(
          backgroundColor: ColorConstant.gray,
          padding: const EdgeInsets.all(6),
          groupValue: bookingOverView,
          thumbColor: ColorConstant.whiteColor,
          children: {
            "0": SizedBox(
              width: Get.width,
              height: Get.height * 0.05,
              child: Center(
                child: Text(
                  "Upcoming",
                  style: bookingOverView == "0"
                      ? AppTextTheme.bold.copyWith(
                          fontSize: 14, color: ColorConstant.blackColor)
                      : AppTextTheme.medium.copyWith(
                          fontSize: 13, color: ColorConstant.grayTextColor),
                ),
              ),
            ),
            "1": Text(
              "Accepted",
              style: bookingOverView == "1"
                  ? AppTextTheme.bold
                      .copyWith(fontSize: 14, color: ColorConstant.blackColor)
                  : AppTextTheme.medium.copyWith(
                      fontSize: 13, color: ColorConstant.grayTextColor),
            ),
          },
          onValueChanged: (dynamic value) {
            setState(() {
              bookingOverView = value;
            });
          }),
    );
  }
}
