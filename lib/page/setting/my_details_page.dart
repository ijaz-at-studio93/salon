import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/api_constant.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/auth_controller.dart';
import 'package:salon/page/blog/Insights_home_page.dart';
import 'package:salon/page/review_rating/review_and_rating_page.dart';
import 'package:salon/page/setting/about_app_page.dart';
import 'package:salon/page/setting/availability_setting_page.dart';
import 'package:salon/page/setting/product_list_page.dart';
import 'package:salon/page/setting/service_list_page.dart';
import 'package:salon/project_specific/progress_container_view.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';
import '../../project_specific/logout_dialog.dart';
import '../bank_account/add_new_fresh_account_page.dart';
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
              children: [
                _imageRowWidget(),
                _dividerCustom(),
                _customRowWidget(
                    titleName: "Availability",
                    image: AssetsConstant.eye,
                    onTap: () {
                      Get.to(() => const AvailabilitySettingPage());
                    }),
                /* _dividerCustom(),
                _customRowWidget(
                    titleName: "Categories",
                    image: AssetsConstant.categories,
                    onTap: () {
                      Get.to(() => const CategoryPage());
                    }),*/
                _dividerCustom(),
                _customRowWidget(
                    titleName: "Product",
                    image: AssetsConstant.product,
                    onTap: () {
                      Get.to(() => const ProductListPage());
                    }),
                _dividerCustom(),
                _customRowWidget(
                    titleName: "Service List",
                    image: AssetsConstant.serviceList,
                    onTap: () {
                      Get.to(() => const ServiceListPage());
                    }),
                _dividerCustom(),
                _customRowWidget(
                    titleName: "Blog",
                    image: AssetsConstant.insights,
                    onTap: () {
                      Get.to(() => const InsightsHomePage(
                            url: "salon/blog/list",
                          ));
                    }),
                _dividerCustom(),
                _customRowWidget(
                    titleName: "Account Details",
                    image: AssetsConstant.accountDetails,
                    onTap: () {
                      Get.to(() => const AddNewFreshAccountPage());
                    }),
                _dividerCustom(),
                _customRowWidget(
                    titleName: "Review & Ratings",
                    image: AssetsConstant.reviewRatings,
                    onTap: () {
                      Get.to(() => const ReviewAndRatingPage());
                    }),
                _dividerCustom(),
                _customRowWidget(
                    titleName: "FAQ’s & Support",
                    image: AssetsConstant.faq,
                    onTap: () {}),
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
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditProfile()));
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(68),
                    border:
                        Border.all(color: ColorConstant.primaryColor, width: 1),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        AssetsConstant.editIcon,
                        width: 14,
                        height: 14,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Edit Details",
                        style: AppTextTheme.regular.copyWith(
                            color: ColorConstant.primaryColor, fontSize: 13),
                      )
                    ],
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
}
