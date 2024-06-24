import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/model/availability/artiest_availability_get_model.dart';
import 'package:salon/project_specific/text_theme.dart';

class DayTileWidget extends StatefulWidget {
  final String dayTitle;
  String startTime;
  String endTime;
  VoidCallback startTimeTap;
  VoidCallback endTimeTap;
  DayTileWidget({
    super.key,
    required this.dayTitle,
    required this.endTimeTap,
    required this.startTimeTap,
    this.startTime = "",
    this.endTime = "",
  });

  @override
  State<DayTileWidget> createState() => _DayTileWidgetState();
}

class _DayTileWidgetState extends State<DayTileWidget> {
  bool isSwitch = false;
  final _homeController = Get.find<HomeController>();
  @override
  void initState() {
    super.initState();
    if (widget.startTime.isNotEmpty && widget.endTime.isNotEmpty) {
      isSwitch = true;

      if (widget.dayTitle == "Sunday") {
        _homeController
            .getArtiestAvailabilityGetModel.data?.sunday?.isSwitchOn = isSwitch;
      }
      if (widget.dayTitle == "Monday") {
        _homeController
            .getArtiestAvailabilityGetModel.data?.monday?.isSwitchOn = isSwitch;
      }
      if (widget.dayTitle == "Tuesday") {
        _homeController.getArtiestAvailabilityGetModel.data?.tuesday
            ?.isSwitchOn = isSwitch;
      }
      if (widget.dayTitle == "Wednesday") {
        _homeController.getArtiestAvailabilityGetModel.data?.wednesday
            ?.isSwitchOn = isSwitch;
      }
      if (widget.dayTitle == "Thursday") {
        _homeController.getArtiestAvailabilityGetModel.data?.thursday
            ?.isSwitchOn = isSwitch;
      }
      if (widget.dayTitle == "Friday") {
        _homeController
            .getArtiestAvailabilityGetModel.data?.friday?.isSwitchOn = isSwitch;
      }
      if (widget.dayTitle == "Saturday") {
        _homeController.getArtiestAvailabilityGetModel.data?.saturday
            ?.isSwitchOn = isSwitch;
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
                        _homeController.getArtiestAvailabilityGetModel.data
                            ?.sunday?.isSwitchOn = isSwitch;
                      }
                      if (widget.dayTitle == "Monday") {
                        _homeController.getArtiestAvailabilityGetModel.data
                            ?.monday?.isSwitchOn = isSwitch;
                      }
                      if (widget.dayTitle == "Tuesday") {
                        _homeController.getArtiestAvailabilityGetModel.data
                            ?.tuesday?.isSwitchOn = isSwitch;
                      }
                      if (widget.dayTitle == "Wednesday") {
                        _homeController.getArtiestAvailabilityGetModel.data
                            ?.wednesday?.isSwitchOn = isSwitch;
                      }
                      if (widget.dayTitle == "Thursday") {
                        _homeController.getArtiestAvailabilityGetModel.data
                            ?.thursday?.isSwitchOn = isSwitch;
                      }
                      if (widget.dayTitle == "Friday") {
                        _homeController.getArtiestAvailabilityGetModel.data
                            ?.friday?.isSwitchOn = isSwitch;
                      }
                      if (widget.dayTitle == "Saturday") {
                        _homeController.getArtiestAvailabilityGetModel.data
                            ?.saturday?.isSwitchOn = isSwitch;
                      }

                      if (isSwitch) {
                        widget.startTime = convertTimeTo12HourFormat("09:00");
                        widget.endTime = convertTimeTo12HourFormat("18:00");

                        if (widget.dayTitle == "Sunday") {
                          _homeController
                                  .getArtiestAvailabilityGetModel.data?.sunday =
                              DayData(start: "09:00", end: "18:00", breaks: [
                            Breaks(start: "14:30", end: "15:00")
                          ]);
                        }
                        if (widget.dayTitle == "Monday") {
                          _homeController
                                  .getArtiestAvailabilityGetModel.data?.monday =
                              DayData(start: "09:00", end: "18:00", breaks: [
                            Breaks(start: "14:30", end: "15:00")
                          ]);
                        }
                        if (widget.dayTitle == "Tuesday") {
                          _homeController.getArtiestAvailabilityGetModel.data
                                  ?.tuesday =
                              DayData(start: "09:00", end: "18:00", breaks: [
                            Breaks(start: "14:30", end: "15:00")
                          ]);
                        }
                        if (widget.dayTitle == "Wednesday") {
                          _homeController.getArtiestAvailabilityGetModel.data
                                  ?.wednesday =
                              DayData(start: "09:00", end: "18:00", breaks: [
                            Breaks(start: "14:30", end: "15:00")
                          ]);
                        }
                        if (widget.dayTitle == "Thursday") {
                          _homeController.getArtiestAvailabilityGetModel.data
                                  ?.thursday =
                              DayData(start: "09:00", end: "18:00", breaks: [
                            Breaks(start: "14:30", end: "15:00")
                          ]);
                        }
                        if (widget.dayTitle == "Friday") {
                          _homeController
                                  .getArtiestAvailabilityGetModel.data?.friday =
                              DayData(start: "09:00", end: "18:00", breaks: [
                            Breaks(start: "14:30", end: "15:00")
                          ]);
                        }
                        if (widget.dayTitle == "Saturday") {
                          _homeController.getArtiestAvailabilityGetModel.data
                                  ?.saturday =
                              DayData(start: "09:00", end: "18:00", breaks: [
                            Breaks(start: "14:30", end: "15:00")
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
