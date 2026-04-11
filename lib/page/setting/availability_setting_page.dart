import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/model/availability/salon_avibility_model.dart';
import 'package:salon/model/availability/salon_working_plain_model.dart';
import 'package:salon/page/setting/widget/salon_day_tile_widget.dart';
import 'package:salon/project_specific/progressbar_view.dart';
import 'package:salon/project_specific/project_appbar.dart';
import '../../project_specific/text_theme.dart';

class AvailabilitySettingPage extends StatefulWidget {
  const AvailabilitySettingPage({super.key});

  @override
  State<AvailabilitySettingPage> createState() =>
      _AvailabilitySettingPageState();
}

class _AvailabilitySettingPageState extends State<AvailabilitySettingPage> {
  final _homeController = Get.find<HomeController>();

  late SalonWorkingPlanModel salonWorkingPlanModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _homeController.doGetSalonAvailability();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      appBar: AppBarWidget(
        nameOfScreen: "Availability",
        actions: [
          TextButton(
            onPressed: () {
              salonWorkingPlanModel = SalonWorkingPlanModel(
                workingPlan: SalonAvailabilityData(
                  sunday: _homeController.getSalonAvailability.data?.sunday
                                      ?.start ==
                                  null &&
                              _homeController
                                      .getSalonAvailability.data?.sunday?.end ==
                                  null ||
                          _homeController.getSalonAvailability.data?.sunday
                                  ?.isSwitchOn ==
                              false
                      ? null
                      : SalonDay(
                          start: _homeController
                              .getSalonAvailability.data?.sunday?.start,
                          end: _homeController
                              .getSalonAvailability.data?.sunday?.end,
                          breaks: _homeController
                              .getSalonAvailability.data?.sunday?.breaks),
                  monday: _homeController.getSalonAvailability.data?.monday
                                      ?.start ==
                                  null &&
                              _homeController
                                      .getSalonAvailability.data?.monday?.end ==
                                  null ||
                          _homeController.getSalonAvailability.data?.monday
                                  ?.isSwitchOn ==
                              false
                      ? null
                      : SalonDay(
                          start: _homeController
                              .getSalonAvailability.data?.monday?.start,
                          end: _homeController
                              .getSalonAvailability.data?.monday?.end,
                          breaks: _homeController
                              .getSalonAvailability.data?.monday?.breaks),
                  tuesday: _homeController.getSalonAvailability.data?.tuesday
                                      ?.start ==
                                  null &&
                              _homeController.getSalonAvailability.data?.tuesday
                                      ?.end ==
                                  null ||
                          _homeController.getSalonAvailability.data?.tuesday
                                  ?.isSwitchOn ==
                              false
                      ? null
                      : SalonDay(
                          start: _homeController
                              .getSalonAvailability.data?.tuesday?.start,
                          end: _homeController
                              .getSalonAvailability.data?.tuesday?.end,
                          breaks: _homeController
                              .getSalonAvailability.data?.tuesday?.breaks),
                  wednesday: _homeController.getSalonAvailability.data
                                      ?.wednesday?.start ==
                                  null &&
                              _homeController.getSalonAvailability.data
                                      ?.wednesday?.end ==
                                  null ||
                          _homeController.getSalonAvailability.data?.wednesday
                                  ?.isSwitchOn ==
                              false
                      ? null
                      : SalonDay(
                          start: _homeController
                              .getSalonAvailability.data?.wednesday?.start,
                          end: _homeController
                              .getSalonAvailability.data?.wednesday?.end,
                          breaks: _homeController
                              .getSalonAvailability.data?.wednesday?.breaks),
                  thursday: _homeController.getSalonAvailability.data?.thursday
                                      ?.start ==
                                  null &&
                              _homeController.getSalonAvailability.data
                                      ?.thursday?.end ==
                                  null ||
                          _homeController.getSalonAvailability.data?.thursday
                                  ?.isSwitchOn ==
                              false
                      ? null
                      : SalonDay(
                          start: _homeController
                              .getSalonAvailability.data?.thursday?.start,
                          end: _homeController
                              .getSalonAvailability.data?.thursday?.end,
                          breaks: _homeController
                              .getSalonAvailability.data?.thursday?.breaks),
                  friday: _homeController.getSalonAvailability.data?.friday
                                      ?.start ==
                                  null &&
                              _homeController
                                      .getSalonAvailability.data?.friday?.end ==
                                  null ||
                          _homeController.getSalonAvailability.data?.friday
                                  ?.isSwitchOn ==
                              false
                      ? null
                      : SalonDay(
                          start: _homeController
                              .getSalonAvailability.data?.friday?.start,
                          end: _homeController
                              .getSalonAvailability.data?.friday?.end,
                          breaks: _homeController
                              .getSalonAvailability.data?.friday?.breaks),
                  saturday: _homeController.getSalonAvailability.data?.saturday
                                      ?.start ==
                                  null &&
                              _homeController.getSalonAvailability.data
                                      ?.saturday?.end ==
                                  null ||
                          _homeController.getSalonAvailability.data?.saturday
                                  ?.isSwitchOn ==
                              false
                      ? null
                      : SalonDay(
                          start: _homeController
                              .getSalonAvailability.data?.saturday?.start,
                          end: _homeController
                              .getSalonAvailability.data?.saturday?.end,
                          breaks: _homeController
                              .getSalonAvailability.data?.saturday?.breaks),
                ),
              );

              print(_homeController
                  .getSalonAvailability.data?.tuesday?.isSwitchOn);
              print(_homeController.getSalonAvailability.data?.tuesday?.start);
              print(_homeController.getSalonAvailability.data?.tuesday?.end);
              print("=======/*/*/*/*/*/*/*/* =============");

              String jsonStr = jsonEncode(salonWorkingPlanModel);
              Map<String, dynamic> data = jsonDecode(jsonStr);

              _homeController.doUpdateSalonAvailability(
                  availability: data,
                  callback: () {
                    _homeController.doGetSalonAvailability();
                  });
            },
            child: Text(
              "UPDATE",
              style: AppTextTheme.bold
                  .copyWith(color: ColorConstant.blackColor, fontSize: 16),
            ),
          )
        ],
      ),
      body: Obx(
        () => _homeController.showProgress
            ? const ProgressBarView()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    /*---------------- Sunday -------------*/
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 5.0,
                              offset: const Offset(0.0, 3.0)),
                        ],
                        border: Border.all(color: ColorConstant.primaryColor),
                        color: ColorConstant.whiteColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SalonDayTileWidget(
                            dayTitle: 'Sunday',
                            endTimeTap: () async {
                              final TimeOfDay? sundayEndTime =
                                  await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );

                              setState(() {
                                String end = formatTimeOfDay(sundayEndTime!);

                                _homeController
                                        .getSalonAvailability.data?.sunday =
                                    SalonDay(
                                        start: _homeController
                                                .getSalonAvailability
                                                .data
                                                ?.sunday
                                                ?.start ??
                                            "",
                                        end: end,
                                        breaks: _homeController
                                                .getSalonAvailability
                                                .data
                                                ?.sunday
                                                ?.breaks ??
                                            []);
                              });
                            },
                            startTimeTap: () async {
                              final TimeOfDay? sundayStartTime =
                                  await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );

                              setState(() {
                                String start =
                                    formatTimeOfDay(sundayStartTime!);

                                _homeController
                                        .getSalonAvailability.data?.sunday =
                                    SalonDay(
                                        start: start,
                                        end: _homeController
                                                .getSalonAvailability
                                                .data
                                                ?.sunday
                                                ?.end ??
                                            "",
                                        breaks: _homeController
                                                .getSalonAvailability
                                                .data
                                                ?.sunday
                                                ?.breaks ??
                                            []);
                              });
                            },
                            endTime: _homeController
                                    .getSalonAvailability.data?.sunday?.end ??
                                "",
                            startTime: _homeController
                                    .getSalonAvailability.data?.sunday?.start ??
                                "",
                          ),
                          const Divider(),
                          Text(
                            "Break",
                            style: AppTextTheme.bold.copyWith(
                                fontSize: 16, color: ColorConstant.blackColor),
                          ),
                          const Divider(),
                          ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: _homeController.getSalonAvailability
                                      .data?.sunday?.breaks?.length ??
                                  0,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        final TimeOfDay? sundayStartTime =
                                            await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        );
                                        setState(() {
                                          String start =
                                              formatTimeOfDay(sundayStartTime!);

                                          _homeController.getSalonAvailability
                                                  .data?.sunday =
                                              SalonDay(
                                                  start: _homeController
                                                          .getSalonAvailability
                                                          .data
                                                          ?.sunday
                                                          ?.start ??
                                                      "",
                                                  end: _homeController
                                                          .getSalonAvailability
                                                          .data
                                                          ?.sunday
                                                          ?.end ??
                                                      "",
                                                  breaks: [
                                                SalonBreaks(
                                                    start: start,
                                                    end: _homeController
                                                            .getSalonAvailability
                                                            .data
                                                            ?.sunday
                                                            ?.breaks?[index]
                                                            .end ??
                                                        "")
                                              ]);
                                        });
                                      },
                                      child: Container(
                                        height: 40,
                                        color: Colors.transparent,
                                        child: Row(
                                          children: [
                                            Text(
                                              "Start Time : ",
                                              style: AppTextTheme.medium
                                                  .copyWith(
                                                      fontSize: 16,
                                                      color: ColorConstant
                                                          .blackColor),
                                            ),
                                            Text(
                                              _homeController
                                                          .getSalonAvailability
                                                          .data
                                                          ?.sunday
                                                          ?.breaks?[index]
                                                          .start
                                                          ?.isEmpty ??
                                                      false
                                                  ? ""
                                                  : convertTimeTo12HourFormat(
                                                      _homeController
                                                              .getSalonAvailability
                                                              .data
                                                              ?.sunday
                                                              ?.breaks?[index]
                                                              .start ??
                                                          ""),
                                              style: AppTextTheme.regular
                                                  .copyWith(
                                                      fontSize: 16,
                                                      color: ColorConstant
                                                          .grayTextColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        final TimeOfDay? sundayEndTime =
                                            await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        );

                                        setState(() {
                                          String end =
                                              formatTimeOfDay(sundayEndTime!);

                                          _homeController.getSalonAvailability
                                                  .data?.sunday =
                                              SalonDay(
                                                  start: _homeController
                                                          .getSalonAvailability
                                                          .data
                                                          ?.sunday
                                                          ?.start ??
                                                      "",
                                                  end: _homeController
                                                          .getSalonAvailability
                                                          .data
                                                          ?.sunday
                                                          ?.end ??
                                                      "",
                                                  breaks: [
                                                SalonBreaks(
                                                    start: _homeController
                                                            .getSalonAvailability
                                                            .data
                                                            ?.sunday
                                                            ?.breaks?[index]
                                                            .start ??
                                                        "",
                                                    end: end)
                                              ]);
                                        });
                                      },
                                      child: Container(
                                        height: 40,
                                        color: Colors.transparent,
                                        child: Row(
                                          children: [
                                            Text(
                                              "End Time : ",
                                              style: AppTextTheme.medium
                                                  .copyWith(
                                                      fontSize: 16,
                                                      color: ColorConstant
                                                          .blackColor),
                                            ),
                                            Text(
                                              _homeController
                                                          .getSalonAvailability
                                                          .data
                                                          ?.sunday
                                                          ?.breaks?[index]
                                                          .end
                                                          ?.isEmpty ??
                                                      false
                                                  ? ""
                                                  : convertTimeTo12HourFormat(
                                                      _homeController
                                                              .getSalonAvailability
                                                              .data
                                                              ?.sunday
                                                              ?.breaks?[index]
                                                              .end ??
                                                          ""),
                                              style: AppTextTheme.regular
                                                  .copyWith(
                                                      fontSize: 16,
                                                      color: ColorConstant
                                                          .grayTextColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        ],
                      ),
                    ),

                    /*---------------- Monday -------------*/
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 5.0,
                              offset: const Offset(0.0, 3.0)),
                        ],
                        border: Border.all(color: ColorConstant.primaryColor),
                        color: ColorConstant.whiteColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SalonDayTileWidget(
                            endTimeTap: () async {
                              final TimeOfDay? sundayEndTime =
                                  await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );

                              setState(() {
                                String end = formatTimeOfDay(sundayEndTime!);

                                _homeController
                                        .getSalonAvailability.data?.monday =
                                    SalonDay(
                                        start: _homeController
                                                .getSalonAvailability
                                                .data
                                                ?.monday
                                                ?.start ??
                                            "",
                                        end: end,
                                        breaks: _homeController
                                                .getSalonAvailability
                                                .data
                                                ?.monday
                                                ?.breaks ??
                                            []);
                              });
                            },
                            startTimeTap: () async {
                              final TimeOfDay? sundayStartTime =
                                  await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );

                              setState(() {
                                String start =
                                    formatTimeOfDay(sundayStartTime!);

                                _homeController
                                        .getSalonAvailability.data?.monday =
                                    SalonDay(
                                        start: start,
                                        end: _homeController
                                                .getSalonAvailability
                                                .data
                                                ?.monday
                                                ?.end ??
                                            "",
                                        breaks: _homeController
                                                .getSalonAvailability
                                                .data
                                                ?.monday
                                                ?.breaks ??
                                            []);
                              });
                            },
                            dayTitle: 'Monday',
                            endTime: _homeController
                                    .getSalonAvailability.data?.monday?.end ??
                                "",
                            startTime: _homeController
                                    .getSalonAvailability.data?.monday?.start ??
                                "",
                          ),
                          const Divider(),
                          Text(
                            "Break",
                            style: AppTextTheme.bold.copyWith(
                                fontSize: 16, color: ColorConstant.blackColor),
                          ),
                          const Divider(),
                          ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: _homeController.getSalonAvailability
                                      .data?.monday?.breaks?.length ??
                                  0,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        final TimeOfDay? sundayStartTime =
                                            await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        );
                                        setState(() {
                                          String start =
                                              formatTimeOfDay(sundayStartTime!);

                                          _homeController.getSalonAvailability
                                                  .data?.monday =
                                              SalonDay(
                                                  start: _homeController
                                                          .getSalonAvailability
                                                          .data
                                                          ?.monday
                                                          ?.start ??
                                                      "",
                                                  end: _homeController
                                                          .getSalonAvailability
                                                          .data
                                                          ?.monday
                                                          ?.end ??
                                                      "",
                                                  breaks: [
                                                SalonBreaks(
                                                    start: start,
                                                    end: _homeController
                                                            .getSalonAvailability
                                                            .data
                                                            ?.monday
                                                            ?.breaks?[index]
                                                            .end ??
                                                        "")
                                              ]);
                                        });
                                      },
                                      child: Container(
                                        height: 40,
                                        color: Colors.transparent,
                                        child: Row(
                                          children: [
                                            Text(
                                              "Start Time : ",
                                              style: AppTextTheme.medium
                                                  .copyWith(
                                                      fontSize: 16,
                                                      color: ColorConstant
                                                          .blackColor),
                                            ),
                                            Text(
                                              _homeController
                                                          .getSalonAvailability
                                                          .data
                                                          ?.monday
                                                          ?.breaks?[index]
                                                          .start
                                                          ?.isEmpty ??
                                                      false
                                                  ? ""
                                                  : convertTimeTo12HourFormat(
                                                      _homeController
                                                              .getSalonAvailability
                                                              .data
                                                              ?.monday
                                                              ?.breaks?[index]
                                                              .start ??
                                                          ""),
                                              style: AppTextTheme.regular
                                                  .copyWith(
                                                      fontSize: 16,
                                                      color: ColorConstant
                                                          .grayTextColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        final TimeOfDay? sundayEndTime =
                                            await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        );

                                        setState(() {
                                          String end =
                                              formatTimeOfDay(sundayEndTime!);

                                          _homeController.getSalonAvailability
                                                  .data?.monday =
                                              SalonDay(
                                                  start: _homeController
                                                          .getSalonAvailability
                                                          .data
                                                          ?.monday
                                                          ?.start ??
                                                      "",
                                                  end: _homeController
                                                          .getSalonAvailability
                                                          .data
                                                          ?.monday
                                                          ?.end ??
                                                      "",
                                                  breaks: [
                                                SalonBreaks(
                                                    start: _homeController
                                                            .getSalonAvailability
                                                            .data
                                                            ?.monday
                                                            ?.breaks?[index]
                                                            .start ??
                                                        "",
                                                    end: end)
                                              ]);
                                        });
                                      },
                                      child: Container(
                                        height: 40,
                                        color: Colors.transparent,
                                        child: Row(
                                          children: [
                                            Text(
                                              "End Time : ",
                                              style: AppTextTheme.medium
                                                  .copyWith(
                                                      fontSize: 16,
                                                      color: ColorConstant
                                                          .blackColor),
                                            ),
                                            Text(
                                              _homeController
                                                          .getSalonAvailability
                                                          .data
                                                          ?.monday
                                                          ?.breaks?[index]
                                                          .end
                                                          ?.isEmpty ??
                                                      false
                                                  ? ""
                                                  : convertTimeTo12HourFormat(
                                                      _homeController
                                                              .getSalonAvailability
                                                              .data
                                                              ?.monday
                                                              ?.breaks?[index]
                                                              .end ??
                                                          ""),
                                              style: AppTextTheme.regular
                                                  .copyWith(
                                                      fontSize: 16,
                                                      color: ColorConstant
                                                          .grayTextColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        ],
                      ),
                    ),

                    /*-------------  TuesDay ----------*/
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 5.0,
                              offset: const Offset(0.0, 3.0)),
                        ],
                        border: Border.all(color: ColorConstant.primaryColor),
                        color: ColorConstant.whiteColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SalonDayTileWidget(
                            endTimeTap: () async {
                              final TimeOfDay? sundayEndTime =
                                  await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );

                              setState(() {
                                String end = formatTimeOfDay(sundayEndTime!);

                                _homeController
                                        .getSalonAvailability.data?.tuesday =
                                    SalonDay(
                                        start: _homeController
                                                .getSalonAvailability
                                                .data
                                                ?.tuesday
                                                ?.start ??
                                            "",
                                        end: end,
                                        breaks: _homeController
                                                .getSalonAvailability
                                                .data
                                                ?.tuesday
                                                ?.breaks ??
                                            []);
                              });
                            },
                            startTimeTap: () async {
                              final TimeOfDay? sundayStartTime =
                                  await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );

                              setState(() {
                                String start =
                                    formatTimeOfDay(sundayStartTime!);

                                _homeController
                                        .getSalonAvailability.data?.tuesday =
                                    SalonDay(
                                        start: start,
                                        end: _homeController
                                                .getSalonAvailability
                                                .data
                                                ?.tuesday
                                                ?.end ??
                                            "",
                                        breaks: _homeController
                                                .getSalonAvailability
                                                .data
                                                ?.tuesday
                                                ?.breaks ??
                                            []);
                              });
                            },
                            dayTitle: 'Tuesday',
                            endTime: _homeController
                                    .getSalonAvailability.data?.tuesday?.end ??
                                "",
                            startTime: _homeController.getSalonAvailability.data
                                    ?.tuesday?.start ??
                                "",
                          ),
                          const Divider(),
                          Text(
                            "Break",
                            style: AppTextTheme.bold.copyWith(
                                fontSize: 16, color: ColorConstant.blackColor),
                          ),
                          const Divider(),
                          ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: _homeController.getSalonAvailability
                                      .data?.tuesday?.breaks?.length ??
                                  0,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        final TimeOfDay? sundayStartTime =
                                            await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        );
                                        setState(() {
                                          String start =
                                              formatTimeOfDay(sundayStartTime!);

                                          _homeController.getSalonAvailability
                                                  .data?.tuesday =
                                              SalonDay(
                                                  start: _homeController
                                                          .getSalonAvailability
                                                          .data
                                                          ?.tuesday
                                                          ?.start ??
                                                      "",
                                                  end: _homeController
                                                          .getSalonAvailability
                                                          .data
                                                          ?.tuesday
                                                          ?.end ??
                                                      "",
                                                  breaks: [
                                                SalonBreaks(
                                                    start: start,
                                                    end: _homeController
                                                            .getSalonAvailability
                                                            .data
                                                            ?.tuesday
                                                            ?.breaks?[index]
                                                            .end ??
                                                        "")
                                              ]);
                                        });
                                      },
                                      child: Container(
                                        height: 40,
                                        color: Colors.transparent,
                                        child: Row(
                                          children: [
                                            Text(
                                              "Start Time : ",
                                              style: AppTextTheme.medium
                                                  .copyWith(
                                                      fontSize: 16,
                                                      color: ColorConstant
                                                          .blackColor),
                                            ),
                                            Text(
                                              _homeController
                                                          .getSalonAvailability
                                                          .data
                                                          ?.tuesday
                                                          ?.breaks?[index]
                                                          .start
                                                          ?.isEmpty ??
                                                      false
                                                  ? ""
                                                  : convertTimeTo12HourFormat(
                                                      _homeController
                                                              .getSalonAvailability
                                                              .data
                                                              ?.tuesday
                                                              ?.breaks?[index]
                                                              .start ??
                                                          ""),
                                              style: AppTextTheme.regular
                                                  .copyWith(
                                                      fontSize: 16,
                                                      color: ColorConstant
                                                          .grayTextColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        final TimeOfDay? sundayEndTime =
                                            await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        );

                                        setState(() {
                                          String end =
                                              formatTimeOfDay(sundayEndTime!);

                                          _homeController.getSalonAvailability
                                                  .data?.tuesday =
                                              SalonDay(
                                                  start: _homeController
                                                          .getSalonAvailability
                                                          .data
                                                          ?.tuesday
                                                          ?.start ??
                                                      "",
                                                  end: _homeController
                                                          .getSalonAvailability
                                                          .data
                                                          ?.tuesday
                                                          ?.end ??
                                                      "",
                                                  breaks: [
                                                SalonBreaks(
                                                    start: _homeController
                                                            .getSalonAvailability
                                                            .data
                                                            ?.tuesday
                                                            ?.breaks?[index]
                                                            .start ??
                                                        "",
                                                    end: end)
                                              ]);
                                        });
                                      },
                                      child: Container(
                                        height: 40,
                                        color: Colors.transparent,
                                        child: Row(
                                          children: [
                                            Text(
                                              "End Time : ",
                                              style: AppTextTheme.medium
                                                  .copyWith(
                                                      fontSize: 16,
                                                      color: ColorConstant
                                                          .blackColor),
                                            ),
                                            Text(
                                              _homeController
                                                          .getSalonAvailability
                                                          .data
                                                          ?.tuesday
                                                          ?.breaks?[index]
                                                          .end
                                                          ?.isEmpty ??
                                                      false
                                                  ? ""
                                                  : convertTimeTo12HourFormat(
                                                      _homeController
                                                              .getSalonAvailability
                                                              .data
                                                              ?.tuesday
                                                              ?.breaks?[index]
                                                              .end ??
                                                          ""),
                                              style: AppTextTheme.regular
                                                  .copyWith(
                                                      fontSize: 16,
                                                      color: ColorConstant
                                                          .grayTextColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        ],
                      ),
                    ),

                    /*-------------  Wednesday ----------*/
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 5.0,
                              offset: const Offset(0.0, 3.0)),
                        ],
                        border: Border.all(color: ColorConstant.primaryColor),
                        color: ColorConstant.whiteColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SalonDayTileWidget(
                            endTimeTap: () async {
                              final TimeOfDay? sundayEndTime =
                                  await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );

                              setState(() {
                                String end = formatTimeOfDay(sundayEndTime!);

                                _homeController
                                        .getSalonAvailability.data?.wednesday =
                                    SalonDay(
                                        start: _homeController
                                                .getSalonAvailability
                                                .data
                                                ?.wednesday
                                                ?.start ??
                                            "",
                                        end: end,
                                        breaks: _homeController
                                                .getSalonAvailability
                                                .data
                                                ?.wednesday
                                                ?.breaks ??
                                            []);
                              });
                            },
                            startTimeTap: () async {
                              final TimeOfDay? sundayStartTime =
                                  await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );

                              setState(() {
                                String start =
                                    formatTimeOfDay(sundayStartTime!);

                                _homeController
                                        .getSalonAvailability.data?.wednesday =
                                    SalonDay(
                                        start: start,
                                        end: _homeController
                                                .getSalonAvailability
                                                .data
                                                ?.wednesday
                                                ?.end ??
                                            "",
                                        breaks: _homeController
                                                .getSalonAvailability
                                                .data
                                                ?.wednesday
                                                ?.breaks ??
                                            []);
                              });
                            },
                            dayTitle: 'Wednesday',
                            endTime: _homeController.getSalonAvailability.data
                                    ?.wednesday?.end ??
                                "",
                            startTime: _homeController.getSalonAvailability.data
                                    ?.wednesday?.start ??
                                "",
                          ),
                          const Divider(),
                          Text(
                            "Break",
                            style: AppTextTheme.bold.copyWith(
                                fontSize: 16, color: ColorConstant.blackColor),
                          ),
                          const Divider(),
                          ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: _homeController.getSalonAvailability
                                      .data?.wednesday?.breaks?.length ??
                                  0,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        final TimeOfDay? sundayStartTime =
                                            await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        );
                                        setState(() {
                                          String start =
                                              formatTimeOfDay(sundayStartTime!);

                                          _homeController.getSalonAvailability
                                                  .data?.wednesday =
                                              SalonDay(
                                                  start: _homeController
                                                          .getSalonAvailability
                                                          .data
                                                          ?.wednesday
                                                          ?.start ??
                                                      "",
                                                  end: _homeController
                                                          .getSalonAvailability
                                                          .data
                                                          ?.wednesday
                                                          ?.end ??
                                                      "",
                                                  breaks: [
                                                SalonBreaks(
                                                    start: start,
                                                    end: _homeController
                                                            .getSalonAvailability
                                                            .data
                                                            ?.wednesday
                                                            ?.breaks?[index]
                                                            .end ??
                                                        "")
                                              ]);
                                        });
                                      },
                                      child: Container(
                                        height: 40,
                                        color: Colors.transparent,
                                        child: Row(
                                          children: [
                                            Text(
                                              "Start Time : ",
                                              style: AppTextTheme.medium
                                                  .copyWith(
                                                      fontSize: 16,
                                                      color: ColorConstant
                                                          .blackColor),
                                            ),
                                            Text(
                                              _homeController
                                                          .getSalonAvailability
                                                          .data
                                                          ?.wednesday
                                                          ?.breaks?[index]
                                                          .start
                                                          ?.isEmpty ??
                                                      false
                                                  ? ""
                                                  : convertTimeTo12HourFormat(
                                                      _homeController
                                                              .getSalonAvailability
                                                              .data
                                                              ?.wednesday
                                                              ?.breaks?[index]
                                                              .start ??
                                                          ""),
                                              style: AppTextTheme.regular
                                                  .copyWith(
                                                      fontSize: 16,
                                                      color: ColorConstant
                                                          .grayTextColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        final TimeOfDay? sundayEndTime =
                                            await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        );

                                        setState(() {
                                          String end =
                                              formatTimeOfDay(sundayEndTime!);

                                          _homeController.getSalonAvailability
                                                  .data?.wednesday =
                                              SalonDay(
                                                  start: _homeController
                                                          .getSalonAvailability
                                                          .data
                                                          ?.wednesday
                                                          ?.start ??
                                                      "",
                                                  end: _homeController
                                                          .getSalonAvailability
                                                          .data
                                                          ?.wednesday
                                                          ?.end ??
                                                      "",
                                                  breaks: [
                                                SalonBreaks(
                                                    start: _homeController
                                                            .getSalonAvailability
                                                            .data
                                                            ?.wednesday
                                                            ?.breaks?[index]
                                                            .start ??
                                                        "",
                                                    end: end)
                                              ]);
                                        });
                                      },
                                      child: Container(
                                        height: 40,
                                        color: Colors.transparent,
                                        child: Row(
                                          children: [
                                            Text(
                                              "End Time : ",
                                              style: AppTextTheme.medium
                                                  .copyWith(
                                                      fontSize: 16,
                                                      color: ColorConstant
                                                          .blackColor),
                                            ),
                                            Text(
                                              _homeController
                                                          .getSalonAvailability
                                                          .data
                                                          ?.wednesday
                                                          ?.breaks?[index]
                                                          .end
                                                          ?.isEmpty ??
                                                      false
                                                  ? ""
                                                  : convertTimeTo12HourFormat(
                                                      _homeController
                                                              .getSalonAvailability
                                                              .data
                                                              ?.wednesday
                                                              ?.breaks?[index]
                                                              .end ??
                                                          ""),
                                              style: AppTextTheme.regular
                                                  .copyWith(
                                                      fontSize: 16,
                                                      color: ColorConstant
                                                          .grayTextColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        ],
                      ),
                    ),

                    /*------------ Thursday -------------*/
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 5.0,
                              offset: const Offset(0.0, 3.0)),
                        ],
                        border: Border.all(color: ColorConstant.primaryColor),
                        color: ColorConstant.whiteColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SalonDayTileWidget(
                            dayTitle: 'Thursday',
                            endTimeTap: () async {
                              final TimeOfDay? sundayEndTime =
                                  await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );

                              setState(() {
                                String end = formatTimeOfDay(sundayEndTime!);

                                _homeController
                                        .getSalonAvailability.data?.thursday =
                                    SalonDay(
                                        start: _homeController
                                                .getSalonAvailability
                                                .data
                                                ?.thursday
                                                ?.start ??
                                            "",
                                        end: end,
                                        breaks: _homeController
                                                .getSalonAvailability
                                                .data
                                                ?.thursday
                                                ?.breaks ??
                                            []);
                              });
                            },
                            startTimeTap: () async {
                              final TimeOfDay? sundayStartTime =
                                  await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );

                              setState(() {
                                String start =
                                    formatTimeOfDay(sundayStartTime!);

                                _homeController
                                        .getSalonAvailability.data?.thursday =
                                    SalonDay(
                                        start: start,
                                        end: _homeController
                                                .getSalonAvailability
                                                .data
                                                ?.thursday
                                                ?.end ??
                                            "",
                                        breaks: _homeController
                                                .getSalonAvailability
                                                .data
                                                ?.thursday
                                                ?.breaks ??
                                            []);
                              });
                            },
                            endTime: _homeController
                                    .getSalonAvailability.data?.thursday?.end ??
                                "",
                            startTime: _homeController.getSalonAvailability.data
                                    ?.thursday?.start ??
                                "",
                          ),
                          const Divider(),
                          Text(
                            "Break",
                            style: AppTextTheme.bold.copyWith(
                                fontSize: 16, color: ColorConstant.blackColor),
                          ),
                          const Divider(),
                          ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: _homeController.getSalonAvailability
                                      .data?.thursday?.breaks?.length ??
                                  0,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        final TimeOfDay? sundayStartTime =
                                            await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        );
                                        setState(() {
                                          String start =
                                              formatTimeOfDay(sundayStartTime!);

                                          _homeController.getSalonAvailability
                                                  .data?.thursday =
                                              SalonDay(
                                                  start: _homeController
                                                          .getSalonAvailability
                                                          .data
                                                          ?.thursday
                                                          ?.start ??
                                                      "",
                                                  end: _homeController
                                                          .getSalonAvailability
                                                          .data
                                                          ?.thursday
                                                          ?.end ??
                                                      "",
                                                  breaks: [
                                                SalonBreaks(
                                                    start: start,
                                                    end: _homeController
                                                            .getSalonAvailability
                                                            .data
                                                            ?.thursday
                                                            ?.breaks?[index]
                                                            .end ??
                                                        "")
                                              ]);
                                        });
                                      },
                                      child: Container(
                                        height: 40,
                                        color: Colors.transparent,
                                        child: Row(
                                          children: [
                                            Text(
                                              "Start Time : ",
                                              style: AppTextTheme.medium
                                                  .copyWith(
                                                      fontSize: 16,
                                                      color: ColorConstant
                                                          .blackColor),
                                            ),
                                            Text(
                                              _homeController
                                                          .getSalonAvailability
                                                          .data
                                                          ?.thursday
                                                          ?.breaks?[index]
                                                          .start
                                                          ?.isEmpty ??
                                                      false
                                                  ? ""
                                                  : convertTimeTo12HourFormat(
                                                      _homeController
                                                              .getSalonAvailability
                                                              .data
                                                              ?.thursday
                                                              ?.breaks?[index]
                                                              .start ??
                                                          ""),
                                              style: AppTextTheme.regular
                                                  .copyWith(
                                                      fontSize: 16,
                                                      color: ColorConstant
                                                          .grayTextColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        final TimeOfDay? sundayEndTime =
                                            await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        );

                                        setState(() {
                                          String end =
                                              formatTimeOfDay(sundayEndTime!);

                                          _homeController.getSalonAvailability
                                                  .data?.thursday =
                                              SalonDay(
                                                  start: _homeController
                                                          .getSalonAvailability
                                                          .data
                                                          ?.thursday
                                                          ?.start ??
                                                      "",
                                                  end: _homeController
                                                          .getSalonAvailability
                                                          .data
                                                          ?.thursday
                                                          ?.end ??
                                                      "",
                                                  breaks: [
                                                SalonBreaks(
                                                    start: _homeController
                                                            .getSalonAvailability
                                                            .data
                                                            ?.thursday
                                                            ?.breaks?[index]
                                                            .start ??
                                                        "",
                                                    end: end)
                                              ]);
                                        });
                                      },
                                      child: Container(
                                        height: 40,
                                        color: Colors.transparent,
                                        child: Row(
                                          children: [
                                            Text(
                                              "End Time : ",
                                              style: AppTextTheme.medium
                                                  .copyWith(
                                                      fontSize: 16,
                                                      color: ColorConstant
                                                          .blackColor),
                                            ),
                                            Text(
                                              _homeController
                                                          .getSalonAvailability
                                                          .data
                                                          ?.thursday
                                                          ?.breaks?[index]
                                                          .end
                                                          ?.isEmpty ??
                                                      false
                                                  ? ""
                                                  : convertTimeTo12HourFormat(
                                                      _homeController
                                                              .getSalonAvailability
                                                              .data
                                                              ?.thursday
                                                              ?.breaks?[index]
                                                              .end ??
                                                          ""),
                                              style: AppTextTheme.regular
                                                  .copyWith(
                                                      fontSize: 16,
                                                      color: ColorConstant
                                                          .grayTextColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        ],
                      ),
                    ),

                    /*------------ Friday -------------*/
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 5.0,
                              offset: const Offset(0.0, 3.0)),
                        ],
                        border: Border.all(color: ColorConstant.primaryColor),
                        color: ColorConstant.whiteColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SalonDayTileWidget(
                            dayTitle: 'Friday',
                            endTimeTap: () async {
                              final TimeOfDay? sundayEndTime =
                                  await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );

                              setState(() {
                                String end = formatTimeOfDay(sundayEndTime!);

                                _homeController
                                        .getSalonAvailability.data?.friday =
                                    SalonDay(
                                        start: _homeController
                                                .getSalonAvailability
                                                .data
                                                ?.friday
                                                ?.start ??
                                            "",
                                        end: end,
                                        breaks: _homeController
                                                .getSalonAvailability
                                                .data
                                                ?.friday
                                                ?.breaks ??
                                            []);
                              });
                            },
                            startTimeTap: () async {
                              final TimeOfDay? sundayStartTime =
                                  await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );

                              setState(() {
                                String start =
                                    formatTimeOfDay(sundayStartTime!);

                                _homeController
                                        .getSalonAvailability.data?.friday =
                                    SalonDay(
                                        start: start,
                                        end: _homeController
                                                .getSalonAvailability
                                                .data
                                                ?.friday
                                                ?.end ??
                                            "",
                                        breaks: _homeController
                                                .getSalonAvailability
                                                .data
                                                ?.friday
                                                ?.breaks ??
                                            []);
                              });
                            },
                            endTime: _homeController
                                    .getSalonAvailability.data?.friday?.end ??
                                "",
                            startTime: _homeController
                                    .getSalonAvailability.data?.friday?.start ??
                                "",
                          ),
                          const Divider(),
                          Text(
                            "Break",
                            style: AppTextTheme.bold.copyWith(
                                fontSize: 16, color: ColorConstant.blackColor),
                          ),
                          const Divider(),
                          ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: _homeController.getSalonAvailability
                                      .data?.friday?.breaks?.length ??
                                  0,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        final TimeOfDay? sundayStartTime =
                                            await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        );
                                        setState(() {
                                          String start =
                                              formatTimeOfDay(sundayStartTime!);

                                          _homeController.getSalonAvailability
                                                  .data?.friday =
                                              SalonDay(
                                                  start: _homeController
                                                          .getSalonAvailability
                                                          .data
                                                          ?.friday
                                                          ?.start ??
                                                      "",
                                                  end: _homeController
                                                          .getSalonAvailability
                                                          .data
                                                          ?.friday
                                                          ?.end ??
                                                      "",
                                                  breaks: [
                                                SalonBreaks(
                                                    start: start,
                                                    end: _homeController
                                                            .getSalonAvailability
                                                            .data
                                                            ?.friday
                                                            ?.breaks?[index]
                                                            .end ??
                                                        "")
                                              ]);
                                        });
                                      },
                                      child: Container(
                                        height: 40,
                                        color: Colors.transparent,
                                        child: Row(
                                          children: [
                                            Text(
                                              "Start Time : ",
                                              style: AppTextTheme.medium
                                                  .copyWith(
                                                      fontSize: 16,
                                                      color: ColorConstant
                                                          .blackColor),
                                            ),
                                            Text(
                                              _homeController
                                                          .getSalonAvailability
                                                          .data
                                                          ?.friday
                                                          ?.breaks?[index]
                                                          .start
                                                          ?.isEmpty ??
                                                      false
                                                  ? ""
                                                  : convertTimeTo12HourFormat(
                                                      _homeController
                                                              .getSalonAvailability
                                                              .data
                                                              ?.friday
                                                              ?.breaks?[index]
                                                              .start ??
                                                          ""),
                                              style: AppTextTheme.regular
                                                  .copyWith(
                                                      fontSize: 16,
                                                      color: ColorConstant
                                                          .grayTextColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        final TimeOfDay? sundayEndTime =
                                            await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        );

                                        setState(() {
                                          String end =
                                              formatTimeOfDay(sundayEndTime!);

                                          _homeController.getSalonAvailability
                                                  .data?.friday =
                                              SalonDay(
                                                  start: _homeController
                                                          .getSalonAvailability
                                                          .data
                                                          ?.friday
                                                          ?.start ??
                                                      "",
                                                  end: _homeController
                                                          .getSalonAvailability
                                                          .data
                                                          ?.friday
                                                          ?.end ??
                                                      "",
                                                  breaks: [
                                                SalonBreaks(
                                                    start: _homeController
                                                            .getSalonAvailability
                                                            .data
                                                            ?.friday
                                                            ?.breaks?[index]
                                                            .start ??
                                                        "",
                                                    end: end)
                                              ]);
                                        });
                                      },
                                      child: Container(
                                        height: 40,
                                        color: Colors.transparent,
                                        child: Row(
                                          children: [
                                            Text(
                                              "End Time : ",
                                              style: AppTextTheme.medium
                                                  .copyWith(
                                                      fontSize: 16,
                                                      color: ColorConstant
                                                          .blackColor),
                                            ),
                                            Text(
                                              _homeController
                                                          .getSalonAvailability
                                                          .data
                                                          ?.friday
                                                          ?.breaks?[index]
                                                          .end
                                                          ?.isEmpty ??
                                                      false
                                                  ? ""
                                                  : convertTimeTo12HourFormat(
                                                      _homeController
                                                              .getSalonAvailability
                                                              .data
                                                              ?.friday
                                                              ?.breaks?[index]
                                                              .end ??
                                                          ""),
                                              style: AppTextTheme.regular
                                                  .copyWith(
                                                      fontSize: 16,
                                                      color: ColorConstant
                                                          .grayTextColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        ],
                      ),
                    ),

                    /*----------- Saturday -----------*/
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 5.0,
                              offset: const Offset(0.0, 3.0)),
                        ],
                        border: Border.all(color: ColorConstant.primaryColor),
                        color: ColorConstant.whiteColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SalonDayTileWidget(
                            dayTitle: 'Saturday',
                            endTimeTap: () async {
                              final TimeOfDay? sundayEndTime =
                                  await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );

                              setState(() {
                                String end = formatTimeOfDay(sundayEndTime!);

                                _homeController
                                        .getSalonAvailability.data?.saturday =
                                    SalonDay(
                                        start: _homeController
                                                .getSalonAvailability
                                                .data
                                                ?.saturday
                                                ?.start ??
                                            "",
                                        end: end,
                                        breaks: _homeController
                                                .getSalonAvailability
                                                .data
                                                ?.saturday
                                                ?.breaks ??
                                            []);
                              });
                            },
                            startTimeTap: () async {
                              final TimeOfDay? sundayStartTime =
                                  await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );

                              setState(() {
                                String start =
                                    formatTimeOfDay(sundayStartTime!);

                                _homeController
                                        .getSalonAvailability.data?.saturday =
                                    SalonDay(
                                        start: start,
                                        end: _homeController
                                                .getSalonAvailability
                                                .data
                                                ?.saturday
                                                ?.end ??
                                            "",
                                        breaks: _homeController
                                                .getSalonAvailability
                                                .data
                                                ?.saturday
                                                ?.breaks ??
                                            []);
                              });
                            },
                            endTime: _homeController
                                    .getSalonAvailability.data?.saturday?.end ??
                                "",
                            startTime: _homeController.getSalonAvailability.data
                                    ?.saturday?.start ??
                                "",
                          ),
                          const Divider(),
                          Text(
                            "Break",
                            style: AppTextTheme.bold.copyWith(
                                fontSize: 16, color: ColorConstant.blackColor),
                          ),
                          const Divider(),
                          ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: _homeController.getSalonAvailability
                                      .data?.saturday?.breaks?.length ??
                                  0,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        final TimeOfDay? sundayStartTime =
                                            await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        );
                                        setState(() {
                                          String start =
                                              formatTimeOfDay(sundayStartTime!);

                                          _homeController.getSalonAvailability
                                                  .data?.saturday =
                                              SalonDay(
                                                  start: _homeController
                                                          .getSalonAvailability
                                                          .data
                                                          ?.saturday
                                                          ?.start ??
                                                      "",
                                                  end: _homeController
                                                          .getSalonAvailability
                                                          .data
                                                          ?.saturday
                                                          ?.end ??
                                                      "",
                                                  breaks: [
                                                SalonBreaks(
                                                    start: start,
                                                    end: _homeController
                                                            .getSalonAvailability
                                                            .data
                                                            ?.saturday
                                                            ?.breaks?[index]
                                                            .end ??
                                                        "")
                                              ]);
                                        });
                                      },
                                      child: Container(
                                        height: 40,
                                        color: Colors.transparent,
                                        child: Row(
                                          children: [
                                            Text(
                                              "Start Time : ",
                                              style: AppTextTheme.medium
                                                  .copyWith(
                                                      fontSize: 16,
                                                      color: ColorConstant
                                                          .blackColor),
                                            ),
                                            Text(
                                              _homeController
                                                          .getSalonAvailability
                                                          .data
                                                          ?.saturday
                                                          ?.breaks?[index]
                                                          .start
                                                          ?.isEmpty ??
                                                      false
                                                  ? ""
                                                  : convertTimeTo12HourFormat(
                                                      _homeController
                                                              .getSalonAvailability
                                                              .data
                                                              ?.saturday
                                                              ?.breaks?[index]
                                                              .start ??
                                                          ""),
                                              style: AppTextTheme.regular
                                                  .copyWith(
                                                      fontSize: 16,
                                                      color: ColorConstant
                                                          .grayTextColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        final TimeOfDay? sundayEndTime =
                                            await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        );

                                        setState(() {
                                          String end =
                                              formatTimeOfDay(sundayEndTime!);

                                          _homeController.getSalonAvailability
                                                  .data?.saturday =
                                              SalonDay(
                                                  start: _homeController
                                                          .getSalonAvailability
                                                          .data
                                                          ?.saturday
                                                          ?.start ??
                                                      "",
                                                  end: _homeController
                                                          .getSalonAvailability
                                                          .data
                                                          ?.saturday
                                                          ?.end ??
                                                      "",
                                                  breaks: [
                                                SalonBreaks(
                                                    start: _homeController
                                                            .getSalonAvailability
                                                            .data
                                                            ?.saturday
                                                            ?.breaks?[index]
                                                            .start ??
                                                        "",
                                                    end: end)
                                              ]);
                                        });
                                      },
                                      child: Container(
                                        height: 40,
                                        color: Colors.transparent,
                                        child: Row(
                                          children: [
                                            Text(
                                              "End Time : ",
                                              style: AppTextTheme.medium
                                                  .copyWith(
                                                      fontSize: 16,
                                                      color: ColorConstant
                                                          .blackColor),
                                            ),
                                            Text(
                                              _homeController
                                                          .getSalonAvailability
                                                          .data
                                                          ?.saturday
                                                          ?.breaks?[index]
                                                          .end
                                                          ?.isEmpty ??
                                                      false
                                                  ? ""
                                                  : convertTimeTo12HourFormat(
                                                      _homeController
                                                              .getSalonAvailability
                                                              .data
                                                              ?.saturday
                                                              ?.breaks?[index]
                                                              .end ??
                                                          ""),
                                              style: AppTextTheme.regular
                                                  .copyWith(
                                                      fontSize: 16,
                                                      color: ColorConstant
                                                          .grayTextColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
      ),
    );
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

  String formatTimeOfDay(TimeOfDay time) {
    final int hour = time.hour;
    final int minute = time.minute;
    final String formattedHour = hour.toString().padLeft(2, '0');
    final String formattedMinute = minute.toString().padLeft(2, '0');
    return '$formattedHour:$formattedMinute';
  }
}
