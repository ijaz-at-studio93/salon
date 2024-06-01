import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/model/service_model/pending_appointments_list_model.dart';
import 'package:salon/project_specific/text_theme.dart';

class CancelledBookingHistoryWidget extends StatefulWidget {
  final VoidCallback onPress;
  final OrderData orderData;
  const CancelledBookingHistoryWidget({super.key, required this.onPress, required this.orderData});

  @override
  State<CancelledBookingHistoryWidget> createState() => _CancelledBookingHistoryWidgetState();
}

class _CancelledBookingHistoryWidgetState extends State<CancelledBookingHistoryWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      margin: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: ColorConstant.whiteColor,
        border: Border.all(
          color: ColorConstant.bankHistoryBorder,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "ID :",
                    textScaler: const TextScaler.linear(0.85),
                    style: AppTextTheme.regular
                        .copyWith(color: ColorConstant.idColor, fontSize: 16),
                  ),
                  Text(
                     "A12345687",
                    textScaler: const TextScaler.linear(0.85),
                    style: AppTextTheme.medium.copyWith(
                        fontSize: 16, color: ColorConstant.blackColor),
                  ),
                ],
              ),
              Text(
                "${convertDate(date: widget.orderData.appointment?.startsAt ?? "")} - ${convertDate(date: widget.orderData.appointment?.endsAt ?? "")}",
                textScaler: const TextScaler.linear(0.85),
                style: AppTextTheme.regular
                    .copyWith(color: ColorConstant.grayTextColor, fontSize: 13),
              )
            ],
          ),
          const SizedBox(height: 12),
          Dash(
            direction: Axis.horizontal,
            length: Get.width * 0.8,
            dashLength: 2,
            dashColor: const Color(0xffCFCFCF),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Status : ",
                textScaler: const TextScaler.linear(0.85),
                style: AppTextTheme.regular
                    .copyWith(color: ColorConstant.idColor, fontSize: 16),
              ),
              Text(
                "Cancel",
                textScaler: const TextScaler.linear(0.85),
                style: AppTextTheme.bold
                    .copyWith(color: ColorConstant.redColor, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total",
                        textScaler: const TextScaler.linear(0.85),
                        style: AppTextTheme.regular.copyWith(
                            color: ColorConstant.idColor, fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "₹${widget.orderData.orderAmount}/-",
                        textScaler: const TextScaler.linear(0.85),
                        style: AppTextTheme.bold.copyWith(
                            color: ColorConstant.blackColor, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Service",
                        textScaler: const TextScaler.linear(0.85),
                        style: AppTextTheme.regular.copyWith(
                            color: ColorConstant.idColor, fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "5",
                        textScaler: const TextScaler.linear(0.85),
                        style: AppTextTheme.bold.copyWith(
                            color: ColorConstant.blackColor, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Stylist",
                        textScaler: const TextScaler.linear(0.85),
                        style: AppTextTheme.regular.copyWith(
                            color: ColorConstant.idColor, fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.orderData.appointment?.artist?.name ?? "",
                        textScaler: const TextScaler.linear(0.85),
                        style: AppTextTheme.bold.copyWith(
                            color: ColorConstant.blackColor, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
              InkWell(
                onTap: widget.onPress,
                child: Container(
                  height: 34,
                  width: 61,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    color: ColorConstant.bgViewColor,
                    border: Border.all(color: ColorConstant.borderRedColor),
                  ),
                  child: Center(
                    child: Text(
                      "View",
                      style: AppTextTheme.regular.copyWith(
                          color: ColorConstant.redColor, fontSize: 13),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  /*---------------- Convert Date tTime  ------------*/
  String convertDate({required String date}) {
    String dateTimeString = date;
    DateTime dateTime = DateTime.parse(dateTimeString);
    String formattedTime = DateFormat('h:mm a').format(dateTime);
    return formattedTime;
  }
}
