import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/page/setting/adding_service/widget/add_category_list_tile_widget.dart';
import 'package:salon/project_specific/progressbar_view.dart';
import 'package:salon/project_specific/text_theme.dart';
import '../../../constant/assetsconstant.dart';

class AddCategoryNewService extends StatefulWidget {
  final VoidCallback callback;
  const AddCategoryNewService({super.key, required this.callback});

  @override
  State<AddCategoryNewService> createState() => _AddCategoryNewServiceState();
}

class _AddCategoryNewServiceState extends State<AddCategoryNewService> {
  final _serviceTextEditingController = TextEditingController();
  final _homeController = Get.find<HomeController>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _homeController.doGetCategoryListData();
      _homeController.productId.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.6,
      width: Get.width,
      decoration: const BoxDecoration(
        color: ColorConstant.whiteColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          topLeft: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
                    _homeController.productId.clear();
                    Get.back();
                  },
                  child: Text(
                    "Cancel",
                    textScaler: const TextScaler.linear(0.85),
                    style: AppTextTheme.regular.copyWith(
                        color: ColorConstant.whiteColor, fontSize: 19),
                  ),
                ),
                Text(
                  "Add Category",
                  textScaler: const TextScaler.linear(0.85),
                  style: AppTextTheme.bold
                      .copyWith(color: ColorConstant.whiteColor, fontSize: 19),
                ),
                TextButton(
                  onPressed: () {
                    widget.callback();
                    Get.back();
                  },
                  child: Text(
                    "Done",
                    style: AppTextTheme.medium.copyWith(
                        color: ColorConstant.whiteColor, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _searchAndService(),
          const SizedBox(height: 10),
          Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            color: ColorConstant.lightColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Suggested Category:",
                  style: AppTextTheme.regular.copyWith(
                      color: ColorConstant.primaryColor, fontSize: 13),
                ),
                Text(
                  "${_homeController.selectCategoryCount}",
                  style: AppTextTheme.bold.copyWith(
                      fontSize: 13, color: ColorConstant.primaryColor),
                ),
              ],
            ),
          ),
          Obx(
            () => Expanded(
              child: _homeController.showProgressCategory
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
                                      .getCategoryModel.data?.length ??
                                  0,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                _homeController.selectCategoryCount =
                                    _homeController
                                            .getCategoryModel.data?.length ??
                                        0;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: AddCategoryListTileWidget(
                                    categoryDataList: _homeController
                                        .getCategoryModel.data![index],
                                    callback: () {
                                      setState(() {
                                        _homeController
                                            .getCategoryModel
                                            .data?[index]
                                            .isSelect = !(_homeController
                                                .getCategoryModel
                                                .data?[index]
                                                .isSelect ??
                                            false);
                                        _homeController.categoryId.clear();
                                        print(_homeController.getCategoryModel
                                                .data?[index].isSelect ??
                                            false);
                                        if (_homeController.getCategoryModel
                                                .data?[index].isSelect ??
                                            false) {
                                          _homeController.categoryId.add(
                                              _homeController.getCategoryModel
                                                  .data?[index].id);
                                        } else {
                                          _homeController.categoryId.remove(
                                              _homeController.getCategoryModel
                                                  .data?[index].id);
                                        }
                                      });
                                    },
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  /*------------------ Search and Service ---------------*/
  _searchAndService() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
            width: Get.width * 0.8,
            child: TextField(
              controller: _serviceTextEditingController,
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
