import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salon/constant/api_constant.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/project_specific/progressbar_view.dart';
import 'package:salon/project_specific/text_theme.dart';
import '../../project_specific/project_appbar.dart';

class BookingHistoryViewpage extends StatefulWidget {
  final String appointmentId;
  final String status;

  const BookingHistoryViewpage(
      {super.key, required this.appointmentId, required this.status});

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
          appointmentId: widget.appointmentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      appBar: const AppBarWidget(
        nameOfScreen: "ID: 79828AH8918",
        isBackIcon: true,
      ),
      body: Obx(
        () => _homeController.showProgress
            ? const ProgressBarView()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      color: ColorConstant.whiteColor,
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          _invoiceWidget(
                              title: "Invoice total",
                              subTitle: "Date",
                              subtitleValue: convertBooingDateFormat(
                                  dateTime: _homeController
                                          .getAppointmentDetailsModel
                                          .data
                                          ?.finalizedAt ??
                                      ""),
                              subTitleValueColor: ColorConstant.blackColor,
                              titleValue:
                                  "₹${_homeController.getAppointmentDetailsModel.data?.orderAmount ?? ""}"),
                          const SizedBox(height: 20),
                          _invoiceWidget(
                              title: "Slot Time",
                              subTitle: "Status",
                              subtitleValue: widget.status,
                              subTitleValueColor: ColorConstant.lightPisTaColor,
                              titleValue:
                                  "${convertDate(date: _homeController.getAppointmentDetailsModel.data?.appointment?.startsAt ?? "")} - ${convertDate(date: _homeController.getAppointmentDetailsModel.data?.appointment?.endsAt ?? "")}"),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      color: ColorConstant.whiteColor,
                      width: Get.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: Text(
                              "Customer Details",
                              style: AppTextTheme.medium.copyWith(
                                  color: ColorConstant.grayTextColor,
                                  fontSize: 13),
                            ),
                          ),
                          _customerDetails(
                              titleName: "Name",
                              titleValue: _homeController
                                      .getAppointmentDetailsModel
                                      .data
                                      ?.user
                                      ?.name ??
                                  ""),
                          const SizedBox(height: 10),
                          _customerDetails(
                              titleName: "Phone",
                              titleValue: _homeController
                                      .getAppointmentDetailsModel
                                      .data
                                      ?.user
                                      ?.mobile ??
                                  ""),
                        ],
                      ),
                    ),
                    Container(
                      color: ColorConstant.whiteColor,
                      width: Get.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Text(
                              "Items",
                              style: AppTextTheme.medium.copyWith(
                                  color: ColorConstant.grayTextColor,
                                  fontSize: 13),
                            ),
                          ),
                          ListView.separated(
                              padding: EdgeInsets.zero,
                              separatorBuilder: (context, i) {
                                return const Divider(
                                  color: ColorConstant.dividerColor,
                                  thickness: 1,
                                );
                              },
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _homeController
                                      .getAppointmentDetailsModel
                                      .data
                                      ?.items
                                      ?.length ??
                                  0,
                              itemBuilder: (context, i) {
                                return Column(
                                  children: [
                                    _homeController.getAppointmentDetailsModel
                                                .data?.items?[i].isService ??
                                            false
                                        ? Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 10),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            decoration: BoxDecoration(
                                                color: ColorConstant.review,
                                                borderRadius:
                                                    BorderRadius.circular(8)),
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
                                                            "${APIConstants.image}${_homeController.getAppointmentDetailsModel.data?.items?[i].service?.image ?? ""}",
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
                                                              style: AppTextTheme
                                                                  .medium
                                                                  .copyWith(
                                                                      color: ColorConstant
                                                                          .grayTextColor,
                                                                      fontSize:
                                                                          13),
                                                            ),
                                                            Text(
                                                              _homeController
                                                                      .getAppointmentDetailsModel
                                                                      .data
                                                                      ?.items?[
                                                                          i]
                                                                      .service
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
                                                                          16),
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
                                                                          13),
                                                            ),
                                                            Text(
                                                              _homeController
                                                                      .getAppointmentDetailsModel
                                                                      .data
                                                                      ?.items?[
                                                                          i]
                                                                      .service
                                                                      ?.price
                                                                      .toString() ??
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
                                                                          16),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    )
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
                                                              fontSize: 13),
                                                    ),
                                                    Text(
                                                      _homeController
                                                              .getAppointmentDetailsModel
                                                              .data
                                                              ?.items?[i]
                                                              .service
                                                              ?.duration
                                                              .toString() ??
                                                          "",
                                                      textScaler:
                                                          const TextScaler
                                                              .linear(0.85),
                                                      style: AppTextTheme.bold
                                                          .copyWith(
                                                              color: ColorConstant
                                                                  .blackColor,
                                                              fontSize: 16),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        : Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 10),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            decoration: BoxDecoration(
                                                color: ColorConstant.review,
                                                borderRadius:
                                                    BorderRadius.circular(8)),
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
                                                          fontSize: 13),
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
                                                                "${APIConstants.image}${_homeController.getAppointmentDetailsModel.data?.items?[i].product?.image ?? ""}",
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
                                                                              13),
                                                                ),
                                                                Text(
                                                                  _homeController
                                                                          .getAppointmentDetailsModel
                                                                          .data
                                                                          ?.items?[
                                                                              i]
                                                                          .product
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
                                                                              16),
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
                                                                              13),
                                                                ),
                                                                Text(
                                                                  _homeController
                                                                          .getAppointmentDetailsModel
                                                                          .data
                                                                          ?.items?[
                                                                              i]
                                                                          .product
                                                                          ?.price
                                                                          .toString() ??
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
                                                                              16),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                  ],
                                );
                              }),
                          const SizedBox(height: 15),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Dash(
                              direction: Axis.horizontal,
                              length: Get.width,
                              dashLength: 2,
                              dashColor: const Color(0xffCFCFCF),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _customerDetails(
                              titleName: "Total", titleValue: "₹300.00"),
                          const SizedBox(height: 10),
                          _customerDetails(
                              titleName: "Tax Applied (18%)",
                              titleValue: "₹300.00"),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Offers Applied",
                                  style: AppTextTheme.medium.copyWith(
                                      color: ColorConstant.grayTextColor,
                                      fontSize: 13),
                                ),
                                Text(
                                  "50% Off",
                                  style: AppTextTheme.bold.copyWith(
                                      color: ColorConstant.primaryColor,
                                      fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 45,
                      width: Get.width,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      color: ColorConstant.primaryColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Price",
                            style: AppTextTheme.bold.copyWith(
                              fontSize: 16,
                              color: ColorConstant.whiteColor,
                            ),
                          ),
                          Text(
                            "₹600",
                            style: AppTextTheme.bold.copyWith(
                              fontSize: 16,
                              color: ColorConstant.whiteColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  /*-------------  Invoice  Widget -----------*/
  _invoiceWidget(
      {required String title,
      required String titleValue,
      required String subTitle,
      required subtitleValue,
      required Color subTitleValueColor}) {
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

  /*---------------- Convert Date tTime  ------------*/
  String convertDate({required String date}) {
    String dateTimeString = date;
    DateTime dateTime = DateTime.parse(dateTimeString);
    String formattedTime = DateFormat('h:mm a').format(dateTime);
    return formattedTime;
  }

  /*------------------------ Convert Booking Date ---------------*/
  String convertBooingDateFormat({required String dateTime}) {
    DateTime date = DateTime.parse(dateTime);
    String formattedDate = DateFormat('dd/MM/yyyy').format(date);
    return formattedDate;
  }

  /*------------- Customer Details Row Widget ---------------*/
  _customerDetails({required String titleName, required String titleValue}) {
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
}
