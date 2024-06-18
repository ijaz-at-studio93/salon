import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/page/home/widget/booking_widget.dart';
import 'package:salon/project_specific/progressbar_view.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:vertical_barchart/vertical-barchart.dart';
import 'package:vertical_barchart/vertical-barchartmodel.dart';
import '../salon_profile_complete/complete_profile_page.dart';
import '../salon_profile_complete/document_submitted_page.dart';
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
      _homeController.doCheckEligibility(callback: () {
        _homeController.doGetSalonDashBoard(distribution: "all_time");
      });
      _homeController.doGetSalonDocument();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _homeController.showProgress
          ? const ProgressBarView()
          : _homeController.getEligibilityModel.data?.isApproved ?? false
              ? Container(
                  color: ColorConstant.bgColor,
                  child: Column(
                    children: [
                      _headerWidget(),
                      Expanded(
                        child: SingleChildScrollView(
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
                                        subTitle: "",
                                        amount:
                                            "₹${_homeController.getSalonDashboardModel.data?.totalEarnings}",
                                        callback: () {
                                          Get.to(() =>
                                              const CompleteProfilePage());
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: EarningWidget(
                                        callback: () {},
                                        color: ColorConstant.orangeDotColor,
                                        title: "Rating",
                                        subTitle: "",
                                        amount:
                                            "₹${_homeController.getSalonDashboardModel.data?.ratingReview?.rating}",
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
                                        amount:
                                            "${_homeController.getSalonDashboardModel.data?.distributedRevenue?.bookingCount}",
                                        title: "Total bookings",
                                        imageUrl:
                                            AssetsConstant.totalBookingsIcon,
                                        imageColor:
                                            ColorConstant.orangeContainer,
                                        total: "",
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
                                        amount:
                                            "${_homeController.getSalonDashboardModel.data?.distributedRevenue?.bookingRevenue}",
                                        title: "Total Revenue",
                                        imageUrl:
                                            AssetsConstant.totalRevenueIcon,
                                        imageColor:
                                            ColorConstant.totalRevenueContainer,
                                        total: "",
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
              : _homeController.getEligibilityModel.data?.documentData
                          ?.isAllSubmitted ??
                      false
                  ? const CompleteProfilePage()
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
            dashboard = value;
            if (dashboard == "0") {
              setState(() {
                _homeController.doGetSalonDashBoard(distribution: "all_time");
              });
            } else if (dashboard == "1") {
              setState(() {
                _homeController.doGetSalonDashBoard(distribution: "daily");
              });
            } else if (dashboard == "2") {
              setState(() {
                _homeController.doGetSalonDashBoard(distribution: "weekly");
              });
            } else if (dashboard == "3") {
              setState(() {
                _homeController.doGetSalonDashBoard(distribution: "monthly");
              });
            }
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
            data: List.generate(
              _homeController.getSalonDashboardModel.data
                      ?.distributedArtistAnalytics?.length ??
                  0,
              (index) => VBarChartModel(
                index: index,
                label: _homeController.getSalonDashboardModel.data
                        ?.distributedArtistAnalytics?[index].name ??
                    "",
                colors: [ColorConstant.service, Colors.transparent],
                jumlah: double.parse(_homeController.getSalonDashboardModel.data
                        ?.distributedArtistAnalytics?[index].serviceDone
                        .toString() ??
                    ""),
                tooltip: "",
              ),
            ),
            barSize: 12,
            barStyle: BarStyle.DEFAULT,
            showLegend: false,
          ),
          VerticalBarchart(
            background: Colors.transparent,
            maxX: 75,
            data: List.generate(
              _homeController.getSalonDashboardModel.data
                      ?.distributedArtistAnalytics?.length ??
                  0,
              (index) => VBarChartModel(
                index: index,
                label: _homeController.getSalonDashboardModel.data
                        ?.distributedArtistAnalytics?[index].name ??
                    "",
                colors: [ColorConstant.primaryColor, Colors.transparent],
                jumlah: double.parse(_homeController.getSalonDashboardModel.data
                        ?.distributedArtistAnalytics?[index].rating
                        .toString() ??
                    ""),
                tooltip: "",
              ),
            ),
            barSize: 12,
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
}
