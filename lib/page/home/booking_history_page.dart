import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
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
      appBar: const AppBarWidget(
        nameOfScreen: "Booking History",
        isBackIcon: false,
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
                                        Get.to(() => BookingHistoryViewpage(
                                              appointmentId: _homeController
                                                      .getSalonUpcomingList
                                                      .data?[index]
                                                      .appointment
                                                      ?.id ??
                                                  "",
                                              status: "Pending",
                                            ));
                                      },
                                    ),
                                  );
                                })
                        : overall == "1"
                            ? _homeController.getSalonCancelServedList.data
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
                                            Get.to(() => BookingHistoryViewpage(
                                                  appointmentId: _homeController
                                                          .getSalonCancelServedList
                                                          .data?[index]
                                                          .appointment
                                                          ?.id ??
                                                      "",
                                                  status: "Cancel",
                                                ));
                                          },
                                        ),
                                      );
                                    })
                            : _homeController
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
                                            Get.to(() => BookingHistoryViewpage(
                                                  appointmentId: _homeController
                                                          .getSalonServedList
                                                          .data?[index]
                                                          .appointment
                                                          ?.id ??
                                                      "",
                                                  status: "Complete",
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
    return Container(

      color: ColorConstant.whiteColor,
      width: Get.width,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: CupertinoSlidingSegmentedControl(
          backgroundColor: ColorConstant.gray,
          padding: const EdgeInsets.all(6),
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
            overall = value;
            if (overall == "0") {
              setState(() {
                _homeController.doUpcomingData();
              });
            } else if (overall == "1") {
              setState(() {
                _homeController.doCancelData();
              });
            } else {
              setState(() {
                _homeController.doCompleteBookingData();
              });
            }
          }),
    );
  }
}
