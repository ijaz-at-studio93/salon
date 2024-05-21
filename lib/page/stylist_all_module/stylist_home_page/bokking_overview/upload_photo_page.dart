import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/button_widget.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:salon/util/pick_image.dart';

class UploadPhotoPage extends StatefulWidget {
  const UploadPhotoPage({super.key});

  @override
  State<UploadPhotoPage> createState() => _UploadPhotoPageState();
}

class _UploadPhotoPageState extends State<UploadPhotoPage> {
  List gridImages = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.whiteColor,
      appBar: const AppBarWidget(
        nameOfScreen: "Upload Photos",
        isBackIcon: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
              ),
              itemCount: gridImages.isEmpty ? 1 : gridImages.length,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _clickMorePhoto(onTap: () {
                    FileUtils.openPlatformImagePicker(onSelectImage: (file) {
                      setState(() {
                        gridImages.add(file.path);
                      });
                    });
                  });
                } else {
                  int imageIndex = index == 0 ? index + 1 : index - 1;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: gridImages[imageIndex] != ""
                        ? Center(
                            child: ClipRRect(
                            borderRadius: BorderRadius.circular(17),
                            child: Stack(
                              children: [
                                Image.file(
                                  File(gridImages[imageIndex]),
                                  width: Get.width,
                                  height: Get.height,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  right: 7,
                                  bottom: 3,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        gridImages.removeAt(imageIndex);
                                      });
                                    },
                                    child: Container(
                                        padding: const EdgeInsets.all(4),
                                        child: Image.asset(
                                          AssetsConstant.crossSign,
                                          width: 25,
                                          height: 25,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ))
                        : const SizedBox(),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: ButtonWidget(
                buttonTitleText: "Upload To My Portfolio",
                onPress: () {
                  Get.back();
                  Get.back();
                  Get.back();
                }),
          )
        ],
      ),
    );
  }

  /*---------- click More Photo ---------*/
  _clickMorePhoto({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
        radius: const Radius.circular(17),
        padding: const EdgeInsets.all(6),
        color: ColorConstant.grayTextColor,
        // Color of the dotted border
        strokeWidth: 1.4,
        borderType: BorderType.RRect,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.camera_alt,
                color: ColorConstant.grayTextColor,
              ),
              const SizedBox(height: 8),
              Text('Click  More Photo',
                  style: AppTextTheme.medium.copyWith(
                      fontSize: 16, color: ColorConstant.grayTextColor)),
            ],
          ),
        ),
      ),
    );
  }
}
