import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/api_constant.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/auth_controller.dart';
import 'package:salon/page/stylist_all_module/profile/stylist_content_page.dart';
import 'package:salon/page/setting/faq_page.dart';
import 'package:salon/page/stylist_all_module/profile/served_booking_page.dart';
import 'package:salon/page/stylist_all_module/profile/stylist_review_and_rating_page.dart';
import 'package:salon/project_specific/logout_dialog.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';

import '../../setting/about_app_page.dart';
import 'edit_profile_stylist_page.dart';

class StylistProfilePage extends StatefulWidget {
  const StylistProfilePage({super.key});

  @override
  State<StylistProfilePage> createState() => _StylistProfilePageState();
}

class _StylistProfilePageState extends State<StylistProfilePage> {
  final _authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      appBar: const AppBarWidget(nameOfScreen: "My Details", isBackIcon: false),
      body: ListView(
        children: [
          _imageRowWidget(),
          _dividerCustom(),
          _customRowWidget(
              titleName: "Services Done",
              image: AssetsConstant.booking,
              onTap: () {
                Get.to(() => const ServedBookingPage());
              }),
          _dividerCustom(),
          _customRowWidget(
              titleName: "Review Rating",
              image: AssetsConstant.reviewRatings,
              onTap: () {
                Get.to(() => const StylistReviewAndRatingPage());
              }),
          _dividerCustom(),
          _customRowWidget(
              titleName: "Content",
              image: AssetsConstant.insights,
              onTap: () {
                Get.to(() => const StylistContentPage());
              }),
          _dividerCustom(),
          _customRowWidget(
              titleName: "FAQ’s & Support",
              image: AssetsConstant.faq,
              onTap: () {
                Get.to(() => const FaqPage());
              }),
          _dividerCustom(),
          _customRowWidget(
              titleName: "About Us",
              image: AssetsConstant.info,
              onTap: () {
                Get.to(() => const AboutAppPage());
              }),
          _dividerCustom(),
          _customRowWidget(
              titleName: "Sign Out",
              image: AssetsConstant.logout,
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return const LogOutDialogWidget();
                    });
              }),
        ],
      ),
    );
  }

  /*---------------- Divider -----------------*/
  _dividerCustom() {
    return const Divider(
      color: ColorConstant.dividerColor,
      indent: 20,
      endIndent: 20,
      height: 25,
      thickness: 1,
    );
  }

  /*------------ Image Row Widget -----------*/
  _imageRowWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: CachedNetworkImage(
              width: 66,
              height: 66,
              fit: BoxFit.cover,
              imageUrl:
                  "${APIConstants.image}${_authController.getSalonArtistResponseModel.data?.salonArtistData?.profileImage ?? ""}",
              placeholder: (context, url) => const Image(
                image: AssetImage(AssetsConstant.placeHolder),
                width: 66,
                height: 66,
                fit: BoxFit.cover,
              ),
              errorWidget: (context, url, error) => const Image(
                image: AssetImage(AssetsConstant.placeHolder),
                width: 66,
                height: 66,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _authController.getSalonArtistResponseModel.data
                        ?.salonArtistData?.name ??
                    "",
                textScaler: const TextScaler.linear(0.85),
                style: AppTextTheme.bold
                    .copyWith(color: ColorConstant.blackColor, fontSize: 20),
              ),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  Get.to(() => const EditProfileStylistPage());
                },
                child: Container(
                    height: 30,
                    width: 106,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: ColorConstant.primaryColor)),
                    child: Center(
                      child: Text(
                        "View Profile",
                        style: AppTextTheme.regular.copyWith(
                            color: ColorConstant.primaryColor, fontSize: 13),
                      ),
                    )),
              )
            ],
          ),
        ],
      ),
    );
  }

  /*----------------- row widget ---------------- */
  _customRowWidget(
      {required String image,
      required String titleName,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 40,
        color: Colors.transparent,
        width: Get.width,
        child: Row(
          children: [
            Image.asset(
              image,
              height: 24,
              width: 24,
              color: ColorConstant.primaryColor,
            ),
            const SizedBox(width: 15),
            Text(
              titleName,
              textScaler: const TextScaler.linear(0.85),
              style: AppTextTheme.medium
                  .copyWith(color: ColorConstant.blackColor, fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
