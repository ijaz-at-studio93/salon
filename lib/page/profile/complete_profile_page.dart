import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/page/profile/document_submitted_page.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({super.key});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      appBar: const AppBarWidget(
        nameOfScreen: "Complete Profile",
        isBackIcon: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 2),
          _editRowWidget(),
          const SizedBox(height: 2),
          _licenseDocument()
        ],
      ),
    );
  }

  /*---------------  Edit Row Widget -------------*/
  _editRowWidget() {
    return Container(
      height: 53,
      color: ColorConstant.whiteColor,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                "Saloon Name",
                style: AppTextTheme.medium
                    .copyWith(fontSize: 16, color: ColorConstant.blackColor),
              ),
              const SizedBox(width: 10),
              Image.asset(
                AssetsConstant.markIcon,
                height: 20,
                width: 20,
              )
            ],
          ),
          TextButton(
              onPressed: () {},
              child: Text(
                "Edit",
                style: AppTextTheme.medium
                    .copyWith(color: ColorConstant.redColor, fontSize: 14),
              ))
        ],
      ),
    );
  }

  /*------------------ License Document --------------*/
  _licenseDocument() {
    return Container(
      height: 53,
      color: ColorConstant.whiteColor,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                "License Document",
                style: AppTextTheme.medium
                    .copyWith(fontSize: 16, color: ColorConstant.blackColor),
              ),
              const SizedBox(width: 10),
              Image.asset(
                AssetsConstant.warningIcon,
                height: 20,
                width: 20,
              )
            ],
          ),
          GestureDetector(
            onTap: (){
              Get.to(()=> const DocumentSubmittedPage());
            },
            child: Container(
              height: 26,
              width: 107,
              decoration: BoxDecoration(
                  color: ColorConstant.primaryColor,
                  borderRadius: BorderRadius.circular(88)),
              child: Center(
                child: Text(
                  "Upload Now",
                  style: AppTextTheme.medium
                      .copyWith(color: ColorConstant.whiteColor, fontSize: 14),
                ),
              ),
            ),
          )

        ],
      ),
    );
  }
}
