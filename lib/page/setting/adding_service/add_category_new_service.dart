import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/page/setting/adding_service/widget/add_category_list_tile_widget.dart';
import 'package:salon/project_specific/progressbar_view.dart';
import 'package:salon/project_specific/text_theme.dart';

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
                    Get.back();
                    widget.callback();
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
                  "${_homeController.selectCategoryCount + 1}",
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
                  : ListView.separated(
                      separatorBuilder: (context, index) {
                        return const Divider(
                          endIndent: 20,
                          indent: 20,
                          color: ColorConstant.dividerColor,
                        );
                      },
                      itemCount:
                          _homeController.getCategoryModel.data?.length ?? 0,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        for (int i = 0;
                            i < _homeController.categoryId.length;
                            i++) {
                          if (_homeController
                                  .getCategoryModel.data?[index].id ==
                              _homeController.categoryId[i]) {
                            _homeController
                                .getCategoryModel.data?[index].isSelect = true;
                          }
                        }

                        _homeController.selectCategoryCount =
                            _homeController.getCategoryModel.data?.length ?? 0;
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: AddCategoryListTileWidget(
                            categoryDataList:
                                _homeController.getCategoryModel.data![index],
                            callback: () {
                              setState(() {
                                _homeController.getCategoryModel.data?[index]
                                    .isSelect = !(_homeController
                                        .getCategoryModel
                                        .data?[index]
                                        .isSelect ??
                                    false);
                                _homeController.categoryId.clear();
                                if (_homeController.getCategoryModel
                                        .data?[index].isSelect ??
                                    false) {
                                  _homeController.categoryId.add(_homeController
                                      .getCategoryModel.data?[index].id);
                                } else {
                                  _homeController.categoryId.remove(
                                      _homeController
                                          .getCategoryModel.data?[index].id);
                                }
                              });
                            },
                          ),
                        );
                      }),
            ),
          ),
        ],
      ),
    );
  }
}
