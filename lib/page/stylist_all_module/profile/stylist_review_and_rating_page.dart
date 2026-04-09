import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/stylist/stylist_controller.dart';
import 'package:salon/page/review_rating/widget/artiest_rating_card_widget.dart';
import 'package:salon/project_specific/progressbar_view.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:salon/util/NoItemsWidget.dart';

class StylistReviewAndRatingPage extends StatefulWidget {
  const StylistReviewAndRatingPage({super.key});

  @override
  State<StylistReviewAndRatingPage> createState() =>
      _StylistReviewAndRatingPageState();
}

class _StylistReviewAndRatingPageState
    extends State<StylistReviewAndRatingPage> {
  final _stylistController = Get.find<StylistController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _stylistController.doGetOverallStylistReview();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      appBar: const AppBarWidget(
        nameOfScreen: "Review & Ratings",
        isBackIcon: true,
      ),
      body: Obx(
            () => _stylistController.showProgress
            ? const ProgressBarView()
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                child: Text(
                  "Artists",
                  style: AppTextTheme.bold.copyWith(
                      color: ColorConstant.primaryColor, fontSize: 18),
                ),
              ),
              _stylistController.getOverallStylistReviewListModel.data
                  ?.artists?.isEmpty ??
                  false
                  ? const NoItemsWidget(
                text: "Artist reviews not found.",
              )
                  : ListView.separated(
                separatorBuilder: (context, index) {
                  return Column(
                    children: [
                      const SizedBox(height: 10),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20),
                        height: 1,
                        width: Get.width,
                        decoration: const BoxDecoration(
                            color: ColorConstant.grayTextColor),
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                },
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 10),
                itemCount: _stylistController
                    .getOverallStylistReviewListModel
                    .data
                    ?.artists
                    ?.length ??
                    0,
                itemBuilder: (context, index) {
                  return ArtiestRatingCardWidget(
                    overAllArtists: _stylistController
                        .getOverallStylistReviewListModel
                        .data!
                        .artists![index],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}