import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/text_theme.dart';

class ServedBookingWidget extends StatelessWidget {
  final String startTime;
  final String endTime;
  final String image;
  final String id;
  final String name;
  final double price;
  final int serviceComplete;
  const ServedBookingWidget(
      {super.key,
      required this.startTime,
      required this.endTime,
      required this.price,
      required this.image,
      required this.name,
      required this.id, required this.serviceComplete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20, top: 20, left: 13, right: 13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: ColorConstant.gray,
        boxShadow: ColorConstant.appointmentCardElevation,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "ID : ",
                    style: AppTextTheme.regular
                        .copyWith(color: ColorConstant.idColor, fontSize: 16),
                  ),
                  SizedBox(
                    width: Get.width * 0.4,
                    child: Text(
                      id,
                      maxLines: 1,
                      style: AppTextTheme.bold.copyWith(
                          color: ColorConstant.blackColor, fontSize: 16),
                    ),
                  ),
                ],
              ),
              Text(
                "${startTime == "" ? "" : convertDate(date: startTime)}- ${endTime == "" ? "" : convertDate(date: endTime)}",
                style: AppTextTheme.regular
                    .copyWith(fontSize: 13, color: ColorConstant.grayTextColor),
              )
            ],
          ),
          const SizedBox(height: 15),
          Dash(
            direction: Axis.horizontal,
            length: Get.width * 0.89,
            dashLength: 2,
            dashColor: const Color(0xffCFCFCF),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Booking Status :",
                style: AppTextTheme.medium
                    .copyWith(fontSize: 12, color: ColorConstant.grayTextColor),
              ),
              const SizedBox(width: 5),
              Text(
                "Complete",
                style: AppTextTheme.bold
                    .copyWith(fontSize: 13, color: Colors.green),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total",
                    style: AppTextTheme.medium.copyWith(
                        fontSize: 12, color: ColorConstant.grayTextColor),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "₹$price/-",
                    style: AppTextTheme.bold.copyWith(
                        fontSize: 13, color: ColorConstant.blackColor),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Service",
                    style: AppTextTheme.medium.copyWith(
                        fontSize: 12, color: ColorConstant.grayTextColor),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    serviceComplete.toString(),
                    style: AppTextTheme.bold.copyWith(
                        fontSize: 13, color: ColorConstant.blackColor),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "For",
                    style: AppTextTheme.medium.copyWith(
                        fontSize: 12, color: ColorConstant.grayTextColor),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.home,
                        size: 15,
                        color: ColorConstant.blackColor,
                      ),
                      Text(
                        "Home",
                        style: AppTextTheme.bold.copyWith(
                            fontSize: 13, color: ColorConstant.blackColor),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          Dash(
            direction: Axis.horizontal,
            length: Get.width * 0.89,
            dashLength: 2,
            dashColor: const Color(0xffCFCFCF),
          ),
          const SizedBox(height: 15),
          Text(
            "User Info",
            style: AppTextTheme.medium
                .copyWith(fontSize: 14, color: ColorConstant.grayTextColor),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CachedNetworkImage(
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  imageUrl: image,
                  placeholder: (context, url) => const Image(
                    image: AssetImage(AssetsConstant.placeHolder),
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                  errorWidget: (context, url, error) => const Image(
                    image: AssetImage(AssetsConstant.placeHolder),
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Row(
                children: [
                  Text(
                    "Name :",
                    style: AppTextTheme.medium.copyWith(
                        fontSize: 12, color: ColorConstant.grayTextColor),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    name,
                    style: AppTextTheme.bold.copyWith(
                        fontSize: 13, color: ColorConstant.primaryColor),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  /*---------------- convertTime ------------*/
  String convertDate({required String date}) {
    String dateTimeString = date;
    DateTime dateTime = DateTime.parse(dateTimeString);
    String formattedTime = DateFormat('h:mm a').format(dateTime);
    return formattedTime;
  }
}
