import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salon/constant/api_constant.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/stylist/stylist_controller.dart';
import 'package:salon/page/stylist_all_module/profile/widget/served_booking_widget.dart';
import 'package:salon/page/stylist_all_module/stylist_home_page/bokking_overview/accepted_booking_overview_widget.dart';
import 'package:salon/page/stylist_all_module/stylist_home_page/bokking_overview/acceptnce_overview_page.dart';
import 'package:salon/project_specific/progressbar_view.dart';
import 'package:salon/project_specific/status_bar_color_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:salon/util/NoItemsWidget.dart';
import 'package:url_launcher/url_launcher.dart';

class StylistBookingOverViewPage extends StatefulWidget {
  const StylistBookingOverViewPage({super.key});

  @override
  State<StylistBookingOverViewPage> createState() =>
      _StylistBookingOverViewPageState();
}

class _StylistBookingOverViewPageState
    extends State<StylistBookingOverViewPage> {
  final _stylistController = Get.find<StylistController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _stylistController.doAcceptAppointment();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.whiteColor,
      appBar: statusBarTheme(context),
      body: Column(
        children: [
          _headerWidget(),
          Container(height: 1, color: ColorConstant.bgColor),
          /* ---------------- Booking Overview -------------- */
          Obx(
            () => Expanded(
              child: _stylistController.showProgress
                  ? const ProgressBarView()
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "Bookings Overview",
                              textScaler: const TextScaler.linear(0.85),
                              style: AppTextTheme.medium.copyWith(
                                  color: ColorConstant.grayTextColor,
                                  fontSize: 23),
                            ),
                          ),
                          const SizedBox(height: 15),
                          _bookingOverView(),
                          bookingOverView == "0"
                              ? _stylistController
                                          .getAcceptAppointmentsListModel
                                          .data
                                          ?.isEmpty ??
                                      false
                                  ? const NoItemsWidget(
                                      text: "No upcoming bookings found.",
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: _stylistController
                                              .getAcceptAppointmentsListModel
                                              .data
                                              ?.length ??
                                          0,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 5),
                                          child: AcceptBookingOverViewWidget(
                                            customerName: _stylistController
                                                    .getAcceptAppointmentsListModel
                                                    .data?[index]
                                                    .user
                                                    ?.name ??
                                                '',
                                            serviceCount: _stylistController
                                                    .getAcceptAppointmentsListModel
                                                    .data?[index]
                                                    .serviceCount ??
                                                0,
                                            onPress: () {
                                              Get.to(() => BookingOverviewPage(
                                                    appointmentId:
                                                        _stylistController
                                                                .getAcceptAppointmentsListModel
                                                                .data?[index]
                                                                .appointment
                                                                ?.id ??
                                                            "",
                                                    callback: () {
                                                      _stylistController
                                                          .doAcceptAppointment();
                                                    },
                                                  ));
                                            },
                                            startTime: _stylistController
                                                    .getAcceptAppointmentsListModel
                                                    .data?[index]
                                                    .appointment
                                                    ?.startsAt ??
                                                "",
                                          ),
                                        );
                                      })
                              : _stylistController
                                          .getCompleteAppointmentsListModel
                                          .data
                                          ?.isEmpty ??
                                      false
                                  ? const NoItemsWidget(
                                      text: "No completed appointments found.",
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: _stylistController
                                              .getCompleteAppointmentsListModel
                                              .data
                                              ?.length ??
                                          0,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 5),
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
                                            onView: () {
                                              final aid = _stylistController
                                                  .getCompleteAppointmentsListModel
                                                  .data?[index]
                                                  .appointment
                                                  ?.id;
                                              if (aid == null || aid.isEmpty) {
                                                return;
                                              }
                                              Get.to(() => BookingOverviewPage(
                                                    appointmentId: aid,
                                                    callback: () {
                                                      _stylistController
                                                          .doGetServedBooking(
                                                              distribution:
                                                                  "all_time");
                                                    },
                                                  ));
                                            },
                                          ),
                                        );
                                      }),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  /* --------------- Header Widget ------------ */
  _headerWidget() {
    return Container(
      height: 60,
      color: ColorConstant.whiteColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "My Dashboard",
              style: AppTextTheme.bold
                  .copyWith(color: ColorConstant.blackColor, fontSize: 19),
            ),
            Row(
              children: [
                /*GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 46,
                    width: 46,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorConstant.primaryColor.withOpacity(0.2),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Image.asset(
                            AssetsConstant.notificationIcon,
                            height: 20,
                            width: 20,
                          ),
                        ),
                        Positioned(
                          top: 10,
                          left: 23,
                          child: Container(
                            height: 10,
                            width: 10,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: ColorConstant.orangeDotColor),
                          ),
                        )
                      ],
                    ),
                  ),
                ),*/

                GestureDetector(
                  onTap: () {
                    _launchDialer(phoneNumber: "88970 90838");
                  },
                  child: Container(
                    height: 46,
                    width: 46,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorConstant.redColor,
                    ),
                    child: Center(
                      child: Image.asset(
                        AssetsConstant.sosIcon,
                        height: 20,
                        width: 20,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  /*======================= LaunchDialer =========================*/
  Future<void> _launchDialer({required String phoneNumber}) async {
    final Uri url = Uri.parse('tel:$phoneNumber');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  /* --------------- Tab Bar variable  ---------------- */
  String? bookingOverView = "0";

  /* --------------------- Switch Tab Stylist & Salon ------------------- */
  _bookingOverView() {
    return Container(
      height: 81,
      color: ColorConstant.whiteColor,
      width: Get.width,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: CupertinoSlidingSegmentedControl(
          backgroundColor: ColorConstant.gray,
          padding: const EdgeInsets.all(6),
          groupValue: bookingOverView,
          thumbColor: ColorConstant.whiteColor,
          children: {
            "0": SizedBox(
              width: Get.width,
              height: Get.height * 0.05,
              child: Center(
                child: Text(
                  "Upcoming",
                  style: bookingOverView == "0"
                      ? AppTextTheme.bold.copyWith(
                          fontSize: 14, color: ColorConstant.blackColor)
                      : AppTextTheme.medium.copyWith(
                          fontSize: 13, color: ColorConstant.grayTextColor),
                ),
              ),
            ),
            "1": Text(
              "Completed",
              style: bookingOverView == "1"
                  ? AppTextTheme.bold
                      .copyWith(fontSize: 14, color: ColorConstant.blackColor)
                  : AppTextTheme.medium.copyWith(
                      fontSize: 13, color: ColorConstant.grayTextColor),
            ),
          },
          onValueChanged: (dynamic value) {
            setState(() {
              bookingOverView = value;
            });
            if (bookingOverView == "1") {
              _stylistController.doGetServedBooking(distribution: "all_time");
            } else {
              _stylistController.doAcceptAppointment();
            }
          }),
    );
  }

  /* ---------------- convertTime -------------- */
  String convertDate({required String date}) {
    String dateTimeString = date;
    DateTime dateTime = DateTime.parse(dateTimeString);
    String formattedTime = DateFormat('h:mm a').format(dateTime);
    return formattedTime;
  }
}
