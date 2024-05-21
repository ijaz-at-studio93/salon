import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/page/stylist_all_module/profile/widget/served_filter_widgtet.dart';
import 'package:salon/page/stylist_all_module/stylist_home_page/bokking_overview/booking_overview_widget.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';

class ServedBookingPage extends StatefulWidget {
  const ServedBookingPage({super.key});

  @override
  State<ServedBookingPage> createState() => _ServedBookingPageState();
}

class _ServedBookingPageState extends State<ServedBookingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      appBar:
          const AppBarWidget(nameOfScreen: "Served Booking", isBackIcon: true),
      body: Column(
        children: [
          _bookingOverview(),
          Expanded(
            child: Container(
              color: ColorConstant.whiteColor,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16,vertical:10),
                      child: BookingOverviewWidget(
                        isAccepted: true,
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  /*-------------- Booking OverView -----------*/
  _bookingOverview() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Booking Overview",
            style: AppTextTheme.medium
                .copyWith(fontSize: 23, color: ColorConstant.blackColor),
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  )),
                  context: context,
                  builder: (context) {
                    return const ServedFilterWidget();
                  });
            },
            child: Container(
              height: 50,
              width: Get.width * 0.2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border:
                    Border.all(color: ColorConstant.grayTextColor, width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Filter",
                    style: AppTextTheme.medium.copyWith(
                        color: ColorConstant.blackColor, fontSize: 13),
                  ),
                  const SizedBox(width: 5),
                  Image.asset(
                    AssetsConstant.filter,
                    height: 18,
                    width: 18,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
