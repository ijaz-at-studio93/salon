import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/page/home/widget/booking_history_widget.dart';
import 'package:salon/page/home/widget/cancelled_booking_history_widget.dart';
import 'package:salon/page/home/widget/complete_booking_history_widget.dart';
import 'package:salon/project_specific/progressbar_view.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:salon/util/NoItemsWidget.dart';

import '../../project_specific/custom_tab_bar.dart';
import '../../project_specific/project_appbar.dart';
import 'booking_history_view_page.dart';

class BookingHistoryPage extends StatefulWidget {
  const BookingHistoryPage({super.key});

  @override
  State<BookingHistoryPage> createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  final _homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _homeController.doUpcomingData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      appBar: AppBarWidget(
        nameOfScreen: "Booking History",
        isBackIcon: Navigator.of(context).canPop(),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                // overall == "0" ? const SizedBox() :
                _noOfServiceYouOffer(),
              ],
            ),
          ),
          _stylistAndSalon(),
          Obx(
            () => Expanded(
                child: _homeController.showProgress
                    ? const ProgressBarView()
                    : overall == "0"
                        ? _homeController.getSalonUpcomingList.data?.isEmpty ??
                                false
                            ? const NoItemsWidget(
                                text: "No Any Upcoming Booking Found",
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: _homeController
                                        .getSalonUpcomingList.data?.length ??
                                    0,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: BookingHistoryPendingWidget(
                                      orderData: _homeController
                                          .getSalonUpcomingList.data![index],
                                      onPress: () {
                                        final appt = _homeController
                                            .getSalonUpcomingList
                                            .data?[index]
                                            .appointment;
                                        final firstStylist = appt?.stylistDetails?.isNotEmpty == true
                                            ? appt!.stylistDetails!.first
                                            : null;
                                        Get.to(() => BookingHistoryViewpage(
                                              appointmentId: appt?.id ?? "",
                                              status: _homeController
                                                      .getSalonUpcomingList
                                                      .data?[index]
                                                      .orderStatus ??
                                                  "",
                                              listStylistName: firstStylist?.name ?? appt?.artist?.name,
                                              listStylistId: firstStylist?.id ?? appt?.artist?.id,
                                            ));
                                      },
                                    ),
                                  );
                                })
                        : overall == "1"
                            ? _homeController
                                        .getSalonServedList.data?.isEmpty ??
                                    false
                                ? const NoItemsWidget(
                                    text: "No Any Complete Booking Found",
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: _homeController
                                            .getSalonServedList.data?.length ??
                                        0,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: CompleteHistoryWidget(
                                          orderData: _homeController
                                              .getSalonServedList.data![index],
                                          onPress: () {
                                            final appt = _homeController
                                                .getSalonServedList
                                                .data?[index]
                                                .appointment;
                                            final firstStylist = appt?.stylistDetails?.isNotEmpty == true
                                                ? appt!.stylistDetails!.first
                                                : null;
                                            Get.to(() => BookingHistoryViewpage(
                                                  appointmentId: appt?.id ?? "",
                                                  status: "Complete",
                                                  listStylistName: firstStylist?.name ?? appt?.artist?.name,
                                                  listStylistId: firstStylist?.id ?? appt?.artist?.id,
                                                ));
                                          },
                                        ),
                                      );
                                    })
                            : _homeController.getSalonCancelServedList.data
                                        ?.isEmpty ??
                                    false
                                ? const NoItemsWidget(
                                    text: "No Any Cancel Booking Found",
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: _homeController
                                            .getSalonCancelServedList
                                            .data
                                            ?.length ??
                                        0,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: CancelledBookingHistoryWidget(
                                          orderData: _homeController
                                              .getSalonCancelServedList
                                              .data![index],
                                          onPress: () {
                                            final appt = _homeController
                                                .getSalonCancelServedList
                                                .data?[index]
                                                .appointment;
                                            final firstStylist = appt?.stylistDetails?.isNotEmpty == true
                                                ? appt!.stylistDetails!.first
                                                : null;
                                            Get.to(() => BookingHistoryViewpage(
                                                  appointmentId: appt?.id ?? "",
                                                  status: "Cancel",
                                                  listStylistName: firstStylist?.name ?? appt?.artist?.name,
                                                  listStylistId: firstStylist?.id ?? appt?.artist?.id,
                                                ));
                                          },
                                        ),
                                      );
                                    })),
          ),
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
        height: 50,
        width: Get.width * 0.4,
        child: DropdownButtonFormField2<String>(
          isExpanded: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Color(0xFF01AB4D)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Color(0xFF01AB4D)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Color(0xFF01AB4D)),
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
            if (overall == "2") {
              if (value == 'Today') {
                _homeController.doCancelData(distribution: "today");
              } else if (value == 'yesterday') {
                _homeController.doCancelData(distribution: "yesterday");
              } else if (value == 'This Week') {
                _homeController.doCancelData(distribution: "this_week");
              } else if (value == 'This Month') {
                _homeController.doCancelData(distribution: "this_month");
              } else if (value == 'This year') {
                _homeController.doCancelData(distribution: "this_year");
              }
            } else if (overall == "1") {
              if (value == 'Today') {
                _homeController.doCompleteBookingData(distribution: "today");
              } else if (value == 'yesterday') {
                _homeController.doCompleteBookingData(
                    distribution: "yesterday");
              } else if (value == 'This Week') {
                _homeController.doCompleteBookingData(
                    distribution: "this_week");
              } else if (value == 'This Month') {
                _homeController.doCompleteBookingData(
                    distribution: "this_month");
              } else if (value == 'This year') {
                _homeController.doCompleteBookingData(
                    distribution: "this_year");
              }
            }
          },
          onSaved: (value) {
            /* selectedValue = value.toString();*/
          },
          buttonStyleData: const ButtonStyleData(
            padding: EdgeInsets.only(right: 8),
          ),
          iconStyleData: const IconStyleData(
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.black,
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
    return CustomTabBar(
      tabs: const [
        CustomTabItem(value: "0", label: "Upcoming"),
        CustomTabItem(value: "1", label: "Completed"),
        CustomTabItem(value: "2", label: "Cancelled"),
      ],
      selectedValue: overall ?? "0",
      onChanged: (value) {
        overall = value;
        if (overall == "0") {
          setState(() {
            _homeController.doUpcomingData();
          });
        } else if (overall == "1") {
          setState(() {
            _homeController.doCompleteBookingData(distribution: "all_time");
          });
        } else {
          setState(() {
            _homeController.doCancelData(distribution: "all_time");
          });
        }
      },
    );
  }
}
