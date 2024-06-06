import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/page/review_rating/widget/by_stylist_card_widget.dart';
import 'package:salon/page/review_rating/widget/artiest_rating_card_widget.dart';
import 'package:salon/page/review_rating/widget/product_rating_card_widget.dart';
import 'package:salon/page/review_rating/widget/service_rating_card_widget.dart';
import 'package:salon/project_specific/progressbar_view.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';

class ReviewAndRatingPage extends StatefulWidget {
  const ReviewAndRatingPage({super.key});

  @override
  State<ReviewAndRatingPage> createState() => _ReviewAndRatingPageState();
}

class _ReviewAndRatingPageState extends State<ReviewAndRatingPage> {
  final _homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _homeController.doGetOverallReview();
      _homeController.doGetArtiestReview();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstant.bgColor,
        appBar: const AppBarWidget(
          nameOfScreen: "Review & Ratings",
          isBackIcon: true,
        ),
        body: Column(
          children: [
            const SizedBox(height: 16),
            _stylistAndSalon(),
            const SizedBox(height: 5),
            Obx(
              () => Expanded(
                  child: _homeController.showProgress
                      ? const ProgressBarView()
                      : SingleChildScrollView(
                          child: Column(children: [
                            overall == "0"
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 10),
                                        child: Text(
                                          "Artists",
                                          style: AppTextTheme.bold.copyWith(
                                              color: ColorConstant.primaryColor,
                                              fontSize: 18),
                                        ),
                                      ),
                                      ListView.separated(
                                          separatorBuilder: (context, index) {
                                            return Column(
                                              children: [
                                                const SizedBox(height: 10),
                                                Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20),
                                                  height: 1,
                                                  width: Get.width,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: ColorConstant
                                                              .grayTextColor),
                                                ),
                                                const SizedBox(height: 10),
                                              ],
                                            );
                                          },
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          itemCount: _homeController
                                                  .getOverallReviewListModel
                                                  .data
                                                  ?.artists
                                                  ?.length ??
                                              0,
                                          itemBuilder: (context, index) {
                                            return ArtiestRatingCardWidget(
                                              overAllArtists: _homeController
                                                  .getOverallReviewListModel
                                                  .data!
                                                  .artists![index],
                                            );
                                          }),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 10),
                                        child: Text(
                                          "Products",
                                          style: AppTextTheme.bold.copyWith(
                                              color: ColorConstant.primaryColor,
                                              fontSize: 18),
                                        ),
                                      ),
                                      ListView.separated(
                                          separatorBuilder: (context, index) {
                                            return Column(
                                              children: [
                                                const SizedBox(height: 10),
                                                Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20),
                                                  height: 1,
                                                  width: Get.width,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: ColorConstant
                                                              .grayTextColor),
                                                ),
                                                const SizedBox(height: 10),
                                              ],
                                            );
                                          },
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          itemCount: _homeController
                                                  .getOverallReviewListModel
                                                  .data
                                                  ?.products
                                                  ?.length ??
                                              0,
                                          itemBuilder: (context, index) {
                                            return ProductRatingCardWidget(
                                              overAllProducts: _homeController
                                                  .getOverallReviewListModel
                                                  .data!
                                                  .products![index],
                                            );
                                          }),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 10),
                                        child: Text(
                                          "Services",
                                          style: AppTextTheme.bold.copyWith(
                                              color: ColorConstant.primaryColor,
                                              fontSize: 18),
                                        ),
                                      ),
                                      ListView.separated(
                                          separatorBuilder: (context, index) {
                                            return Column(
                                              children: [
                                                const SizedBox(height: 10),
                                                Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20),
                                                  height: 1,
                                                  width: Get.width,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: ColorConstant
                                                              .grayTextColor),
                                                ),
                                                const SizedBox(height: 10),
                                              ],
                                            );
                                          },
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          itemCount: _homeController
                                                  .getOverallReviewListModel
                                                  .data
                                                  ?.services
                                                  ?.length ??
                                              0,
                                          itemBuilder: (context, index) {
                                            return ServiceRatingCardWidget(
                                              overAllServices: _homeController
                                                  .getOverallReviewListModel
                                                  .data!
                                                  .services![index],
                                            );
                                          }),
                                    ],
                                  )
                                : ListView.separated(
                                    separatorBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          const SizedBox(height: 10),
                                          Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            height: 1,
                                            width: Get.width,
                                            decoration: const BoxDecoration(
                                                color: ColorConstant
                                                    .grayTextColor),
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                      );
                                    },
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: const EdgeInsets.only(bottom: 10),
                                    itemCount: _homeController
                                            .getSalonReviewByArtiestModel
                                            .data
                                            ?.length ??
                                        0,
                                    itemBuilder: (context, index) {
                                      return ByStylistCardWidget(
                                        salonArtiestReviewOverall:
                                            _homeController
                                                .getSalonReviewByArtiestModel
                                                .data![index],
                                      );
                                    }),
                          ]),
                        )),
            ),
          ],
        ));
  }

  /*----------- Tab Bar variable  ----------- */
  String? overall = "0";

  /*------------------- Switch Tab Stylist & Salon -------------------*/
  _stylistAndSalon() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
          color: ColorConstant.whiteColor,
          border: Border.all(color: ColorConstant.primaryColor, width: 2),
          borderRadius: BorderRadius.circular(15)),
      width: Get.width,
      padding: const EdgeInsets.all(2),
      child: CupertinoSlidingSegmentedControl(
          groupValue: overall,
          thumbColor: ColorConstant.whiteColor,
          children: {
            "0": SizedBox(
              width: Get.width,
              height: Get.height * 0.06,
              child: Center(
                child: Text(
                  "Overall",
                  style: AppTextTheme.medium.copyWith(
                      fontSize: 16,
                      color: overall == "0"
                          ? ColorConstant.blackColor
                          : ColorConstant.grayTextColor),
                ),
              ),
            ),
            "1": Text(
              "By Stylist",
              style: AppTextTheme.medium.copyWith(
                  fontSize: 16,
                  color: overall == "1"
                      ? ColorConstant.blackColor
                      : ColorConstant.grayTextColor),
            ),
          },
          onValueChanged: (dynamic value) {
            overall = value;
            if (overall == "0") {
              setState(() {
                _homeController.doGetOverallReview();
              });
            } else {
              setState(() {
                _homeController.doGetArtiestReview();
              });
            }
          }),
    );
  }

  /*--------------- Filter Category ------------*/
  filterCategory() {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: ColorConstant.whiteColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: ColorConstant.borderColor2),
      ),
      child: Center(
        child: Text(
          "High To Low",
          style: AppTextTheme.medium
              .copyWith(color: ColorConstant.blackColor, fontSize: 13),
        ),
      ),
    );
  }
}
