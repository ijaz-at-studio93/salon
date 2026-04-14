import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/page/home/transaction_history_page.dart';
import 'package:salon/project_specific/progressbar_view.dart';
import 'package:salon/project_specific/custom_tab_bar.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:salon/util/NoItemsWidget.dart';
import '../salon_profile_complete/complete_profile_page.dart';
import '../salon_profile_complete/document_submitted_page.dart';
import 'booking_history_page.dart';
import 'widget/earning_widget.dart';

// ✅ Added correct imports for navigation

import 'package:salon/page/review_rating/review_and_rating_page.dart';

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
                      if (_homeController
                              .getSalonDashboardModel.data?.isUpfront ==
                          true)
                        _walletBalanceWidget(),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              if (_homeController
                                      .getSalonDashboardModel.data?.isUpfront !=
                                  true)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 16),
                                  child: Row(
                                    children: [
                                      // 🟣 TOTAL EARNING navigates to Transaction Page
                                      Expanded(
                                        child: EarningWidget(
                                          color: ColorConstant.primaryColor,
                                          title: "Total Earning",
                                          subTitle: "",
                                          amount:
                                              "₹ ${_homeController.getSalonDashboardModel.data?.totalEarnings}",
                                          callback: () {
                                            Get.to(() =>
                                                const TransactionHistoryPage());
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 16),

                                      // 🟠 RATING navigates to Review & Rating Page
                                      Expanded(
                                        child: EarningWidget(
                                          callback: () {
                                            Get.to(() =>
                                                const ReviewAndRatingPage());
                                          },
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
                              _statCards(),
                              // Padding(
                              //   padding: const EdgeInsets.symmetric(
                              //       horizontal: 20, vertical: 16),
                              //   child: Row(
                              //     children: [
                              //       Expanded(
                              //         child: BookingWidget(
                              //           callback: () {
                              //             Get.to(
                              //                 () => const BookingHistoryPage());
                              //           },
                              //           color: ColorConstant.grayTextColor
                              //               .withOpacity(0.1),
                              //           amount:
                              //               "${_homeController.getSalonDashboardModel.data?.distributedRevenue?.bookingCount}",
                              //           title: "Total bookings",
                              //           imageUrl:
                              //               AssetsConstant.totalBookingsIcon,
                              //           imageColor:
                              //               ColorConstant.orangeContainer,
                              //           total: "",
                              //           valueColor:
                              //               ColorConstant.totalContainer,
                              //         ),
                              //       ),
                              //       const SizedBox(width: 12),
                              //       Expanded(
                              //         child: BookingWidget(
                              //           callback: () {},
                              //           color: ColorConstant.grayTextColor
                              //               .withOpacity(0.1),
                              //           amount:
                              //               "${_homeController.getSalonDashboardModel.data?.distributedRevenue?.bookingRevenue}",
                              //           title: "Total Revenue",
                              //           imageUrl:
                              //               AssetsConstant.totalRevenueIcon,
                              //           imageColor:
                              //               ColorConstant.totalRevenueContainer,
                              //           total: "",
                              //           valueColor:
                              //               ColorConstant.totalContainer,
                              //         ),
                              //       )
                              //     ],
                              //   ),
                              // ),
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
                  ? const DocumentSubmittedPage()
                  : const CompleteProfilePage(),
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
          ],
        ),
      ),
    );
  }

  /*----------- Tab Bar variable  ----------- */
  String? dashboard = "0";

  /*------------------- Switch Tab Stylist & Salon -------------------*/
  Widget _dashBoardTabBar() {
    return CustomTabBar(
      tabs: const [
        CustomTabItem(value: "0", label: "All"),
        CustomTabItem(value: "1", label: "This Month"),
        CustomTabItem(value: "2", label: "This Week"),
        CustomTabItem(value: "3", label: "Today"),
      ],
      selectedValue: dashboard ?? "0",
      onChanged: (value) {
        setState(() => dashboard = value);
        const dist = {
          "0": "all_time",
          "1": "monthly",
          "2": "weekly",
          "3": "daily",
        };
        _homeController.doGetSalonDashBoard(distribution: dist[value]!);
      },
    );
  }

  /*----------------- Report Analytics --------------*/
  _reportAnalytics() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: Get.width,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: ColorConstant.lightGreyColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            "Analytics",
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
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: SizedBox(
                            width: Get.width * 0.2,
                            child: Text(
                              _homeController.getSalonDashboardModel.data
                                      ?.distributedArtistAnalytics?[i].name ??
                                  "",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: AppTextTheme.semibold.copyWith(
                                  color: ColorConstant.blackColor,
                                  fontSize: 13),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              _tipBar(
                                ratingValue: _homeController
                                        .getSalonDashboardModel
                                        .data
                                        ?.distributedArtistAnalytics?[i]
                                        .rating ??
                                    0,
                                pct: double.parse(_homeController
                                            .getSalonDashboardModel
                                            .data
                                            ?.distributedArtistAnalytics?[i]
                                            .rating
                                            .toString() ??
                                        "0") /
                                    100,
                                color: const Color(0xffCD73B4),
                              ),
                              const SizedBox(height: 6),
                              _tipBar(
                                ratingValue: _homeController
                                        .getSalonDashboardModel
                                        .data
                                        ?.distributedArtistAnalytics?[i]
                                        .serviceDone ??
                                    0,
                                pct: double.parse(_homeController
                                            .getSalonDashboardModel
                                            .data
                                            ?.distributedArtistAnalytics?[i]
                                            .serviceDone
                                            .toString() ??
                                        "0") /
                                    100,
                                color: const Color(0xFF8565D0),
                              ),
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
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: List.generate(
          //     data.length,
          //     (index) => Center(
          //       child: Text(
          //         "${data[index]}",
          //         style: AppTextTheme.medium.copyWith(
          //             color: ColorConstant.grayTextColor, fontSize: 13),
          //       ),
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                        color: const Color(0xffCD73B4),
                        borderRadius: BorderRadius.circular(3)),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Rating Received",
                    style: AppTextTheme.regular.copyWith(
                        color: ColorConstant.blackColor, fontSize: 13),
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                        color: const Color(0xFF8565D0),
                        borderRadius: BorderRadius.circular(3)),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Service Done",
                    style: AppTextTheme.regular.copyWith(
                        color: ColorConstant.blackColor, fontSize: 13),
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

  get transaction_details_page => null;

  get transaction_history_page => null;

  Widget _tipBar({
    required num ratingValue,
    required double pct,
    required Color color,
  }) {
    const double badgeSize = 20;
    const double barHeight = 12;
    return LayoutBuilder(
      builder: (context, constraints) {
        final double filledWidth =
            (constraints.maxWidth - badgeSize) * pct.clamp(0.0, 1.0);
        return SizedBox(
          height: badgeSize,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.centerLeft,
            children: [
              // Filled portion
              Positioned(
                left: 0,
                top: (badgeSize - barHeight) / 2,
                bottom: (badgeSize - barHeight) / 2,
                width: filledWidth + badgeSize / 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              // Badge at tip
              Positioned(
                left: filledWidth,
                top: 0,
                child: Container(
                  width: badgeSize,
                  height: badgeSize,
                  decoration: const BoxDecoration(
                    color: Color(0XFFD9D9D9),
                    shape: BoxShape.circle,
                    // border: Border.all(color: color.withOpacity(0.4), width: 1),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: color.withOpacity(0.2),
                    //     blurRadius: 4,
                    //     offset: const Offset(0, 2),
                    //   ),
                    // ],
                  ),
                  alignment: Alignment.center,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: ratingValue.toDouble()),
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeOut,
                    builder: (context, val, _) {
                      final display = ratingValue % 1 != 0
                          ? val.toStringAsFixed(1)
                          : val.toInt().toString();
                      return Text(
                        display,
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: ColorConstant.blackColor,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _statCard({
    required String title,
    required num value,
    required Color color,
    VoidCallback? onTap,
  }) {
    final isDecimal = value % 1 != 0;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(
            color: const Color(0xffd9d9d9).withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: AppTextTheme.semibold
                    .copyWith(fontSize: 15, color: color.withOpacity(0.7)),
              ),
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: value.toDouble()),
                duration: const Duration(milliseconds: 1200),
                curve: Curves.easeOut,
                builder: (context, val, _) {
                  final display = isDecimal
                      ? val.toStringAsFixed(1)
                      : val.toInt().toString();
                  return IntrinsicWidth(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 60,
                          child: Text(
                            display,
                            style: TextStyle(
                              fontSize: 48,
                              color: color,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Container(
                          height: 3,
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCards() {
    final data = _homeController.getSalonDashboardModel.data;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          _statCard(
            title: "Rating",
            value: data?.ratingReview?.rating ?? 0,
            color: const Color(0xffCD73B4),
            onTap: () => Get.to(() => const ReviewAndRatingPage()),
          ),
          const SizedBox(width: 14),
          _statCard(
            title: "Bookings",
            value: data?.distributedRevenue?.bookingCount ?? 0,
            color: ColorConstant.primaryColor,
            onTap: () =>
                Get.to(() => const BookingHistoryPage(initialTab: "1")),
          ),
        ],
      ),
    );
  }

  Widget _walletBalanceWidget() {
    final data = _homeController.getSalonDashboardModel.data;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xff8565D0).withOpacity(0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 🔵 Recharge Button
          GestureDetector(
            onTap: () {
              // const dist = {
              //   "0": "all_time",
              //   "1": "monthly",
              //   "2": "weekly",
              //   "3": "daily",
              // };
              _homeController.doRequestSalonRecharge(
                  // distribution: dist[dashboard ?? "0"] ?? "all_time",
                  );
            },
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xff01AB4D)
                    .withOpacity(0.2), // ✅ light green bg
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xff039544)
                      .withOpacity(0.7), // ✅ subtle border
                  width: 1,
                ),
              ),
              child: const Center(
                child: Text(
                  "Recharge",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff039544), // ✅ dark green text
                  ),
                ),
              ),
            ),
          ),

          // 💰 Wallet Info
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Wallet Balance",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(
                "₹ ${data?.walletBalance ?? 0}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff8565D0),
                ),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () {
                  Get.to(() => const TransactionHistoryPage());
                },
                child: const Text(
                  "View Transactions",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                  ),
                ),
              )
            ],
          ),

          const SizedBox(width: 60), // spacing balance
        ],
      ),
    );
  }
}
