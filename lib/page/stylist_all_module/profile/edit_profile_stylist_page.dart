import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/api_constant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/auth_controller.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';
import '../../../constant/assetsconstant.dart';
import '../../stylist/stylist_about_page.dart';

class EditProfileStylistPage extends StatefulWidget {
  const EditProfileStylistPage({super.key});

  @override
  State<EditProfileStylistPage> createState() => _EditProfileStylistPageState();
}

class _EditProfileStylistPageState extends State<EditProfileStylistPage> {
  final _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      appBar: const AppBarWidget(nameOfScreen: "Edit Profile"),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: Get.height * 0.05),
                  _stylistProfilePhoto(),
                  SizedBox(height: Get.height * 0.05),
                  _profileRowWidget(
                      title: "Full Name",
                      subTitle: _authController.getSalonArtistResponseModel.data
                              ?.salonArtistData?.name ??
                          ""),
                  const Divider(
                    height: 30,
                    color: ColorConstant.grayTextColor,
                    endIndent: 20,
                    indent: 20,
                  ),
                  _profileRowWidget(
                      title: "Email",
                      subTitle: _authController.getSalonArtistResponseModel.data
                              ?.salonArtistData?.email ??
                          ""),
                  const Divider(
                    height: 30,
                    color: ColorConstant.grayTextColor,
                    endIndent: 20,
                    indent: 20,
                  ),
                  _profileRowWidget(
                      title: "Gender",
                      subTitle: _authController.getSalonArtistResponseModel.data
                              ?.salonArtistData?.gender ??
                          ""),
                  const Divider(
                    height: 30,
                    color: ColorConstant.grayTextColor,
                    endIndent: 20,
                    indent: 20,
                  ),
                  /* _profileRowWidget(
                      title: "Date Of Birth", subTitle: _authController.getSalonArtistResponseModel.data?.salonArtistData?.),
                  const Divider(
                    height: 30,
                    color: ColorConstant.grayTextColor,
                    endIndent: 20,
                    indent: 20,
                  ),*/
                  _profileRowWidget(
                      title: "Mobile Number",
                      subTitle:
                          "+91 ${_authController.getSalonArtistResponseModel.data?.salonArtistData?.mobile}"),
                  const Divider(
                    height: 30,
                    color: ColorConstant.grayTextColor,
                    endIndent: 20,
                    indent: 20,
                  ),
                  _profileRowWidget(
                      title: "Date Of Birth",
                      subTitle: _authController.getSalonArtistResponseModel.data
                              ?.salonArtistData?.dob ??
                          ""),
                  /* const Divider(
                    height: 30,
                    color: ColorConstant.grayTextColor,
                    endIndent: 20,
                    indent: 20,
                  ),
                  _profileRowWidget(
                      title: "Can Do", subTitle: "${_authController.getSalonArtistResponseModel.data?.salonArtistData?.homeService}"),*/
                  const Divider(
                    height: 30,
                    color: ColorConstant.grayTextColor,
                    endIndent: 20,
                    indent: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Portfolio",
                          textScaler: const TextScaler.linear(0.85),
                          style: AppTextTheme.medium.copyWith(
                              fontSize: 16, color: ColorConstant.grayTextColor),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => const StylistAboutPage());
                          },
                          child: Container(
                            color: Colors.transparent,
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Text(
                                  "See Activity",
                                  textScaler: const TextScaler.linear(0.85),
                                  style: AppTextTheme.bold.copyWith(
                                      fontSize: 16,
                                      color: ColorConstant.primaryColor),
                                ),
                                const SizedBox(width: 10),
                                Image.asset(
                                  AssetsConstant.arrowShare,
                                  height: 13,
                                  width: 13,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
         /* Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: ButtonWidget(buttonTitleText: "Save", onPress: () {}),
          )*/
        ],
      ),
    );
  }

  /*----------- Profile Photo -------------*/
  File imagePath = File("");
  _stylistProfilePhoto() {
    return   ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: CachedNetworkImage(
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        imageUrl:
        "${APIConstants.image}${_authController.getSalonArtistResponseModel.data?.salonArtistData?.profileImage ?? ""}",
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
    ) ;
    /*GestureDetector(
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
              "${APIConstants.image}${_authController.getSalonArtistResponseModel.data?.salonArtistData?.profileImage ?? ""}",
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
              : Positioned(
            bottom: -5,
            left: 70,
            right: 0,
            child: Container(
              width: 38,
              height: 38,
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                  color: ColorConstant.whiteColor,
                  shape: BoxShape.circle),
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                    color: ColorConstant.editButtonColor,
                    shape: BoxShape.circle),
                child: Center(
                  child: Image.asset(
                    AssetsConstant.editIcon,
                    width: 10,
                    height: 10,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    )*/
  }

  /*---------------------  Widget For Data  For Row Widget ---------------*/
  _profileRowWidget({required String title, required String subTitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            textScaler: const TextScaler.linear(0.85),
            style: AppTextTheme.medium
                .copyWith(fontSize: 16, color: ColorConstant.grayTextColor),
          ),
          Text(
            subTitle,
            textScaler: const TextScaler.linear(0.85),
            style: AppTextTheme.bold
                .copyWith(fontSize: 16, color: ColorConstant.blackColor),
          ),
        ],
      ),
    );
  }
}
