import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salon/constant/color_constant.dart';

import 'package:salon/project_specific/text_theme.dart';

class AcceptBookingOverViewWidget extends StatefulWidget {
  final String startTime;
  final String endTime;
  final int price;
  final VoidCallback onPress;
  const AcceptBookingOverViewWidget(
      {super.key,
      required this.onPress,
      required this.startTime,
      required this.endTime,
      required this.price});

  @override
  State<AcceptBookingOverViewWidget> createState() =>
      _AcceptBookingOverViewWidgetState();
}

class _AcceptBookingOverViewWidgetState
    extends State<AcceptBookingOverViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20, top: 20, left: 13, right: 13),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7), color: ColorConstant.gray),
      child: Column(
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
                  Text(
                    "79828AH8918",
                    style: AppTextTheme.bold.copyWith(
                        color: ColorConstant.blackColor, fontSize: 16),
                  ),
                ],
              ),
              Text(
                "${convertDate(date: widget.startTime)}- ${convertDate(date: widget.endTime)}",
                style: AppTextTheme.regular
                    .copyWith(fontSize: 13, color: ColorConstant.grayTextColor),
              )
            ],
          ),
          const SizedBox(height: 15),
          Dash(
            direction: Axis.horizontal,
            length: Get.width * 0.8,
            dashLength: 2,
            dashColor: const Color(0xffCFCFCF),
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
                    "₹${widget.price}/-",
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
                    "5",
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
          const SizedBox(height: 20),
          GestureDetector(
            onTap: widget.onPress,
            child: Container(
              height: 50,
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xffEAEAEA),
              ),
              child: Center(
                child: Text(
                  "View",
                  style: AppTextTheme.regular
                      .copyWith(color: ColorConstant.blackColor, fontSize: 14),
                ),
              ),
            ),
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
