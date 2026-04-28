import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/api/dio_client.dart';
import 'package:salon/api/master_api.dart';
import 'package:salon/constant/api_constant.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/model/master_model/get_category_model.dart';
import 'package:salon/model/service_model/product_list_data_model.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:salon/util/pick_image.dart';

class AddProductPage extends StatefulWidget {
  /// When set, the page is used to update an existing product (same fields as create).
  final Product? product;

  const AddProductPage({super.key, this.product});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _productName = TextEditingController();
  final _description = TextEditingController();
  final _homeController = Get.find<HomeController>();

  // List<GetCategoryData> _categories = [];
  // String _selectedCategoryId = "";
  final List<String> staticCategories = [
    "Colouring",
    "Hair Spa",
    "Hair Treatments",
    "De-tan",
    "Facial",
    "Clean Up",
    "Mani",
    "Pedi",
    "Waxing",
  ];

  String _selectedCategory = "";
  final TextEditingController _customCategory = TextEditingController();
  File _imagePath = File("");

  bool get _isEdit => widget.product != null;

  String? get _existingImagePath => widget.product?.image;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    if (p != null) {
      _productName.text = p.name ?? "";
      _description.text = p.description ?? "";
      //_selectedCategoryId = p.serviceCategoryId ?? "";
      _selectedCategory = p.salonCategory ?? "";

      if (!staticCategories.contains(_selectedCategory) &&
          _selectedCategory.isNotEmpty) {
        _customCategory.text = _selectedCategory;
      }
    }
    //_loadCategories();
  }

  @override
  void dispose() {
    _productName.dispose();
    _description.dispose();
    super.dispose();
  }

  // Future<void> _loadCategories() async {
  //   try {
  //     final list = await MasterApi.getCategory();
  //     if (mounted) setState(() => _categories = list);
  //   } catch (_) {}
  // }

  void _submit() {
    if (_productName.text.isEmpty) {
      showMessage("Please enter product name.");
    } else if (_selectedCategory.isEmpty) {
      showMessage("Please select a category.");
    } else {
      if (_isEdit) {
        _homeController.doUpdateProduct(
          productId: widget.product!.id ?? "",
          name: _productName.text,
          description: _description.text,
          //serviceCategoryId: _selectedCategoryId,
          salonCategory: _selectedCategory,
          image: _imagePath.path.isEmpty ? null : File(_imagePath.path),
          callback: () {
            Get.back();
            _homeController.doGetProductListData();
          },
        );
      } else {
        _homeController.doAddProduct(
          //categoryId: _selectedCategoryId,
          salonCategory: _selectedCategory,
          name: _productName.text,
          description: _description.text,
          price: "",
          image: _imagePath.path.isEmpty ? null : File(_imagePath.path),
          callback: () {
            Get.back();
            _homeController.doGetProductListData();
          },
        );
      }
    }
  }

  Widget _buildImageArea() {
    if (_imagePath.path.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          _imagePath,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
      );
    }
    if (_isEdit &&
        _existingImagePath != null &&
        _existingImagePath!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          width: double.infinity,
          height: 180,
          imageUrl: "${APIConstants.image}$_existingImagePath",
          placeholder: (context, url) => const Image(
            image: AssetImage(AssetsConstant.placeHolder),
            fit: BoxFit.cover,
          ),
          errorWidget: (context, url, error) => const Image(
            image: AssetImage(AssetsConstant.placeHolder),
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.upload_rounded,
          size: 52,
          color: ColorConstant.blackColor,
        ),
        const SizedBox(height: 10),
        Text(
          "Drop Image",
          style: AppTextTheme.medium
              .copyWith(fontSize: 15, color: ColorConstant.blackColor),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.whiteColor,
      appBar: AppBarWidget(
          nameOfScreen: _isEdit ? "Update Product" : "Add Product"),
      body: Obx(
        () => _homeController.showProgress
            ? const Center(
                child: CircularProgressIndicator(
                  color: ColorConstant.primaryColor,
                ),
              )
            : Column(
                children: [
                  // ── Scrollable content ───────────────────────
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Product Name ─────────────────────
                          Text(
                            "Product Name",
                            style: AppTextTheme.bold.copyWith(
                                fontSize: 14, color: ColorConstant.blackColor),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: ColorConstant.primaryColor,
                                  width: 1.5),
                            ),
                            child: TextField(
                              controller: _productName,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              style: AppTextTheme.medium.copyWith(
                                  color: ColorConstant.blackColor,
                                  fontSize: 13),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 14),
                                border: InputBorder.none,
                                hintText: "Enter product name",
                                hintStyle: AppTextTheme.regular.copyWith(
                                    color: ColorConstant.grayColor,
                                    fontSize: 13),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // ── Image Upload Box ─────────────────
                          GestureDetector(
                            onTap: () {
                              FileUtils.openPlatformImagePicker(
                                  onSelectImage: (file) {
                                setState(() => _imagePath = file);
                              });
                            },
                            child: Container(
                              height: 180,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: ColorConstant.whiteColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: ColorConstant.blackColor,
                                    width: 1.5),
                              ),
                              child: _buildImageArea(),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // ── Description (Optional) ───────────
                          Text(
                            "Description (Optional)",
                            style: AppTextTheme.bold.copyWith(
                                fontSize: 14, color: ColorConstant.blackColor),
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
                              textInputAction: TextInputAction.done,
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
                          const SizedBox(height: 24),

                          // ── Category Radio Buttons (Wrap) ────
                          // if (_categories.isEmpty)
                          //   const Center(
                          //     child: Padding(
                          //       padding: EdgeInsets.symmetric(vertical: 8),
                          //       child: CircularProgressIndicator(
                          //         color: ColorConstant.primaryColor,
                          //         strokeWidth: 2,
                          //       ),
                          //     ),
                          //   )
                          // else
                          //   Wrap(
                          //     spacing: 0,
                          //     runSpacing: 4,
                          //     children: staticCategories.map((cat) {
                          //       return GestureDetector(
                          //         onTap: () {
                          //           setState(() {
                          //             _selectedCategory = cat;
                          //             _customCategory.clear();
                          //           });
                          //         },
                          //         child: SizedBox(
                          //           width: (MediaQuery.of(context).size.width - 40) / 3,
                          //           child: Row(
                          //             children: [
                          //               Radio<String>(
                          //                 value: cat,
                          //                 groupValue: _selectedCategory,
                          //                 activeColor: ColorConstant.primaryColor,
                          //                 onChanged: (val) {
                          //                   setState(() {
                          //                     _selectedCategory = val ?? "";
                          //                     _customCategory.clear();
                          //                   });
                          //                 },
                          //               ),
                          //               Flexible(
                          //                 child: Text(
                          //                   cat,
                          //                   overflow: TextOverflow.ellipsis,
                          //                   style: AppTextTheme.bold.copyWith(fontSize: 13, color: Colors.black),
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       );
                          //     }).toList(),
                          //   ),
                          Wrap(
                            spacing: 0,
                            runSpacing: 4,
                            children: staticCategories.map((cat) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedCategory = cat;
                                    _customCategory.clear();
                                  });
                                },
                                child: SizedBox(
                                  width: (MediaQuery.of(context).size.width - 40) / 3,
                                  child: Row(
                                    children: [
                                      Radio<String>(
                                        value: cat,
                                        groupValue: _selectedCategory,
                                        activeColor: ColorConstant.primaryColor,
                                        onChanged: (val) {
                                          setState(() {
                                            _selectedCategory = val ?? "";
                                            _customCategory.clear();
                                          });
                                        },
                                      ),
                                      Flexible(
                                        child: Text(
                                          cat,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppTextTheme.bold.copyWith(fontSize: 13, color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),

                          /// 👇 ADD THIS BLOCK HERE
                          if (_customCategory.text.isNotEmpty)
                            SizedBox(
                              width: (MediaQuery.of(context).size.width - 40) / 3,
                              child: Row(
                                children: [
                                  Radio<String>(
                                    value: _customCategory.text,
                                    groupValue: _selectedCategory,
                                    activeColor: ColorConstant.primaryColor,
                                    onChanged: (val) {
                                      setState(() {
                                        _selectedCategory = val ?? "";
                                      });
                                    },
                                  ),
                                  Flexible(
                                    child: Text(
                                      _customCategory.text,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextTheme.bold.copyWith(
                                        fontSize: 13,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 24),

                          // ── Create You Own Button ────────────
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Enter Category"),
                                      content: TextField(
                                        controller: _customCategory,
                                        decoration: const InputDecoration(
                                          hintText: "Enter custom category",
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          // onPressed: () {
                                          //   if (_customCategory.text.isNotEmpty) {
                                          //     setState(() {
                                          //       _selectedCategory = _customCategory.text;
                                          //     });
                                          //     Navigator.pop(context);
                                          //   }
                                          // },
                                          onPressed: () {
                                            final text = _customCategory.text.trim();

                                            if (text.isNotEmpty) {
                                              setState(() {
                                                _selectedCategory = text;
                                                _customCategory.text = text;
                                              });
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: const Text("Save"),
                                        )
                                      ],
                                    );
                                  },
                                );
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
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),

                  // ── Submit Button (pinned to bottom) ──────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
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
                          _isEdit ? "Update" : "Submit",
                          style: AppTextTheme.bold.copyWith(
                              fontSize: 17, color: ColorConstant.whiteColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
