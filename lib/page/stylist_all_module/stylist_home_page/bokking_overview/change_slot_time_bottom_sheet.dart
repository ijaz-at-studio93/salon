import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/stylist/stylist_controller.dart';
import 'package:salon/page/stylist_all_module/stylist_home_page/bokking_overview/widget/time_sloat_widget.dart';
import 'package:salon/project_specific/button_widget.dart';
import 'package:salon/project_specific/text_theme.dart';

class ChangeSlotTimeBottomSheet extends StatefulWidget {
  final String currentTime;
  final String appointmentId;
  final VoidCallback callback;
  const ChangeSlotTimeBottomSheet({
    super.key,
    required this.currentTime,
    required this.appointmentId,
    required this.callback,
  });

  @override
  State<ChangeSlotTimeBottomSheet> createState() =>
      _ChangeSlotTimeBottomSheetState();
}

class _ChangeSlotTimeBottomSheetState extends State<ChangeSlotTimeBottomSheet> {
  final _stylistController = Get.find<StylistController>();

  int isSelected = 0;
  String selectTimeSlot = "";
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.32,
      width: Get.width,
      decoration: const BoxDecoration(
        color: ColorConstant.whiteColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          topLeft: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 71,
            width: Get.width,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(
              color: ColorConstant.primaryColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16),
                topLeft: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    "Cancel",
                    style: AppTextTheme.medium.copyWith(
                        color: ColorConstant.whiteColor, fontSize: 19),
                  ),
                ),
                Text(
                  "Change Slot Time",
                  textScaler: const TextScaler.linear(0.85),
                  style: AppTextTheme.bold
                      .copyWith(color: ColorConstant.whiteColor, fontSize: 19),
                ),
                const SizedBox(),
                const SizedBox()
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      "Current Slot Time",
                      style: AppTextTheme.medium.copyWith(
                          fontSize: 13, color: ColorConstant.grayTextColor),
                    ),
                    Text(
                      widget.currentTime,
                      textScaler: const TextScaler.linear(0.85),
                      style: AppTextTheme.bold.copyWith(
                          fontSize: 16, color: ColorConstant.blackColor),
                    ),
                  ],
                ), /*Container(
                  height: Get.height * 0.04,
                  width: 1,
                  color: ColorConstant.grayTextColor,
                ),
                Column(
                  children: [
                    Text(
                      "Changed Slot Timing",
                      style: AppTextTheme.medium.copyWith(
                          fontSize: 13, color: ColorConstant.grayTextColor),
                    ),
                    Text(
                      "2:00-4:15 PM",
                      textScaler: const TextScaler.linear(0.85),
                      style: AppTextTheme.bold.copyWith(
                          fontSize: 16, color: ColorConstant.blackColor),
                    ),
                  ],
                ),*/
              ],
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: timeSlotString.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TimeSlotWidget(
                      timeSlot: "+${timeSlotString[i]}",
                      isSelected: isSelected == i,
                      onPress: () {
                        setState(() {
                          selectTimeSlot = timeSlotString[i];
                          isSelected = i;
                        });
                      },
                    ),
                  );
                }),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ButtonWidget(
                buttonTitleText: "Apply",
                onPress: () {
                  _stylistController.doUpdateBookingTimeSlot(
                      appointmentId: widget.appointmentId,
                      changeMinutes: {
                        "changeMinutes":
                            selectTimeSlot == "" ? 15 : selectTimeSlot,
                      },
                      callback: () {
                        Get.back();
                        widget.callback.call();
                      });
                }),
          ),
        ],
      ),
    );
  }

  List timeSlotString = ["15", "25", "35", "45", "55"];
}
