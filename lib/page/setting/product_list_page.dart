import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:salon/constant/api_constant.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/page/setting/widget/update_product.dart';
import 'package:salon/project_specific/project_appbar.dart';

import '../../project_specific/progressbar_view.dart';
import '../../project_specific/text_theme.dart';
import '../../util/NoItemsWidget.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final _homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _homeController.doGetProductListData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      appBar: const AppBarWidget(
        nameOfScreen: "Product",
      ),
      body: Obx(
        () => _homeController.showProgress
            ? const ProgressBarView()
            : _homeController.getProductListModel.productList?.isEmpty ?? false
                ? const NoItemsWidget(text: "Product Not Detected.")
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    separatorBuilder: (context, i) {
                      return const Divider(
                        indent: 1,
                        color: ColorConstant.blackColor,
                      );
                    },
                    shrinkWrap: true,
                    itemCount: _homeController
                            .getProductListModel.productList?.length ??
                        0,
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Product Name : ",
                                      style: AppTextTheme.medium.copyWith(
                                          fontSize: 13,
                                          color: ColorConstant.blackColor),
                                    ),
                                    Text(
                                      _homeController.getProductListModel
                                              .productList?[i].name ??
                                          "",
                                      style: AppTextTheme.regular.copyWith(
                                          fontSize: 13,
                                          color: ColorConstant.blackColor),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text(
                                      "Review Rating : ",
                                      style: AppTextTheme.medium.copyWith(
                                          fontSize: 13,
                                          color: ColorConstant.blackColor),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          size: 20,
                                        ),
                                        Text(
                                          "${_homeController.getProductListModel.productList?[i].rating}",
                                          style: AppTextTheme.regular.copyWith(
                                              fontSize: 13,
                                              color: ColorConstant.blackColor),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text(
                                      "Service Price : ",
                                      style: AppTextTheme.medium.copyWith(
                                          fontSize: 13,
                                          color: ColorConstant.blackColor),
                                    ),
                                    Text(
                                      "₹${_homeController.getProductListModel.productList?[i].price}",
                                      style: AppTextTheme.regular.copyWith(
                                          fontSize: 13,
                                          color: ColorConstant.blackColor),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                SizedBox(
                                  width: Get.width * 0.6,
                                  child: ReadMoreText(
                                    _homeController.getProductListModel
                                            .productList?[i].description ??
                                        "",
                                    trimMode: TrimMode.Line,
                                    style: AppTextTheme.medium.copyWith(
                                        height: 1.5,
                                        color: ColorConstant.grayTextColor,
                                        fontSize: 14),
                                    trimLines: 2,
                                    colorClickableText:
                                        ColorConstant.primaryColor,
                                    trimCollapsedText: 'more',
                                    trimExpandedText: 'Show less',
                                    moreStyle: AppTextTheme.medium.copyWith(
                                        fontSize: 15,
                                        color: ColorConstant.primaryColor),
                                  ),
                                ),
                              ],
                            ),
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: CachedNetworkImage(
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        "${APIConstants.image}${_homeController.getProductListModel.productList?[i].image}",
                                    placeholder: (context, url) => const Image(
                                      image: AssetImage(
                                          AssetsConstant.placeHolder),
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Image(
                                      image: AssetImage(
                                          AssetsConstant.placeHolder),
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: -15,
                                  left: 4,
                                  child: GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                          isScrollControlled: true,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(32),
                                            topRight: Radius.circular(32),
                                          )),
                                          context: context,
                                          builder: (context) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom),
                                              child: UpdateProduct(
                                                product: _homeController
                                                    .getProductListModel
                                                    .productList![i],
                                              ),
                                            );
                                          });
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 90,
                                      decoration: BoxDecoration(
                                          color: ColorConstant.reviewCardColor,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                              color:
                                                  ColorConstant.primaryColor)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            AssetsConstant.editIcon,
                                            color: ColorConstant.primaryColor,
                                            height: 15,
                                            width: 15,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            "Edit",
                                            style: AppTextTheme.regular
                                                .copyWith(
                                                    color: ColorConstant
                                                        .primaryColor),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Expanded(
                              child: IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                            "Delete",
                                            style: AppTextTheme.medium.copyWith(
                                                color:
                                                    ColorConstant.blackColor),
                                          ),
                                          content: Text(
                                            "Are you sure you want to delete product",
                                            style: AppTextTheme.medium.copyWith(
                                                color:
                                                    ColorConstant.blueGrayColor,
                                                fontSize: 14),
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                child: Text(
                                                  "Cancel",
                                                  style: AppTextTheme.medium
                                                      .copyWith(
                                                          color: ColorConstant
                                                              .redColor,
                                                          fontSize: 14),
                                                )),
                                            TextButton(
                                                onPressed: () {
                                                  _homeController
                                                      .doDeleteProduct(
                                                          callback: () {
                                                            Get.back();
                                                            _homeController
                                                                .doGetProductListData();
                                                          },
                                                          productId: _homeController
                                                                  .getProductListModel
                                                                  .productList?[
                                                                      i]
                                                                  .id ??
                                                              "");
                                                },
                                                child: Text(
                                                  "Yes",
                                                  style: AppTextTheme.medium
                                                      .copyWith(
                                                          color: ColorConstant
                                                              .primaryColor,
                                                          fontSize: 14),
                                                )),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: ColorConstant.redColor,
                                  )),
                            )
                          ],
                        ),
                      );
                    }),
      ),
    );
  }
}
