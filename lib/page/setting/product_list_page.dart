import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/api_constant.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/model/service_model/product_list_data_model.dart';
import 'package:salon/page/setting/add_product_page.dart';
import 'package:salon/page/setting/widget/update_product.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';

import '../../project_specific/progressbar_view.dart';

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

  void _openAddPage() {
    Get.to(() => const AddProductPage());
  }

  void _openEditSheet(Product product) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      context: context,
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: UpdateProduct(product: product),
      ),
    );
  }

  void _confirmDelete(Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Delete",
          style:
              AppTextTheme.medium.copyWith(color: ColorConstant.blackColor),
        ),
        content: Text(
          "Are you sure you want to delete this product?",
          style: AppTextTheme.medium
              .copyWith(color: ColorConstant.blueGrayColor, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "Cancel",
              style: AppTextTheme.medium
                  .copyWith(color: ColorConstant.redColor, fontSize: 14),
            ),
          ),
          TextButton(
            onPressed: () {
              _homeController.doDeleteProduct(
                callback: () {
                  Get.back();
                  _homeController.doGetProductListData();
                },
                productId: product.id ?? "",
              );
            },
            child: Text(
              "Yes",
              style: AppTextTheme.medium
                  .copyWith(color: ColorConstant.primaryColor, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      appBar: const AppBarWidget(nameOfScreen: "Products"),
      body: Obx(
        () => _homeController.showProgress
            ? const ProgressBarView()
            : GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount:
                    (_homeController.getProductListModel.productList?.length ??
                            0) +
                        1,
                itemBuilder: (context, i) {
                  if (i == 0) return _addCard();
                  final product =
                      _homeController.getProductListModel.productList![i - 1];
                  return _productCard(product);
                },
              ),
      ),
    );
  }

  Widget _addCard() {
    return GestureDetector(
      onTap: _openAddPage,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              size: 40,
              color: Colors.grey.shade500,
            ),
            const SizedBox(height: 8),
            Text(
              "Add",
              style: AppTextTheme.regular
                  .copyWith(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _productCard(Product product) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── Product Image ──────────────────────────
          CachedNetworkImage(
            imageUrl: "${APIConstants.image}${product.image ?? ""}",
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.grey.shade200,
              child: const Image(
                image: AssetImage(AssetsConstant.placeHolder),
                fit: BoxFit.cover,
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey.shade200,
              child: const Image(
                image: AssetImage(AssetsConstant.placeHolder),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // ── Action Buttons Overlay ─────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.55),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Edit
                  GestureDetector(
                    onTap: () => _openEditSheet(product),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit_outlined,
                        size: 16,
                        color: ColorConstant.primaryColor,
                      ),
                    ),
                  ),
                  // Delete
                  GestureDetector(
                    onTap: () => _confirmDelete(product),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        size: 16,
                        color: ColorConstant.redColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
