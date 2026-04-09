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
import 'package:salon/util/NoItemsWidget.dart';

class ReviewAndRatingPage extends StatefulWidget {
  const ReviewAndRatingPage({super.key});

  @override
  State<ReviewAndRatingPage> createState() => _ReviewAndRatingPageState();
}

class _ReviewAndRatingPageState extends State<ReviewAndRatingPage> {
  final _homeController = Get.find<HomeController>();

  // ▼▼▼ NEW: Added 3 expand/collapse controls ▼▼▼
  bool showSalon = false;
  bool showArtists = false;
  bool showProducts = false;

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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // ---------------- SALON TITLE WITH ARROW ----------------
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showSalon = !showSalon;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Salon",
                                  style: AppTextTheme.bold.copyWith(
                                      color: ColorConstant.primaryColor,
                                      fontSize: 18),
                                ),
                                Icon(
                                  showSalon
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: ColorConstant.primaryColor,
                                  size: 28,
                                )
                              ],
                            ),
                          ),
                        ),

                        // ▼▼▼ SHOW/HIDE SALON REVIEWS ▼▼▼
                        if (showSalon)
                          (_homeController.getOverallReviewListModel.data
                              ?.services?.isEmpty ??
                              false)
                              ? const NoItemsWidget(
                              text: "Salon Review Not Found")
                              : ListView.separated(
                              separatorBuilder:
                                  (context, index) {
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
                                          color:
                                          ColorConstant
                                              .grayTextColor),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                );
                              },
                              shrinkWrap: true,
                              physics:
                              const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(
                                  bottom: 10),
                              itemCount: _homeController
                                  .getOverallReviewListModel
                                  .data
                                  ?.services
                                  ?.length ??
                                  0,
                              itemBuilder: (context, index) {
                                return ServiceRatingCardWidget(
                                  overAllServices:
                                  _homeController
                                      .getOverallReviewListModel
                                      .data!
                                      .services![index],
                                );
                              }),

                        // ---------------- ARTISTS TITLE WITH ARROW ----------------
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showArtists = !showArtists;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Artists",
                                  style: AppTextTheme.bold.copyWith(
                                      color: ColorConstant.primaryColor,
                                      fontSize: 18),
                                ),
                                Icon(
                                  showArtists
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: ColorConstant.primaryColor,
                                  size: 28,
                                )
                              ],
                            ),
                          ),
                        ),

                        // ▼▼▼ SHOW/HIDE ARTISTS REVIEWS ▼▼▼
                        if (showArtists)
                          (_homeController.getOverallReviewListModel
                              .data?.artists?.isEmpty ??
                              false)
                              ? const NoItemsWidget(
                              text: "Artiest Review Not Found")
                              : ListView.separated(
                              separatorBuilder:
                                  (context, index) {
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
                                          color:
                                          ColorConstant
                                              .grayTextColor),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                );
                              },
                              shrinkWrap: true,
                              physics:
                              const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(
                                  bottom: 10),
                              itemCount: _homeController
                                  .getOverallReviewListModel
                                  .data
                                  ?.artists
                                  ?.length ??
                                  0,
                              itemBuilder: (context, index) {
                                return ArtiestRatingCardWidget(
                                  overAllArtists:
                                  _homeController
                                      .getOverallReviewListModel
                                      .data!
                                      .artists![index],
                                );
                              }),

                        // ---------------- PRODUCTS TITLE WITH ARROW ----------------
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showProducts = !showProducts;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Products",
                                  style: AppTextTheme.bold.copyWith(
                                      color: ColorConstant.primaryColor,
                                      fontSize: 18),
                                ),
                                Icon(
                                  showProducts
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: ColorConstant.primaryColor,
                                  size: 28,
                                )
                              ],
                            ),
                          ),
                        ),

                        // ▼▼▼ SHOW/HIDE PRODUCTS REVIEWS ▼▼▼
                        if (showProducts)
                          (_homeController.getOverallReviewListModel
                              .data?.products?.isEmpty ??
                              false)
                              ? const NoItemsWidget(
                              text: "Product Review Not Found")
                              : ListView.separated(
                              separatorBuilder:
                                  (context, index) {
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
                                          color:
                                          ColorConstant
                                              .grayTextColor),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                );
                              },
                              shrinkWrap: true,
                              physics:
                              const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(
                                  bottom: 10),
                              itemCount: _homeController
                                  .getOverallReviewListModel
                                  .data
                                  ?.products
                                  ?.length ??
                                  0,
                              itemBuilder: (context, index) {
                                return ProductRatingCardWidget(
                                  overAllProducts:
                                  _homeController
                                      .getOverallReviewListModel
                                      .data!
                                      .products![index],
                                );
                              }),
                      ],
                    )

                    // ---------- BY STYLIST TAB REMAINS SAME ----------
                        : _homeController.getSalonReviewByArtiestModel
                        .data?.isEmpty ??
                        false
                        ? Column(
                      children: [
                        SizedBox(
                          height: Get.height * 0.2,
                        ),
                        const NoItemsWidget(
                            text:
                            "No Any Stylist Review Found"),
                      ],
                    )
                        : ListView.separated(
                        separatorBuilder: (context, index) {
                          return Column(
                            children: [
                              const SizedBox(height: 10),
                              Container(
                                margin:
                                const EdgeInsets.symmetric(
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
                        padding:
                        const EdgeInsets.only(bottom: 10),
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
                ),
              ),
            ),
          ],
        ));
  }

  // ----------- Tab Bar variable -----------
  String? overall = "0";

  // ----------- Switch Tab Stylist & Salon -----------
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