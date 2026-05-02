import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/auth_controller.dart';
import 'package:salon/controller/stylist/stylist_controller.dart';
import 'package:salon/page/stylist_all_module/stylist_home_page/widget/rating_service_row_widget.dart';
import 'package:salon/project_specific/progressbar_view.dart';
import 'package:salon/project_specific/stylist_portfolio_section.dart';
// import 'package:url_launcher/url_launcher.dart'; // SOS / dial

import '../../../constant/assetsconstant.dart';
import '../../../project_specific/text_theme.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  final _stylistController = Get.find<StylistController>();
  final _authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _stylistController.doGetArtiestDashBoard(distribution: "all_time");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _stylistController.doGetArtistPortfolio(showProgress: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.whiteColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
        ),
        child: Column(
          children: [
            _sidBanner(context),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Obx(() {
                            final portfolio = _stylistController
                                    .getArtistPortfolioModel.data?.portfolio ??
                                [];
                            return StylistPortfolioSection(
                              items: portfolio,
                            );
                          }),
                        ),
                        const SizedBox(height: 24),
                        // Container(
                        //   decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(7),
                        //       color: ColorConstant.gray),
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Padding(
                        //         padding: const EdgeInsets.symmetric(
                        //             horizontal: 20, vertical: 15),
                        //         child: Text(
                        //           "Service Breakdown",
                        //           style: AppTextTheme.bold.copyWith(
                        //               color: ColorConstant.blackColor,
                        //               fontSize: 13),
                        //         ),
                        //       ),
                        //       _stylistController
                        //                   .getArtiestDashboardModel
                        //                   .data
                        //                   ?.serviceCountData
                        //                   ?.serviceBreakdown
                        //                   ?.isEmpty ??
                        //               false
                        //           ? const NoItemsWidget(
                        //               text: "No breakdown services found.",
                        //             )
                        //           : GridView.builder(
                        //               shrinkWrap: true,
                        //               physics:
                        //                   const NeverScrollableScrollPhysics(),
                        //               padding: const EdgeInsets.only(
                        //                 left: 20.0,
                        //                 right: 20.0,
                        //                 bottom: 40.0,
                        //               ),
                        //               gridDelegate:
                        //                   const SliverGridDelegateWithFixedCrossAxisCount(
                        //                 crossAxisCount: 3,
                        //                 mainAxisSpacing: 20.0,
                        //                 crossAxisSpacing: 20.0,
                        //                 childAspectRatio: 2,
                        //               ),
                        //               itemCount: _stylistController
                        //                       .getArtiestDashboardModel
                        //                       .data
                        //                       ?.serviceCountData
                        //                       ?.serviceBreakdown
                        //                       ?.length ??
                        //                   0,
                        //               itemBuilder: (context, index) {
                        //                 return ServiceBreakdownWidget(
                        //                   imageUrl: AssetsConstant.haircutImage,
                        //                   count:
                        //                       "${_stylistController.getArtiestDashboardModel.data?.serviceCountData?.serviceBreakdown?[index].count ?? ""}",
                        //                   name: _stylistController
                        //                           .getArtiestDashboardModel
                        //                           .data
                        //                           ?.serviceCountData
                        //                           ?.serviceBreakdown?[index]
                        //                           .name ??
                        //                       "",
                        //                 );
                        //               },
                        //             ),
                        //     ],
                        //   ),
                        // ),
                        // const SizedBox(height: 16),
                        // _reportAnalytics(),
                      ],
                    ),
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _sidBanner(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    final rawSid =
        _authController.getSalonArtistResponseModel.data?.salonArtistData?.id
                ?.trim() ??
            '';
    final sid = rawSid.isEmpty ? '—' : rawSid;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, topInset + 8, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xffcd73b4),
                    Color(0xff8454e5),
                  ],
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                'SId : $sid',
                textAlign: TextAlign.center,
                style: AppTextTheme.bold.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          // SOS / emergency dial (disabled)
          // const SizedBox(width: 8),
          // GestureDetector(
          //   onTap: () {
          //     _launchDialer(phoneNumber: "88970 90838");
          //   },
          //   child: Container(
          //     height: 46,
          //     width: 46,
          //     decoration: const BoxDecoration(
          //       shape: BoxShape.circle,
          //       color: ColorConstant.redColor,
          //     ),
          //     child: Center(
          //       child: Image.asset(
          //         AssetsConstant.sosIcon,
          //         height: 20,
          //         width: 20,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  // /*======================= LaunchDialer (SOS) =========================*/
  // Future<void> _launchDialer({required String phoneNumber}) async {
  //   final Uri url = Uri.parse('tel:$phoneNumber');
  //
  //   if (await canLaunchUrl(url)) {
  //     await launchUrl(url, mode: LaunchMode.externalApplication);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

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
  // _reportAnalytics() {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 20),
  //     width: Get.width,
  //     padding: const EdgeInsets.all(15),
  //     decoration: BoxDecoration(
  //       color: ColorConstant.grayTextColor.withOpacity(0.1),
  //       borderRadius: BorderRadius.circular(8),
  //     ),
  //     child: Column(
  //       children: [
  //         Text(
  //           "Reports Analytics",
  //           textScaler: const TextScaler.linear(0.85),
  //           style: AppTextTheme.bold
  //               .copyWith(color: ColorConstant.blackColor, fontSize: 20),
  //         ),
  //         const SizedBox(height: 20),
  //         _stylistController.getArtiestDashboardModel.data
  //                     ?.serviceWithReviewCount?.isEmpty ??
  //                 false
  //             ? const NoItemsWidget(
  //                 text: "No data is available for report analytics.")
  //             : ListView.builder(
  //                 itemCount: _stylistController.getArtiestDashboardModel.data!
  //                         .serviceWithReviewCount?.length ??
  //                     0,
  //                 shrinkWrap: true,
  //                 physics: const NeverScrollableScrollPhysics(),
  //                 itemBuilder: (context, i) {
  //                   return Row(
  //                     children: [
  //                       SizedBox(
  //                         width: Get.width * 0.2,
  //                         child: Text(
  //                           _stylistController.getArtiestDashboardModel.data!
  //                                   .serviceWithReviewCount?[i].name ??
  //                               "",
  //                           style: AppTextTheme.medium.copyWith(
  //                               color: ColorConstant.grayTextColor,
  //                               fontSize: 13),
  //                         ),
  //                       ),
  //                       Expanded(
  //                         child: Column(
  //                           children: [
  //                             GFProgressBar(
  //                                 lineHeight: 11,
  //                                 circleWidth: 0,
  //                                 isDragable: false,
  //                                 percentage: double.parse(_stylistController
  //                                             .getArtiestDashboardModel
  //                                             .data
  //                                             ?.serviceWithReviewCount?[i]
  //                                             .rating
  //                                             .toString() ??
  //                                         "") /
  //                                     100,
  //                                 backgroundColor: Colors.transparent,
  //                                 progressBarColor: const Color(0xff2178FC)),
  //                             const SizedBox(height: 4),
  //                             GFProgressBar(
  //                                 lineHeight: 11,
  //                                 circleWidth: 0,
  //                                 isDragable: false,
  //                                 percentage: _stylistController
  //                                             .getArtiestDashboardModel
  //                                             .data
  //                                             ?.serviceWithReviewCount?[i]
  //                                             .count ==
  //                                         null
  //                                     ? 0.0
  //                                     : double.parse(_stylistController
  //                                                 .getArtiestDashboardModel
  //                                                 .data
  //                                                 ?.serviceWithReviewCount?[i]
  //                                                 .count
  //                                                 .toString() ??
  //                                             "") /
  //                                         100,
  //                                 backgroundColor: Colors.transparent,
  //                                 progressBarColor: ColorConstant.service),
  //                             const SizedBox(height: 10),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   );
  //                 }),
  //         const Divider(
  //           color: ColorConstant.dividerColor,
  //           indent: 60.0,
  //           endIndent: 10,
  //         ),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           children: List.generate(
  //             data.length,
  //             (index) => Center(
  //               child: Text(
  //                 "${data[index]}",
  //                 style: AppTextTheme.medium.copyWith(
  //                     color: ColorConstant.grayTextColor, fontSize: 13),
  //               ),
  //             ),
  //           ),
  //         ),
  //         const SizedBox(height: 10),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceAround,
  //           children: [
  //             Row(
  //               children: [
  //                 Container(
  //                   width: 12,
  //                   height: 12,
  //                   decoration: BoxDecoration(
  //                       color: ColorConstant.service,
  //                       borderRadius: BorderRadius.circular(3)),
  //                 ),
  //                 const SizedBox(width: 12),
  //                 Text(
  //                   "Service Done",
  //                   style: AppTextTheme.regular.copyWith(
  //                       color: ColorConstant.grayTextColor, fontSize: 13),
  //                 )
  //               ],
  //             ),
  //             Row(
  //               children: [
  //                 Container(
  //                   width: 12,
  //                   height: 12,
  //                   decoration: BoxDecoration(
  //                       color: ColorConstant.skyBlueColor,
  //                       borderRadius: BorderRadius.circular(3)),
  //                 ),
  //                 const SizedBox(width: 12),
  //                 Text(
  //                   "Ratings",
  //                   style: AppTextTheme.regular.copyWith(
  //                       color: ColorConstant.grayTextColor, fontSize: 13),
  //                 )
  //               ],
  //             ),
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }

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
