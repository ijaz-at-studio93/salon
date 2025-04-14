import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/api/dio_client.dart';
import 'package:salon/constant/api_constant.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/model/service_model/salon_service_list_model.dart';
import 'package:salon/page/setting/adding_service/service_preview_page.dart';
import 'package:salon/project_specific/button_widget.dart';
import 'package:salon/project_specific/plus_icon_simple_textfield.dart';
import 'package:salon/project_specific/progress_container_view.dart';
import 'package:salon/project_specific/simple_text_field.dart';
import 'package:salon/util/pick_image.dart';

import '../../../project_specific/text_theme.dart';
import 'add_category_new_service.dart';
import 'add_new_product_service_page.dart';

class CreateNewServicePage extends StatefulWidget {
  final bool isUpdate;
  final String serviceId;
  final SalonService? salonService;

  const CreateNewServicePage(
      {super.key,
      required this.isUpdate,
      required this.salonService,
      required this.serviceId});

  @override
  State<CreateNewServicePage> createState() => _CreateNewServicePageState();
}

class _CreateNewServicePageState extends State<CreateNewServicePage> {
  final _serviceName = TextEditingController();
  final _descriptionController = TextEditingController();
  final _servicePrice = TextEditingController();
  final _duration = TextEditingController();
  int _selectedGender = 1;
  final Rx<String> _category = "".obs;

  String get getCategory => _category.value;
  final _product = TextEditingController();
  bool isHomeServiceEnable = false; // Variable to track the switch state

  final _homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    _homeController.categoryId.clear();
    _homeController.productId.clear();

