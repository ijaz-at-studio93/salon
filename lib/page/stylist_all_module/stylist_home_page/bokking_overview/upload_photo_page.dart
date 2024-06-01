import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/api/dio_client.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/stylist/stylist_controller.dart';
import 'package:salon/page/stylist_all_module/stylist_bottom_bar_page.dart';
import 'package:salon/project_specific/progress_container_view.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:salon/util/pick_image.dart';

class UploadPhotoPage extends StatefulWidget {
  final String appointmentId;
  const UploadPhotoPage({super.key, required this.appointmentId});

  @override
  State<UploadPhotoPage> createState() => _UploadPhotoPageState();
}

class _UploadPhotoPageState extends State<UploadPhotoPage> {
  List gridImages = [];
  final _stylistController = Get.find<StylistController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.whiteColor,
      appBar: const AppBarWidget(
        nameOfScreen: "Upload Photos",
        isBackIcon: true,
      ),
      body: Obx(
        () => ProgressContainerView(
          isProgressRunning: _stylistController.showProgress,
          child: Column(
            children: [
              Expanded(
                child: gridImages.isEmpty
                    ? _clickMorePhoto()
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                        ),
                        itemCount: gridImages.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: ClipRRect(
                              borderRadius: BorderRadius.circular(17),
                              child: Stack(
                                children: [
                                  Image.file(
                                    File(gridImages[index]),
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
                                          gridImages.removeAt(index);
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
                            )),
                          );
                        },
                      ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (gridImages.isNotEmpty) {
                          List<String> data = [];

                          for (int i = 0; i < gridImages.length; i++) {
                            data.add(gridImages[i]);
                          }

                          _stylistController.doUploadImage(
                              appointmentId: widget.appointmentId,
                              multiplePath: data,
                              callback: () {
                                Get.offAll(() => const StylistBottomBarPage());
                              });
                        } else {
                          showMessage("Please Select Image");
                        }
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: const BoxDecoration(
                            color: ColorConstant.primaryColor,
                            shape: BoxShape.circle),
                        child: const Center(
                          child: Icon(
                            Icons.cloud_upload,
                            color: ColorConstant.whiteColor,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        FileUtils.openPlatformImagePicker(
                            onSelectImage: (file) {
                          setState(() {
                            gridImages.add(file.path);
                          });
                        });
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: const BoxDecoration(
                            color: ColorConstant.primaryColor,
                            shape: BoxShape.circle),
                        child: const Center(
                          child: Icon(
                            Icons.photo,
                            color: ColorConstant.whiteColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /*---------- click More Photo ---------*/
  _clickMorePhoto() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.camera_alt,
            color: ColorConstant.grayTextColor,
            size: 60,
          ),
          const SizedBox(height: 8),
          Text('Please Choose Or Capture Image',
              style: AppTextTheme.bold
                  .copyWith(fontSize: 18, color: ColorConstant.grayTextColor)),
        ],
      ),
    );
  }
}
