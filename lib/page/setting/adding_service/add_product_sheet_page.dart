import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/api/dio_client.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/project_specific/button_widget.dart';
import 'package:salon/project_specific/progress_container_view.dart';
import 'package:salon/project_specific/simple_text_field.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:salon/util/pick_image.dart';

class ProductDetailsPage extends StatefulWidget {
  final VoidCallback callback;
  const ProductDetailsPage({super.key, required this.callback});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final _description = TextEditingController();
  final _productName = TextEditingController();
  final _price = TextEditingController();
  final _homeController = Get.find<HomeController>();
  String categoryId = "";
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
                      Get.back();
                    },
                    child: Text(
                      "Cancel",
                      textScaler: const TextScaler.linear(0.85),
                      style: AppTextTheme.regular.copyWith(
                          color: ColorConstant.whiteColor, fontSize: 19),
                    )),
                Text(
                  "Add New Product",
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
                      textScaler: const TextScaler.linear(0.85),
                      style: AppTextTheme.regular.copyWith(
                          color: ColorConstant.whiteColor, fontSize: 19),
                    ))
              ],
            ),
          ),
          Obx(
            () => Expanded(
              child: ProgressContainerView(
                isProgressRunning: _homeController.showProgress,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      _selectCategory(),
                      const SizedBox(height: 16),
                      SimpleTextFieldWidget(
                          textEditingController: _productName,
                          hintText: "Enter Here",
                          textInputType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          title: "Product Name"),
                      const SizedBox(height: 16),
                      _address(
                          textEditingController: _description,
                          hintText: "Product Detail",
                          textInputType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          title: "Description"),
                      const SizedBox(height: 16),
                      SimpleTextFieldWidget(
                          textEditingController: _price,
                          hintText: "for Ex 100",
                          textInputType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          title: "Product Price"),
                      const SizedBox(height: 16),
                      _serviceImage(),
                      const SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ButtonWidget(
                            buttonTitleText: "Save",
                            onPress: () {
                              doProductAdd();
                            }),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /*------------------ Validation --------------*/
  doProductAdd() {
    if (_productName.text.isEmpty) {
      showMessage("Please enter product-name.");
    } else if (_description.text.isEmpty) {
      showMessage("Please enter description.");
    } else if (_price.text.isEmpty) {
      showMessage("Please enter price.");
    } else if (imagePath.path.isEmpty) {
      showMessage("Please Choose Product-image.");
    } else if (categoryId.isEmpty) {
      showMessage("Please Choose category.");
    } else {
      _homeController.doAddProduct(
          categoryId: categoryId,
          name: _productName.text,
          description: _description.text,
          price: _price.text,
          image: File(imagePath.path),
          callback: () {
            widget.callback();
            Get.back();
          });
    }
  }

  /*------------ Saloon Address TextField -----------*/
  _address({
    required TextEditingController textEditingController,
    required String hintText,
    required String title,
    required TextInputType textInputType,
    required TextInputAction textInputAction,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextTheme.regular
                .copyWith(fontSize: 13, color: ColorConstant.blackColor),
          ),
          const SizedBox(height: 12),
          Container(
              height: 110,
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: ColorConstant.borderColor,
                ),
              ),
              child: TextField(
                controller: textEditingController,
                maxLines: 8,
                keyboardType: textInputType,
                textInputAction: textInputAction,
                style: AppTextTheme.medium
                    .copyWith(color: ColorConstant.blackColor, fontSize: 13),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 12, top: 15),
                    border: InputBorder.none,
                    hintText: hintText,
                    hintStyle: AppTextTheme.medium.copyWith(
                        color: ColorConstant.grayColor, fontSize: 13)),
              )),
        ],
      ),
    );
  }

  /*---------------------- Select  Category ---------------------*/
  _selectCategory() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 50,
        width: Get.width,
        child: DropdownButtonFormField2(
          isExpanded: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          hint: Text(
            'Select Category',
            style: AppTextTheme.medium
                .copyWith(color: ColorConstant.grayColor, fontSize: 13),
          ),
          items: _homeController.getCategoryModel.data
              ?.map((item) => DropdownMenuItem(
                    value: item.name,
                    onTap: () {
                      categoryId = item.id.toString();
                    },
                    child: Text(item.name ?? "",
                        style: AppTextTheme.medium.copyWith(
                            color: ColorConstant.blackColor, fontSize: 13)),
                  ))
              .toList(),
          validator: (value) {
            if (value == null) {
              return 'Select Category';
            }
            return null;
          },
          onChanged: (value) {
            //Do something when selected item is changed.
          },
          onSaved: (value) {
            /* selectedValue = value.toString();*/
          },
          buttonStyleData: const ButtonStyleData(
            padding: EdgeInsets.only(right: 8),
          ),
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            padding: EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
      ),
    );
  }

  /*----------------- Service Image --------------*/
  File imagePath = File("");
  _serviceImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Product Image ",
            style: AppTextTheme.regular
                .copyWith(fontSize: 13, color: ColorConstant.blackColor),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              FileUtils.openPlatformImagePicker(onSelectImage: (file) {
                setState(() {
                  imagePath = file;
                });
              });
            },
            child: Container(
              height: 165,
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: ColorConstant.borderColor,
                ),
              ),
              child: imagePath.path.isEmpty
                  ? Center(
                      child: Image.asset(
                        AssetsConstant.uploadIcon,
                        height: 24,
                        width: 24,
                      ),
                    )
                  : Image.file(
                      imagePath,
                      fit: BoxFit.fitHeight,
                    ),
            ),
          )
        ],
      ),
    );
  }
}
