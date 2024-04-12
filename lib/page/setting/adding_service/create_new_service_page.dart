import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/page/setting/adding_service/product_details_page.dart';
import 'package:salon/project_specific/button_widget.dart';
import 'package:salon/project_specific/plus_icon_simple_textfield.dart';
import 'package:salon/project_specific/simple_text_field.dart';

import '../../../project_specific/text_theme.dart';
import 'add_category_new_service.dart';
import 'add_new_product_service_page.dart';

class CreateNewServicePage extends StatefulWidget {
  const CreateNewServicePage({super.key});

  @override
  State<CreateNewServicePage> createState() => _CreateNewServicePageState();
}

class _CreateNewServicePageState extends State<CreateNewServicePage> {
  final _serviceName = TextEditingController();
  final _categoryName = TextEditingController();
  final _productName = TextEditingController();
  final _descriptionName = TextEditingController();
  final _servicePrice = TextEditingController();

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
                  "Create Service",
                  textScaler: const TextScaler.linear(0.85),
                  style: AppTextTheme.bold
                      .copyWith(color: ColorConstant.whiteColor, fontSize: 19),
                ),
                const SizedBox(),
                const SizedBox()
              ],
            ),
          ),
          _countRowWidget(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SimpleTextFieldWidget(
                      textEditingController: _serviceName,
                      hintText: "Eg. Hair Straightening",
                      textInputType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      title: "Enter Service Name"),
                  const SizedBox(height: 16),
                  PlusIconSimpleTextField(
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
                              return const AddCategoryNewService();
                            });
                      },
                      readOnly: true,
                      textEditingController: _categoryName,
                      hintText: "Tap To Enter",
                      textInputType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      title: "Category Name"),
                  const SizedBox(height: 16),
                  PlusIconSimpleTextField(
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
                              return const AddNewProductServicePage();
                            });
                      },
                      readOnly: true,
                      textEditingController: _productName,
                      hintText: "Tap To Enter",
                      textInputType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      title: "Product/Service "),
                  const SizedBox(height: 16),
                  _address(
                      textEditingController: _descriptionName,
                      hintText: "Start Writing....",
                      textInputType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      title: "Description"),
                  const SizedBox(height: 16),
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
                            return const ProductDetailsPage();
                          });
                    },
                    child: _serviceImage(),
                  ),
                  const SizedBox(height: 16),
                  SimpleTextFieldWidget(
                      textEditingController: _servicePrice,
                      hintText: "For eg. ₹200",
                      textInputType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      title: "Service Price"),
                  const SizedBox(height: 16),
                  PlusIconSimpleTextField(
                      onTap: () {},
                      readOnly: true,
                      textEditingController: _productName,
                      hintText: "Tap To Enter",
                      textInputType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      title: "Add Offer"),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    child:
                        ButtonWidget(buttonTitleText: "Next", onPress: () {}),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /*---------------- Count Row Widget -------------*/
  _countRowWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 20,
                width: 20,
                decoration: const BoxDecoration(
                    color: ColorConstant.primaryColor, shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    "1",
                    textScaler: const TextScaler.linear(0.85),
                    style: AppTextTheme.bold.copyWith(
                        color: ColorConstant.whiteColor, fontSize: 16),
                  ),
                ),
              ),
              Container(
                height: 2,
                width: 80,
                color: ColorConstant.primaryColor,
              ),
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: ColorConstant.primaryColor,
                    ),
                    shape: BoxShape.circle),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(right: 100, left: 100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Details",
                  textScaler: const TextScaler.linear(0.85),
                  style: AppTextTheme.regular.copyWith(
                      color: ColorConstant.grayTextColor, fontSize: 12),
                ),
                Text(
                  "Preview",
                  textScaler: const TextScaler.linear(0.85),
                  style: AppTextTheme.regular.copyWith(
                      color: ColorConstant.grayTextColor, fontSize: 12),
                ),
              ],
            ),
          )
        ],
      ),
    );
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
  _serviceImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Service",
            style: AppTextTheme.regular
                .copyWith(fontSize: 13, color: ColorConstant.blackColor),
          ),
          const SizedBox(height: 12),
          Container(
            height: 165,
            width: Get.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: ColorConstant.borderColor,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AssetsConstant.uploadIcon,
                  height: 24,
                  width: 24,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
