import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:salon/constant/color_constant.dart';
import 'package:salon/page/bank_account/widget/booking_history_widget.dart';
import 'package:salon/project_specific/text_theme.dart';
import '../../project_specific/project_appbar.dart';

class BookingHistoryPage extends StatefulWidget {
  const BookingHistoryPage({super.key});

  @override
  State<BookingHistoryPage> createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      appBar: const AppBarWidget(
        nameOfScreen: "Booking History",
        isBackIcon: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Latest Order",
                  textScaler: const TextScaler.linear(0.85),
                  style: AppTextTheme.bold
                      .copyWith(fontSize: 20, color: ColorConstant.blackColor),
                ),
                _noOfServiceYouOffer(),
              ],
            ),
          ),
          _stylistAndSalon(),
          Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 15,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: BookingHistoryWidget(
                        onPress: () {},
                      ),
                    );
                  })),
        ],
      ),
    );
  }

  /*--------------- Dummy Data ---------*/
  final List<String> dataList = [
    'Today',
    'yesterday',
    'This Week',
    'This Month',
    'This year',
  ];

  /*--------------------- No. Of Service You Offer ------------------*/
  _noOfServiceYouOffer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: Get.width * 0.4,
        child: DropdownButtonFormField2<String>(
          isExpanded: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          hint: Text(
            'Today',
            style: AppTextTheme.medium
                .copyWith(color: ColorConstant.grayColor, fontSize: 13),
          ),
          items: dataList
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item,
                        style: AppTextTheme.medium.copyWith(
                            color: ColorConstant.blackColor, fontSize: 13)),
                  ))
              .toList(),
          validator: (value) {
            if (value == null) {
              return 'Today';
            }
            return null;
          },
          onChanged: (value) {
            //Do something when selected item is changed.
          },
          onSaved: (value) {
            /* selectedValue = value.toString();*/
          },
          buttonStyleData: const ButtonStyleData(
            padding: EdgeInsets.only(right: 8),
          ),
          iconStyleData: const IconStyleData(
            icon: Icon(
              Icons.arrow_drop_down,
              color: Colors.black45,
            ),
            iconSize: 24,
          ),
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            padding: EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
      ),
    );
  }

  /*----------- Tab Bar variable  ----------- */
  String? overall = "0";

  /*------------------- Switch Tab Stylist & Salon -------------------*/
  _stylistAndSalon() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
          color: ColorConstant.whiteColor,
          border: Border.all(color: ColorConstant.dividerColor, width: 2),
          borderRadius: BorderRadius.circular(15)),
      width: Get.width,
      padding: const EdgeInsets.all(2),
      child: CupertinoSlidingSegmentedControl(
          groupValue: overall,
          thumbColor: ColorConstant.whiteColor,
          children: {
            "0": SizedBox(
              width: Get.width,
              height: Get.height * 0.06,
              child: Center(
                child: Text(
                  "Upcoming",
                  style: AppTextTheme.medium.copyWith(
                      fontSize: 16,
                      color: overall == "0"
                          ? ColorConstant.blackColor
                          : ColorConstant.grayTextColor),
                ),
              ),
            ),
            "1": Text(
              "Cancelled",
              style: AppTextTheme.medium.copyWith(
                  fontSize: 16,
                  color: overall == "1"
                      ? ColorConstant.blackColor
                      : ColorConstant.grayTextColor),
            ),
            "2": Text(
              "Completed",
              style: AppTextTheme.medium.copyWith(
                  fontSize: 16,
                  color: overall == "2"
                      ? ColorConstant.blackColor
                      : ColorConstant.grayTextColor),
            ),
          },
          onValueChanged: (dynamic value) {
            setState(() {
              overall = value;
            });
          }),
    );
  }
}
