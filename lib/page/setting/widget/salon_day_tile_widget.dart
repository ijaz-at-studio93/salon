import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/project_specific/text_theme.dart';

import '../../../model/availability/salon_avibility_model.dart';

class SalonDayTileWidget extends StatefulWidget {
  final String dayTitle;
  String startTime;
  String endTime;
  VoidCallback startTimeTap;
  VoidCallback endTimeTap;
  SalonDayTileWidget({
    super.key,
    required this.dayTitle,
    required this.endTimeTap,
    required this.startTimeTap,
    this.startTime = "",
    this.endTime = "",
  });

  @override
  State<SalonDayTileWidget> createState() => _SalonDayTileWidgetState();
}

class _SalonDayTileWidgetState extends State<SalonDayTileWidget> {
  bool isSwitch = false;
  final _homeController = Get.find<HomeController>();
  @override
  void initState() {
    super.initState();
    if (widget.startTime.isNotEmpty && widget.endTime.isNotEmpty) {
      isSwitch = true;

      if (widget.dayTitle == "Sunday") {
        _homeController.getSalonAvailability.data?.sunday?.isSwitchOn =
            isSwitch;
      }
      if (widget.dayTitle == "Monday") {
        _homeController.getSalonAvailability.data?.monday?.isSwitchOn =
            isSwitch;
      }
      if (widget.dayTitle == "TuesDay") {
        _homeController.getSalonAvailability.data?.tuesday?.isSwitchOn =
            isSwitch;
      }
      if (widget.dayTitle == "Wednesday") {
        _homeController.getSalonAvailability.data?.wednesday?.isSwitchOn =
            isSwitch;
      }
      if (widget.dayTitle == "Thursday") {
        _homeController.getSalonAvailability.data?.thursday?.isSwitchOn =
            isSwitch;
      }
      if (widget.dayTitle == "Friday") {
        _homeController.getSalonAvailability.data?.friday?.isSwitchOn =
            isSwitch;
      }
      if (widget.dayTitle == "Saturday") {
        _homeController.getSalonAvailability.data?.saturday?.isSwitchOn =
            isSwitch;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: Get.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.dayTitle,
                  style: AppTextTheme.bold
                      .copyWith(fontSize: 16, color: ColorConstant.blackColor),
                ),
                CupertinoSwitch(
                  value: isSwitch,
                  activeColor: ColorConstant.primaryColor,
                  onChanged: (bool? value) {
                    setState(() {
                      isSwitch = value ?? false;

                      if (widget.dayTitle == "Sunday") {
                        _homeController.getSalonAvailability.data?.sunday
                            ?.isSwitchOn = isSwitch;
                      }
                      if (widget.dayTitle == "Monday") {
                        _homeController.getSalonAvailability.data?.monday
                            ?.isSwitchOn = isSwitch;
                      }
                      if (widget.dayTitle == "TuesDay") {
                        _homeController.getSalonAvailability.data?.tuesday
                            ?.isSwitchOn = isSwitch;
                      }
                      if (widget.dayTitle == "Wednesday") {
                        _homeController.getSalonAvailability.data?.wednesday
                            ?.isSwitchOn = isSwitch;
                      }
                      if (widget.dayTitle == "Thursday") {
                        _homeController.getSalonAvailability.data?.thursday
                            ?.isSwitchOn = isSwitch;
                      }
                      if (widget.dayTitle == "Friday") {
                        _homeController.getSalonAvailability.data?.friday
                            ?.isSwitchOn = isSwitch;
                      }
                      if (widget.dayTitle == "Saturday") {
                        _homeController.getSalonAvailability.data?.saturday
                            ?.isSwitchOn = isSwitch;
                      }

                      if (isSwitch) {
                        widget.startTime = convertTimeTo12HourFormat("09:00");
                        widget.endTime = convertTimeTo12HourFormat("18:00");

                        if (widget.dayTitle == "Sunday") {
                          _homeController.getSalonAvailability.data?.sunday =
                              SalonDay(start: "9:00", end: "18:00", breaks: [
                            SalonBreaks(start: "14:30", end: "15:00")
                          ]);
                        }
                        if (widget.dayTitle == "Monday") {
                          _homeController.getSalonAvailability.data?.monday =
                              SalonDay(start: "9:00", end: "18:00", breaks: [
                            SalonBreaks(start: "14:30", end: "15:00")
                          ]);
                        }
                        if (widget.dayTitle == "TuesDay") {
                          _homeController.getSalonAvailability.data?.tuesday =
                              SalonDay(start: "9:00", end: "18:00", breaks: [
                            SalonBreaks(start: "14:30", end: "15:00")
                          ]);
                        }
                        if (widget.dayTitle == "Wednesday") {
                          _homeController.getSalonAvailability.data?.wednesday =
                              SalonDay(start: "9:00", end: "18:00", breaks: [
                            SalonBreaks(start: "14:30", end: "15:00")
                          ]);
                        }
                        if (widget.dayTitle == "Thursday") {
                          _homeController.getSalonAvailability.data?.thursday =
                              SalonDay(start: "9:00", end: "18:00", breaks: [
                            SalonBreaks(start: "14:30", end: "15:00")
                          ]);
                        }
                        if (widget.dayTitle == "Friday") {
                          _homeController.getSalonAvailability.data?.friday =
                              SalonDay(start: "9:00", end: "18:00", breaks: [
                            SalonBreaks(start: "14:30", end: "15:00")
                          ]);
                        }
                        if (widget.dayTitle == "Saturday") {
                          _homeController.getSalonAvailability.data?.saturday =
                              SalonDay(start: "9:00", end: "18:00", breaks: [
                            SalonBreaks(start: "14:30", end: "15:00")
                          ]);
                        }
                      }
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: widget.startTimeTap,
                  child: Container(
                    height: 40,
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        Text(
                          "Start Time : ",
                          style: AppTextTheme.medium.copyWith(
                              fontSize: 16, color: ColorConstant.blackColor),
                        ),
                        Text(
                          convertTimeTo12HourFormat(widget.startTime),
                          style: AppTextTheme.regular.copyWith(
                              fontSize: 16, color: ColorConstant.grayTextColor),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: widget.endTimeTap,
                  child: Container(
                    height: 40,
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        Text(
                          "End Time : ",
                          style: AppTextTheme.medium.copyWith(
                              fontSize: 16, color: ColorConstant.blackColor),
                        ),
                        Text(
                          convertTimeTo12HourFormat(widget.endTime),
                          style: AppTextTheme.regular.copyWith(
                              fontSize: 16, color: ColorConstant.grayTextColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  String convertTimeTo12HourFormat(String time24) {
    if (time24.isEmpty) {
      return "";
    } else {
      // Parse the 24-hour format time
      DateTime dateTime = DateFormat("HH:mm").parse(time24);
      // Format the time to 12-hour format with AM/PM
      String time12 = DateFormat("h:mm a").format(dateTime);
      return time12;
    }
  }
}
