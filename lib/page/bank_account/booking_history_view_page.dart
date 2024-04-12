import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:get/get.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/text_theme.dart';
import '../../project_specific/project_appbar.dart';

class BookingHistoryViewpage extends StatefulWidget {
  const BookingHistoryViewpage({super.key});

  @override
  State<BookingHistoryViewpage> createState() => _BookingHistoryViewpageState();
}

class _BookingHistoryViewpageState extends State<BookingHistoryViewpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      appBar: const AppBarWidget(
        nameOfScreen: "ID: 79828AH8918",
        isBackIcon: true,
      ),
      body: Column(
        children: [
          Container(
            color: ColorConstant.whiteColor,
            child: Column(
              children: [
                const SizedBox(height: 10),
                _invoiceWidget(
                    title: "Invoice total",
                    subTitle: "Date",
                    subtitleValue: "12/02/204",
                    subTitleValueColor: ColorConstant.blackColor,
                    titleValue: "₹4000.00"),
                const SizedBox(height: 20),
                _invoiceWidget(
                    title: "Slot Time",
                    subTitle: "Status",
                    subtitleValue: "Upcoming",
                    subTitleValueColor: ColorConstant.lightPisTaColor,
                    titleValue: "2:00-4:00 PM"),
                const SizedBox(height: 30),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Container(
            color: ColorConstant.whiteColor,
            width: Get.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Text(
                    "Customer Details",
                    style: AppTextTheme.medium.copyWith(
                        color: ColorConstant.grayTextColor, fontSize: 13),
                  ),
                ),
                _customerDetails(
                    titleName: "Name", titleValue: "Tilak Chauhan"),
                const SizedBox(height: 10),
                _customerDetails(titleName: "Phone", titleValue: "900-XX-XXXX"),
                const SizedBox(height: 10),
                _customerDetails(
                    titleName: "Email", titleValue: "xxxxxxx@gmail.com"),
                const SizedBox(height: 20),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Container(
            color: ColorConstant.whiteColor,
            width: Get.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Text(
                    "Items",
                    style: AppTextTheme.medium.copyWith(
                        color: ColorConstant.grayTextColor, fontSize: 13),
                  ),
                ),
                _customerDetails(titleName: "Hair Cut", titleValue: "₹300.00"),
                const SizedBox(height: 10),
                _customerDetails(titleName: "Shaving", titleValue: "₹300.00"),
                const SizedBox(height: 10),
                _customerDetails(titleName: "Bleach", titleValue: "₹300.00"),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: Dash(
                    direction: Axis.horizontal,
                    length: Get.width * 0.88,
                    dashLength: 2,
                    dashColor: const Color(0xffCFCFCF),
                  ),
                ),
                const SizedBox(height: 20),
                _customerDetails(titleName: "Total", titleValue: "₹300.00"),
                const SizedBox(height: 10),
                _customerDetails(
                    titleName: "Tax Applied (18%)", titleValue: "₹300.00"),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Offers Applied",
                        style: AppTextTheme.medium.copyWith(
                            color: ColorConstant.grayTextColor, fontSize: 13),
                      ),
                      Text(
                        "50% Off",
                        style: AppTextTheme.bold.copyWith(
                            color: ColorConstant.primaryColor, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 45,
            width: Get.width,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            color: ColorConstant.primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Price",
                  style: AppTextTheme.bold.copyWith(
                    fontSize: 16,
                    color: ColorConstant.whiteColor,
                  ),
                ),
                Text(
                  "₹600",
                  style: AppTextTheme.bold.copyWith(
                    fontSize: 16,
                    color: ColorConstant.whiteColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /*-------------  Invoice  Widget -----------*/
  _invoiceWidget(
      {required String title,
        required String titleValue,
        required String subTitle,
        required subtitleValue,
        required Color subTitleValueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextTheme.medium
                    .copyWith(color: ColorConstant.grayTextColor, fontSize: 13),
              ),
              Text(
                titleValue,
                textScaler: const TextScaler.linear(0.85),
                style: AppTextTheme.bold
                    .copyWith(color: ColorConstant.blackColor, fontSize: 16),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subTitle,
                style: AppTextTheme.medium
                    .copyWith(color: ColorConstant.grayTextColor, fontSize: 13),
              ),
              Text(
                subtitleValue,
                textScaler: const TextScaler.linear(0.85),
                style: AppTextTheme.bold
                    .copyWith(color: subTitleValueColor, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /*------------- Customer Details Row Widget ---------------*/
  _customerDetails({required String titleName, required String titleValue}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            titleName,
            style: AppTextTheme.medium
                .copyWith(color: ColorConstant.grayTextColor, fontSize: 13),
          ),
          Text(
            titleValue,
            textScaler: const TextScaler.linear(0.85),
            style: AppTextTheme.bold
                .copyWith(color: ColorConstant.blackColor, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
