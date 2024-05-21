import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:salon/constant/api_constant.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/project_specific/project_appbar.dart';

import '../../project_specific/progressbar_view.dart';
import '../../project_specific/text_theme.dart';

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
        nameOfScreen: "Service",
      ),
      body: Obx(
        () => _homeController.showProgress
            ? const ProgressBarView()
            : ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 15),
                separatorBuilder: (context, i) {
                  return const Divider(
                    indent: 1,
                    color: ColorConstant.blackColor,
                  );
                },
                shrinkWrap: true,
                itemCount:
                    _homeController.getProductListModel.productList?.length ??
                        0,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: CachedNetworkImage(
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            imageUrl:
                                "${APIConstants.image}${_homeController.getProductListModel.productList?[i].image}",
                            placeholder: (context, url) => const Image(
                              image: AssetImage(AssetsConstant.placeHolder),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            errorWidget: (context, url, error) => const Image(
                              image: AssetImage(AssetsConstant.placeHolder),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
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
                                colorClickableText: ColorConstant.primaryColor,
                                trimCollapsedText: 'more',
                                trimExpandedText: 'Show less',
                                moreStyle: AppTextTheme.medium.copyWith(
                                    fontSize: 15,
                                    color: ColorConstant.primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
      ),
    );
  }
}
