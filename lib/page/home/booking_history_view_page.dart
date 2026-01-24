import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salon/constant/api_constant.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/page/home/upload_image.dart';
import 'package:salon/project_specific/progressbar_view.dart';
import 'package:salon/project_specific/text_theme.dart';

import '../../project_specific/project_appbar.dart';
import '../stylist_all_module/stylist_home_page/bokking_overview/widget/portfolio_permission_dialog.dart';

class BookingHistoryViewpage extends StatefulWidget {
  final String appointmentId;
  final String status;

  const BookingHistoryViewpage({
    super.key,
    required this.appointmentId,
    required this.status,
  });

  @override
  State<BookingHistoryViewpage> createState() => _BookingHistoryViewpageState();
}

class _BookingHistoryViewpageState extends State<BookingHistoryViewpage> {
  final _homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _homeController.doGetAppointmentDetailsModel(
        appointmentId: widget.appointmentId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final status = _homeController.getAppointmentDetailsModel.data?.orderStatus;
    final scanned = _homeController.qrScanned[widget.appointmentId] ?? false;
    final token = _homeController.qrToken[widget.appointmentId];
    return Obx(
      () => Scaffold(
        backgroundColor: ColorConstant.bgColor,
        appBar: AppBarWidget(
          nameOfScreen:
              "ID: ${_homeController.getAppointmentDetailsModel.data?.idx ?? ""}",
          isBackIcon: true,
        ),
        body: _homeController.showProgress
            ? const ProgressBarView()
            : Column(
                children: [
                  // ======= FIXED TOP: Staff / Slot =======
                  Container(
                    color: ColorConstant.whiteColor,
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        _invoiceWidget(
                          title: "Staff Name",
                          subTitle: "Date",
                          subtitleValue: convertBooingDateFormat(
                            dateTime: _homeController.getAppointmentDetailsModel
                                    .data?.finalizedAt ??
                                "",
                          ),
                          subTitleValueColor: ColorConstant.blackColor,
                          titleValue:
                              "${_homeController.getAppointmentDetailsModel.data?.appointment?.artist?.name ?? ""}",
                        ),
                        const SizedBox(height: 20),
                        _invoiceWidget(
                          title: "Slot Time",
                          subTitle: "Status",
                          subtitleValue: _homeController
                                  .getAppointmentDetailsModel
                                  .data
                                  ?.orderStatus ??
                              '',
                          subTitleValueColor: ColorConstant.lightPisTaColor,
                          titleValue:
                              "${convertDate(date: _homeController.getAppointmentDetailsModel.data?.appointment?.startsAt ?? "")} - ${convertDate(date: _homeController.getAppointmentDetailsModel.data?.appointment?.endsAt ?? "")}",
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),

                  // ======= FIXED: Customer details =======
                  Container(
                    color: ColorConstant.whiteColor,
                    width: Get.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Text(
                            "Customer Details",
                            style: AppTextTheme.medium.copyWith(
                              color: ColorConstant.grayTextColor,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        _customerDetails(
                          titleName: "Name",
                          titleValue: _homeController.getAppointmentDetailsModel
                                  .data?.user?.name ??
                              "",
                        ),
                        const SizedBox(height: 5),
                        _customerDetails(
                          titleName: "Phone",
                          titleValue: _homeController.getAppointmentDetailsModel
                                  .data?.user?.mobile ??
                              "",
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),

                  // ======= SCROLLABLE: Services only =======
                  Expanded(
                    child: Container(
                      color: ColorConstant.whiteColor,
                      width: Get.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 7),
                            child: Text(
                              "Services",
                              style: AppTextTheme.bold.copyWith(
                                color: ColorConstant.grayTextColor,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Expanded(
                              child: ScrollbarTheme(
                                  data: ScrollbarThemeData(
                                    thumbColor: MaterialStateProperty.all(
                                        ColorConstant.primaryColor),
                                  ),
                                  child: Scrollbar(
                                    thumbVisibility: true,
                                    trackVisibility: true,
                                    thickness: 6,
                                    radius: const Radius.circular(12),
                                    scrollbarOrientation:
                                        ScrollbarOrientation.right,
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: _homeController
                                              .getAppointmentDetailsModel
                                              .data
                                              ?.items
                                              ?.length ??
                                          0,
                                      itemBuilder: (context, i) {
                                        final item = _homeController
                                            .getAppointmentDetailsModel
                                            .data
                                            ?.items?[i];
                                        final isService =
                                            item?.isService ?? false;

                                        if (isService) {
                                          return Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 10),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: ColorConstant.review,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      child: CachedNetworkImage(
                                                        width: 50,
                                                        height: 50,
                                                        fit: BoxFit.cover,
                                                        imageUrl:
                                                            "${APIConstants.image}${item?.service?.image ?? ""}",
                                                        placeholder:
                                                            (context, url) =>
                                                                const Image(
                                                          image: AssetImage(
                                                              AssetsConstant
                                                                  .placeHolder),
                                                          width: 50,
                                                          height: 50,
                                                          fit: BoxFit.cover,
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            const Image(
                                                          image: AssetImage(
                                                              AssetsConstant
                                                                  .placeHolder),
                                                          width: 50,
                                                          height: 50,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Service Name : ",
                                                              style:
                                                                  AppTextTheme
                                                                      .medium
                                                                      .copyWith(
                                                                color: ColorConstant
                                                                    .grayTextColor,
                                                                fontSize: 13,
                                                              ),
                                                            ),
                                                            Text(
                                                              item?.service
                                                                      ?.name ??
                                                                  "",
                                                              textScaler:
                                                                  const TextScaler
                                                                      .linear(
                                                                      0.85),
                                                              style:
                                                                  AppTextTheme
                                                                      .bold
                                                                      .copyWith(
                                                                color: ColorConstant
                                                                    .blackColor,
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 5),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Service Price : ",
                                                              style:
                                                                  AppTextTheme
                                                                      .medium
                                                                      .copyWith(
                                                                color: ColorConstant
                                                                    .grayTextColor,
                                                                fontSize: 13,
                                                              ),
                                                            ),
                                                            Text(
                                                              item?.service
                                                                      ?.price
                                                                      ?.toString() ??
                                                                  "",
                                                              textScaler:
                                                                  const TextScaler
                                                                      .linear(
                                                                      0.85),
                                                              style:
                                                                  AppTextTheme
                                                                      .bold
                                                                      .copyWith(
                                                                color: ColorConstant
                                                                    .blackColor,
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Duration : ",
                                                      style: AppTextTheme.medium
                                                          .copyWith(
                                                        color: ColorConstant
                                                            .grayTextColor,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                    Text(
                                                      item?.service?.duration
                                                              ?.toString() ??
                                                          "",
                                                      textScaler:
                                                          const TextScaler
                                                              .linear(0.85),
                                                      style: AppTextTheme.bold
                                                          .copyWith(
                                                        color: ColorConstant
                                                            .blackColor,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        } else {
                                          // product
                                          return Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 10),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: ColorConstant.review,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Product",
                                                  style: AppTextTheme.medium
                                                      .copyWith(
                                                    color: ColorConstant
                                                        .grayTextColor,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100),
                                                          child:
                                                              CachedNetworkImage(
                                                            width: 50,
                                                            height: 50,
                                                            fit: BoxFit.cover,
                                                            imageUrl:
                                                                "${APIConstants.image}${item?.product?.image ?? ""}",
                                                            placeholder:
                                                                (context,
                                                                        url) =>
                                                                    const Image(
                                                              image: AssetImage(
                                                                  AssetsConstant
                                                                      .placeHolder),
                                                              width: 50,
                                                              height: 50,
                                                              fit: BoxFit.cover,
                                                            ),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    const Image(
                                                              image: AssetImage(
                                                                  AssetsConstant
                                                                      .placeHolder),
                                                              width: 50,
                                                              height: 50,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "Service Name : ",
                                                                  style: AppTextTheme
                                                                      .medium
                                                                      .copyWith(
                                                                    color: ColorConstant
                                                                        .grayTextColor,
                                                                    fontSize:
                                                                        13,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  item?.product
                                                                          ?.name ??
                                                                      "",
                                                                  textScaler:
                                                                      const TextScaler
                                                                          .linear(
                                                                          0.85),
                                                                  style: AppTextTheme
                                                                      .bold
                                                                      .copyWith(
                                                                    color: ColorConstant
                                                                        .blackColor,
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                                height: 5),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "Service Price : ",
                                                                  style: AppTextTheme
                                                                      .medium
                                                                      .copyWith(
                                                                    color: ColorConstant
                                                                        .grayTextColor,
                                                                    fontSize:
                                                                        13,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  item?.product
                                                                          ?.price
                                                                          ?.toString() ??
                                                                      "",
                                                                  textScaler:
                                                                      const TextScaler
                                                                          .linear(
                                                                          0.85),
                                                                  style: AppTextTheme
                                                                      .bold
                                                                      .copyWith(
                                                                    color: ColorConstant
                                                                        .blackColor,
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ))),
                          const SizedBox(height: 5),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Dash(
                              direction: Axis.horizontal,
                              length: Get.width,
                              dashLength: 2,
                              dashColor: ColorConstant.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                        ],
                      ),
                    ),
                  ),

                  // ======= FIXED BOTTOM: Total & Action =======
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Total Price = ",
                          style: AppTextTheme.bold.copyWith(
                            fontSize: 15,
                            color: ColorConstant.blackColor,
                          ),
                        ),
                        Text(
                          "Rs. ${_homeController.getAppointmentDetailsModel.data?.items!.fold<double>(0.0, (sum, item) => sum + (item.service?.price ?? 0)) ?? 0}",
                          style: AppTextTheme.bold.copyWith(
                            fontSize: 20,
                            color: ColorConstant.blackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorConstant.primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () async {
                          final status = _homeController
                              .getAppointmentDetailsModel.data?.orderStatus;
                          final token = _homeController.qrToken[
                              widget.appointmentId]; // if you stored it

                          if (status == 'pending') {
                            // ACCEPT
                            _homeController.doBookingApprove(
                              appointmentId: widget.appointmentId,
                              status: "confirmed",
                              callback: () {
                                // REFRESH the appointment so UI sees orderStatus = 'confirmed'
                                _homeController.doGetAppointmentDetailsModel(
                                  appointmentId: widget.appointmentId,
                                );
                              },
                            );
                          } else if (status == 'confirmed') {
                            _homeController.doScanQrcode(
                              appointmentId: widget.appointmentId,
                              callback: () {
                                var allow = _homeController
                                        .getAllowPortfolioUploadModel
                                        .data
                                        ?.allowPortfolioUpload ==
                                    true;
                                debugPrint('***********');
                                print(allow);
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  if (allow) {
                                    Get.dialog(
                                      PortfolioPermissionDialog(
                                        yes: () {
                                          Get.back();
                                          Get.to(() => UploadImagePage(
                                              appointmentId:
                                                  widget.appointmentId));
                                        },
                                        cancel: () {
                                          Get.back();
                                          Get.back();
                                        },
                                      ),
                                      barrierDismissible: false,
                                    );
                                  } else {
                                    Get.back();
                                  }
                                });
                              },
                            );
                          }
                        },
                        child: Text(
                          (_homeController.getAppointmentDetailsModel.data
                                      ?.orderStatus ==
                                  'pending')
                              ? "Accept"
                              : (_homeController.getAppointmentDetailsModel.data
                                          ?.orderStatus ==
                                      'confirmed')
                                  ? "Mark As Done"
                                  : "",
                          style: AppTextTheme.bold
                              .copyWith(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
      ),
    );
  }

  /*-------------  Invoice  Widget -----------*/
  Widget _invoiceWidget({
    required String title,
    required String titleValue,
    required String subTitle,
    required String subtitleValue,
    required Color subTitleValueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextTheme.medium
                    .copyWith(color: ColorConstant.grayTextColor, fontSize: 13),
              ),
              Text(
                titleValue,
                textScaler: const TextScaler.linear(0.85),
                style: AppTextTheme.bold
                    .copyWith(color: ColorConstant.blackColor, fontSize: 16),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subTitle,
                style: AppTextTheme.medium
                    .copyWith(color: ColorConstant.grayTextColor, fontSize: 13),
              ),
              Text(
                subtitleValue,
                textScaler: const TextScaler.linear(0.85),
                style: AppTextTheme.bold
                    .copyWith(color: subTitleValueColor, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /*---------------- Convert Date Time ------------*/
  String convertDate({required String date}) {
    if (date == "") return "";
    final dateTime = DateTime.parse(date);
    return DateFormat('h:mm a').format(dateTime);
    // example output: 3:15 PM
  }

  /*------------------------ Convert Booking Date ---------------*/
  String convertBooingDateFormat({required String dateTime}) {
    if (dateTime == "") return "";
    final date = DateTime.parse(dateTime);
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /*------------- Customer Details Row Widget ---------------*/
  Widget _customerDetails({
    required String titleName,
    required String titleValue,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            titleName,
            style: AppTextTheme.medium
                .copyWith(color: ColorConstant.grayTextColor, fontSize: 13),
          ),
          Text(
            titleValue,
            textScaler: const TextScaler.linear(0.85),
            style: AppTextTheme.bold
                .copyWith(color: ColorConstant.blackColor, fontSize: 16),
          ),
        ],
      ),
    );
  }

  String _generateManualToken(String appointmentId) {
    // Simple, unique-enough token. Change format if your backend enforces a pattern.
    final ts = DateTime.now().millisecondsSinceEpoch;
    return 'manual:$appointmentId:$ts';
  }
}
