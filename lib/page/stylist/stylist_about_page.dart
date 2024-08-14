import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:salon/constant/api_constant.dart';
import 'package:salon/controller/stylist/stylist_controller.dart';
import 'package:salon/page/stylist/widget/stylist_about_widget.dart';
import 'package:salon/page/stylist/widget/service_offered_list_tile_widget.dart';
import 'package:salon/page/stylist/widget/stylist_portfolio_gird_view.dart';
import 'package:salon/project_specific/progressbar_view.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:salon/util/pick_image.dart';
import '../../constant/assetsconstant.dart';
import '../../constant/color_constant.dart';
import '../../project_specific/status_bar_color_appbar.dart';

class StylistAboutPage extends StatefulWidget {
  const StylistAboutPage({super.key});

  @override
  State<StylistAboutPage> createState() => _StylistAboutPageState();
}

class _StylistAboutPageState extends State<StylistAboutPage> {
  final _stylistController = Get.find<StylistController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _stylistController.doGetArtistPortfolio();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: statusBarTheme(context),
      backgroundColor: ColorConstant.bgColor,
      body: Obx(
        () => _stylistController.showProgress
            ? const ProgressBarView()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    _imageHeaderWidget(),
                    _nameContainColum(),
                    _tabBarView(),
                    isSelectedTab == 1
                        ? ListView.separated(
                            separatorBuilder: (context, index) {
                              return const Divider(
                                endIndent: 20,
                                indent: 20,
                                color: ColorConstant.grayTextColor,
                              );
                            },
                            itemCount: _stylistController
                                    .getArtistPortfolioModel
                                    .data
                                    ?.services
                                    ?.length ??
                                0,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                  child: ServiceOfferedListTileWidget(
                                    image:
                                        "${APIConstants.image}${_stylistController.getArtistPortfolioModel.data?.services?[index].image}",
                                    name: _stylistController
                                            .getArtistPortfolioModel
                                            .data
                                            ?.services?[index]
                                            .name ??
                                        "",
                                    description: _stylistController
                                            .getArtistPortfolioModel
                                            .data
                                            ?.services?[index]
                                            .description ??
                                        "",
                                    onPress: () {},
                                  ));
                            })
                        : isSelectedTab == 2
                            ? StylistPortfolioGridview(
                                portfolio:
                                    _stylistController.getArtistPortfolioModel,
                              )
                            : StylistAbout(
                                artistPortfolioModel:
                                    _stylistController.getArtistPortfolioModel,
                              ),
                  ],
                ),
              ),
      ),
    );
  }

  /*-------------- Image header Widget ------------*/

  File profileImage = File("");

  _imageHeaderWidget() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CachedNetworkImage(
          width: Get.width,
          height: Get.height * 0.28,
          fit: BoxFit.fitWidth,
          imageUrl:
              "${APIConstants.image}${_stylistController.getArtistPortfolioModel.data?.salon?.image ?? ""}",
          placeholder: (context, url) => Image(
            image: const AssetImage(AssetsConstant.placeHolder),
            width: Get.width,
            height: Get.height * 0.28,
            fit: BoxFit.fitWidth,
          ),
          errorWidget: (context, url, error) => Image(
            image: const AssetImage(AssetsConstant.placeHolder),
            width: Get.width,
            height: Get.height * 0.28,
            fit: BoxFit.fitWidth,
          ),
        ),
        Positioned(
            child: Container(
          width: Get.width,
          height: Get.height * 0.28,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.02, 1.00),
              end: Alignment(-0.02, -1),
              colors: [Colors.black, Color(0x003D3636)],
            ),
          ),
        )),
        Positioned(
          top: 12,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buttonWidget(
                imageUrl: AssetsConstant.backArrow,
                onPress: () {
                  Get.back();
                },
                h: 15,
                w: 15,
              ),
            ],
          ),
        ),
        Positioned(
          bottom: -50,
          left: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              FileUtils.openPlatformImagePicker(onSelectImage: (file) {
                setState(() {
                  profileImage = file;
                });
              });
            },
            child: Container(
              width: 110,
              height: 110,
              decoration: const BoxDecoration(
                color: ColorConstant.bgColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: profileImage.path == ""
                      ? CachedNetworkImage(
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                          imageUrl:
                              "${APIConstants.image}${_stylistController.getArtistPortfolioModel.data?.profileImage ?? ""}",
                          placeholder: (context, url) => const Image(
                            image: AssetImage(AssetsConstant.placeHolder),
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                          errorWidget: (context, url, error) => const Image(
                            image: AssetImage(AssetsConstant.placeHolder),
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.file(
                          profileImage,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -40,
          left: Get.width * 0.2,
          right: 0,
          child: GestureDetector(
            onTap: () {
              FileUtils.openPlatformImagePicker(onSelectImage: (file) {
                setState(() {
                  profileImage = file;
                });
              });
            },
            child: Container(
              padding: const EdgeInsets.all(5),
              width: 35,
              height: 35,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: ColorConstant.whiteColor),
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorConstant.editButtonColor),
                child: Center(
                  child: Image.asset(
                    AssetsConstant.editIcon,
                    width: 10,
                    height: 10,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /*------------ Back Button --------------*/
  buttonWidget(
      {required String imageUrl,
      required VoidCallback onPress,
      required double h,
      required double w}) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ColorConstant.blackColor.withOpacity(0.50),
          ),
          child: Center(
            child: Image.asset(
              imageUrl,
              width: w,
              height: h,
              fit: BoxFit.contain,
            ),
          )),
    );
  }

  /*------------ Naming Contain Colum --------*/
  _nameContainColum() {
    return Column(
      children: [
        SizedBox(height: Get.height * 0.07),
        Text(
          _stylistController.getArtistPortfolioModel.data?.name ?? "",
          style: AppTextTheme.bold
              .copyWith(color: ColorConstant.blackColor, fontSize: 19),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RatingBar.builder(
              initialRating:
                  _stylistController.getArtistPortfolioModel.data?.rating ??
                      0.0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 25.0,
              unratedColor: ColorConstant.editButtonColor,
              ignoreGestures: true,
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: ColorConstant.primaryColor,
                size: 25,
              ),
              onRatingUpdate: (rating) {},
            ),
            Text(
              "(${_stylistController.getArtistPortfolioModel.data?.reviewCount} Reviews)",
              style: AppTextTheme.medium
                  .copyWith(fontSize: 13, color: ColorConstant.grayTextColor),
            ),
          ],
        ),
      ],
    );
  }

  /*------------- Tab Bar View ------------*/
  int isSelectedTab = 1;
  _tabBarView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    isSelectedTab = 1;
                  });
                },
                child: Column(
                  children: [
                    Text(
                      "Service Offered",
                      style: isSelectedTab == 1
                          ? AppTextTheme.bold.copyWith(
                              fontSize: 16, color: ColorConstant.primaryColor)
                          : AppTextTheme.medium.copyWith(
                              fontSize: 16, color: ColorConstant.grayTextColor),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 4,
                      width: Get.width * 0.2,
                      decoration: BoxDecoration(
                          color: isSelectedTab == 1
                              ? ColorConstant.primaryColor
                              : Colors.transparent,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12))),
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isSelectedTab = 2;
                  });
                },
                child: Column(
                  children: [
                    Text(
                      "Portfolio",
                      style: isSelectedTab == 2
                          ? AppTextTheme.bold.copyWith(
                              fontSize: 16, color: ColorConstant.primaryColor)
                          : AppTextTheme.medium.copyWith(
                              fontSize: 16, color: ColorConstant.grayTextColor),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 4,
                      width: Get.width * 0.2,
                      decoration: BoxDecoration(
                          color: isSelectedTab == 2
                              ? ColorConstant.primaryColor
                              : Colors.transparent,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12))),
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isSelectedTab = 3;
                  });
                },
                child: Column(
                  children: [
                    Text(
                      "About",
                      style: isSelectedTab == 3
                          ? AppTextTheme.bold.copyWith(
                              fontSize: 16, color: ColorConstant.primaryColor)
                          : AppTextTheme.medium.copyWith(
                              fontSize: 16, color: ColorConstant.grayTextColor),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 4,
                      width: Get.width * 0.2,
                      decoration: BoxDecoration(
                          color: isSelectedTab == 3
                              ? ColorConstant.primaryColor
                              : Colors.transparent,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12))),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 1,
          width: Get.width,
          color: const Color(0xffADADAD),
        ),
      ],
    );
  }
}