    if (widget.isUpdate) {
      _serviceName.text = widget.salonService?.name ?? "";
      _descriptionController.text = widget.salonService?.description ?? "";
      _servicePrice.text = widget.salonService?.price.toString() ?? "";
      _duration.text = widget.salonService?.duration.toString() ?? "";
      if (widget.salonService?.gender == "male") {
        _selectedGender = 1;
      } else if (widget.salonService?.gender == "female") {
        _selectedGender = 2;
      } else {
        _selectedGender = 3;
      }
      _category.value =
          "Select Category${widget.salonService?.categories?.length.toString() ?? ""}";
      isHomeServiceEnable = widget.salonService?.homeService ?? false;
    }
  }

  int count = 0;
  int productCount = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.8,
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
          Obx(
            () => Expanded(
              child: ProgressContainerView(
                isProgressRunning: _homeController.showProgress,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SimpleTextFieldWidget(
                          textEditingController: _serviceName,
                          hintText: "Eg. Hair Straightening",
                          textInputType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          title: "Enter Service Name"),
                      const SizedBox(height: 16),
                      _description(
                          textEditingController: _descriptionController,
                          hintText: "Start Writing....",
                          textInputType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          title: "Description"),
                      const SizedBox(height: 16),
                      SimpleTextFieldWidget(
                          textEditingController: _servicePrice,
                          hintText: "For eg. ₹200",
                          textInputType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          title: "Service Price"),
                      const SizedBox(height: 16),
                      SimpleTextFieldWidget(
                          textEditingController: _duration,
                          hintText: "for eg. 45 min",
                          textInputType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          title: "Duration"),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "Select Gender",
                          style: AppTextTheme.regular.copyWith(
                              fontSize: 13, color: ColorConstant.blackColor),
                        ),
                      ),
                      _selectServiceGender(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Category Name",
                          style: AppTextTheme.regular.copyWith(
                              fontSize: 13, color: ColorConstant.blackColor),
                        ),
                      ),
                      const SizedBox(height: 5),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            enableDrag: false,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(32),
                                topRight: Radius.circular(32),
                              ),
                            ),
                            context: context,
                            builder: (context) {
                              return AddCategoryNewService(
                                callback: () {
                                  count = 0;

                                  categoryData.clear();
                                  int length = _homeController
                                          .getCategoryModel.data?.length ??
                                      0;

                                  for (int i = 0; i < length; i++) {
                                    if (_homeController.getCategoryModel
                                            .data?[i].isSelect ??
                                        false) {
                                      _homeController.categoryId.add(
                                          _homeController.getCategoryModel
                                                  .data?[i].id ??
                                              "");
                                      categoryData.add(_homeController
                                              .getCategoryModel.data?[i].id ??
                                          "");

                                      log('Create New Service ::=> ${_homeController.getCategoryModel.data?[i].id}');

                                      count++; // Increment count only for selected categories
                                    }
                                  }

                                  setState(() {
                                    log('categoryData New Service ::=> ${categoryData.length}');
                                  });
                                },
                              );
                            },
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          height: 50,
                          width: Get.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.transparent,
                            border: Border.all(
                              color: ColorConstant.borderColor,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                count == 0
                                    ? 'Tap To Enter'
                                    : "Selected Category ${count.toString()}",
                                style: AppTextTheme.medium.copyWith(
                                  color: count == 0
                                      ? ColorConstant.grayColor
                                      : ColorConstant.blackColor,
                                  fontSize: 13,
                                ),
                              ),
                              const Icon(
                                Icons.add,
                                color: ColorConstant.idColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Product/Service",
                          style: AppTextTheme.regular.copyWith(
                              fontSize: 13, color: ColorConstant.blackColor),
                        ),
                      ),
                      const SizedBox(height: 5),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            enableDrag: false,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(32),
                                topRight: Radius.circular(32),
                              ),
                            ),
                            context: context,
                            builder: (context) {
                              return AddNewProductServicePage(
                                callback: () {
                                  productCount = 0;
                                  _homeController.categoryId.clear();
                                  int length = _homeController
                                          .getProductListModel
                                          .productList
                                          ?.length ??
                                      0;

                                  for (int i = 0; i < length; i++) {
                                    if (_homeController
                                            .getProductListModel
                                            .productList?[i]
                                            .isSelectedProduct ??
                                        false) {
                                      _homeController.productId.add(
                                          _homeController.getProductListModel
                                              .productList?[i].id);
                                      productCount++; // Increment count only for selected categories
                                    }
                                  }

                                  setState(() {});
                                },
                              );
                            },
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          height: 50,
                          width: Get.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.transparent,
                            border: Border.all(
                              color: ColorConstant.borderColor,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                productCount == 0
                                    ? 'Tap To Enter'
                                    : "Select Product Service ${productCount.toString()}",
                                style: AppTextTheme.medium.copyWith(
                                  color: count == 0
                                      ? ColorConstant.grayColor
                                      : ColorConstant.blackColor,
                                  fontSize: 13,
                                ),
                              ),
                              const Icon(
                                Icons.add,
                                color: ColorConstant.idColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {},
                        child: _serviceImage(),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Is home service",
                              style: AppTextTheme.regular.copyWith(
                                  fontSize: 13,
                                  color: ColorConstant.blackColor),
                            ),
                            CupertinoSwitch(
                              activeColor: ColorConstant.primaryColor,
                              value: isHomeServiceEnable,
                              // Current state of the CupertinoSwitch
                              onChanged: (value) {
                                setState(() {
                                  isHomeServiceEnable =
                                      value; // Update the CupertinoSwitch state
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 30),
                        child: ButtonWidget(
                            buttonTitleText:
                                widget.isUpdate ? "Update" : "Next",
                            onPress: () {
                              if (widget.isUpdate) {
                                _doUpdateService();
                              } else {
                                _doAddService();
                              }
                            }),
                      ),
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

  List<String> categoryData = [];
  List<String> productData = [];

  /*--------------------- Do add Service ------------------------*/
  _doAddService() {
    if (_serviceName.text.isEmpty) {
      showMessage("Please enter service-name");
      return;
    } else if (_descriptionController.text.isEmpty) {
      showMessage("Please enter service description");
      return;
    } else if (_servicePrice.text.isEmpty) {
      showMessage("Please enter service price");
      return;
    } else if (_duration.text.isEmpty) {
      showMessage("Please enter service timing");
      return;
    } else if (count == 0) {
      showMessage("Please select Category");
      return;
    } else if (imagePath.path.isEmpty) {
      showMessage("Please add Service image");
      return;
    } else {
      print(_homeController.categoryId.length);

      /*for (int i = 0; i < _homeController.categoryId.length; i++) {
        categoryData.add(_homeController.categoryId[i]);
      }*/

      for (int i = 0; i < _homeController.productId.length; i++) {
        productData.add(_homeController.productId[i]);
      }
      _homeController.doAddService(
          name: _serviceName.text,
          description: _descriptionController.text,
          price: _servicePrice.text,
          duration: _duration.text,
          gender: _selectedGender == 1
              ? "male"
              : _selectedGender == 2
                  ? "female"
                  : "unisex",
          categoryID: categoryData,
          productId: productData,
          image: File(imagePath.path),
          isHomeService: isHomeServiceEnable,
          callback: () {
            showModalBottomSheet(
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                )),
                context: context,
                builder: (context) {
                  return ServicePreviewPage(
                    salonServiceId: _homeController.salonServiceId.value,
                  );
                });
          });
    }
  }

  /*-------------------- Do Update Service ----------------------*/
  _doUpdateService() {
    if (_serviceName.text.isEmpty) {
      showMessage("Please enter service-name");
      return;
    } else if (_descriptionController.text.isEmpty) {
      showMessage("Please enter service description");
      return;
    } else if (_servicePrice.text.isEmpty) {
      showMessage("Please enter service price");
      return;
    } else if (_duration.text.isEmpty) {
      showMessage("Please enter service timing");
      return;
    } else {
      List<String> categoryData = [];
      List<String> productData = [];

      for (int i = 0; i < _homeController.categoryId.length; i++) {
        categoryData.add(_homeController.categoryId[i]);
      }

      for (int i = 0; i < _homeController.productId.length; i++) {
        productData.add(_homeController.productId[i]);
      }

      _homeController.doUpdateService(
          serviceId: widget.serviceId,
          name: _serviceName.text,
          description: _descriptionController.text,
          price: _servicePrice.text,
          duration: _duration.text,
          gender: _selectedGender == 1
              ? "male"
              : _selectedGender == 2
                  ? "female"
                  : "unisex",
          categoryID: categoryData,
          productId: productData,
          image: imagePath.path.isEmpty ? null : File(imagePath.path),
          isHomeService: isHomeServiceEnable,
          callback: () {
            Navigator.pop(context);
            _homeController.doGetSalonServiceList();
          });
    }
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
  _description({
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
            "Service Image",
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
                  ? widget.isUpdate
                      ? CachedNetworkImage(
                          fit: BoxFit.fitHeight,
                          imageUrl:
                              "${APIConstants.image}${widget.salonService?.image ?? ""}",
                          placeholder: (context, url) => const Image(
                            image: AssetImage(AssetsConstant.placeHolder),
                            fit: BoxFit.fitHeight,
                          ),
                          errorWidget: (context, url, error) => const Image(
                            image: AssetImage(AssetsConstant.placeHolder),
                            fit: BoxFit.fitHeight,
                          ),
                        )
                      : Center(
                          child: Image.asset(
                            AssetsConstant.uploadIcon,
                            height: 24,
                            width: 24,
                          ),
                        )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        imagePath,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
            ),
          )
        ],
      ),
    );
  }

  /*--------------- Select Service Gender ------------*/

  _selectServiceGender() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedGender = 1;
              });
            },
            child: Container(
              height: 30,
              width: 100,
              decoration: BoxDecoration(
                  color: _selectedGender == 1
                      ? ColorConstant.primaryColor.withOpacity(0.10)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 16,
                    width: 16,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _selectedGender == 1
                            ? ColorConstant.primaryColor
                            : ColorConstant.blackColor,
                      ),
                    ),
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _selectedGender == 1
                            ? ColorConstant.primaryColor
                            : Colors.transparent,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    "Male",
                    style: AppTextTheme.medium.copyWith(
                        color: ColorConstant.blackColor, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 15),
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedGender = 2;
              });
            },
            child: Container(
              height: 30,
              width: 100,
              decoration: BoxDecoration(
                  color: _selectedGender == 2
                      ? ColorConstant.primaryColor.withOpacity(0.10)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 16,
                    width: 16,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _selectedGender == 2
                            ? ColorConstant.primaryColor
                            : ColorConstant.blackColor,
                      ),
                    ),
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _selectedGender == 2
                            ? ColorConstant.primaryColor
                            : Colors.transparent,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    "Female",
                    style: AppTextTheme.medium.copyWith(
                        color: ColorConstant.blackColor, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 15),
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedGender = 3;
              });
            },
            child: Container(
              height: 30,
              width: 100,
              decoration: BoxDecoration(
                  color: _selectedGender == 3
                      ? ColorConstant.primaryColor.withOpacity(0.10)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 16,
                    width: 16,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _selectedGender == 3
                            ? ColorConstant.primaryColor
                            : ColorConstant.blackColor,
                      ),
                    ),
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _selectedGender == 3
                            ? ColorConstant.primaryColor
                            : Colors.transparent,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    "Unisex",
                    style: AppTextTheme.medium.copyWith(
                        color: ColorConstant.blackColor, fontSize: 13),
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
