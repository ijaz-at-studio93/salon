import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/api_constant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/stylist/stylist_controller.dart';
import 'package:salon/model/stylist/artist_portfolio_model.dart';
import 'package:salon/page/stylist/widget/stack_image_widget.dart';
import 'package:salon/page/stylist/widget/video_view_model_sheet.dart';
import 'package:salon/util/NoItemsWidget.dart';
import '../../../util/pick_image.dart';

class StylistPortfolioGridview extends StatefulWidget {
  final ArtistPortfolioModel portfolio;
  const StylistPortfolioGridview({super.key, required this.portfolio});

  @override
  State<StylistPortfolioGridview> createState() =>
      _StylistPortfolioGridviewState();
}

class _StylistPortfolioGridviewState extends State<StylistPortfolioGridview> {
  final _stylistController = Get.find<StylistController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorConstant.whiteColor,
      child: widget.portfolio.data?.portfolio?.isEmpty ?? false
          ? const NoItemsWidget(
              text: "No portfolio available.",
            )
          : GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: widget.portfolio.data?.portfolio?.length ?? 0,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.98),
              itemBuilder: (context, index) => StackImageWidget(
                video: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      isDismissible: false,
                      enableDrag: false,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      )),
                      context: context,
                      builder: (context) {
                        return VideoViewModelSheet(
                            videoString:
                                "${APIConstants.image}${widget.portfolio.data?.portfolio?[index].video}");
                      });
                },
                image: widget.portfolio.data?.portfolio?[index].image ?? "",
                isVideo:
                    widget.portfolio.data?.portfolio?[index].isVideo ?? false,
                onTapEdit: () {
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
                                    imagePath = file;
                                    setState(() {
                                      _stylistController.doUpdatePostFolio(
                                          portfolioId: widget.portfolio.data
                                                  ?.portfolio?[index].id ??
                                              "",
                                          isImage: true,
                                          image: imagePath,
                                          video: File(""),
                                          callback: () {
                                            _stylistController
                                                .doGetArtistPortfolio();
                                          });
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
                                    videoPath = file;
                                    setState(() {
                                      _stylistController.doUpdatePostFolio(
                                          portfolioId: widget.portfolio.data
                                                  ?.portfolio?[index].id ??
                                              "",
                                          isImage: false,
                                          image: File(""),
                                          video: videoPath,
                                          callback: () {
                                            _stylistController
                                                .doGetArtistPortfolio();
                                          });
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
              ),
            ),
    );
  }

  File imagePath = File("");
  File videoPath = File("");
}
