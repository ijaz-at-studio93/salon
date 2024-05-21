import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/api_constant.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/auth_controller.dart';
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
  final _authController = Get.find<AuthController>();
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
                _detailWidget(
                    title: "Full Name",
                    subTile: _authController
                            .salonResponseModel.data?.salonData?.name ??
                        ""),
                _dividerWidget(),
                _detailWidget(
                    title: "Email",
                    subTile: _authController
                            .salonResponseModel.data?.salonData?.email ??
                        ""),
                _dividerWidget(),
                _detailWidget(
                    title: "Mobile Number",
                    subTile: _authController
                            .salonResponseModel.data?.salonData?.mobile ??
                        ""),
                _dividerWidget(),
                _detailWidget(
                    title: "Owner Name;",
                    subTile: _authController
                            .salonResponseModel.data?.salonData?.ownerName ??
                        ""),
                /* _detailWidget(title: "Address", subTile: _authController.salonResponseModel.data?.salonData?.address ?? ""),*/
                _dividerWidget(),
                _detailWidget(
                    title: "Owner Mobile;",
                    subTile: _authController
                            .salonResponseModel.data?.salonData?.ownerMobile ??
                        ""),
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
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CachedNetworkImage(
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    imageUrl:
                        "${APIConstants.image}${_authController.salonResponseModel.data?.salonData?.image ?? ""}",
                    placeholder: (context, url) => const Image(
                      image: AssetImage(AssetsConstant.placeHolder),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    errorWidget: (context, url, error) => const Image(
                      image: AssetImage(AssetsConstant.placeHolder),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
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
