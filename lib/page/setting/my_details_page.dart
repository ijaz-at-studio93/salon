import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/api_constant.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/auth_controller.dart';
import 'package:salon/page/setting/content_page.dart';
import 'package:salon/page/review_rating/review_and_rating_page.dart';
import 'package:salon/page/setting/menu_change_page.dart';
import 'package:salon/page/setting/salon_availability_page.dart';
import 'package:salon/page/stylist/manage_stylist_page.dart';
import 'package:salon/page/stylist/set_stylist_availability_page.dart';
import 'package:salon/page/setting/faq_page.dart';
import 'package:salon/page/setting/product_list_page.dart';
import 'package:salon/project_specific/progress_container_view.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';

import '../../project_specific/logout_dialog.dart';
import '../stylist_all_module/stylist_home_page/edit_profile.dart';

class MyDetailsPage extends StatefulWidget {
  const MyDetailsPage({super.key});

  @override
  State<MyDetailsPage> createState() => _MyDetailsPageState();
}

class _MyDetailsPageState extends State<MyDetailsPage> {
  final _authController = Get.find<AuthController>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _authController.doGetSalonProfile(callback: () {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      appBar: const AppBarWidget(nameOfScreen: "My Details", isBackIcon: false),
      body: Obx(
        () => ProgressContainerView(
          isProgressRunning: _authController.showProgress,
          child: SingleChildScrollView(
            child: Column(
              spacing: 10,
              children: [
                _imageRowWidget(),
                _customRowWidget(
                    titleName: "Set Stylist Availability",
                    image: AssetsConstant.stylishAvailability,
                    onTap: () {
                      Get.to(() => const SetStylistAvailabilityPage());
                    }),
                _customRowWidget(
                    titleName: "Manage Stylists",
                    image: AssetsConstant.manageStylishIcon,
                    onTap: () {
                      Get.to(() => const ManageStylistPage());
                    }),
                _customRowWidget(
                    titleName: "Salon Availability",
                    image: AssetsConstant.salonAvailabilityIcon,
                    onTap: () {
                      Get.to(() => const SalonAvailabilityPage());
                    }),
                _customRowWidget(
                    titleName: "Products",
                    image: AssetsConstant.productsIcon,
                    onTap: () {
                      Get.to(() => const ProductListPage());
                    }),
                _customRowWidget(
                    titleName: "Review & Ratings",
                    image: AssetsConstant.ratingsAndReviewIcon,
                    onTap: () {
                      Get.to(() => const ReviewAndRatingPage());
                    }),
                _customRowWidget(
                    titleName: "Content",
                    image: AssetsConstant.contentIcon,
                    onTap: () {
                      Get.to(() => const ContentPage());
                    }),
                /* _customRowWidget(
                    titleName: "Account Details",
                    image: AssetsConstant.accountDetails,
                    onTap: () {
                      Get.to(() => const AddNewFreshAccountPage());
                    }),*/
                _customRowWidget(
                    titleName: "Request Menu change",
                    image: AssetsConstant.requestMenuChangeIcon,
                    onTap: () {
                      Get.to(() => const MenuChangePage());
                    }),
                _customRowWidget(
                    titleName: "Support & FAQ’s",
                    image: AssetsConstant.faq,
                    onTap: () {
                      Get.to(() => const FaqPage());
                    }),
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
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
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
                  "${APIConstants.image}${_authController.getGetSalonProfile.data?.image ?? ""}",
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
                _authController.getGetSalonProfile.data?.name ?? "",
                textScaler: const TextScaler.linear(0.85),
                style: AppTextTheme.bold
                    .copyWith(color: ColorConstant.blackColor, fontSize: 20),
              ),
              const SizedBox(height: 5),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: ColorConstant.primaryColor2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditProfile()),
                  );
                },
                child: Text(
                  "Edit Details",
                  style: AppTextTheme.regular.copyWith(
                    color: ColorConstant.primaryColor2,
                    fontSize: 13,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  /*----------------- row widget ---------------- */
  _customRowWidget(
      {required String image,
      required String titleName,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 38,
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
