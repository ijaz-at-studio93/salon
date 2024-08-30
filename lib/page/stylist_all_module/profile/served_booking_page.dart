import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/api_constant.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/stylist/stylist_controller.dart';
import 'package:salon/page/stylist_all_module/profile/widget/served_booking_widget.dart';
import 'package:salon/page/stylist_all_module/profile/widget/served_filter_widgtet.dart';
import 'package:salon/project_specific/progressbar_view.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:salon/util/NoItemsWidget.dart';

class ServedBookingPage extends StatefulWidget {
  const ServedBookingPage({super.key});

  @override
  State<ServedBookingPage> createState() => _ServedBookingPageState();
}

class _ServedBookingPageState extends State<ServedBookingPage> {
  final _stylistController = Get.find<StylistController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _stylistController.doGetServedBooking(distribution: "all_time");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      appBar:
          const AppBarWidget(nameOfScreen: "Served Booking", isBackIcon: true),
      body: Column(
        children: [
          _bookingOverview(),
          Obx(
            () => Expanded(
              child: _stylistController.showProgress
                  ? const ProgressBarView()
                  : _stylistController
                              .getCompleteAppointmentsListModel.data?.isEmpty ??
                          false
                      ? const NoItemsWidget(
                          text: "No Any Served Booking Found",
                        )
                      : Container(
                          color: ColorConstant.whiteColor,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _stylistController
                                  .getCompleteAppointmentsListModel
                                  .data
                                  ?.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ServedBookingWidget(
                                    serviceComplete: _stylistController
                                            .getCompleteAppointmentsListModel
                                            .data?[index]
                                            .serviceCount ??
                                        0,
                                    id: _stylistController
                                            .getCompleteAppointmentsListModel
                                            .data?[index]
                                            .idx ??
                                        "",
                                    price: _stylistController
                                            .getCompleteAppointmentsListModel
                                            .data?[index]
                                            .orderAmount ??
                                        0,
                                    startTime: _stylistController
                                            .getCompleteAppointmentsListModel
                                            .data?[index]
                                            .appointment
                                            ?.startsAt ??
                                        "",
                                    endTime: _stylistController
                                            .getCompleteAppointmentsListModel
                                            .data?[index]
                                            .appointment
                                            ?.endsAt ??
                                        "",
                                    name: _stylistController
                                            .getCompleteAppointmentsListModel
                                            .data?[index]
                                            .user
                                            ?.name ??
                                        "",
                                    image:
                                        "${APIConstants.image}${_stylistController.getCompleteAppointmentsListModel.data?[index].user?.profileImage ?? ""}",
                                  ),
                                );
                              }),
                        ),
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
            onTap: () async {
              int index = await showModalBottomSheet(
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  )),
                  context: context,
                  builder: (context) {
                    return ServedFilterWidget(
                      callback: () {},
                    );
                  });

              if (index == 0) {
                _stylistController.doGetServedBooking(distribution: "all_time");
              } else if (index == 1) {
                _stylistController.doGetServedBooking(
                    distribution: "this_week");
              } else if (index == 2) {
                _stylistController.doGetServedBooking(
                    distribution: "this_month");
              } else if (index == 3) {
                _stylistController.doGetServedBooking(
                    distribution: "this_year");
              }
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
