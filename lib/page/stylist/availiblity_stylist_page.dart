import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/model/availability/artiest_availability_get_model.dart';
import 'package:salon/model/availability/working_plan_model.dart';
import 'package:salon/page/stylist/widget/day_tile_widget.dart';
import 'package:salon/project_specific/button_widget.dart';
import 'package:salon/project_specific/progressbar_view.dart';
import 'package:salon/project_specific/project_appbar.dart';

import '../../project_specific/text_theme.dart';
import 'block_slot_page.dart';

class AvailabilitySheetPage extends StatefulWidget {
  final String artiestId;
  const AvailabilitySheetPage({super.key, required this.artiestId});

  @override
  State<AvailabilitySheetPage> createState() => _AvailiblitySheetPageState();
}

class _AvailiblitySheetPageState extends State<AvailabilitySheetPage> {
  final _homeController = Get.find<HomeController>();

  late WorkingPlanModel workingPlanModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _homeController.doGetArtiestAvailability(artistId: widget.artiestId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      appBar: AppBarWidget(
        nameOfScreen: "Available",
        isBackIcon: true,
        rightWidget: GestureDetector(
          onTap: () async {
            print("Block Slot clicked");
            final result = await Get.to(() => BlockSlotPage(
              artistId: widget.artiestId,
            ));
            print(result);

            if (result == true) {
              // 🔄 RELOAD availability
              _homeController.doGetArtiestAvailability(artistId: widget.artiestId);
            }
            },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              "Block Slot",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => Expanded(
              child: _homeController.showProgress
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
                              border:
                                  Border.all(color: ColorConstant.primaryColor),
                              color: ColorConstant.whiteColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DayTileWidget(
                                  dayTitle: 'Sunday',
                                  endTimeTap: () async {
                                    final TimeOfDay? sundayEndTime =
                                        await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );

                                    setState(() {
                                      String end =
                                          formatTimeOfDay(sundayEndTime!);

                                      _homeController
                                              .getArtiestAvailabilityGetModel
                                              .data
                                              ?.sunday =
                                          DayData(
                                              start: _homeController
                                                      .getArtiestAvailabilityGetModel
                                                      .data
                                                      ?.sunday
                                                      ?.start ??
                                                  "",
                                              end: end,
                                              breaks: _homeController
                                                      .getArtiestAvailabilityGetModel
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
                                              .getArtiestAvailabilityGetModel
                                              .data
                                              ?.sunday =
                                          DayData(
                                              start: start,
                                              end: _homeController
                                                      .getArtiestAvailabilityGetModel
                                                      .data
                                                      ?.sunday
                                                      ?.end ??
                                                  "",
                                              breaks: _homeController
                                                      .getArtiestAvailabilityGetModel
                                                      .data
                                                      ?.sunday
                                                      ?.breaks ??
                                                  []);
                                    });
                                  },
                                  endTime: _homeController
                                          .getArtiestAvailabilityGetModel
                                          .data
                                          ?.sunday
                                          ?.end ??
                                      "",
                                  startTime: _homeController
                                          .getArtiestAvailabilityGetModel
                                          .data
                                          ?.sunday
                                          ?.start ??
                                      "",
                                ),
                                const Divider(),
                                Text(
                                  "Break",
                                  style: AppTextTheme.bold.copyWith(
                                      fontSize: 16,
                                      color: ColorConstant.blackColor),
                                ),
                                const Divider(),
                                ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: _homeController
                                            .getArtiestAvailabilityGetModel
                                            .data
                                            ?.sunday
                                            ?.breaks
                                            ?.length ??
                                        0,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
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
                                                String start = formatTimeOfDay(
                                                    sundayStartTime!);

                                                _homeController
                                                        .getArtiestAvailabilityGetModel
                                                        .data
                                                        ?.sunday =
                                                    DayData(
                                                        start: _homeController
                                                                .getArtiestAvailabilityGetModel
                                                                .data
                                                                ?.sunday
                                                                ?.start ??
                                                            "",
                                                        end: _homeController
                                                                .getArtiestAvailabilityGetModel
                                                                .data
                                                                ?.sunday
                                                                ?.end ??
                                                            "",
                                                        breaks: [
                                                      Breaks(
                                                          start: start,
                                                          end: _homeController
                                                                  .getArtiestAvailabilityGetModel
                                                                  .data
                                                                  ?.sunday
                                                                  ?.breaks?[
                                                                      index]
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
                                                                .getArtiestAvailabilityGetModel
                                                                .data
                                                                ?.sunday
                                                                ?.breaks?[index]
                                                                .start
                                                                ?.isEmpty ??
                                                            false
                                                        ? ""
                                                        : convertTimeTo12HourFormat(
                                                            _homeController
                                                                    .getArtiestAvailabilityGetModel
                                                                    .data
                                                                    ?.sunday
                                                                    ?.breaks?[
                                                                        index]
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
                                                String end = formatTimeOfDay(
                                                    sundayEndTime!);

                                                _homeController
                                                        .getArtiestAvailabilityGetModel
                                                        .data
                                                        ?.sunday =
                                                    DayData(
                                                        start: _homeController
                                                                .getArtiestAvailabilityGetModel
                                                                .data
                                                                ?.sunday
                                                                ?.start ??
                                                            "",
                                                        end: _homeController
                                                                .getArtiestAvailabilityGetModel
                                                                .data
                                                                ?.sunday
                                                                ?.end ??
                                                            "",
                                                        breaks: [
                                                      Breaks(
                                                          start: _homeController
                                                                  .getArtiestAvailabilityGetModel
                                                                  .data
                                                                  ?.sunday
                                                                  ?.breaks?[
                                                                      index]
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
                                                                .getArtiestAvailabilityGetModel
                                                                .data
                                                                ?.sunday
                                                                ?.breaks?[index]
                                                                .end
                                                                ?.isEmpty ??
                                                            false
                                                        ? ""
                                                        : convertTimeTo12HourFormat(
                                                            _homeController
                                                                    .getArtiestAvailabilityGetModel
                                                                    .data
                                                                    ?.sunday
                                                                    ?.breaks?[
                                                                        index]
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
                              border:
                                  Border.all(color: ColorConstant.primaryColor),
                              color: ColorConstant.whiteColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DayTileWidget(
                                  endTimeTap: () async {
                                    final TimeOfDay? sundayEndTime =
                                        await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );

                                    setState(() {
                                      String end =
                                          formatTimeOfDay(sundayEndTime!);

                                      _homeController
                                              .getArtiestAvailabilityGetModel
                                              .data
                                              ?.monday =
                                          DayData(
                                              start: _homeController
                                                      .getArtiestAvailabilityGetModel
                                                      .data
                                                      ?.monday
                                                      ?.start ??
                                                  "",
                                              end: end,
                                              breaks: _homeController
                                                      .getArtiestAvailabilityGetModel
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
                                              .getArtiestAvailabilityGetModel
                                              .data
                                              ?.monday =
                                          DayData(
                                              start: start,
                                              end: _homeController
                                                      .getArtiestAvailabilityGetModel
                                                      .data
                                                      ?.monday
                                                      ?.end ??
                                                  "",
                                              breaks: _homeController
                                                      .getArtiestAvailabilityGetModel
                                                      .data
                                                      ?.monday
                                                      ?.breaks ??
                                                  []);
                                    });
                                  },
                                  dayTitle: 'Monday',
                                  endTime: _homeController
                                          .getArtiestAvailabilityGetModel
                                          .data
                                          ?.monday
                                          ?.end ??
                                      "",
                                  startTime: _homeController
                                          .getArtiestAvailabilityGetModel
                                          .data
                                          ?.monday
                                          ?.start ??
                                      "",
                                ),
                                const Divider(),
                                Text(
                                  "Break",
                                  style: AppTextTheme.bold.copyWith(
                                      fontSize: 16,
                                      color: ColorConstant.blackColor),
                                ),
                                const Divider(),
                                ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: _homeController
                                            .getArtiestAvailabilityGetModel
                                            .data
                                            ?.monday
                                            ?.breaks
                                            ?.length ??
                                        0,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
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
                                                String start = formatTimeOfDay(
                                                    sundayStartTime!);

                                                _homeController
                                                        .getArtiestAvailabilityGetModel
                                                        .data
                                                        ?.monday =
                                                    DayData(
                                                        start: _homeController
                                                                .getArtiestAvailabilityGetModel
                                                                .data
                                                                ?.monday
                                                                ?.start ??
                                                            "",
                                                        end: _homeController
                                                                .getArtiestAvailabilityGetModel
                                                                .data
                                                                ?.monday
                                                                ?.end ??
                                                            "",
                                                        breaks: [
                                                      Breaks(
                                                          start: start,
                                                          end: _homeController
                                                                  .getArtiestAvailabilityGetModel
                                                                  .data
                                                                  ?.monday
                                                                  ?.breaks?[
                                                                      index]
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
                                                                .getArtiestAvailabilityGetModel
                                                                .data
                                                                ?.monday
                                                                ?.breaks?[index]
                                                                .start
                                                                ?.isEmpty ??
                                                            false
                                                        ? ""
                                                        : convertTimeTo12HourFormat(
                                                            _homeController
                                                                    .getArtiestAvailabilityGetModel
                                                                    .data
                                                                    ?.monday
                                                                    ?.breaks?[
                                                                        index]
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
                                                String end = formatTimeOfDay(
                                                    sundayEndTime!);

                                                _homeController
                                                        .getArtiestAvailabilityGetModel
                                                        .data
                                                        ?.monday =
                                                    DayData(
                                                        start: _homeController
                                                                .getArtiestAvailabilityGetModel
                                                                .data
                                                                ?.monday
                                                                ?.start ??
                                                            "",
                                                        end: _homeController
                                                                .getArtiestAvailabilityGetModel
                                                                .data
                                                                ?.monday
                                                                ?.end ??
                                                            "",
                                                        breaks: [
                                                      Breaks(
                                                          start: _homeController
                                                                  .getArtiestAvailabilityGetModel
                                                                  .data
                                                                  ?.monday
                                                                  ?.breaks?[
                                                                      index]
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
                                                                .getArtiestAvailabilityGetModel
                                                                .data
                                                                ?.monday
                                                                ?.breaks?[index]
                                                                .end
                                                                ?.isEmpty ??
                                                            false
                                                        ? ""
                                                        : convertTimeTo12HourFormat(
                                                            _homeController
                                                                    .getArtiestAvailabilityGetModel
                                                                    .data
                                                                    ?.monday
                                                                    ?.breaks?[
                                                                        index]
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
                              border:
                                  Border.all(color: ColorConstant.primaryColor),
                              color: ColorConstant.whiteColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DayTileWidget(
                                  endTimeTap: () async {
                                    final TimeOfDay? sundayEndTime =
                                        await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );

                                    setState(() {
                                      String end =
                                          formatTimeOfDay(sundayEndTime!);

                                      _homeController
                                              .getArtiestAvailabilityGetModel
                                              .data
                                              ?.tuesday =
                                          DayData(
                                              start: _homeController
                                                      .getArtiestAvailabilityGetModel
                                                      .data
                                                      ?.tuesday
                                                      ?.start ??
                                                  "",
                                              end: end,
                                              breaks: _homeController
                                                      .getArtiestAvailabilityGetModel
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
                                              .getArtiestAvailabilityGetModel
                                              .data
                                              ?.tuesday =
                                          DayData(
                                              start: start,
                                              end: _homeController
                                                      .getArtiestAvailabilityGetModel
                                                      .data
                                                      ?.tuesday
                                                      ?.end ??
                                                  "",
                                              breaks: _homeController
                                                      .getArtiestAvailabilityGetModel
                                                      .data
                                                      ?.tuesday
                                                      ?.breaks ??
                                                  []);
                                    });
                                  },
                                  dayTitle: 'Tuesday',
                                  endTime: _homeController
                                          .getArtiestAvailabilityGetModel
                                          .data
                                          ?.tuesday
                                          ?.end ??
                                      "",
                                  startTime: _homeController
                                          .getArtiestAvailabilityGetModel
                                          .data
                                          ?.tuesday
                                          ?.start ??
                                      "",
                                ),
                                const Divider(),
                                Text(
                                  "Break",
                                  style: AppTextTheme.bold.copyWith(
                                      fontSize: 16,
                                      color: ColorConstant.blackColor),
                                ),
                                const Divider(),
                                ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: _homeController
                                            .getArtiestAvailabilityGetModel
                                            .data
                                            ?.tuesday
                                            ?.breaks
                                            ?.length ??
                                        0,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
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
                                                String start = formatTimeOfDay(
                                                    sundayStartTime!);

                                                _homeController
                                                        .getArtiestAvailabilityGetModel
                                                        .data
                                                        ?.tuesday =
                                                    DayData(
                                                        start: _homeController
                                                                .getArtiestAvailabilityGetModel
                                                                .data
                                                                ?.tuesday
                                                                ?.start ??
                                                            "",
                                                        end: _homeController
                                                                .getArtiestAvailabilityGetModel
                                                                .data
                                                                ?.tuesday
                                                                ?.end ??
                                                            "",
                                                        breaks: [
                                                      Breaks(
                                                          start: start,
                                                          end: _homeController
                                                                  .getArtiestAvailabilityGetModel
                                                                  .data
                                                                  ?.tuesday
                                                                  ?.breaks?[
                                                                      index]
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
                                                                .getArtiestAvailabilityGetModel
                                                                .data
                                                                ?.tuesday
                                                                ?.breaks?[index]
                                                                .start
                                                                ?.isEmpty ??
                                                            false
                                                        ? ""
                                                        : convertTimeTo12HourFormat(
                                                            _homeController
                                                                    .getArtiestAvailabilityGetModel
                                                                    .data
                                                                    ?.tuesday
                                                                    ?.breaks?[
                                                                        index]
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
                                                String end = formatTimeOfDay(
                                                    sundayEndTime!);

                                                _homeController
                                                        .getArtiestAvailabilityGetModel
                                                        .data
                                                        ?.tuesday =
                                                    DayData(
                                                        start: _homeController
                                                                .getArtiestAvailabilityGetModel
                                                                .data
                                                                ?.tuesday
                                                                ?.start ??
                                                            "",
                                                        end: _homeController
                                                                .getArtiestAvailabilityGetModel
                                                                .data
                                                                ?.tuesday
                                                                ?.end ??
                                                            "",
                                                        breaks: [
                                                      Breaks(
                                                          start: _homeController
                                                                  .getArtiestAvailabilityGetModel
                                                                  .data
                                                                  ?.tuesday
                                                                  ?.breaks?[
                                                                      index]
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
                                                                .getArtiestAvailabilityGetModel
                                                                .data
                                                                ?.tuesday
                                                                ?.breaks?[index]
                                                                .end
                                                                ?.isEmpty ??
                                                            false
                                                        ? ""
                                                        : convertTimeTo12HourFormat(
                                                            _homeController
                                                                    .getArtiestAvailabilityGetModel
                                                                    .data
                                                                    ?.tuesday
                                                                    ?.breaks?[
                                                                        index]
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
                              border:
                                  Border.all(color: ColorConstant.primaryColor),
                              color: ColorConstant.whiteColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DayTileWidget(
                                  endTimeTap: () async {
                                    final TimeOfDay? sundayEndTime =
                                        await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );

                                    setState(() {
                                      String end =
                                          formatTimeOfDay(sundayEndTime!);

                                      _homeController
                                              .getArtiestAvailabilityGetModel
                                              .data
                                              ?.wednesday =
                                          DayData(
                                              start: _homeController
                                                      .getArtiestAvailabilityGetModel
                                                      .data
                                                      ?.wednesday
                                                      ?.start ??
                                                  "",
                                              end: end,
                                              breaks: _homeController
                                                      .getArtiestAvailabilityGetModel
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
                                              .getArtiestAvailabilityGetModel
                                              .data
                                              ?.wednesday =
                                          DayData(
                                              start: start,
                                              end: _homeController
                                                      .getArtiestAvailabilityGetModel
                                                      .data
                                                      ?.wednesday
                                                      ?.end ??
                                                  "",
                                              breaks: _homeController
                                                      .getArtiestAvailabilityGetModel
                                                      .data
                                                      ?.wednesday
                                                      ?.breaks ??
                                                  []);
                                    });
                                  },
                                  dayTitle: 'Wednesday',
                                  endTime: _homeController
                                          .getArtiestAvailabilityGetModel
                                          .data
                                          ?.wednesday
                                          ?.end ??
                                      "",
                                  startTime: _homeController
                                          .getArtiestAvailabilityGetModel
                                          .data
                                          ?.wednesday
                                          ?.start ??
                                      "",
                                ),
                                const Divider(),
                                Text(
                                  "Break",
                                  style: AppTextTheme.bold.copyWith(
                                      fontSize: 16,
                                      color: ColorConstant.blackColor),
                                ),
                                const Divider(),
                                ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: _homeController
                                            .getArtiestAvailabilityGetModel
                                            .data
                                            ?.wednesday
                                            ?.breaks
                                            ?.length ??
                                        0,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
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
                                                String start = formatTimeOfDay(
                                                    sundayStartTime!);

                                                _homeController
                                                        .getArtiestAvailabilityGetModel
                                                        .data
                                                        ?.wednesday =
                                                    DayData(
                                                        start: _homeController
                                                                .getArtiestAvailabilityGetModel
                                                                .data
                                                                ?.wednesday
                                                                ?.start ??
                                                            "",
                                                        end: _homeController
                                                                .getArtiestAvailabilityGetModel
                                                                .data
                                                                ?.wednesday
                                                                ?.end ??
                                                            "",
                                                        breaks: [
                                                      Breaks(
                                                          start: start,
                                                          end: _homeController
                                                                  .getArtiestAvailabilityGetModel
                                                                  .data
                                                                  ?.wednesday
                                                                  ?.breaks?[
                                                                      index]
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
                                                                .getArtiestAvailabilityGetModel
                                                                .data
                                                                ?.wednesday
                                                                ?.breaks?[index]
                                                                .start
                                                                ?.isEmpty ??
                                                            false
                                                        ? ""
                                                        : convertTimeTo12HourFormat(
                                                            _homeController
                                                                    .getArtiestAvailabilityGetModel
                                                                    .data
                                                                    ?.wednesday
                                                                    ?.breaks?[
                                                                        index]
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
                                                String end = formatTimeOfDay(
                                                    sundayEndTime!);

                                                _homeController
                                                        .getArtiestAvailabilityGetModel
                                                        .data
                                                        ?.wednesday =
                                                    DayData(
                                                        start: _homeController
                                                                .getArtiestAvailabilityGetModel
                                                                .data
                                                                ?.wednesday
                                                                ?.start ??
                                                            "",
                                                        end: _homeController
                                                                .getArtiestAvailabilityGetModel
                                                                .data
                                                                ?.wednesday
                                                                ?.end ??
                                                            "",
                                                        breaks: [
                                                      Breaks(
                                                          start: _homeController
                                                                  .getArtiestAvailabilityGetModel
                                                                  .data
                                                                  ?.wednesday
                                                                  ?.breaks?[
                                                                      index]
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
                                                                .getArtiestAvailabilityGetModel
                                                                .data
                                                                ?.wednesday
                                                                ?.breaks?[index]
                                                                .end
                                                                ?.isEmpty ??
                                                            false
                                                        ? ""
                                                        : convertTimeTo12HourFormat(
                                                            _homeController
                                                                    .getArtiestAvailabilityGetModel
                                                                    .data
                                                                    ?.wednesday
                                                                    ?.breaks?[
                                                                        index]
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
                              border:
                                  Border.all(color: ColorConstant.primaryColor),
                              color: ColorConstant.whiteColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DayTileWidget(
                                  dayTitle: 'Thursday',
                                  endTimeTap: () async {
                                    final TimeOfDay? sundayEndTime =
                                        await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );

                                    setState(() {
                                      String end =
                                          formatTimeOfDay(sundayEndTime!);

                                      _homeController
                                              .getArtiestAvailabilityGetModel
                                              .data
                                              ?.thursday =
                                          DayData(
                                              start: _homeController
                                                      .getArtiestAvailabilityGetModel
                                                      .data
                                                      ?.thursday
                                                      ?.start ??
                                                  "",
                                              end: end,
                                              breaks: _homeController
                                                      .getArtiestAvailabilityGetModel
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
                                              .getArtiestAvailabilityGetModel
                                              .data
                                              ?.thursday =
                                          DayData(
                                              start: start,
                                              end: _homeController
                                                      .getArtiestAvailabilityGetModel
                                                      .data
                                                      ?.thursday
                                                      ?.end ??
                                                  "",
                                              breaks: _homeController
                                                      .getArtiestAvailabilityGetModel
                                                      .data
                                                      ?.thursday
                                                      ?.breaks ??
                                                  []);
                                    });
                                  },
                                  endTime: _homeController
                                          .getArtiestAvailabilityGetModel
                                          .data
                                          ?.thursday
                                          ?.end ??
                                      "",
                                  startTime: _homeController
                                          .getArtiestAvailabilityGetModel
                                          .data
                                          ?.thursday
                                          ?.start ??
                                      "",
                                ),
                                const Divider(),
                                Text(
                                  "Break",
                                  style: AppTextTheme.bold.copyWith(
                                      fontSize: 16,
                                      color: ColorConstant.blackColor),
                                ),
                                const Divider(),
                                ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: _homeController
                                            .getArtiestAvailabilityGetModel
                                            .data
                                            ?.thursday
                                            ?.breaks
                                            ?.length ??
                                        0,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
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
                                                String start = formatTimeOfDay(
                                                    sundayStartTime!);

                                                _homeController
                                                        .getArtiestAvailabilityGetModel
                                                        .data
                                                        ?.thursday =
                                                    DayData(
                                                        start: _homeController
                                                                .getArtiestAvailabilityGetModel
                                                                .data
                                                                ?.thursday
                                                                ?.start ??
                                                            "",
                                                        end: _homeController
                                                                .getArtiestAvailabilityGetModel
                                                                .data
                                                                ?.thursday
                                                                ?.end ??
                                                            "",
                                                        breaks: [
                                                      Breaks(
                                                          start: start,
                                                          end: _homeController
                                                                  .getArtiestAvailabilityGetModel
                                                                  .data
                                                                  ?.thursday
                                                                  ?.breaks?[
                                                                      index]
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
                                                                .getArtiestAvailabilityGetModel
                                                                .data
                                                                ?.thursday
                                                                ?.breaks?[index]
                                                                .start
                                                                ?.isEmpty ??
                                                            false
                                                        ? ""
                                                        : convertTimeTo12HourFormat(
                                                            _homeController
                                                                    .getArtiestAvailabilityGetModel
                                                                    .data
                                                                    ?.thursday
                                                                    ?.breaks?[
                                                                        index]
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
                                                String end = formatTimeOfDay(
                                                    sundayEndTime!);

                                                _homeController
                                                        .getArtiestAvailabilityGetModel
                                                        .data
                                                        ?.thursday =
                                                    DayData(
                                                        start: _homeController
                                                                .getArtiestAvailabilityGetModel
                                                                .data
                                                                ?.thursday
                                                                ?.start ??
                                                            "",
                                                        end: _homeController
                                                                .getArtiestAvailabilityGetModel
                                                                .data
                                                                ?.thursday
                                                                ?.end ??
                                                            "",
                                                        breaks: [
                                                      Breaks(
                                                          start: _homeController
                                                                  .getArtiestAvailabilityGetModel
                                                                  .data
                                                                  ?.thursday
                                                                  ?.breaks?[
                                                                      index]
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
                                                                .getArtiestAvailabilityGetModel
                                                                .data
                                                                ?.thursday
                                                                ?.breaks?[index]
                                                                .end
                                                                ?.isEmpty ??
                                                            false
                                                        ? ""
                                                        : convertTimeTo12HourFormat(
                                                            _homeController
                                                                    .getArtiestAvailabilityGetModel
                                                                    .data
                                                                    ?.thursday
                                                                    ?.breaks?[
                                                                        index]
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
                              border:
                                  Border.all(color: ColorConstant.primaryColor),
                              color: ColorConstant.whiteColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DayTileWidget(
                                  dayTitle: 'Friday',
                                  endTimeTap: () async {
                                    final TimeOfDay? sundayEndTime =
                                        await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );

                                    setState(() {
                                      String end =
                                          formatTimeOfDay(sundayEndTime!);

                                      _homeController
                                              .getArtiestAvailabilityGetModel
                                              .data
                                              ?.friday =
                                          DayData(
                                              start: _homeController
                                                      .getArtiestAvailabilityGetModel
                                                      .data
                                                      ?.friday
                                                      ?.start ??
                                                  "",
                                              end: end,
                                              breaks: _homeController
                                                      .getArtiestAvailabilityGetModel
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
                                              .getArtiestAvailabilityGetModel
                                              .data
                                              ?.friday =
                                          DayData(
                                              start: start,
                                              end: _homeController
                                                      .getArtiestAvailabilityGetModel
                                                      .data
                                                      ?.friday
                                                      ?.end ??
                                                  "",
                                              breaks: _homeController
                                                      .getArtiestAvailabilityGetModel
                                                      .data
                                                      ?.friday
                                                      ?.breaks ??
                                                  []);
                                    });
                                  },
                                  endTime: _homeController
                                          .getArtiestAvailabilityGetModel
                                          .data
                                          ?.friday
                                          ?.end ??
                                      "",
                                  startTime: _homeController
                                          .getArtiestAvailabilityGetModel
                                          .data
                                          ?.friday
                                          ?.start ??
                                      "",
                                ),
                                const Divider(),
                                Text(
                                  "Break",
                                  style: AppTextTheme.bold.copyWith(
                                      fontSize: 16,
                                      color: ColorConstant.blackColor),
                                ),
                                const Divider(),
                                ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: _homeController
                                            .getArtiestAvailabilityGetModel
                                            .data
                                            ?.friday
                                            ?.breaks
                                            ?.length ??
                                        0,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
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
                                                String start = formatTimeOfDay(
                                                    sundayStartTime!);

                                                _homeController
                                                        .getArtiestAvailabilityGetModel
                                                        .data
                                                        ?.friday =
                                                    DayData(
                                                        start: _homeController
                                                                .getArtiestAvailabilityGetModel
                                                                .data
                                                                ?.friday
                                                                ?.start ??
                                                            "",
                                                        end: _homeController
                                                                .getArtiestAvailabilityGetModel
                                                                .data
                                                                ?.friday
                                                                ?.end ??
                                                            "",
                                                        breaks: [
                                                      Breaks(
                                                          start: start,
                                                          end: _homeController
                                                                  .getArtiestAvailabilityGetModel
                                                                  .data
                                                                  ?.friday
                                                                  ?.breaks?[
                                                                      index]
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
                                                                .getArtiestAvailabilityGetModel
                                                                .data
                                                                ?.friday
                                                                ?.breaks?[index]
                                                                .start
                                                                ?.isEmpty ??
                                                            false
                                                        ? ""
                                                        : convertTimeTo12HourFormat(
                                                            _homeController
                                                                    .getArtiestAvailabilityGetModel
                                                                    .data
                                                                    ?.friday
                                                                    ?.breaks?[
                                                                        index]
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
                                                String end = formatTimeOfDay(
                                                    sundayEndTime!);

                                                _homeController
                                                        .getArtiestAvailabilityGetModel
                                                        .data
                                                        ?.friday =
                                                    DayData(
                                                        start: _homeController
                                                                .getArtiestAvailabilityGetModel
                                                                .data
                                                                ?.friday
                                                                ?.start ??
                                                            "",
                                                        end: _homeController
                                                                .getArtiestAvailabilityGetModel
                                                                .data
                                                                ?.friday
                                                                ?.end ??
                                                            "",
                                                        breaks: [
                                                      Breaks(
                                                          start: _homeController
                                                                  .getArtiestAvailabilityGetModel
                                                                  .data
                                                                  ?.friday
                                                                  ?.breaks?[
                                                                      index]
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
                                                                .getArtiestAvailabilityGetModel
                                                                .data
                                                                ?.friday
                                                                ?.breaks?[index]
                                                                .end
                                                                ?.isEmpty ??
                                                            false
                                                        ? ""
                                                        : convertTimeTo12HourFormat(
                                                            _homeController
                                                                    .getArtiestAvailabilityGetModel
                                                                    .data
                                                                    ?.friday
                                                                    ?.breaks?[
                                                                        index]
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
                              border:
                                  Border.all(color: ColorConstant.primaryColor),
                              color: ColorConstant.whiteColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DayTileWidget(
                                  dayTitle: 'Saturday',
                                  endTimeTap: () async {
                                    final TimeOfDay? sundayEndTime =
                                        await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );

                                    setState(() {
                                      String end =
                                          formatTimeOfDay(sundayEndTime!);

                                      _homeController
                                              .getArtiestAvailabilityGetModel
                                              .data
                                              ?.saturday =
                                          DayData(
                                              start: _homeController
                                                      .getArtiestAvailabilityGetModel
                                                      .data
                                                      ?.saturday
                                                      ?.start ??
                                                  "",
                                              end: end,
                                              breaks: _homeController
                                                      .getArtiestAvailabilityGetModel
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
                                              .getArtiestAvailabilityGetModel
                                              .data
                                              ?.saturday =
                                          DayData(
                                              start: start,
                                              end: _homeController
                                                      .getArtiestAvailabilityGetModel
                                                      .data
                                                      ?.saturday
                                                      ?.end ??
                                                  "",
                                              breaks: _homeController
                                                      .getArtiestAvailabilityGetModel
                                                      .data
                                                      ?.saturday
                                                      ?.breaks ??
                                                  []);
                                    });
                                  },
                                  endTime: _homeController
                                          .getArtiestAvailabilityGetModel
                                          .data
                                          ?.saturday
                                          ?.end ??
                                      "",
                                  startTime: _homeController
                                          .getArtiestAvailabilityGetModel
                                          .data
                                          ?.saturday
                                          ?.start ??
                                      "",
                                ),
                                const Divider(),
                                Text(
                                  "Break",
                                  style: AppTextTheme.bold.copyWith(
                                      fontSize: 16,
                                      color: ColorConstant.blackColor),
                                ),
                                const Divider(),
                                ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: _homeController
                                            .getArtiestAvailabilityGetModel
                                            .data
                                            ?.saturday
                                            ?.breaks
                                            ?.length ??
                                        0,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
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
                                                String start = formatTimeOfDay(
                                                    sundayStartTime!);

                                                _homeController
                                                        .getArtiestAvailabilityGetModel
                                                        .data
                                                        ?.saturday =
                                                    DayData(
                                                        start: _homeController
                                                                .getArtiestAvailabilityGetModel
                                                                .data
                                                                ?.saturday
                                                                ?.start ??
                                                            "",
                                                        end: _homeController
                                                                .getArtiestAvailabilityGetModel
                                                                .data
                                                                ?.saturday
                                                                ?.end ??
                                                            "",
                                                        breaks: [
                                                      Breaks(
                                                          start: start,
                                                          end: _homeController
                                                                  .getArtiestAvailabilityGetModel
                                                                  .data
                                                                  ?.saturday
                                                                  ?.breaks?[
                                                                      index]
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
                                                                .getArtiestAvailabilityGetModel
                                                                .data
                                                                ?.saturday
                                                                ?.breaks?[index]
                                                                .start
                                                                ?.isEmpty ??
                                                            false
                                                        ? ""
                                                        : convertTimeTo12HourFormat(
                                                            _homeController
                                                                    .getArtiestAvailabilityGetModel
                                                                    .data
                                                                    ?.saturday
                                                                    ?.breaks?[
                                                                        index]
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
                                                String end = formatTimeOfDay(
                                                    sundayEndTime!);

                                                _homeController
                                                        .getArtiestAvailabilityGetModel
                                                        .data
                                                        ?.saturday =
                                                    DayData(
                                                        start: _homeController
                                                                .getArtiestAvailabilityGetModel
                                                                .data
                                                                ?.saturday
                                                                ?.start ??
                                                            "",
                                                        end: _homeController
                                                                .getArtiestAvailabilityGetModel
                                                                .data
                                                                ?.saturday
                                                                ?.end ??
                                                            "",
                                                        breaks: [
                                                      Breaks(
                                                          start: _homeController
                                                                  .getArtiestAvailabilityGetModel
                                                                  .data
                                                                  ?.saturday
                                                                  ?.breaks?[
                                                                      index]
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
                                                                .getArtiestAvailabilityGetModel
                                                                .data
                                                                ?.saturday
                                                                ?.breaks?[index]
                                                                .end
                                                                ?.isEmpty ??
                                                            false
                                                        ? ""
                                                        : convertTimeTo12HourFormat(
                                                            _homeController
                                                                    .getArtiestAvailabilityGetModel
                                                                    .data
                                                                    ?.saturday
                                                                    ?.breaks?[
                                                                        index]
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
                        ],
                      ),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ButtonWidget(
                buttonTitleText: "Save",
                onPress: () {
                  workingPlanModel = WorkingPlanModel(
                    workingPlan: Availability(
                      sunday: _homeController.getArtiestAvailabilityGetModel
                                          .data?.sunday?.start ==
                                      null &&
                                  _homeController.getArtiestAvailabilityGetModel
                                          .data?.sunday?.end ==
                                      null ||
                              _homeController.getArtiestAvailabilityGetModel
                                      .data?.sunday?.isSwitchOn ==
                                  false
                          ? null
                          : DayData(
                              start: _homeController
                                  .getArtiestAvailabilityGetModel
                                  .data
                                  ?.sunday
                                  ?.start,
                              end: _homeController
                                  .getArtiestAvailabilityGetModel
                                  .data
                                  ?.sunday
                                  ?.end,
                              breaks: _homeController
                                  .getArtiestAvailabilityGetModel
                                  .data
                                  ?.sunday
                                  ?.breaks),
                      monday: _homeController.getArtiestAvailabilityGetModel
                                          .data?.monday?.start ==
                                      null &&
                                  _homeController.getArtiestAvailabilityGetModel
                                          .data?.monday?.end ==
                                      null ||
                              _homeController.getArtiestAvailabilityGetModel
                                      .data?.monday?.isSwitchOn ==
                                  false
                          ? null
                          : DayData(
                              start: _homeController
                                  .getArtiestAvailabilityGetModel
                                  .data
                                  ?.monday
                                  ?.start,
                              end: _homeController
                                  .getArtiestAvailabilityGetModel
                                  .data
                                  ?.monday
                                  ?.end,
                              breaks: _homeController
                                  .getArtiestAvailabilityGetModel
                                  .data
                                  ?.monday
                                  ?.breaks),
                      tuesday: _homeController.getArtiestAvailabilityGetModel
                                          .data?.tuesday?.start ==
                                      null &&
                                  _homeController.getArtiestAvailabilityGetModel
                                          .data?.tuesday?.end ==
                                      null ||
                              _homeController.getArtiestAvailabilityGetModel
                                      .data?.tuesday?.isSwitchOn ==
                                  false
                          ? null
                          : DayData(
                              start: _homeController
                                  .getArtiestAvailabilityGetModel
                                  .data
                                  ?.thursday
                                  ?.start,
                              end: _homeController
                                  .getArtiestAvailabilityGetModel
                                  .data
                                  ?.thursday
                                  ?.end,
                              breaks: _homeController
                                  .getArtiestAvailabilityGetModel
                                  .data
                                  ?.tuesday
                                  ?.breaks),
                      wednesday: _homeController.getArtiestAvailabilityGetModel
                                          .data?.wednesday?.start ==
                                      null &&
                                  _homeController.getArtiestAvailabilityGetModel
                                          .data?.wednesday?.end ==
                                      null ||
                              _homeController.getArtiestAvailabilityGetModel
                                      .data?.wednesday?.isSwitchOn ==
                                  false
                          ? null
                          : DayData(
                              start: _homeController
                                  .getArtiestAvailabilityGetModel
                                  .data
                                  ?.wednesday
                                  ?.start,
                              end: _homeController
                                  .getArtiestAvailabilityGetModel
                                  .data
                                  ?.wednesday
                                  ?.end,
                              breaks: _homeController
                                  .getArtiestAvailabilityGetModel
                                  .data
                                  ?.wednesday
                                  ?.breaks),
                      thursday: _homeController.getArtiestAvailabilityGetModel
                                          .data?.thursday?.start ==
                                      null &&
                                  _homeController.getArtiestAvailabilityGetModel
                                          .data?.thursday?.end ==
                                      null ||
                              _homeController.getArtiestAvailabilityGetModel
                                      .data?.thursday?.isSwitchOn ==
                                  false
                          ? null
                          : DayData(
                              start: _homeController
                                  .getArtiestAvailabilityGetModel
                                  .data
                                  ?.thursday
                                  ?.start,
                              end: _homeController
                                  .getArtiestAvailabilityGetModel
                                  .data
                                  ?.thursday
                                  ?.end,
                              breaks: _homeController
                                  .getArtiestAvailabilityGetModel
                                  .data
                                  ?.thursday
                                  ?.breaks),
                      friday: _homeController.getArtiestAvailabilityGetModel
                                          .data?.friday?.start ==
                                      null &&
                                  _homeController.getArtiestAvailabilityGetModel
                                          .data?.friday?.end ==
                                      null ||
                              _homeController.getArtiestAvailabilityGetModel
                                      .data?.friday?.isSwitchOn ==
                                  false
                          ? null
                          : DayData(
                              start: _homeController
                                  .getArtiestAvailabilityGetModel
                                  .data
                                  ?.friday
                                  ?.start,
                              end: _homeController
                                  .getArtiestAvailabilityGetModel
                                  .data
                                  ?.friday
                                  ?.end,
                              breaks: _homeController
                                  .getArtiestAvailabilityGetModel
                                  .data
                                  ?.friday
                                  ?.breaks),
                      saturday: _homeController.getArtiestAvailabilityGetModel
                                          .data?.saturday?.start ==
                                      null &&
                                  _homeController.getArtiestAvailabilityGetModel
                                          .data?.saturday?.end ==
                                      null ||
                              _homeController.getArtiestAvailabilityGetModel
                                      .data?.saturday?.isSwitchOn ==
                                  false
                          ? null
                          : DayData(
                              start: _homeController
                                  .getArtiestAvailabilityGetModel
                                  .data
                                  ?.saturday
                                  ?.start,
                              end: _homeController
                                  .getArtiestAvailabilityGetModel
                                  .data
                                  ?.saturday
                                  ?.end,
                              breaks: _homeController
                                  .getArtiestAvailabilityGetModel
                                  .data
                                  ?.saturday
                                  ?.breaks),
                    ),
                  );

                  String jsonStr = jsonEncode(workingPlanModel);
                  Map<String, dynamic> data = jsonDecode(jsonStr);

                  _homeController.doUpdateArtiestAvailability(
                      availability: data,
                      artistId: widget.artiestId,
                      callback: () {
                        Get.back();
                      });
                }),
          ),
        ],
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
