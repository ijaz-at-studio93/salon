import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/page/stylist_all_module/widget/service_count_row_widget.dart';
import 'package:salon/project_specific/status_bar_color_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:vertical_barchart/vertical-barchart.dart';
import 'package:vertical_barchart/vertical-barchartmodel.dart';
import 'booking_overview_widget.dart';

class StylistBookingOverViewPage extends StatefulWidget {
  const StylistBookingOverViewPage({super.key});

  @override
  State<StylistBookingOverViewPage> createState() =>
      _StylistBookingOverViewPageState();
}

class _StylistBookingOverViewPageState
    extends State<StylistBookingOverViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.whiteColor,
      appBar: statusBarTheme(context),
      body: Column(
        children: [
          _headerWidget(),
          Container(height: 1, color: ColorConstant.bgColor),
          /*---------------- Booking Overview --------------*/
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ServiceCountRowWidget(
                            image: AssetsConstant.topRatedDoneIcon,
                            title: "Average Rating",
                            titleValue: "4.1",
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ServiceCountRowWidget(
                            image: AssetsConstant.receiveDoneIcon,
                            title: "Top Rated ",
                            titleValue: "12",
                          ),
                        ),
                      ],
                    ),
                  ),
                  _reportAnalytics(),
                  const SizedBox(height: 15),
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
                          }),
                ],
              ),
            ),
          ),
          bookingOverView == "1"
              ? Container(
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
              : const SizedBox(),
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



  /*----------------- Report Analytics --------------*/
  _reportAnalytics() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: Get.width,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: ColorConstant.grayTextColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            "Reports Analytics",
            textScaler: const TextScaler.linear(0.85),
            style: AppTextTheme.bold
                .copyWith(color: ColorConstant.blackColor, fontSize: 20),
          ),
          VerticalBarchart(
            background: Colors.transparent,
            maxX: 75,
            data: bardata,
            barSize: 11,
            barStyle: BarStyle.DEFAULT,
            showLegend: false,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                        color: ColorConstant.service,
                        borderRadius: BorderRadius.circular(3)),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Service Done",
                    style: AppTextTheme.regular.copyWith(
                        color: ColorConstant.grayTextColor, fontSize: 13),
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                        color: ColorConstant.skyBlueColor,
                        borderRadius: BorderRadius.circular(3)),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Ratings",
                    style: AppTextTheme.regular.copyWith(
                        color: ColorConstant.grayTextColor, fontSize: 13),
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  List<VBarChartModel> bardata = [
    const VBarChartModel(
      index: 0,
      label: "Akhil",
      colors: [ColorConstant.service, Colors.transparent],
      jumlah: 20,
      tooltip: "",
    ),
    const VBarChartModel(
      index: 1,
      label: "Akhil",
      colors: [ColorConstant.service, Colors.transparent],
      jumlah: 70,
      tooltip: "",
    ),
    const VBarChartModel(
      index: 2,
      label: "Akhil",
      colors: [ColorConstant.service, Colors.transparent],
      jumlah: 20,
      tooltip: "",
    ),
    const VBarChartModel(
      index: 3,
      label: "Akhil",
      colors: [ColorConstant.service, Colors.transparent],
      jumlah: 70,
      tooltip: "",
    ),
    const VBarChartModel(
      index: 4,
      label: "Akhil",
      colors: [ColorConstant.service, Colors.transparent],
      jumlah: 20,
      tooltip: "",
    ),
    const VBarChartModel(
      index: 5,
      label: "Akhil",
      colors: [ColorConstant.service, Colors.transparent],
      jumlah: 70,
      tooltip: "",
    ),
    const VBarChartModel(
      index: 6,
      label: "Akhil",
      colors: [ColorConstant.service, Colors.transparent],
      jumlah: 50,
      tooltip: "",
    ),
    const VBarChartModel(
      index: 3,
      label: "Akhil",
      colors: [ColorConstant.service, Colors.transparent],
      jumlah: 70,
      tooltip: "",
    ),
  ];
}
