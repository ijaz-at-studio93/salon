import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/model/salon_review_model/salon_overall_review_model.dart';
import 'package:salon/project_specific/text_theme.dart';

class ServiceRatingCardWidget extends StatelessWidget {
  final OverAllServices overAllServices;
  const ServiceRatingCardWidget({super.key, required this.overAllServices});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /*Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  "https://images.unsplash.com/flagged/photo-1573740144655-bbb6e88fb18a?q=80&w=1935&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                  height: 39,
                  width: 39,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "Suhel Khan",
                style: AppTextTheme.medium
                    .copyWith(fontSize: 15, color: ColorConstant.blackColor),
              ),
              const SizedBox(width: 10),
              Container(
                height: 26,
                width: 87,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(45),
                    color: ColorConstant.primaryColor),
                child: Center(
                  child: Text(
                    "Most Rated",
                    style: AppTextTheme.medium.copyWith(
                        color: ColorConstant.whiteColor, fontSize: 13),
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 12),*/
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Service Name : ${overAllServices.service?.name  ?? ""}",
            style: AppTextTheme.medium
                .copyWith(color: ColorConstant.blackColor, fontSize: 13),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: Get.width,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: ColorConstant.reviewCardColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                overAllServices.review ?? "",
                style: AppTextTheme.italic
                    .copyWith(color: ColorConstant.blackColor, fontSize: 13),
              ),
              const SizedBox(height: 10),
              RatingBar.builder(
                initialRating: overAllServices.rating ?? 0.0,
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
              Text(
                "Posted on ${convertDateFormat(overAllServices.updatedAt ?? "")}",
                style: AppTextTheme.medium
                    .copyWith(color: ColorConstant.grayTextColor, fontSize: 13),
              )
            ],
          ),
        ),
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
