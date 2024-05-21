import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/page/home/widget/booking_widget.dart';
import 'package:salon/page/profile/document_submitted_page.dart';
import 'package:salon/project_specific/progressbar_view.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:vertical_barchart/vertical-barchart.dart';
import 'package:vertical_barchart/vertical-barchartmodel.dart';
import 'widget/earning_widget.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _homeController = Get.find<HomeController>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _homeController.doCheckEligibility();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _homeController.eligibility
          ? Container(
              color: ColorConstant.bgColor,
              child: Column(
                children: [
                  _headerWidget(),
                    Expanded(
                      child: _homeController.showProgress
                          ? const ProgressBarView()
                          : SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 16),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: EarningWidget(
                                            color: ColorConstant.primaryColor,
                                            title: "Total Earning",
                                            subTitle: "+17.09% than yesterday",
                                            amount: "₹4000,000",
                                            callback: () {},
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: EarningWidget(
                                            callback: () {},
                                            color: ColorConstant.orangeDotColor,
                                            title: "Rating",
                                            subTitle: "983 Reviews",
                                            amount: "4.3",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  _dashBoardTabBar(),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 16),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: BookingWidget(
                                            callback: () {},
                                            color: ColorConstant.grayTextColor
                                                .withOpacity(0.1),
                                            amount: "40",
                                            title: "Total bookings",
                                            imageUrl: AssetsConstant
                                                .totalBookingsIcon,
                                            imageColor:
                                                ColorConstant.orangeContainer,
                                            total: "+25",
                                            valueColor:
                                                ColorConstant.totalContainer,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: BookingWidget(
                                            callback: () {},
                                            color: ColorConstant.grayTextColor
                                                .withOpacity(0.1),
                                            amount: "40",
                                            title: "Total Revenue",
                                            imageUrl:
                                                AssetsConstant.totalRevenueIcon,
                                            imageColor: ColorConstant
                                                .totalRevenueContainer,
                                            total: "+25",
                                            valueColor:
                                                ColorConstant.totalContainer,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _reportAnalytics(),
                                  const SizedBox(height: 25),
                                ],
                              ),
                            ),
                    ),

                ],
              ),
            )
          : const DocumentSubmittedPage(),
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
                    child: Center(
                      child: Image.asset(
                        AssetsConstant.search,
                        height: 20,
                        width: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
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
                        color: ColorConstant.primaryColor,
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
      colors: [ColorConstant.primaryColor, Colors.transparent],
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
      colors: [ColorConstant.primaryColor, Colors.transparent],
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
      colors: [ColorConstant.primaryColor, Colors.transparent],
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
      colors: [ColorConstant.primaryColor, Colors.transparent],
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
