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
          childAspectRatio: 0.98,
        ),
        itemBuilder: (context, index) => StackImageWidget(
          // tapping the image or video preview now ONLY plays the video (if any)
          video: () {
            showModalBottomSheet(
              isScrollControlled: true,
              isDismissible: false,
              enableDrag: false,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              context: context,
              builder: (context) {
                return VideoViewModelSheet(
                  videoString:
                  "${APIConstants.image}${widget.portfolio.data?.portfolio?[index].video}",
                );
              },
            );
          },
          image: widget.portfolio.data?.portfolio?[index].image ?? "",
          isVideo:
          widget.portfolio.data?.portfolio?[index].isVideo ?? false,

          // 🚫 disable edit functionality
        ),
      ),
    );
  }
}