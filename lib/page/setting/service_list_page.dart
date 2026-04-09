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
import 'package:salon/util/NoItemsWidget.dart';
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
      _homeController.doGetSalonServiceCategory();
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
            : _homeController.getSettingSalonServiceListModel.data?.isEmpty ??
                    false
                ? const NoItemsWidget(text: "Service Not Detected.")
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: _homeController
                            .getSettingSalonServiceListModel.data?.length ??
                        0,
                    itemBuilder: (context, i) {
                      return ExpansionTile(
                        title: Text(
                          _homeController.getSettingSalonServiceListModel
                                  .data?[i].name ??
                              "",
                          textScaler: const TextScaler.linear(0.85),
                          style: AppTextTheme.bold.copyWith(
                              fontSize: 16, color: ColorConstant.blackColor),
                        ),
                        initiallyExpanded: i == 0 ? true : false,
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: _homeController
                                      .getSettingSalonServiceListModel
                                      .data?[i]
                                      .services
                                      ?.length ??
                                  0,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _homeController
                                                    .getSettingSalonServiceListModel
                                                    .data?[i]
                                                    .services?[index]
                                                    .name ??
                                                "",
                                            style: AppTextTheme.bold.copyWith(
                                                fontSize: 16,
                                                color:
                                                    ColorConstant.blackColor),
                                          ),
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              Text(
                                                "Service Gender : ",
                                                style: AppTextTheme.medium
                                                    .copyWith(
                                                        fontSize: 13,
                                                        color: ColorConstant
                                                            .blackColor),
                                              ),
                                              Text(
                                                _homeController
                                                        .getSettingSalonServiceListModel
                                                        .data?[i]
                                                        .services?[index]
                                                        .gender ??
                                                    "",
                                                style: AppTextTheme.regular
                                                    .copyWith(
                                                        fontSize: 14,
                                                        color: ColorConstant
                                                            .blackColor),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              Text(
                                                "Service Price : ",
                                                style: AppTextTheme.medium
                                                    .copyWith(
                                                        fontSize: 13,
                                                        color: ColorConstant
                                                            .blackColor),
                                              ),
                                              Text(
                                                "₹${_homeController.getSettingSalonServiceListModel.data?[i].services?[index].price}",
                                                textScaler:
                                                    const TextScaler.linear(
                                                        0.85),
                                                style: AppTextTheme.regular
                                                    .copyWith(
                                                        fontSize: 14,
                                                        color: ColorConstant
                                                            .blackColor),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              Text(
                                                "Home Service : ",
                                                style: AppTextTheme.medium
                                                    .copyWith(
                                                        fontSize: 13,
                                                        color: ColorConstant
                                                            .blackColor),
                                              ),
                                              Text(
                                                "${_homeController.getSettingSalonServiceListModel.data?[i].services?[index].homeService}",
                                                style: AppTextTheme.regular
                                                    .copyWith(
                                                        fontSize: 14,
                                                        color: ColorConstant
                                                            .blackColor),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              Text(
                                                "Timing : ",
                                                style: AppTextTheme.medium
                                                    .copyWith(
                                                        fontSize: 13,
                                                        color: ColorConstant
                                                            .blackColor),
                                              ),
                                              Text(
                                                "${_homeController.getSettingSalonServiceListModel.data?[i].services?[index].duration} min",
                                                style: AppTextTheme.regular
                                                    .copyWith(
                                                        fontSize: 14,
                                                        color: ColorConstant
                                                            .blackColor),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          SizedBox(
                                            width: Get.width * 0.6,
                                            child: ReadMoreText(
                                              _homeController
                                                      .getSettingSalonServiceListModel
                                                      .data?[i]
                                                      .services?[index]
                                                      .description ??
                                                  "",
                                              trimMode: TrimMode.Line,
                                              style: AppTextTheme.medium
                                                  .copyWith(
                                                      height: 1.5,
                                                      color: ColorConstant
                                                          .grayTextColor,
                                                      fontSize: 14),
                                              trimLines: 2,
                                              colorClickableText:
                                                  ColorConstant.primaryColor,
                                              trimCollapsedText: 'more',
                                              trimExpandedText: 'Show less',
                                              moreStyle: AppTextTheme.medium
                                                  .copyWith(
                                                      fontSize: 15,
                                                      color: ColorConstant
                                                          .primaryColor),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: CachedNetworkImage(
                                              width: 108,
                                              height: 123,
                                              fit: BoxFit.cover,
                                              imageUrl:
                                                  "${APIConstants.image}${_homeController.getSettingSalonServiceListModel.data?[i].services?[index].image}",
                                              placeholder: (context, url) =>
                                                  const Image(
                                                image: AssetImage(
                                                    AssetsConstant.placeHolder),
                                                width: 108,
                                                height: 123,
                                                fit: BoxFit.cover,
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Image(
                                                image: AssetImage(
                                                    AssetsConstant.placeHolder),
                                                width: 108,
                                                height: 123,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          /* Positioned(
                                            bottom: -15,
                                            left: 3,
                                            child: GestureDetector(
                                              onTap: () {
                                                showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                      topLeft:
                                                          Radius.circular(32),
                                                      topRight:
                                                          Radius.circular(32),
                                                    )),
                                                    context: context,
                                                    builder: (context) {
                                                      return Padding(
                                                        padding: EdgeInsets.only(
                                                            bottom:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .viewInsets
                                                                    .bottom),
                                                        child:
                                                            CreateNewServicePage(
                                                          serviceId: _homeController
                                                                  .getSettingSalonServiceListModel
                                                                  .data?[i]
                                                                  .services?[
                                                                      index]
                                                                  .id ??
                                                              "",
                                                          isUpdate: true,
                                                          salonService:
                                                              _homeController
                                                                  .getSalonServiceList
                                                                  .data![i],
                                                        ),
                                                      );
                                                    });
                                              },
                                              child: Container(
                                                height: 40,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                    color: ColorConstant
                                                        .reviewCardColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                        color: ColorConstant
                                                            .primaryColor)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                      AssetsConstant.editIcon,
                                                      color: ColorConstant
                                                          .primaryColor,
                                                      height: 15,
                                                      width: 15,
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Text(
                                                      "Edit",
                                                      style: AppTextTheme
                                                          .regular
                                                          .copyWith(
                                                              color: ColorConstant
                                                                  .primaryColor),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )*/
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }),
                          const SizedBox(height: 10),
                        ],
                      );
                    },
                  ),
      ),
    );
  }
}
