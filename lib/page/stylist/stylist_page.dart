import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/api_constant.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/page/stylist/stylist_about_page.dart';
import 'package:salon/page/stylist/widget/filter_tile.dart';
import 'package:salon/page/stylist/widget/stylist_list_tile_widget.dart';
import 'package:salon/project_specific/progressbar_view.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';
import '../../controller/home_controller.dart';
import 'add_stylist/add_stylist_page.dart';

class StylistPage extends StatefulWidget {
  const StylistPage({super.key});

  @override
  State<StylistPage> createState() => _StylistPageState();
}

class _StylistPageState extends State<StylistPage> {
  final _stylistTextEditingController = TextEditingController();

  final _homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _homeController.doSalonArtistList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      appBar: const AppBarWidget(
        nameOfScreen: "Stylist",
        isBackIcon: true,
      ),
      body: Obx(
        () => Column(
          children: [

            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${_homeController.getSalonArtistListModel.data?.length ?? 0} Stylist Found:",
                    style: AppTextTheme.regular.copyWith(
                        color: ColorConstant.grayTextColor, fontSize: 15),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const AddStylistPage(
                            isBasicInfoUpdate: false,
                            artistId: "",
                          ));
                    },
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      color: ColorConstant.primaryColor,
                      radius: const Radius.circular(66),
                      padding: const EdgeInsets.all(4),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        child: Container(
                          height: 30,
                          width: 100,
                          color: ColorConstant.lightColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.add,
                                color: ColorConstant.primaryColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "Add New",
                                style: AppTextTheme.regular.copyWith(
                                    color: ColorConstant.primaryColor,
                                    fontSize: 14),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _homeController.showProgress
                  ? const ProgressBarView()
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          ListView.separated(
                              separatorBuilder: (context, index) {
                                return const Divider(
                                  endIndent: 20,
                                  indent: 20,
                                  color: ColorConstant.dividerColor,
                                );
                              },
                              itemCount: _homeController
                                      .getSalonArtistListModel.data?.length ??
                                  0,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 12),
                                  child: StylistListTileWidget(
                                    id: _homeController.getSalonArtistListModel
                                            .data?[index].id ??
                                        "",
                                    image:
                                        "${APIConstants.image}${_homeController.getSalonArtistListModel.data?[index].profileImage}",
                                    name: _homeController
                                            .getSalonArtistListModel
                                            .data?[index]
                                            .name ??
                                        "",
                                    onPress: () {
                                      /* Get.to(() => const StylistAboutPage());*/
                                    },
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /*------------------ Search and Service ---------------*/
  _searchAndService() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: ShapeDecoration(
        color: ColorConstant.whiteColor,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFE1E1E1)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Image.asset(
            AssetsConstant.search,
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 5),
          SizedBox(
            width: Get.width * 0.6,
            child: TextField(
              controller: _stylistTextEditingController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search and add service",
                  hintStyle: AppTextTheme.regular.copyWith(
                      fontSize: 16, color: ColorConstant.grayTextColor)),
            ),
          ),
        ],
      ),
    );
  }
}
