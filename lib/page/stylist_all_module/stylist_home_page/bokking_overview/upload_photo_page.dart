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

  /// Pre-filled image paths (e.g. camera vs gallery chosen before this screen).
  final List<String>? initialImagePaths;

  /// Called after portfolio upload succeeds (e.g. refresh booking lists).
  final VoidCallback? onUploadSuccess;

  const UploadPhotoPage({
    super.key,
    required this.appointmentId,
    this.initialImagePaths,
    this.onUploadSuccess,
  });

  @override
  State<UploadPhotoPage> createState() => _UploadPhotoPageState();
}

class _UploadPhotoPageState extends State<UploadPhotoPage> {
  List gridImages = [];
  List gridVideo = [];
  final _stylistController = Get.find<StylistController>();

  @override
  void initState() {
    super.initState();
    final initial = widget.initialImagePaths;
    if (initial != null && initial.isNotEmpty) {
      gridImages.addAll(initial);
    }
  }

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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                gridVideo.isEmpty && gridImages.isEmpty
                    ? Column(
                        children: [
                          SizedBox(height: Get.height * 0.3),
                          Center(
                            child: _clickMorePhoto(),
                          ),
                        ],
                      )
                    : gridImages.isEmpty
                        ? const SizedBox()
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
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
                gridVideo.isEmpty
                    ? const SizedBox()
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                        ),
                        itemCount: gridVideo.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: ClipRRect(
                              borderRadius: BorderRadius.circular(17),
                              child: Stack(
                                children: [
                                  Container(
                                    width: Get.width,
                                    height: Get.height,
                                    color: ColorConstant.editButtonColor,
                                    child: Center(
                                      child: Image.asset(
                                        AssetsConstant.playIcon,
                                        height: 40,
                                        width: 40,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 7,
                                    bottom: 3,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          gridVideo.removeAt(index);
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
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
                              onPressed: () async {
                                Navigator.pop(context);
                                final file = await FileUtils.openCameraForImage();
                                setState(() {
                                  gridImages.add(file.path);
                                });
                              },
                              child: const Text("Photo"),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                final file = await FileUtils.openCameraForVideo();
                                setState(() {
                                  gridVideo.add(file.path);
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
              child: Container(
                height: 60,
                width: 60,
                decoration: const BoxDecoration(
                    color: ColorConstant.primaryColor, shape: BoxShape.circle),
                child: const Center(
                  child: Icon(
                    Icons.photo,
                    color: ColorConstant.whiteColor,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (gridImages.isEmpty && gridVideo.isEmpty) {
                  showMessage(
                      "Please Choose Image or Video Or Capture Image or Video");
                } else if (gridImages.isNotEmpty && gridVideo.isNotEmpty) {
                  List<String> data = [];
                  List<String> videoData = [];

                  for (int i = 0; i < gridImages.length; i++) {
                    data.add(gridImages[i]);
                  }

                  for (int i = 0; i < gridVideo.length; i++) {
                    videoData.add(gridVideo[i]);
                  }

                  _stylistController.doUploadImage(
                      appointmentId: widget.appointmentId,
                      multiplePath: data,
                      multiplePathVideo: videoData,
                      callback: () {
                        widget.onUploadSuccess?.call();
                        Get.offAll(() => const StylistBottomBarPage());
                      });
                } else if (gridImages.isNotEmpty) {
                  print("Images");
                  List<String> data = [];

                  for (int i = 0; i < gridImages.length; i++) {
                    data.add(gridImages[i]);
                  }

                  _stylistController.doUploadImage(
                      appointmentId: widget.appointmentId,
                      multiplePath: data,
                      multiplePathVideo: [],
                      callback: () {
                        widget.onUploadSuccess?.call();
                        Get.offAll(() => const StylistBottomBarPage());
                      });
                } else if (gridVideo.isNotEmpty) {
                  print("Video ");
                  List<String> videoData = [];

                  for (int i = 0; i < gridVideo.length; i++) {
                    videoData.add(gridVideo[i]);
                  }

                  _stylistController.doUploadImage(
                      appointmentId: widget.appointmentId,
                      multiplePath: [],
                      multiplePathVideo: videoData,
                      callback: () {
                        widget.onUploadSuccess?.call();
                        Get.offAll(() => const StylistBottomBarPage());
                      });
                }

                /*if (gridImages.isNotEmpty && gridVideo.isNotEmpty) {
                  List<String> data = [];
                  List<String> videoData = [];

                  for (int i = 0; i < gridImages.length; i++) {
                    data.add(gridImages[i]);
                  }

                  for (int i = 0; i < gridVideo.length; i++) {
                    videoData.add(gridVideo[i]);
                  }

                  _stylistController.doUploadImage(
                      appointmentId: widget.appointmentId,
                      multiplePath: data,
                      multiplePathVideo: videoData,
                      callback: () {
                        Get.offAll(() => const StylistBottomBarPage());
                      });
                } else {

                }*/
              },
              child: Container(
                height: 60,
                width: 60,
                decoration: const BoxDecoration(
                    color: ColorConstant.primaryColor, shape: BoxShape.circle),
                child: const Center(
                  child: Icon(
                    Icons.cloud_upload,
                    color: ColorConstant.whiteColor,
                  ),
                ),
              ),
            ),
          ],
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
            Icons.photo,
            color: ColorConstant.primaryColor,
            size: 60,
          ),
          const SizedBox(height: 8),
          Text('Please Choose Image or Video \n Or \n Capture Image or Video',
              textAlign: TextAlign.center,
              style: AppTextTheme.medium
                  .copyWith(fontSize: 18, color: ColorConstant.grayTextColor)),
        ],
      ),
    );
  }
}
