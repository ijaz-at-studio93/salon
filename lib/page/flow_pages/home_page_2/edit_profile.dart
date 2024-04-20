import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/button_widget.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:salon/util/pick_image.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.whiteColor,
      appBar: const AppBarWidget(
        nameOfScreen: "Edit Profile",
        isBackIcon: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              children: [
                _stylistProfilePhoto(),
                const SizedBox(height: 15),
                _detailWidget(title: "Full Name", subTile: "Tilak Chauhan"),
                _dividerWidget(),
                _detailWidget(
                    title: "Email", subTile: "sourabhdahari1221@gmail.com"),
                _dividerWidget(),
                _detailWidget(title: "Gender", subTile: "Male"),
                _dividerWidget(),
                _detailWidget(title: "Date Of Birth", subTile: "12/5/2000"),
                _dividerWidget(),
                _detailWidget(title: "Mobile Number", subTile: "+91 900956516"),
                _dividerWidget(),
                _detailWidget(
                    title: "Mobile Number", subTile: "Portfilio Video"),
                _dividerWidget(),
                _detailWidget(
                    title: "Can Do", subTile: "Both In Home and Saloon"),
                _dividerWidget(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Portfolio",
                      style: AppTextTheme.medium.copyWith(
                          color: ColorConstant.grayTextColor, fontSize: 16),
                    ),
                    Row(
                      children: [
                        Text(
                          "See Activity",
                          style: AppTextTheme.bold.copyWith(
                              fontSize: 16, color: ColorConstant.primaryColor),
                        ),
                        const SizedBox(width: 2),
                        const Icon(
                          CupertinoIcons.arrowshape_turn_up_right_fill,
                          color: ColorConstant.primaryColor,
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: ButtonWidget(
                buttonTitleText: "Save",
                onPress: () {
                  Get.back();
                }),
          ),
        ],
      ),
    );
  }

  /*----------- Profile Photo -------------*/
  File imagePath = File("");
  _stylistProfilePhoto() {
    return GestureDetector(
      onTap: () {
        FileUtils.openPlatformImagePicker(onSelectImage: (file) {
          setState(() {
            imagePath = file;
          });
        });
      },
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          imagePath.path == ""
              ? Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: ColorConstant.grayTextColor.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.file(
                    imagePath,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
          Positioned(
            bottom: 10,
            left: 70,
            right: 0,
            child: Container(
              width: 38,
              height: 38,
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                  color: ColorConstant.whiteColor, shape: BoxShape.circle),
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                    color: ColorConstant.editButtonColor,
                    shape: BoxShape.circle),
                child: Center(
                  child: Image.asset(
                    AssetsConstant.editIcon,
                    width: 16,
                    height: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /*---------- Detail Widget ------------*/
  _detailWidget({required String title, required String subTile}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextTheme.medium
              .copyWith(color: ColorConstant.grayTextColor, fontSize: 16),
        ),
        Text(
          subTile,
          style: AppTextTheme.bold
              .copyWith(fontSize: 16, color: ColorConstant.blackColor),
        ),
      ],
    );
  }

  /*------------- Divider ----------*/
  _dividerWidget() {
    return const Divider(
      height: 35,
      color: ColorConstant.dividerColor,
    );
  }
}
