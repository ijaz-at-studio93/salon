import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/api/dio_client.dart';
import 'package:salon/api/master_api.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/model/master_model/get_category_model.dart';
import 'package:salon/project_specific/progress_container_view.dart';
import 'package:salon/project_specific/simple_text_field.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:salon/util/pick_image.dart';

class AddProductSheet extends StatefulWidget {
  const AddProductSheet({super.key});

  @override
  State<AddProductSheet> createState() => _AddProductSheetState();
}

class _AddProductSheetState extends State<AddProductSheet> {
  final _productName = TextEditingController();
  final _description = TextEditingController();
  final _price = TextEditingController();
  final _homeController = Get.find<HomeController>();

  List<GetCategoryData> _categories = [];
  String _selectedCategoryId = "";
  File _imagePath = File("");

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final list = await MasterApi.getCategory();
      if (mounted) setState(() => _categories = list);
    } catch (_) {}
  }

  void _submit() {
    if (_productName.text.isEmpty) {
      showMessage("Please enter product name.");
    } else if (_price.text.isEmpty) {
      showMessage("Please enter price.");
    } else if (_selectedCategoryId.isEmpty) {
      showMessage("Please select a category.");
    } else {
      _homeController.doAddProduct(
        categoryId: _selectedCategoryId,
        name: _productName.text,
        description: _description.text,
        price: _price.text,
        image: _imagePath.path.isEmpty ? null : File(_imagePath.path),
        callback: () {
          Navigator.pop(context);
          _homeController.doGetProductListData();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.88,
      width: Get.width,
      decoration: const BoxDecoration(
        color: ColorConstant.whiteColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          topLeft: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ────────────────────────────────────────────
          Container(
            height: 71,
            width: Get.width,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(
              color: ColorConstant.primaryColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(24),
                topLeft: Radius.circular(24),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    "Cancel",
                    textScaler: const TextScaler.linear(0.85),
                    style: AppTextTheme.regular.copyWith(
                        color: ColorConstant.whiteColor, fontSize: 19),
                  ),
                ),
                Text(
                  "Add Product",
                  textScaler: const TextScaler.linear(0.85),
                  style: AppTextTheme.bold
                      .copyWith(color: ColorConstant.whiteColor, fontSize: 19),
                ),
                const SizedBox(width: 72),
              ],
            ),
          ),

          // ── Scrollable Body ───────────────────────────────────
          Obx(
            () => Expanded(
              child: ProgressContainerView(
                isProgressRunning: _homeController.showProgress,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Name
                            SimpleTextFieldWidget(
                              textEditingController: _productName,
                              hintText: "Enter product name",
                              textInputType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              title: "Product Name",
                            ),
                            const SizedBox(height: 16),

                            // Price
                            SimpleTextFieldWidget(
                              textEditingController: _price,
                              hintText: "e.g. 100",
                              textInputType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              title: "Price",
                            ),
                            const SizedBox(height: 16),

                            // ── Image Upload Box ───────────────
                            GestureDetector(
                              onTap: () {
                                FileUtils.openPlatformImagePicker(
                                    onSelectImage: (file) {
                                  setState(() => _imagePath = file);
                                });
                              },
                              child: Container(
                                height: 165,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: ColorConstant.whiteColor,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: ColorConstant.blackColor,
                                      width: 1.5),
                                ),
                                child: _imagePath.path.isEmpty
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.upload_rounded,
                                            size: 52,
                                            color: ColorConstant.blackColor,
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            "Drop Image",
                                            style: AppTextTheme.medium.copyWith(
                                                fontSize: 15,
                                                color:
                                                    ColorConstant.blackColor),
                                          ),
                                        ],
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(_imagePath,
                                            fit: BoxFit.cover,
                                            width: double.infinity),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // ── Description (Optional) ─────────
                            Text(
                              "Description (Optional)",
                              style: AppTextTheme.bold.copyWith(
                                  fontSize: 14,
                                  color: ColorConstant.blackColor),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 70,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: ColorConstant.primaryColor,
                                    width: 1.5),
                              ),
                              child: TextField(
                                controller: _description,
                                maxLines: 4,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                style: AppTextTheme.medium.copyWith(
                                    color: ColorConstant.blackColor,
                                    fontSize: 13),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 10),
                                  border: InputBorder.none,
                                  hintStyle: AppTextTheme.regular.copyWith(
                                      color: ColorConstant.grayColor,
                                      fontSize: 13),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // ── Category Radio Buttons (Wrap) ──
                            if (_categories.isEmpty)
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: CircularProgressIndicator(
                                    color: ColorConstant.primaryColor,
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            else
                              Wrap(
                                spacing: 0,
                                runSpacing: 4,
                                children: _categories.map((cat) {
                                  return GestureDetector(
                                    onTap: () => setState(() =>
                                        _selectedCategoryId = cat.id ?? ""),
                                    child: SizedBox(
                                    width: (Get.width - 40) / 3,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Radio<String>(
                                          value: cat.id ?? "",
                                          groupValue: _selectedCategoryId,
                                          activeColor:
                                              ColorConstant.primaryColor,
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          visualDensity: VisualDensity.compact,
                                          onChanged: (val) => setState(() =>
                                              _selectedCategoryId = val ?? ""),
                                        ),
                                        Flexible(
                                          child: Text(
                                            cat.name ?? "",
                                            style: AppTextTheme.bold.copyWith(
                                                fontSize: 13,
                                                color:
                                                    ColorConstant.blackColor),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  );
                                }).toList(),
                              ),
                            const SizedBox(height: 20),

                            // ── Create You Own Button ──────────
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  // TODO: open create custom category flow
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorConstant.primaryColor
                                      .withOpacity(0.18),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32, vertical: 14),
                                ),
                                child: Text(
                                  "Create You Own",
                                  style: AppTextTheme.medium.copyWith(
                                      fontSize: 14,
                                      color: ColorConstant.primaryColor),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),

                    // ── Submit Button (pinned to bottom) ──────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      child: SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorConstant.primaryColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            "Submit",
                            style: AppTextTheme.bold.copyWith(
                                fontSize: 17, color: ColorConstant.whiteColor),
                          ),
                        ),
                      ),
                    ),
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
