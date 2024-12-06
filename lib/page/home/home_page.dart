import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/progress_bar/gf_progress_bar.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/page/home/widget/booking_widget.dart';
import 'package:salon/project_specific/progressbar_view.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:salon/util/NoItemsWidget.dart';
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
                                            "₹ ${_homeController.getSalonDashboardModel.data?.totalEarnings}",
                                        callback: () {},
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
                                            "✰ ${_homeController.getSalonDashboardModel.data?.ratingReview?.rating}",
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
          const SizedBox(height: 15),
          _homeController.getSalonDashboardModel.data
                      ?.distributedArtistAnalytics?.isEmpty ??
                  false
              ? const NoItemsWidget(text: "No analytics reports were found.")
              : ListView.builder(
                  itemCount: _homeController.getSalonDashboardModel.data
                          ?.distributedArtistAnalytics?.length ??
                      0,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, i) {
                    return Row(
                      children: [
                        SizedBox(
                          width: Get.width * 0.2,
                          child: Text(
                            _homeController.getSalonDashboardModel.data
                                    ?.distributedArtistAnalytics?[i].name ??
                                "",
                            style: AppTextTheme.medium.copyWith(
                                color: ColorConstant.grayTextColor,
                                fontSize: 13),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              GFProgressBar(
                                  lineHeight: 11,
                                  circleWidth: 0,
                                  isDragable: false,
                                  percentage: double.parse(_homeController
                                              .getSalonDashboardModel
                                              .data
                                              ?.distributedArtistAnalytics?[i]
                                              .rating
                                              .toString() ??
                                          "") /
                                      100,
                                  backgroundColor: Colors.transparent,
                                  progressBarColor: const Color(0xff2178FC)),
                              const SizedBox(height: 4),
                              GFProgressBar(
                                  lineHeight: 11,
                                  circleWidth: 0,
                                  isDragable: false,
                                  percentage: double.parse(_homeController
                                              .getSalonDashboardModel
                                              .data
                                              ?.distributedArtistAnalytics?[i]
                                              .serviceDone
                                              .toString() ??
                                          "") /
                                      100,
                                  backgroundColor: Colors.transparent,
                                  progressBarColor: ColorConstant.service),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
          const Divider(
            color: ColorConstant.dividerColor,
            indent: 60.0,
            endIndent: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              data.length,
              (index) => Center(
                child: Text(
                  "${data[index]}",
                  style: AppTextTheme.medium.copyWith(
                      color: ColorConstant.grayTextColor, fontSize: 13),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
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
                        color: const Color(0xff2178FC),
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

  List data = [
    "0",
    "2",
    "4",
    "6",
    "8",
    "10",
    "12",
  ];
}
