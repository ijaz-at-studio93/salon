import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/page/setting/adding_service/add_product_sheet_page.dart';
import 'package:salon/page/setting/adding_service/widget/add_product_check_box_widget.dart';
import 'package:salon/project_specific/progressbar_view.dart';
import 'package:salon/project_specific/text_theme.dart';

class AddNewProductServicePage extends StatefulWidget {
  final VoidCallback callback;
  const AddNewProductServicePage({super.key, required this.callback});

  @override
  State<AddNewProductServicePage> createState() =>
      _AddNewProductServicePageState();
}

class _AddNewProductServicePageState extends State<AddNewProductServicePage> {
  final _serviceTextEditingController = TextEditingController();

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
    return Container(
      height: Get.height * 0.7,
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
                    )),
                Text(
                  "Add Product",
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
                      textScaler: const TextScaler.linear(0.85),
                      style: AppTextTheme.regular.copyWith(
                          color: ColorConstant.whiteColor, fontSize: 19),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _searchAndService(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
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
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: ProductDetailsPage(
                              callback: () {
                                _homeController.doGetProductListData();
                              },
                            ),
                          );
                        });
                  },
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    color: ColorConstant.primaryColor,
                    radius: const Radius.circular(66),
                    padding: const EdgeInsets.all(4),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
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
          Obx(
            () => Expanded(
              child: _homeController.showProgress
                  ? const ProgressBarView()
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          _homeController.getProductListModel.productList
                                      ?.isEmpty ??
                                  false
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: Get.height * 0.15),
                                    Text(
                                      "No Any Product Found",
                                      style: AppTextTheme.bold.copyWith(
                                          color: ColorConstant.blackColor,
                                          fontSize: 18),
                                    ),
                                    Text(
                                      "Please Tap to  + Add new Button",
                                      style: AppTextTheme.bold.copyWith(
                                          color: ColorConstant.blackColor,
                                          fontSize: 18),
                                    ),
                                  ],
                                )
                              : ListView.separated(
                                  separatorBuilder: (context, index) {
                                    return const Divider(
                                      endIndent: 20,
                                      indent: 20,
                                      color: ColorConstant.dividerColor,
                                    );
                                  },
                                  itemCount: _homeController.getProductListModel
                                          .productList?.length ??
                                      0,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    for (int i = 0;
                                        i < _homeController.productId.length;
                                        i++) {
                                      if (_homeController.productId[i] ==
                                          _homeController.getProductListModel
                                              .productList?[index].id) {
                                        _homeController
                                            .getProductListModel
                                            .productList?[index]
                                            .isSelectedProduct = true;
                                      }
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: AddProductCheckBoxWidget(
                                        homeController: _homeController,
                                        product: _homeController
                                            .getProductListModel
                                            .productList![index],
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
