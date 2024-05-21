import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:salon/constant/api_constant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/project_specific/progressbar_view.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';

import '../../constant/assetsconstant.dart';

class ServiceListPage extends StatefulWidget {
  const ServiceListPage({super.key});

  @override
  State<ServiceListPage> createState() => _ServiceListPageState();
}

class _ServiceListPageState extends State<ServiceListPage> {
  final _homeController = Get.find<HomeController>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _homeController.doGetSalonServiceList();
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
                padding: const EdgeInsets.symmetric(vertical: 10),
                separatorBuilder: (context, i) {
                  return const Divider(
                    indent: 1,
                    color: ColorConstant.blackColor,
                  );
                },
                shrinkWrap: true,
                itemCount:
                    _homeController.getSalonServiceList.data?.length ?? 0,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _homeController
                                      .getSalonServiceList.data?[i].name ??
                                  "",
                              style: AppTextTheme.bold.copyWith(
                                  fontSize: 16,
                                  color: ColorConstant.blackColor),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Text(
                                  "Service Gender : ",
                                  style: AppTextTheme.medium.copyWith(
                                      fontSize: 13,
                                      color: ColorConstant.blackColor),
                                ),
                                Text(
                                  _homeController.getSalonServiceList.data?[i]
                                          .gender ??
                                      "",
                                  style: AppTextTheme.regular.copyWith(
                                      fontSize: 14,
                                      color: ColorConstant.blackColor),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Text(
                                  "Service Price : ",
                                  style: AppTextTheme.medium.copyWith(
                                      fontSize: 13,
                                      color: ColorConstant.blackColor),
                                ),
                                Text(
                                  "₹${_homeController.getSalonServiceList.data?[i].price}",
                                  textScaler: const TextScaler.linear(0.85),
                                  style: AppTextTheme.regular.copyWith(
                                      fontSize: 14,
                                      color: ColorConstant.blackColor),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Text(
                                  "Home Service : ",
                                  style: AppTextTheme.medium.copyWith(
                                      fontSize: 13,
                                      color: ColorConstant.blackColor),
                                ),
                                Text(
                                  "${_homeController.getSalonServiceList.data?[i].homeService}",
                                  style: AppTextTheme.regular.copyWith(
                                      fontSize: 14,
                                      color: ColorConstant.blackColor),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Text(
                                  "Timing : ",
                                  style: AppTextTheme.medium.copyWith(
                                      fontSize: 13,
                                      color: ColorConstant.blackColor),
                                ),
                                Text(
                                  "${_homeController.getSalonServiceList.data?[i].duration} min",
                                  style: AppTextTheme.regular.copyWith(
                                      fontSize: 14,
                                      color: ColorConstant.blackColor),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            SizedBox(
                              width: Get.width * 0.6,
                              child: ReadMoreText(
                                _homeController.getSalonServiceList.data?[i]
                                        .description ??
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            width: 108,
                            height: 123,
                            fit: BoxFit.cover,
                            imageUrl:
                                "${APIConstants.image}${_homeController.getSalonServiceList.data?[i].image}",
                            placeholder: (context, url) => const Image(
                              image: AssetImage(AssetsConstant.placeHolder),
                              width: 108,
                              height: 123,
                              fit: BoxFit.cover,
                            ),
                            errorWidget: (context, url, error) => const Image(
                              image: AssetImage(AssetsConstant.placeHolder),
                              width: 108,
                              height: 123,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
      ),
    );
  }
}
