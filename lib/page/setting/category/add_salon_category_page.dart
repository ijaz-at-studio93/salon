import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/api/dio_client.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/project_specific/button_widget.dart';
import 'package:salon/project_specific/progress_container_view.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/simple_text_field.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:salon/util/pick_image.dart';
import '../../../constant/assetsconstant.dart';

class AddSalonCategoryPage extends StatefulWidget {
  final VoidCallback callback;
  const AddSalonCategoryPage({super.key, required this.callback});

  @override
  State<AddSalonCategoryPage> createState() => _AddSalonCategoryPageState();
}

class _AddSalonCategoryPageState extends State<AddSalonCategoryPage> {
  final _categoryTitle = TextEditingController();
  final _categoryDescription = TextEditingController();
  final _homeController = Get.find<HomeController>();
  int selectProfession = 0; // 0 = hair, 1 = beauty
  String get _professionValue => selectProfession == 0 ? 'hair' : 'beauty';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(nameOfScreen: "Add Category"),
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
                const SizedBox(height: 10),
                _selectProfessionWidget(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: ButtonWidget(
                      buttonTitleText: "Add Category",
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
        if (maleImage.path.isEmpty) {
          showMessage("Please choose maleImage");
        } else {
          _homeController.doAddSalonCategory(
              name: _categoryTitle.text,
              description: _categoryDescription.text,
              serviceableGender: "male",
              profession: _professionValue,
              maleImage: maleImage,
              femaleImage: null,
              callback: () {
                Get.back();
                widget.callback.call();
              });
        }
      } else if (selectGender == 1) {
        if (femaleImage.path.isEmpty) {
          showMessage("Please choose femaleImage");
        } else {
          _homeController.doAddSalonCategory(
              name: _categoryTitle.text,
              description: _categoryDescription.text,
              serviceableGender: "female",
              profession: _professionValue,
              maleImage: null,
              femaleImage: femaleImage,
              callback: () {
                Get.back();
                widget.callback.call();
              });
        }
      } else if (selectGender == 2) {
        if (maleImage.path.isEmpty) {
          showMessage("Please choose maleImage");
        } else if (femaleImage.path.isEmpty) {
          showMessage("Please choose femaleImage");
        } else {
          _homeController.doAddSalonCategory(
              name: _categoryTitle.text,
              description: _categoryDescription.text,
              serviceableGender: "unisex",
              profession: _professionValue,
              maleImage: maleImage,
              femaleImage: femaleImage,
              callback: () {
                Get.back();
                widget.callback.call();
              });
        }
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
                    hintStyle: AppTextTheme.medium.copyWith(
                        color: ColorConstant.grayColor, fontSize: 13)),
              )),
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
                      child: Image.asset(
                        AssetsConstant.uploadIcon,
                        height: 24,
                        width: 24,
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
                      child: Image.asset(
                        AssetsConstant.uploadIcon,
                        height: 24,
                        width: 24,
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

  _selectProfessionWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select Profession",
            style: AppTextTheme.regular
                .copyWith(fontSize: 13, color: ColorConstant.blackColor),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () => setState(() => selectProfession = 0),
                child: Row(
                  children: [
                    Container(
                      width: 20, height: 20, padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        border: Border.all(color: ColorConstant.blackColor),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 15, height: 15,
                          decoration: BoxDecoration(
                            color: selectProfession == 0
                                ? ColorConstant.primaryColor
                                : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text("Hair",
                        style: AppTextTheme.regular.copyWith(
                            fontSize: 13, color: ColorConstant.blackColor)),
                  ],
                ),
              ),
              //const SizedBox(width: 10), // gap
              GestureDetector(
                onTap: () => setState(() => selectProfession = 1),
                child: Row(
                  children: [
                    Container(
                      width: 20, height: 20, padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        border: Border.all(color: ColorConstant.blackColor),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 15, height: 15,
                          decoration: BoxDecoration(
                            color: selectProfession == 1
                                ? ColorConstant.primaryColor
                                : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text("Beauty",
                        style: AppTextTheme.regular.copyWith(
                            fontSize: 13, color: ColorConstant.blackColor)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}
