import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
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
import '../../../constant/api_constant.dart';
import '../../../model/service_model/product_list_data_model.dart';

class UpdateProduct extends StatefulWidget {
  final Product product;
  const UpdateProduct({super.key, required this.product});

  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  final _description = TextEditingController();
  final _productName = TextEditingController();
  final _price = TextEditingController();
  final _homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    _description.text = widget.product.description ?? "";
    _productName.text = widget.product.name ?? "";
    _price.text = widget.product.price.toString();
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
                  "Update Product",
                  textScaler: const TextScaler.linear(0.85),
                  style: AppTextTheme.bold
                      .copyWith(color: ColorConstant.whiteColor, fontSize: 19),
                ),
                TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      "Done",
                      textScaler: const TextScaler.linear(0.85),
                      style: AppTextTheme.regular
                          .copyWith(color: Colors.transparent, fontSize: 19),
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
                            buttonTitleText: "Update",
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
    } else {
      _homeController.doUpdateProduct(
          productId: widget.product.id ?? "",
          name: _productName.text,
          description: _description.text ?? "",
          price: _price.text,
          image: imagePath.path.isEmpty ? null : File(imagePath.path),
          callback: () {
            Navigator.pop(context);
            _homeController.doGetProductListData();
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
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CachedNetworkImage(
                        fit: BoxFit.fitHeight,
                        imageUrl:
                            "${APIConstants.image}${widget.product.image}",
                        placeholder: (context, url) => const Image(
                          image: AssetImage(AssetsConstant.placeHolder),
                          fit: BoxFit.fitWidth,
                        ),
                        errorWidget: (context, url, error) => const Image(
                          image: AssetImage(AssetsConstant.placeHolder),
                          fit: BoxFit.fitWidth,
                        ),
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
