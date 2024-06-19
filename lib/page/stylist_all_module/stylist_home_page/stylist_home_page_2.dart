import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/stylist/stylist_controller.dart';
import 'package:salon/page/stylist_all_module/stylist_home_page/widget/rating_service_row_widget.dart';
import 'package:salon/page/stylist_all_module/stylist_home_page/widget/service_breakdown_widget.dart';
import 'package:salon/project_specific/progressbar_view.dart';
import 'package:salon/util/NoItemsWidget.dart';
import 'package:vertical_barchart/vertical-barchart.dart';
import 'package:vertical_barchart/vertical-barchartmodel.dart';
import '../../../constant/assetsconstant.dart';
import '../../../project_specific/status_bar_color_appbar.dart';
import '../../../project_specific/text_theme.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  final _stylistController = Get.find<StylistController>();

  @override
  void initState() {
    super.initState();
    _stylistController.doGetArtiestDashBoard(distribution: "all_time");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.whiteColor,
      appBar: statusBarTheme(context),
      body: Column(
        children: [
          _headerWidget(),
          Container(height: 1, color: ColorConstant.bgColor),
          Obx(
            () => Expanded(
              child: _stylistController.showProgress
                  ? const ProgressBarView()
                  : ListView(
                      children: [
                        _dashBoardTabBar(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: RatingServicesRowWidget(
                                  image: AssetsConstant.overallDoneIcon,
                                  title: "Overall Rating",
                                  titleValue:
                                      "${_stylistController.getArtiestDashboardModel.data?.ratingData?.rating ?? ""}",
                                  color: ColorConstant.primaryColor,
                                  subTitleValue: "",
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: RatingServicesRowWidget(
                                  image: AssetsConstant.serviceDoneIcon,
                                  title: "Service Done",
                                  titleValue:
                                      "${_stylistController.getArtiestDashboardModel.data?.serviceCountData?.totalServiceCount ?? ""}",
                                  color: ColorConstant.totalRevenueContainer,
                                  subTitleValue: " ",
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
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
                                      color: ColorConstant.blackColor,
                                      fontSize: 13),
                                ),
                              ),
                              _stylistController
                                          .getArtiestDashboardModel
                                          .data
                                          ?.serviceCountData
                                          ?.serviceBreakdown
                                          ?.isEmpty ??
                                      false
                                  ? const NoItemsWidget(
                                      text: "No Any BreakDownService Found",
                                    )
                                  : GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      padding: const EdgeInsets.only(
                                        left: 20.0,
                                        right: 20.0,
                                        bottom: 40.0,
                                      ),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        mainAxisSpacing: 20.0,
                                        crossAxisSpacing: 20.0,
                                        childAspectRatio: 2,
                                      ),
                                      itemCount: _stylistController
                                              .getArtiestDashboardModel
                                              .data
                                              ?.serviceCountData
                                              ?.serviceBreakdown
                                              ?.length ??
                                          0,
                                      itemBuilder: (context, index) {
                                        return ServiceBreakdownWidget(
                                          imageUrl: AssetsConstant.haircutImage,
                                          count:
                                              "${_stylistController.getArtiestDashboardModel.data?.serviceCountData?.serviceBreakdown?[index].count ?? ""}",
                                          name: _stylistController
                                                  .getArtiestDashboardModel
                                                  .data
                                                  ?.serviceCountData
                                                  ?.serviceBreakdown?[index]
                                                  .name ??
                                              "",
                                        );
                                      },
                                    ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _reportAnalytics(),
                      ],
                    ),
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
            dashboard = value;
            if (dashboard == "0") {
              setState(() {
                _stylistController.doGetArtiestDashBoard(
                    distribution: "all_time");
              });
            } else if (dashboard == "1") {
              setState(() {
                _stylistController.doGetArtiestDashBoard(distribution: "daily");
              });
            } else if (dashboard == "2") {
              setState(() {
                _stylistController.doGetArtiestDashBoard(
                    distribution: "weekly");
              });
            } else if (dashboard == "3") {
              setState(() {
                _stylistController.doGetArtiestDashBoard(
                    distribution: "monthly");
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
          _stylistController.getArtiestDashboardModel.data
                      ?.serviceWithReviewCount?.isEmpty ??
                  false
              ? const NoItemsWidget(
                  text: "No DataFound Report Analytics",
                )
              : Column(
                  children: [
                    VerticalBarchart(
                      background: Colors.transparent,
                      maxX: 75,
                      data: List.generate(
                        _stylistController.getArtiestDashboardModel.data!
                                .serviceWithReviewCount?.length ??
                            0,
                        (index) => VBarChartModel(
                          index: index,
                          label: _stylistController.getArtiestDashboardModel
                                  .data?.serviceWithReviewCount?[index].name ??
                              "",
                          colors: [
                            ColorConstant.skyBlueColor,
                            Colors.transparent
                          ],
                          jumlah: double.parse(_stylistController
                                  .getArtiestDashboardModel
                                  .data
                                  ?.serviceWithReviewCount?[index]
                                  .rating
                                  .toString() ??
                              ""),
                          tooltip: "",
                        ),
                      ),
                      barSize: 11,
                      barStyle: BarStyle.DEFAULT,
                      showLegend: false,
                    ),
                    VerticalBarchart(
                      background: Colors.transparent,
                      maxX: 75,
                      data: List.generate(
                        _stylistController.getArtiestDashboardModel.data!
                                .serviceWithReviewCount?.length ??
                            0,
                        (index) => VBarChartModel(
                          index: index,
                          label: _stylistController.getArtiestDashboardModel
                                  .data?.serviceWithReviewCount?[index].name ??
                              "",
                          colors: [ColorConstant.service, Colors.transparent],
                          jumlah: _stylistController
                                      .getArtiestDashboardModel
                                      .data
                                      ?.serviceWithReviewCount?[index]
                                      .count ==
                                  null
                              ? 0
                              : double.parse(_stylistController
                                      .getArtiestDashboardModel
                                      .data
                                      ?.serviceWithReviewCount?[index]
                                      .count
                                      .toString() ??
                                  ""),
                          tooltip: "",
                        ),
                      ),
                      barSize: 11,
                      barStyle: BarStyle.DEFAULT,
                      showLegend: false,
                    )
                  ],
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
}
