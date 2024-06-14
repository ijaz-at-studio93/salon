import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/model/stylist/pending_appointment.dart';
import 'package:salon/page/stylist_all_module/stylist_home_page/bokking_overview/acceptnce_overview_page.dart';

import 'package:salon/project_specific/text_theme.dart';

import 'view_accept_page.dart';

class BookingOverviewWidget extends StatelessWidget {
  final String startTime;
  final String endTime;
  final String id;
  final int price;
  final bool isHomeService;
  final VoidCallback tapReject;
  final VoidCallback tapViewAndAccept;

  const BookingOverviewWidget({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.price,
    required this.tapReject,
    required this.tapViewAndAccept,
    required this.id,
    required this.isHomeService,
  });

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
                    id,
                    style: AppTextTheme.bold.copyWith(
                        color: ColorConstant.blackColor, fontSize: 16),
                  ),
                ],
              ),
              Text(
                "${convertDate(date: startTime)}- ${convertDate(date: endTime)}",
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
                    "1",
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
                        isHomeService ? "Home" : "Salon",
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
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: tapReject,
                  child: Container(
                    height: 50,
                    width: Get.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: ColorConstant.redColor,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Reject",
                        style: AppTextTheme.regular.copyWith(
                            color: ColorConstant.redColor, fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: tapViewAndAccept,
                  child: Container(
                    height: 50,
                    width: Get.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: ColorConstant.primaryColor,
                    ),
                    child: Center(
                      child: Text(
                        "View & Accept",
                        style: AppTextTheme.regular.copyWith(
                            color: ColorConstant.whiteColor, fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
