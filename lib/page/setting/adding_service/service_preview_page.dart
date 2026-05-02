import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'package:salon/constant/api_constant.dart';

import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/page/setting/adding_service/widget/category_list_tile_widget.dart';
import 'package:salon/page/setting/adding_service/widget/reset_and_add_row_widget.dart';
import 'package:salon/page/setting/adding_service/widget/review_product_list_tile_widget.dart';

import 'package:salon/project_specific/progressbar_view.dart';

import '../../../project_specific/text_theme.dart';

class ServicePreviewPage extends StatefulWidget {
  final String salonServiceId;
  const ServicePreviewPage({super.key, required this.salonServiceId});

  @override
  State<ServicePreviewPage> createState() => _ServicePreviewPageState();
}

class _ServicePreviewPageState extends State<ServicePreviewPage> {
  final _homeController = Get.find<HomeController>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _homeController.doGetServiceReview(salonServiceId: widget.salonServiceId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.8,
      width: Get.width,
      decoration: const BoxDecoration(
        color: ColorConstant.whiteColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          topLeft: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 71,
            width: Get.width,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(
              color: ColorConstant.primaryColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16),
                topLeft: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      "Cancel",
                      textScaler: const TextScaler.linear(0.85),
                      style: AppTextTheme.regular.copyWith(
                          color: ColorConstant.whiteColor, fontSize: 19),
                    )),
                Text(
                  "Preview",
                  textScaler: const TextScaler.linear(0.85),
                  style: AppTextTheme.bold
                      .copyWith(color: ColorConstant.whiteColor, fontSize: 19),
                ),
                const SizedBox(),
                const SizedBox()
              ],
            ),
          ),
          _countRowWidget(),
          Obx(
            () => Expanded(
              child: _homeController.showProgress
                  ? const ProgressBarView()
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          _headerWidget(
                              color: ColorConstant.review,
                              titleValue: _homeController
                                      .getServiceReviewModel.data?.name ??
                                  "",
                              title: "Service Name"),
                          _headerWidget(
                              color: Colors.transparent,
                              titleValue: _homeController
                                      .getServiceReviewModel.data?.gender ??
                                  "",
                              title: "Serviceable Gender"),
                          _headerWidget(
                              color: ColorConstant.review,
                              titleValue:
                                  "₹${_homeController.getServiceReviewModel.data?.price ?? ""}/-",
                              title: "Service Price"),
                          const SizedBox(height: 5),
                          _headerWidthImageWidget(
                              image:
                                  "${APIConstants.image}${_homeController.getServiceReviewModel.data?.image ?? ""}",
                              title: "Services Image"),
                          const SizedBox(height: 5),
                          _headerWidget(
                              color: ColorConstant.review,
                              titleValue: _homeController.getServiceReviewModel
                                          .data?.homeService ==
                                      false
                                  ? "NO"
                                  : "YES",
                              title: "Home Service"),
                          const SizedBox(height: 5),
                          _headerWidget(
                              color: ColorConstant.review,
                              titleValue:
                                  "${_homeController.getServiceReviewModel.data?.categories?.length} Added",
                              title: "Category"),
                          const SizedBox(height: 5),
                          ListView.separated(
                              separatorBuilder: (context, index) {
                                return const Divider(
                                  color: ColorConstant.dividerColor,
                                  indent: 20,
                                  endIndent: 20,
                                );
                              },
                              padding: EdgeInsets.zero,
                              itemCount: _homeController.getServiceReviewModel
                                      .data?.categories?.length ??
                                  0,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 15),
                                    child: CategoryListTileWidget(
                                      name: _homeController
                                              .getServiceReviewModel
                                              .data
                                              ?.categories?[index]
                                              .name ??
                                          "",
                                      description: _homeController
                                              .getServiceReviewModel
                                              .data
                                              ?.categories?[index]
                                              .description ??
                                          "",
                                      gender: _homeController
                                              .getServiceReviewModel
                                              .data
                                              ?.categories?[index]
                                              .serviceableGender ??
                                          "",
                                      image: _homeController
                                                  .getServiceReviewModel
                                                  .data
                                                  ?.categories?[index]
                                                  .serviceableGender ==
                                              "male"
                                          ? "${APIConstants.image}${_homeController.getServiceReviewModel.data?.categories?[index].imageMale}"
                                          : "${APIConstants.image}${_homeController.getServiceReviewModel.data?.categories?[index].imageFemale}",
                                    ));
                              }),
                          const SizedBox(height: 5),
                          _homeController.getServiceReviewModel.data?.products
                                      ?.isEmpty ??
                                  false
                              ? const SizedBox()
                              : Column(
                                  children: [
                                    _headerWidget(
                                        color: ColorConstant.review,
                                        titleValue:
                                            "${_homeController.getServiceReviewModel.data?.products?.length} Added",
                                        title: "Product"),
                                    ListView.separated(
                                        separatorBuilder: (context, index) {
                                          return const Divider(
                                            color: ColorConstant.dividerColor,
                                            indent: 20,
                                            endIndent: 20,
                                          );
                                        },
                                        padding: EdgeInsets.zero,
                                        itemCount: _homeController.getServiceReviewModel.data?.products
                                                ?.length ??
                                            0,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 15),
                                              child:
                                                  ReviewProductListTileWidget(
                                                name:  _homeController.getServiceReviewModel.data?.products?[index]
                                                        .name ??
                                                    "",
                                                image:
                                                    "${APIConstants.image}${_homeController.getServiceReviewModel.data?.products?[index].image ?? ""}",
                                                des:_homeController.getServiceReviewModel.data?.products?[index]
                                                        .description ??
                                                    "",
                                                price: _homeController.getServiceReviewModel.data!.products![index]
                                                    .price
                                                    .toString(),
                                              ));
                                        }),
                                  ],
                                ),
                        ],
                      ),
                    ),
            ),
          ),
          ResetAndAddRowWidget(
            buttonRest: "Edit",
            buttonAdd: "Save",
            reset: () {
              Get.back();
            },
            add: () {
              _homeController.doUpdateStatus(
                  salonServiceId: widget.salonServiceId,
                  callback: () {
                    Get.back();
                    Get.back();
                  });
            },
          ),
        ],
      ),
    );
  }

  /*---------------- Count Row Widget -------------*/
  _countRowWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: const BoxDecoration(
                    color: ColorConstant.primaryColor, shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    "1",
                    textScaler: const TextScaler.linear(0.85),
                    style: AppTextTheme.bold.copyWith(
                        color: ColorConstant.whiteColor, fontSize: 16),
                  ),
                ),
              ),
              Container(
                height: 2,
                width: 80,
                color: ColorConstant.primaryColor,
              ),
              Container(
                height: 30,
                width: 30,
                decoration: const BoxDecoration(
                    color: ColorConstant.primaryColor, shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    "2",
                    textScaler: const TextScaler.linear(0.85),
                    style: AppTextTheme.bold.copyWith(
                        color: ColorConstant.whiteColor, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(right: 60, left: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Details",
                  textScaler: const TextScaler.linear(0.85),
                  style: AppTextTheme.regular.copyWith(
                      color: ColorConstant.grayTextColor, fontSize: 12),
                ),
                Text(
                  "Preview",
                  textScaler: const TextScaler.linear(0.85),
                  style: AppTextTheme.regular.copyWith(
                      color: ColorConstant.grayTextColor, fontSize: 12),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  /*--------------- Row  Widget -------------*/
  Widget _headerWidget(
      {required Color color,
      required String title,
      required String titleValue}) {
    return Container(
      color: color,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 36,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextTheme.regular
                .copyWith(color: ColorConstant.blackColor, fontSize: 14),
          ),
          Text(
            titleValue,
            style: AppTextTheme.bold
                .copyWith(color: ColorConstant.blackColor, fontSize: 14),
          ),
        ],
      ),
    );
  }

  /*-----------------  header With  Image ---------------*/
  _headerWidthImageWidget({required String title, required String image}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextTheme.regular
                .copyWith(color: ColorConstant.blackColor, fontSize: 14),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.network(
              image,
              height: 41,
              width: 41,
            ),
          ),
        ],
      ),
    );
  }
}
