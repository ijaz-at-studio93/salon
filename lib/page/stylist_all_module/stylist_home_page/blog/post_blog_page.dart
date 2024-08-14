import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/api/dio_client.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/stylist/stylist_controller.dart';
import 'package:salon/page/stylist_all_module/stylist_home_page/blog/offline_video_widget.dart';
import 'package:salon/project_specific/button_widget.dart';
import 'package:salon/project_specific/progress_container_view.dart';
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

  final _stylistController = Get.find<StylistController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.whiteColor,
      appBar: const AppBarWidget(
        nameOfScreen: "Post Blog",
        isBackIcon: true,
      ),
      body: Obx(
        () => ProgressContainerView(
          isProgressRunning: _stylistController.showProgress,
          child: Column(
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
                        textInputType: TextInputType.multiline,
                        textInputAction: TextInputAction.none,
                        title: "Body"),
                    const SizedBox(height: 16),
                    _serviceImage()
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: ButtonWidget(
                  buttonTitleText: "Post",
                  onPress: () {
                    doCreateBlog();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /*-------------------  do  Crete Blog ------------*/
  doCreateBlog() {
    if (_titleForBlog.text.isEmpty) {
      showMessage("Please Enter Title");
    } else if (_shortDescription.text.isEmpty) {
      showMessage("Please Enter Short Description");
    } else if (_body.text.isEmpty) {
      showMessage("Please Enter body Text");
    } else if (imagePath.path == "" && videoPath.path == "") {
      showMessage("Please Choose Image or Video");
    } else {
      _stylistController.doCreateBlog(
          title: _titleForBlog.text,
          body: _shortDescription.text,
          description: _body.text,
          image: imagePath,
          video: videoPath,
          callback: () {
            Get.back();
            Get.to(() => const SocialPage());
          });
    }
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
                maxLines: null,
                enabled: true,
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
  File videoPath = File("");
  _serviceImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Service Image or Video",
            style: AppTextTheme.regular
                .copyWith(fontSize: 13, color: ColorConstant.blackColor),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              Get.dialog(Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Get.back();
                              FileUtils.openPlatformImagePicker(
                                  onSelectImage: (file) {
                                setState(() {
                                  imagePath = file;
                                  videoPath = File("");
                                });
                              });
                            },
                            child: const Text("Photo"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Get.back();
                              FileUtils.openPlatformVideoPicker(
                                  onSelectVideo: (file) {
                                setState(() {
                                  videoPath = file;
                                  imagePath = File("");
                                });
                              });
                            },
                            child: const Text("Video"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ));
            },
            child: videoPath.path.isNotEmpty
                ? OfflineVideoWidget(videoString: videoPath.path)
                : Container(
                    height: 165,
                    width: Get.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: ColorConstant.borderColor,
                      ),
                    ),
                    child: imagePath.path.isEmpty && videoPath.path.isEmpty
                        ? Center(
                            child: Image.asset(
                              AssetsConstant.uploadIcon,
                              height: 24,
                              width: 24,
                            ),
                          )
                        : imagePath.path.isNotEmpty
                            ? Image.file(
                                imagePath,
                                fit: BoxFit.fitHeight,
                              )
                            : OfflineVideoWidget(videoString: videoPath.path),
                  ),
          )
        ],
      ),
    );
  }
}
