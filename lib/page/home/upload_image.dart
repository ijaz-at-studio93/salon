import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/api/dio_client.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/page/stylist_all_module/stylist_bottom_bar_page.dart';
import 'package:salon/project_specific/progress_container_view.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:salon/util/pick_image.dart';

class UploadImagePage extends StatefulWidget {
  final String appointmentId;

  const UploadImagePage({super.key, required this.appointmentId});

  @override
  State<UploadImagePage> createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
  List gridImages = [];
  List gridVideo = [];
  final _homeController = Get.find<HomeController>();

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
          isProgressRunning: _homeController.showProgress,
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
          children: [
            // LEFT: camera icon
            GestureDetector(
              onTap: () {
                // one popup: choose Photo or Video, then open CAMERA directly
                Get.dialog(
                  Center(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              final file = await FileUtils
                                  .openCameraForImage(); // CAMERA ONLY
                              setState(() => gridImages.add(file.path));
                            },
                            child: const Text("Photo (Camera)"),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              final file = await FileUtils
                                  .openCameraForVideo(); // CAMERA ONLY
                              setState(() => gridVideo.add(file.path));
                            },
                            child: const Text("Video (Camera)"),
                          ),
                        ],
                      ),
                    ),
                  ),
                  barrierDismissible: true,
                );
              },
              child: Container(
                height: 60,
                width: 60,
                decoration: const BoxDecoration(
                  color: ColorConstant.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child:
                      Icon(Icons.camera_alt, color: ColorConstant.whiteColor),
                ),
              ),
            ),

            const Spacer(),

            // RIGHT: Upload button with text
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstant.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              ),
              onPressed: () {
                if (gridImages.isEmpty && gridVideo.isEmpty) {
                  showMessage("Please capture a Photo or Video first");
                  return;
                }

                final photos = List<String>.from(gridImages);
                final videos = List<String>.from(gridVideo);

                _homeController.doUploadImage(
                  appointmentId: widget.appointmentId,
                  multiplePath: photos,
                  multiplePathVideo: videos,
                  callback: () {
                    // go back to previous page (booking details), then previous (list)
                    Get.back(); // close UploadImagePage
                    Get.back(); // close Booking details page

                    Future.delayed(const Duration(milliseconds: 300), () {
                      // 3️⃣ Refresh the list page (pending/completed appointments)
                      _homeController.doUpcomingData();
                    });
                  },
                );
              },
              child: Text(
                "Upload",
                style: AppTextTheme.bold
                    .copyWith(fontSize: 16, color: Colors.white),
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
            Icons.camera_alt,
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
