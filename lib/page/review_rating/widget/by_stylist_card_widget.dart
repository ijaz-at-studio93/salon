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

class ByStylistCardWidget extends StatelessWidget {
  final SalonArtiestReviewOverall salonArtiestReviewOverall;
  const ByStylistCardWidget(
      {super.key, required this.salonArtiestReviewOverall});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                  Text(
                    salonArtiestReviewOverall.name ?? "",
                    style: AppTextTheme.medium.copyWith(
                        fontSize: 15, color: ColorConstant.blackColor),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              RatingBar.builder(
                initialRating: salonArtiestReviewOverall.rating ?? 0.0,
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
            ],
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
            shrinkWrap: true,
            itemCount: salonArtiestReviewOverall.reviews?.length ?? 0,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, i) {
              return Container(
                width: Get.width,
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: ColorConstant.reviewCardColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      salonArtiestReviewOverall.reviews?[i].review ?? "",
                      style: AppTextTheme.italic.copyWith(
                          color: ColorConstant.blackColor, fontSize: 13),
                    ),
                    const SizedBox(height: 10),
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
                              color: ColorConstant.grayTextColor, fontSize: 13),
                        ),
                        const SizedBox(height: 10),
                        /*Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: CachedNetworkImage(
                                height: 39,
                                width: 39,
                                fit: BoxFit.cover,
                                imageUrl:
                                    "${APIConstants.image}${salonArtiestReviewOverall.reviews?[i].user?.profileImage ?? ""}",
                                placeholder: (context, url) => const Image(
                                  image: AssetImage(AssetsConstant.placeHolder),
                                  height: 39,
                                  width: 39,
                                  fit: BoxFit.cover,
                                ),
                                errorWidget: (context, url, error) =>
                                    const Image(
                                  image: AssetImage(AssetsConstant.placeHolder),
                                  height: 39,
                                  width: 39,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              salonArtiestReviewOverall
                                      .reviews?[i].user?.name ??
                                  "",
                              style: AppTextTheme.medium.copyWith(
                                  color: ColorConstant.grayTextColor,
                                  fontSize: 13),
                            ),
                          ],
                        )*/
                      ],
                    )
                  ],
                ),
              );
            })
      ],
    );
  }

  String convertDateFormat(String timestamp) {
    // Parse the timestamp into a DateTime object
    DateTime dateTime = DateTime.parse(timestamp);
    // Define the desired date format
    DateFormat dateFormat = DateFormat('dd MMMM yyyy');
    // Format the date
    String formattedDate = dateFormat.format(dateTime);
    print(formattedDate); //

    return formattedDate; // Output: 04 June 2024
  }
}
