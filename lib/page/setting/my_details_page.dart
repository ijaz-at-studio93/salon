import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/page/flow_pages/home_page_2/edit_profile.dart';
import 'package:salon/page/setting/categoty_page.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:salon/util/pick_image.dart';

import 'job_vacancy/job_vacancy_page.dart';

class MyDetailsPage extends StatefulWidget {
  const MyDetailsPage({super.key});

  @override
  State<MyDetailsPage> createState() => _MyDetailsPageState();
}

class _MyDetailsPageState extends State<MyDetailsPage> {
  File imagePath = File("");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      appBar: const AppBarWidget(
        nameOfScreen: "My Details",
        isBackIcon: false
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _imageRowWidget(),
            _dividerCustom(),
            _customRowWidget(
                titleName: "Availablity",
                image: AssetsConstant.eye,
                onTap: () {}),
            _dividerCustom(),
            _customRowWidget(
                titleName: "Categories",
                image: AssetsConstant.categories,
                onTap: () {
                  Get.to(() => const CategoryPage());
                }),
            _dividerCustom(),
            _customRowWidget(
                titleName: "Product",
                image: AssetsConstant.product,
                onTap: () {}),
            _dividerCustom(),
            _customRowWidget(
                titleName: "Service List",
                image: AssetsConstant.serviceList,
                onTap: () {}),
            _dividerCustom(),
            _customRowWidget(
                titleName: "Job",
                image: AssetsConstant.job,
                onTap: () {
                  Get.to(() => const JobVacancyPage());
                }),
            _dividerCustom(),
            _customRowWidget(
                titleName: "Account Details",
                image: AssetsConstant.accountDetails,
                onTap: () {}),
            _dividerCustom(),
            _customRowWidget(
                titleName: "Review & Ratings",
                image: AssetsConstant.reviewRatings,
                onTap: () {}),
            _dividerCustom(),
            _customRowWidget(
                titleName: "FAQ’s & Support",
                image: AssetsConstant.faq,
                onTap: () {}),
            _dividerCustom(),
            _customRowWidget(
                titleName: "About Us", image: AssetsConstant.info, onTap: () {}),
            _dividerCustom(),
            _customRowWidget(
                titleName: "Sign Out",
                image: AssetsConstant.logout,
                onTap: () {}),

            const SizedBox(height: 20),

          ],
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
          InkWell(
            onTap: () async {
              FileUtils.openPlatformImagePicker(onSelectImage: (file) {
                setState(() {
                  imagePath = file;
                });
              });
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: imagePath.path == ""
                  ? Image.network(
                      "https://plus.unsplash.com/premium_photo-1708271598114-5e6e8892a2ad?q=80&w=1935&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                      width: 66,
                      height: 66,
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      imagePath,
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
                "Jay Morjariya",
                textScaler: const TextScaler.linear(0.85),
                style: AppTextTheme.bold
                    .copyWith(color: ColorConstant.blackColor, fontSize: 20),
              ),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: (){
                  Get.to(()=> const EditProfile());
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
