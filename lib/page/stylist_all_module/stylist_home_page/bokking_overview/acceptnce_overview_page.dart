import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/stylist/stylist_controller.dart';
import 'package:salon/page/stylist_all_module/stylist_home_page/bokking_overview/scan_page.dart';
import 'package:salon/project_specific/progressbar_view.dart';
import 'package:salon/project_specific/text_theme.dart';
import '../../../../project_specific/project_appbar.dart';
import '../../stylist_to_user_location.dart';
import 'change_slot_time_bottom_sheet.dart';

class BookingOverviewPage extends StatefulWidget {
  final String appointmentId;
  final VoidCallback callback;
  const BookingOverviewPage(
      {super.key, required this.appointmentId, required this.callback});

  @override
  State<BookingOverviewPage> createState() => _BookingOverviewPageState();
}

class _BookingOverviewPageState extends State<BookingOverviewPage> {
  final _stylistController = Get.find<StylistController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _stylistController.doAppointmentsDetailsModel(
          appointmentId: widget.appointmentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.whiteColor,
      appBar: const AppBarWidget(
        nameOfScreen: "Booking Overview",
        isBackIcon: true,
      ),
      body: Column(
        children: [
          Obx(
            () => Expanded(
              child: _stylistController.showProgress
                  ? const ProgressBarView()
                  : ListView(
                      children: [
                        Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          color: ColorConstant.bgColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Opted For",
                                style: AppTextTheme.medium.copyWith(
                                    color: ColorConstant.grayTextColor,
                                    fontSize: 16),
                              ),
                              Text(
                                _stylistController.getAppointmentsDetailsModel
                                            .data?.isHomeService ??
                                        false
                                    ? "Home Service"
                                    : "Salon Service",
                                style: AppTextTheme.bold.copyWith(
                                    color: ColorConstant.primaryColor,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
                        Container(
                          color: ColorConstant.whiteColor,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Booking ID",
                                        style: AppTextTheme.regular.copyWith(
                                            fontSize: 13,
                                            color: ColorConstant.grayTextColor),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        _stylistController
                                                .getAppointmentsDetailsModel
                                                .data
                                                ?.idx ??
                                            "",
                                        style: AppTextTheme.bold.copyWith(
                                            fontSize: 16,
                                            color: ColorConstant.blackColor),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Date",
                                        style: AppTextTheme.regular.copyWith(
                                            fontSize: 13,
                                            color: ColorConstant.grayTextColor),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        _stylistController
                                                    .getAppointmentsDetailsModel
                                                    .data
                                                    ?.finalizedAt ==
                                                ""
                                            ? ""
                                            : convertFinalDate(
                                                date: _stylistController
                                                        .getAppointmentsDetailsModel
                                                        .data
                                                        ?.finalizedAt ??
                                                    ""),
                                        style: AppTextTheme.bold.copyWith(
                                            fontSize: 16,
                                            color: ColorConstant.blackColor),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Slot Time",
                                        style: AppTextTheme.regular.copyWith(
                                            fontSize: 13,
                                            color: ColorConstant.grayTextColor),
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Text(
                                            "${_stylistController.getAppointmentsDetailsModel.data?.appointment?.startsAt == "" ? "" : convertDate(date: _stylistController.getAppointmentsDetailsModel.data?.appointment?.startsAt ?? "")} - ${_stylistController.getAppointmentsDetailsModel.data?.appointment?.endsAt == "" ? "" : convertDate(date: _stylistController.getAppointmentsDetailsModel.data?.appointment?.endsAt ?? "")}",
                                            style: AppTextTheme.bold.copyWith(
                                                fontSize: 16,
                                                color:
                                                    ColorConstant.blackColor),
                                          ),
                                          const SizedBox(width: 10),
                                          GestureDetector(
                                            onTap: () {
                                              showModalBottomSheet(
                                                  isScrollControlled: true,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(32),
                                                    topRight:
                                                        Radius.circular(32),
                                                  )),
                                                  context: context,
                                                  builder: (context) {
                                                    return const ChangeSlotTimeBottomSheet();
                                                  });
                                            },
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  AssetsConstant.editIcon,
                                                  color: ColorConstant.redColor,
                                                  height: 15,
                                                  width: 15,
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  "Edit",
                                                  style: AppTextTheme.regular
                                                      .copyWith(
                                                          color: ColorConstant
                                                              .redColor),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Status",
                                        style: AppTextTheme.regular.copyWith(
                                            fontSize: 13,
                                            color: ColorConstant.grayTextColor),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "Accepted",
                                        style: AppTextTheme.bold.copyWith(
                                            fontSize: 16,
                                            color: ColorConstant.primaryColor),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          height: 1.5,
                          width: Get.width,
                          color: ColorConstant.bgColor,
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Customer Details",
                                style: AppTextTheme.medium.copyWith(
                                    color: ColorConstant.grayTextColor,
                                    fontSize: 16),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Name",
                                    style: AppTextTheme.medium.copyWith(
                                        color: ColorConstant.grayTextColor,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    _stylistController
                                            .getAppointmentsDetailsModel
                                            .data
                                            ?.user
                                            ?.name ??
                                        "",
                                    style: AppTextTheme.bold.copyWith(
                                        color: ColorConstant.blackColor,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Phone",
                                    style: AppTextTheme.medium.copyWith(
                                        color: ColorConstant.grayTextColor,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    _stylistController
                                            .getAppointmentsDetailsModel
                                            .data
                                            ?.user
                                            ?.mobile ??
                                        "",
                                    style: AppTextTheme.bold.copyWith(
                                        color: ColorConstant.blackColor,
                                        fontSize: 16),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              _stylistController.getAppointmentsDetailsModel
                                          .data?.isHomeService ??
                                      false
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Address",
                                          style: AppTextTheme.medium.copyWith(
                                              color:
                                                  ColorConstant.grayTextColor,
                                              fontSize: 16),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: Get.width * 0.8,
                                              child: Text(
                                                _stylistController
                                                        .getAppointmentsDetailsModel
                                                        .data
                                                        ?.address
                                                        ?.address ??
                                                    "",
                                                maxLines: 3,
                                                style: AppTextTheme.bold
                                                    .copyWith(
                                                        color: ColorConstant
                                                            .blackColor,
                                                        fontSize: 16),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(() => StylistToUserLocation(
                                                  longitude: _stylistController
                                                          .getAppointmentsDetailsModel
                                                          .data
                                                          ?.address
                                                          ?.geoLocationPoint
                                                          ?.coordinates?[0] ??
                                                      0.0,
                                                  latitude: _stylistController
                                                          .getAppointmentsDetailsModel
                                                          .data
                                                          ?.address
                                                          ?.geoLocationPoint
                                                          ?.coordinates?[1] ??
                                                      0.0,
                                                ));
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            height: 50,
                                            width: Get.width,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(9),
                                              border: Border.all(
                                                color:
                                                    ColorConstant.primaryColor,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 24,
                                                  height: 24,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color:
                                                              ColorConstant
                                                                  .primaryColor,
                                                          shape:
                                                              BoxShape.circle),
                                                  child: Center(
                                                    child: Image.asset(
                                                      AssetsConstant.map,
                                                      height: 10,
                                                      width: 10,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  "Get Direction",
                                                  style: AppTextTheme.medium
                                                      .copyWith(
                                                          color: ColorConstant
                                                              .primaryColor,
                                                          fontSize: 16),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                      ],
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                        Container(
                          height: 1.5,
                          width: Get.width,
                          color: ColorConstant.bgColor,
                        ),
                        const SizedBox(height: 10),
                        _headerWidget(
                            color: ColorConstant.review,
                            title: "",
                            titleValue: "Category"),
                        const SizedBox(height: 10),
                        ListView.builder(
                            itemCount: _stylistController
                                .getAppointmentsDetailsModel
                                .data
                                ?.items
                                ?.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, i) {
                              return _stylistController
                                          .getAppointmentsDetailsModel
                                          .data
                                          ?.items?[i]
                                          .isService ??
                                      false
                                  ? _headerValueWidget(
                                      title: _stylistController
                                              .getAppointmentsDetailsModel
                                              .data
                                              ?.items?[i]
                                              .service
                                              ?.name ??
                                          "",
                                      titleValue:
                                          "₹${_stylistController.getAppointmentsDetailsModel.data?.items?[i].service?.price ?? ""}/-")
                                  : const SizedBox();
                            }),
                        const SizedBox(height: 10),
                        _headerWidget(
                            color: ColorConstant.review,
                            title: "",
                            titleValue: "product"),
                        const SizedBox(height: 10),
                        ListView.builder(
                            itemCount: _stylistController
                                .getAppointmentsDetailsModel
                                .data
                                ?.items
                                ?.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, i) {
                              return _stylistController
                                          .getAppointmentsDetailsModel
                                          .data
                                          ?.items?[i]
                                          .isService ==
                                      false
                                  ? _headerValueWidget(
                                      title: _stylistController
                                              .getAppointmentsDetailsModel
                                              .data
                                              ?.items?[i]
                                              .product
                                              ?.name ??
                                          "",
                                      titleValue:
                                          "₹${_stylistController.getAppointmentsDetailsModel.data?.items?[i].product?.price ?? ""}/-")
                                  : const SizedBox();
                            }),
                      ],
                    ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.to(
                () => ScanPage(
                  appointmentId: widget.appointmentId,
                  callback: widget.callback,
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              height: 50,
              decoration: BoxDecoration(
                color: ColorConstant.primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AssetsConstant.scanner,
                    height: 13,
                    width: 13,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    "Scanner",
                    style: AppTextTheme.medium.copyWith(
                        fontSize: 16, color: ColorConstant.whiteColor),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  /*--------------- Row  Widget -------------*/
  _headerWidget(
      {required Color color,
      required String title,
      required String titleValue}) {
    return Container(
      color: color,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 36,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            titleValue,
            style: AppTextTheme.bold
                .copyWith(color: ColorConstant.blackColor, fontSize: 14),
          ),
          Text(
            title,
            style: AppTextTheme.regular
                .copyWith(color: ColorConstant.blackColor, fontSize: 14),
          ),
        ],
      ),
    );
  }

  /*---------------- convertTime ------------*/
  String convertDate({required String date}) {
    String dateTimeString = date;
    DateTime dateTime = DateTime.parse(dateTimeString);
    String formattedTime = DateFormat('hh:mm a').format(dateTime);
    return formattedTime;
  }

  /*--------------  convert Final  Date -----------*/
  String convertFinalDate({required String date}) {
    String dateTimeString = date;
    DateTime dateTime = DateTime.parse(dateTimeString);
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    String formattedTime = DateFormat('hh:mm a').format(dateTime);
    return "$formattedDate $formattedTime";
  }

  /*---------------- Header Value Widget ----------- */
  _headerValueWidget({required String title, required String titleValue}) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 36,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextTheme.regular
                .copyWith(color: ColorConstant.blackColor, fontSize: 14),
          ),
          Text(
            titleValue,
            style: AppTextTheme.bold
                .copyWith(color: ColorConstant.blackColor, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
