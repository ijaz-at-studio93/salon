import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salon/constant/api_constant.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/model/salon_review_model/salon_review_by_artiest_model.dart';
import '../../../project_specific/text_theme.dart';

class ByStylistCardWidget extends StatefulWidget {
  final SalonArtiestReviewOverall salonArtiestReviewOverall;
  final bool initiallyExpanded;

  const ByStylistCardWidget({
    super.key,
    required this.salonArtiestReviewOverall,
    this.initiallyExpanded = false,
  });

  @override
  State<ByStylistCardWidget> createState() => _ByStylistCardWidgetState();
}

class _ByStylistCardWidgetState extends State<ByStylistCardWidget> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final salonArtiestReviewOverall = widget.salonArtiestReviewOverall;
    final rating = salonArtiestReviewOverall.rating ?? 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                        height: 39,
                        width: 39,
                        fit: BoxFit.cover,
                        imageUrl:
                            "${APIConstants.image}${salonArtiestReviewOverall.profileImage ?? ""}",
                        placeholder: (context, url) => const Image(
                          image: AssetImage(AssetsConstant.placeHolder),
                          height: 39,
                          width: 39,
                          fit: BoxFit.cover,
                        ),
                        errorWidget: (context, url, error) => const Image(
                          image: AssetImage(AssetsConstant.placeHolder),
                          height: 39,
                          width: 39,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        salonArtiestReviewOverall.name ?? "",
                        style: AppTextTheme.medium.copyWith(
                            fontSize: 15, color: ColorConstant.blackColor),
                      ),
                    ),
                    Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: ColorConstant.primaryColor,
                      size: 28,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (_expanded) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Row(
              children: [
                RatingBar.builder(
                  initialRating: rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 25.0,
                  ignoreGestures: true,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: ColorConstant.primaryColor,
                    size: 25,
                  ),
                  onRatingUpdate: (rating) {},
                ),
                const SizedBox(width: 8),
                Text(
                  rating.toStringAsFixed(1),
                  style: AppTextTheme.medium.copyWith(
                    color: ColorConstant.blackColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ListView.builder(
              shrinkWrap: true,
              itemCount: salonArtiestReviewOverall.reviews?.length ?? 0,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, i) {
                return Container(
                  width: Get.width,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: ColorConstant.reviewCardColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (salonArtiestReviewOverall.reviews?[i].review !=
                              null &&
                          salonArtiestReviewOverall.reviews?[i].review !=
                              "") ...[
                        Text(
                          salonArtiestReviewOverall.reviews?[i].review ?? "",
                          style: AppTextTheme.italic.copyWith(
                              color: ColorConstant.blackColor, fontSize: 13),
                        ),
                        const SizedBox(height: 10),
                      ],
                      RatingBar.builder(
                        initialRating: 5.0,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 25.0,
                        ignoreGestures: true,
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: ColorConstant.primaryColor,
                          size: 25,
                        ),
                        onRatingUpdate: (rating) {},
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Posted on ${convertDateFormat(salonArtiestReviewOverall.reviews?[i].updatedAt ?? "")}",
                            style: AppTextTheme.medium.copyWith(
                                color: ColorConstant.grayTextColor,
                                fontSize: 13),
                          ),
                          // const SizedBox(height: 10),
                        ],
                      )
                    ],
                  ),
                );
              }),
        ],
      ],
    );
  }

  String convertDateFormat(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);

    DateFormat dateFormat = DateFormat('dd MMMM yyyy');

    return dateFormat.format(dateTime);
  }
}
