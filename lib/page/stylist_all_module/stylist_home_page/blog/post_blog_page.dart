import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/button_widget.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/simple_text_field.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:salon/util/pick_image.dart';

import 'social_page.dart';

class PostBlogPage extends StatefulWidget {
  const PostBlogPage({super.key});

  @override
  State<PostBlogPage> createState() => _PostBlogPageState();
}

class _PostBlogPageState extends State<PostBlogPage> {
  final _titleForBlog = TextEditingController();
  final _shortDescription = TextEditingController();
  final _body = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.whiteColor,
      appBar: const AppBarWidget(
        nameOfScreen: "Post Blog",
        isBackIcon: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                const SizedBox(height: 15),
                SimpleTextFieldWidget(
                    textEditingController: _titleForBlog,
                    hintText: "Tap To Enter",
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    title: "Title of your Blog"),
                const SizedBox(height: 16),
                SimpleTextFieldWidget(
                    textEditingController: _shortDescription,
                    hintText: "Tap To Enter",
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    title: "Short Description"),
                const SizedBox(height: 16),
                _addressField(
                    textEditingController: _body,
                    hintText: "Tap To Enter",
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    title: "Body"),
                const SizedBox(height: 16),
                _serviceImage()
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: ButtonWidget(
              buttonTitleText: "Post",
              onPress: () {
                Get.to(()=> const SocialPage());
              },
            ),
          )
        ],
      ),
    );
  }

  /*------------ Saloon Address TextField -----------*/
  _addressField({
    required TextEditingController textEditingController,
    required String hintText,
    required String title,
    required TextInputType textInputType,
    required TextInputAction textInputAction,
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
              height: 200,
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: ColorConstant.borderColor,
                ),
              ),
              child: TextField(
                controller: textEditingController,
                maxLines: 12,
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

  /*----------------- Service Image --------------*/
  File imagePath = File("");
  _serviceImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Product Image ",
            style: AppTextTheme.regular
                .copyWith(fontSize: 13, color: ColorConstant.blackColor),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              FileUtils.openPlatformImagePicker(onSelectImage: (file) {
                setState(() {
                  imagePath = file;
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
              child: imagePath.path.isEmpty
                  ? Center(
                      child: Image.asset(
                        AssetsConstant.uploadIcon,
                        height: 24,
                        width: 24,
                      ),
                    )
                  : Image.file(
                      imagePath,
                      fit: BoxFit.fitHeight,
                    ),
            ),
          )
        ],
      ),
    );
  }
}
