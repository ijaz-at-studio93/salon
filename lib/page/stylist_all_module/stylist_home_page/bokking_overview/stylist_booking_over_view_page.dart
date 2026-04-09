import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/stylist/stylist_controller.dart';
import 'package:salon/page/stylist_all_module/stylist_home_page/bokking_overview/accepted_booking_overview_widget.dart';
import 'package:salon/page/stylist_all_module/stylist_home_page/bokking_overview/acceptnce_overview_page.dart';
import 'package:salon/page/stylist_all_module/stylist_home_page/bokking_overview/view_accept_page.dart';
import 'package:salon/project_specific/progressbar_view.dart';
import 'package:salon/project_specific/status_bar_color_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:salon/util/NoItemsWidget.dart';
import 'package:salon/util/reject_service_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'booking_overview_widget.dart';

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
      _stylistController.doPendingAppointmentsListModel();
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
                                          .getPendingAppointmentsListModel
                                          .data
                                          ?.isEmpty ??
                                      false
                                  ? const NoItemsWidget(
                                      text: "No upcoming bookings found.",
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: _stylistController
                                              .getPendingAppointmentsListModel
                                              .data
                                              ?.length ??
                                          0,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 5),
                                          child: BookingOverviewWidget(
                                            serviceCount: _stylistController
                                                    .getPendingAppointmentsListModel
                                                    .data?[index]
                                                    .serviceCount ??
                                                0,
                                            tapAccept: () {
                                              _stylistController
                                                  .doAppointmentsDetailsModel(
                                                      appointmentId:
                                                          _stylistController
                                                                  .getPendingAppointmentsListModel
                                                                  .data?[index]
                                                                  .appointment
                                                                  ?.id ??
                                                              "");
                                              Get.to(() => ViewAcceptPage(
                                                    appointmentId:
                                                        _stylistController
                                                                .getPendingAppointmentsListModel
                                                                .data?[index]
                                                                .appointment
                                                                ?.id ??
                                                            "",
                                                  ));
                                            },
                                            isHomeService: _stylistController
                                                    .getPendingAppointmentsListModel
                                                    .data?[index]
                                                    .isHomeService ??
                                                false,
                                            id: _stylistController
                                                    .getPendingAppointmentsListModel
                                                    .data?[index]
                                                    .idx ??
                                                "",
                                            price: _stylistController
                                                    .getPendingAppointmentsListModel
                                                    .data?[index]
                                                    .orderAmount ??
                                                0,
                                            startTime: _stylistController
                                                    .getPendingAppointmentsListModel
                                                    .data?[index]
                                                    .appointment
                                                    ?.startsAt ??
                                                "",
                                            endTime: _stylistController
                                                    .getPendingAppointmentsListModel
                                                    .data?[index]
                                                    .appointment
                                                    ?.endsAt ??
                                                "",
                                            tapReject: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return RejectServiceDiaLog(
                                                        tapNo: () {
                                                      Get.back();
                                                    }, tapYes: () {
                                                      _stylistController
                                                          .doBookingApprove(
                                                              appointmentId: _stylistController
                                                                      .getPendingAppointmentsListModel
                                                                      .data?[
                                                                          index]
                                                                      .appointment
                                                                      ?.id ??
                                                                  "",
                                                              status:
                                                                  "salon_artist_rejected",
                                                              callback: () {
                                                                Navigator.pop(
                                                                    context);
                                                                _stylistController
                                                                    .doPendingAppointmentsListModel();
                                                              });
                                                    });
                                                  });
                                            },
                                          ),
                                        );
                                      })
                              : _stylistController
                                          .getAcceptAppointmentsListModel
                                          .data
                                          ?.isEmpty ??
                                      false
                                  ? const NoItemsWidget(
                                      text: "No accepted bookings available.",
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
                                            serviceCount: _stylistController
                                                    .getAcceptAppointmentsListModel
                                                    .data?[index]
                                                    .serviceCount ??
                                                0,
                                            isHomeService: _stylistController
                                                    .getAcceptAppointmentsListModel
                                                    .data?[index]
                                                    .isHomeService ??
                                                false,
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
                                            id: _stylistController
                                                    .getAcceptAppointmentsListModel
                                                    .data?[index]
                                                    .idx ??
                                                "",
                                            endTime: _stylistController
                                                    .getAcceptAppointmentsListModel
                                                    .data?[index]
                                                    .appointment
                                                    ?.endsAt ??
                                                "",
                                            price: _stylistController
                                                    .getAcceptAppointmentsListModel
                                                    .data?[index]
                                                    .orderAmount ??
                                                0,
                                            startTime: _stylistController
                                                    .getAcceptAppointmentsListModel
                                                    .data?[index]
                                                    .appointment
                                                    ?.startsAt ??
                                                "",
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
              "Accepted",
              style: bookingOverView == "1"
                  ? AppTextTheme.bold
                      .copyWith(fontSize: 14, color: ColorConstant.blackColor)
                  : AppTextTheme.medium.copyWith(
                      fontSize: 13, color: ColorConstant.grayTextColor),
            ),
          },
          onValueChanged: (dynamic value) {
            bookingOverView = value;
            if (bookingOverView == "1") {
              _stylistController.doAcceptAppointment();
            } else {
              _stylistController.doPendingAppointmentsListModel();
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
