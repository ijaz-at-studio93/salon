import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/api_constant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/page/setting/category/add_salon_category_page.dart';
import 'package:salon/page/setting/category/edit_salon_category_page.dart';
import 'package:salon/page/setting/category/widget/category_list_tile_widget.dart';
import 'package:salon/project_specific/progressbar_view.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:salon/util/NoItemsWidget.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final _homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _homeController.doGetSalonCategory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      appBar: const AppBarWidget(
        nameOfScreen: "Categories",
        isBackIcon: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: () {
                Get.to(() => AddSalonCategoryPage(
                      callback: () {
                        _homeController.doGetSalonCategory();
                      },
                    ));
              },
              child: Container(
                height: 45,
                width: Get.width * 0.4,
                margin: const EdgeInsets.only(right: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: ColorConstant.primaryColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.add,
                      color: ColorConstant.whiteColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Add Category",
                      style: AppTextTheme.medium.copyWith(
                          color: ColorConstant.whiteColor, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Obx(
            () => Expanded(
              child: _homeController.showProgress
                  ? const ProgressBarView()
                  : _homeController.getSalonCategoryListModel.data?.isEmpty ??
                          false
                      ? const NoItemsWidget(text: "Salon Category not found")
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              ListView.separated(
                                  separatorBuilder: (context, index) {
                                    return const Divider(
                                      endIndent: 20,
                                      indent: 20,
                                      color: ColorConstant.grayTextColor,
                                    );
                                  },
                                  itemCount: _homeController
                                          .getSalonCategoryListModel
                                          .data
                                          ?.length ??
                                      0,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: CategoryListTileWidget(
                                        description: _homeController
                                                .getSalonCategoryListModel
                                                .data?[index]
                                                .description ??
                                            "",
                                        name: _homeController
                                                .getSalonCategoryListModel
                                                .data?[index]
                                                .name ??
                                            "",
                                        imageFemale: _homeController
                                                .getSalonCategoryListModel
                                                .data?[index]
                                                .imageFemale ??
                                            "",
                                        imageMale: _homeController
                                                .getSalonCategoryListModel
                                                .data?[index]
                                                .imageMale ??
                                            "",
                                        serviceableGender: _homeController
                                                .getSalonCategoryListModel
                                                .data?[index]
                                                .serviceableGender ??
                                            "",
                                        onEdit: () {
                                          Get.to(() => EditSalonCategoryPage(
                                            salonCategoryId: _homeController
                                                .getSalonCategoryListModel
                                                .data?[index]
                                                .id  ??
                                                "",
                                                callback: () {
                                                  _homeController
                                                      .doGetSalonCategory();
                                                },
                                                categoryName: _homeController
                                                        .getSalonCategoryListModel
                                                        .data?[index]
                                                        .name ??
                                                    "",
                                                categoryGender: _homeController
                                                        .getSalonCategoryListModel
                                                        .data?[index]
                                                        .serviceableGender ??
                                                    "",
                                                categoryDescription: _homeController
                                                        .getSalonCategoryListModel
                                                        .data?[index]
                                                        .description ??
                                                    "",
                                                categoryMaleImage:
                                                    "${APIConstants.image}${_homeController.getSalonCategoryListModel.data?[index].imageMale ?? ""}",
                                                categoryFeMaleImage:
                                                    "${APIConstants.image}${_homeController.getSalonCategoryListModel.data?[index].imageFemale ?? ""}",
                                              ));
                                        },
                                        onDelete: () {
                                          _homeController.doDeleteSalonCategory(
                                              salonCategoryId: _homeController
                                                      .getSalonCategoryListModel
                                                      .data?[index]
                                                      .id ??
                                                  "",
                                              callback: () {
                                                _homeController
                                                    .doGetSalonCategory();
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
}
