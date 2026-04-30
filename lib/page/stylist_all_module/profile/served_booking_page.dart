import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/api_constant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/stylist/stylist_controller.dart';
import 'package:salon/page/stylist_all_module/profile/widget/served_booking_widget.dart';
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

  final List<String> _servedFilterList = [
    'All',
    'This Week',
    'This Month',
    'This year',
  ];

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
          const AppBarWidget(nameOfScreen: "Services Done", isBackIcon: true),
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
          Expanded(
            child: Text(
              "Booking Overview",
              style: AppTextTheme.medium
                  .copyWith(fontSize: 23, color: ColorConstant.blackColor),
            ),
          ),
          SizedBox(
            height: 50,
            width: Get.width * 0.38,
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
                'All',
                style: AppTextTheme.extraBold
                    .copyWith(color: ColorConstant.blackColor, fontSize: 13),
              ),
              items: _servedFilterList
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: AppTextTheme.extraBold.copyWith(
                            color: ColorConstant.blackColor,
                            fontSize: 13,
                          ),
                        ),
                      ))
                  .toList(),
              validator: (value) => null,
              onChanged: (value) {
                if (value == 'All') {
                  _stylistController.doGetServedBooking(distribution: "all_time");
                } else if (value == 'This Week') {
                  _stylistController.doGetServedBooking(
                      distribution: "this_week");
                } else if (value == 'This Month') {
                  _stylistController.doGetServedBooking(
                      distribution: "this_month");
                } else if (value == 'This year') {
                  _stylistController.doGetServedBooking(
                      distribution: "this_year");
                }
              },
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.only(right: 8),
              ),
              iconStyleData: const IconStyleData(
                icon: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
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
        ],
      ),
    );
  }
}
