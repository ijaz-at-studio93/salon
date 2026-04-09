import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/api/dio_client.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:salon/util/pick_image.dart';
import '../../../constant/assetsconstant.dart';
import '../../../project_specific/button_widget.dart';
import '../../../project_specific/progress_container_view.dart';
import '../../../project_specific/project_appbar.dart';
import '../../../project_specific/simple_text_field.dart';

class EditSalonCategoryPage extends StatefulWidget {
  final VoidCallback callback;
  final String categoryName;
  final String salonCategoryId;
  final String categoryGender;
  final String categoryDescription;
  final String categoryMaleImage;
  final String categoryFeMaleImage;
  const EditSalonCategoryPage(
      {super.key,
      required this.callback,
      required this.categoryName,
      required this.categoryGender,
      required this.categoryDescription,
      required this.categoryMaleImage,
      required this.categoryFeMaleImage,
      required this.salonCategoryId});

  @override
  State<EditSalonCategoryPage> createState() => _EditSalonCategoryPageState();
}

class _EditSalonCategoryPageState extends State<EditSalonCategoryPage> {
  final _categoryTitle = TextEditingController();
  final _categoryDescription = TextEditingController();
  final _homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    _categoryTitle.text = widget.categoryName;
    _categoryDescription.text = widget.categoryDescription;
    if (widget.categoryGender == "male") {
      selectGender = 0;
    } else if (widget.categoryGender == "female") {
      selectGender = 1;
    } else {
      selectGender = 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(nameOfScreen: "Edit Category"),
      body: Obx(
        () => ProgressContainerView(
          isProgressRunning: _homeController.showProgress,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                SimpleTextFieldWidget(
                    textEditingController: _categoryTitle,
                    hintText: "Enter category title",
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    title: "Enter Category Title"),
                const SizedBox(height: 10),
                _saloonAddress(
                    textEditingController: _categoryDescription,
                    hintText: "Category Description",
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    title: "Enter Category Description",
                    onTap: () {}),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Category Image",
                    style: AppTextTheme.regular.copyWith(
                        fontSize: 13, color: ColorConstant.blackColor),
                  ),
                ),
                const SizedBox(height: 10),
                selectGender == 0
                    ? _maleImage()
                    : selectGender == 1
                        ? _femaleImage()
                        : Column(
                            children: [
                              _maleImage(),
                              const SizedBox(height: 10),
                              _femaleImage(),
                            ],
                          ),
                const SizedBox(height: 10),
                _selectGenderWidget(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: ButtonWidget(
                      buttonTitleText: "Update Category",
                      onPress: () {
                        doAddCategory();
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /*--------------------  Validation -----------------*/
  doAddCategory() {
    if (_categoryTitle.text.isEmpty) {
      showMessage("Please Enter CategoryTitle");
    } else if (_categoryDescription.text.isEmpty) {
      showMessage("Please Enter CategoryTitle");
    } else {
      if (selectGender == 0) {
        _homeController.doUpdateCategory(
            salonCategoryId: widget.salonCategoryId,
            name: _categoryTitle.text,
            description: _categoryDescription.text,
            serviceableGender: "male",
            maleImage: maleImage.path.isNotEmpty ? maleImage : null,
            femaleImage: null,
            callback: () {
              Get.back();
              widget.callback.call();
            });
      } else if (selectGender == 1) {
        _homeController.doUpdateCategory(
            salonCategoryId: widget.salonCategoryId,
            name: _categoryTitle.text,
            description: _categoryDescription.text,
            serviceableGender: "female",
            maleImage: null,
            femaleImage: femaleImage.path.isNotEmpty ? femaleImage : null,
            callback: () {
              Get.back();
              widget.callback.call();
            });
      } else if (selectGender == 2) {
        _homeController.doUpdateCategory(
            name: _categoryTitle.text,
            description: _categoryDescription.text,
            serviceableGender: "unisex",
            maleImage: maleImage.path.isNotEmpty ? maleImage : null,
            femaleImage: femaleImage.path.isNotEmpty ? femaleImage : null,
            callback: () {
              Get.back();
              widget.callback.call();
            },
            salonCategoryId: widget.salonCategoryId);
      }
    }
  }

  /*------------ Saloon Address TextField -----------*/
  _saloonAddress({
    required TextEditingController textEditingController,
    required String hintText,
    required String title,
    required TextInputType textInputType,
    required TextInputAction textInputAction,
    required VoidCallback onTap,
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
              onTap: onTap,
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
                  hintStyle: AppTextTheme.medium
                      .copyWith(color: ColorConstant.grayColor, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /*----------------------  category  Image  -----------------*/
  /*----------------- Service Image --------------*/
  File maleImage = File("");
  _maleImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Add Category Male Image.",
            style: AppTextTheme.regular
                .copyWith(fontSize: 13, color: ColorConstant.blackColor),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              FileUtils.openPlatformImagePicker(onSelectImage: (file) {
                setState(() {
                  maleImage = file;
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
              child: maleImage.path.isEmpty
                  ? Center(
                      child: CachedNetworkImage(
                        fit: BoxFit.fitHeight,
                        imageUrl: widget.categoryMaleImage,
                        placeholder: (context, url) => const Image(
                          image: AssetImage(AssetsConstant.placeHolder),
                        ),
                        errorWidget: (context, url, error) => const Image(
                          image: AssetImage(AssetsConstant.placeHolder),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        maleImage,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
            ),
          )
        ],
      ),
    );
  }

  File femaleImage = File("");
  _femaleImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Add Category Female Image.",
            style: AppTextTheme.regular
                .copyWith(fontSize: 13, color: ColorConstant.blackColor),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              FileUtils.openPlatformImagePicker(onSelectImage: (file) {
                setState(() {
                  femaleImage = file;
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
              child: femaleImage.path.isEmpty
                  ? Center(
                      child: CachedNetworkImage(
                        fit: BoxFit.fitHeight,
                        imageUrl: widget.categoryFeMaleImage,
                        placeholder: (context, url) => const Image(
                          image: AssetImage(AssetsConstant.placeHolder),
                        ),
                        errorWidget: (context, url, error) => const Image(
                          image: AssetImage(AssetsConstant.placeHolder),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        femaleImage,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
            ),
          )
        ],
      ),
    );
  }

  int selectGender = 0;

  /*----------------------  Select  Gender  ---------------------*/
  _selectGenderWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select Gender",
            style: AppTextTheme.regular
                .copyWith(fontSize: 13, color: ColorConstant.blackColor),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectGender = 0;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorConstant.blackColor),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              color: selectGender == 0
                                  ? ColorConstant.primaryColor
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Male",
                        style: AppTextTheme.regular.copyWith(
                            fontSize: 13, color: ColorConstant.blackColor),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectGender = 1;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorConstant.blackColor),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              color: selectGender == 1
                                  ? ColorConstant.primaryColor
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Female",
                        style: AppTextTheme.regular.copyWith(
                            fontSize: 13, color: ColorConstant.blackColor),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectGender = 2;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorConstant.blackColor),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              color: selectGender == 2
                                  ? ColorConstant.primaryColor
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Unisex",
                        style: AppTextTheme.regular.copyWith(
                            fontSize: 13, color: ColorConstant.blackColor),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
