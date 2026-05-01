import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
  /// Tab values: "0" Upcoming, "1" Completed, "2" Cancelled.
  const BookingHistoryPage({super.key, this.initialTab = "0"});

  final String initialTab;

  @override
  State<BookingHistoryPage> createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  final _homeController = Get.find<HomeController>();

  static const String _filterCustom = 'Custom';

  String _selectedFilter = 'Today';
  DateTime? _customRangeStart;
  DateTime? _customRangeEnd;

  @override
  void initState() {
    super.initState();
    overall = widget.initialTab;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (overall == "0") {
        _homeController.doUpcomingData(distribution: "today");
      } else if (overall == "1") {
        _homeController.doCompleteBookingData(distribution: "all_time");
      } else if (overall == "2") {
        _homeController.doCancelData(distribution: "all_time");
      }
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
                                        final firstStylist =
                                            appt?.stylistDetails?.isNotEmpty ==
                                                    true
                                                ? appt!.stylistDetails!.first
                                                : null;
                                        Get.to(() => BookingHistoryViewpage(
                                              appointmentId: appt?.id ?? "",
                                              status: _homeController
                                                      .getSalonUpcomingList
                                                      .data?[index]
                                                      .orderStatus ??
                                                  "",
                                              listStylistName:
                                                  firstStylist?.name ??
                                                      appt?.artist?.name,
                                              listStylistId: firstStylist?.id ??
                                                  appt?.stylistIds?.firstOrNull,
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
                                            final firstStylist = appt
                                                        ?.stylistDetails
                                                        ?.isNotEmpty ==
                                                    true
                                                ? appt!.stylistDetails!.first
                                                : null;
                                            Get.to(() => BookingHistoryViewpage(
                                                  appointmentId: appt?.id ?? "",
                                                  status: "Complete",
                                                  listStylistName:
                                                      firstStylist?.name ??
                                                          appt?.artist?.name,
                                                  listStylistId:
                                                      firstStylist?.id ??
                                                          appt?.stylistIds
                                                              ?.firstOrNull,
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
                                            final firstStylist = appt
                                                        ?.stylistDetails
                                                        ?.isNotEmpty ==
                                                    true
                                                ? appt!.stylistDetails!.first
                                                : null;
                                            Get.to(() => BookingHistoryViewpage(
                                                  appointmentId: appt?.id ?? "",
                                                  status: "Cancel",
                                                  listStylistName:
                                                      firstStylist?.name ??
                                                          appt?.artist?.name,
                                                  listStylistId:
                                                      firstStylist?.id ??
                                                          appt?.stylistIds
                                                              ?.firstOrNull,
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

  /*--------------- Date filters: Upcoming vs Completed/Cancelled ---------*/
  final List<String> upcomingDataList = [
    'Today',
    'Tomorrow',
    'This Week',
  ];

  final List<String> dataList = [
    'Today',
    'yesterday',
    'This Week',
    'This Month',
    'This year',
    _filterCustom,
  ];

  /*--------------------- No. Of Service You Offer ------------------*/
  void _fetchCustomDateRangeIfComplete() {
    final start = _customRangeStart;
    final end = _customRangeEnd;
    if (start == null || end == null) return;
    final startStr = DateFormat('yyyy-MM-dd').format(start);
    final endStr = DateFormat('yyyy-MM-dd').format(end);
    if (overall == "1") {
      _homeController.doCompleteBookingData(
        fromDate: startStr,
        toDate: endStr,
      );
    } else if (overall == "2") {
      _homeController.doCancelData(
        fromDate: startStr,
        toDate: endStr,
      );
    }
  }

  Future<void> _pickCustomStartDate() async {
    final now = DateTime.now();
    final initial = _customRangeStart ?? now;
    final last = _customRangeEnd ?? now.add(const Duration(days: 365 * 2));
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 5),
      lastDate: last,
    );
    if (picked == null || !mounted) return;
    setState(() {
      _customRangeStart = picked;
      if (_customRangeEnd != null && _customRangeEnd!.isBefore(picked)) {
        _customRangeEnd = picked;
      }
    });
    _fetchCustomDateRangeIfComplete();
  }

  Future<void> _pickCustomEndDate() async {
    final now = DateTime.now();
    final initial = _customRangeEnd ?? _customRangeStart ?? now;
    final first = _customRangeStart ?? DateTime(now.year - 5);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: now.add(const Duration(days: 365 * 2)),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _customRangeEnd = picked;
      if (_customRangeStart != null && picked.isBefore(_customRangeStart!)) {
        _customRangeStart = picked;
      }
    });
    _fetchCustomDateRangeIfComplete();
  }

  void _onFilterDropdownChanged(String? value) {
    if (value == null) return;
    setState(() {
      _selectedFilter = value;
      _customRangeStart = null;
      _customRangeEnd = null;
    });
    if (value == _filterCustom) {
      return;
    }
    if (overall == "0") {
      if (value == 'Today') {
        _homeController.doUpcomingData(distribution: "today");
      } else if (value == 'Tomorrow') {
        _homeController.doUpcomingData(distribution: "tomorrow");
      } else if (value == 'This Week') {
        _homeController.doUpcomingData(distribution: "this_week");
      }
    } else if (overall == "2") {
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
        _homeController.doCompleteBookingData(distribution: "yesterday");
      } else if (value == 'This Week') {
        _homeController.doCompleteBookingData(distribution: "this_week");
      } else if (value == 'This Month') {
        _homeController.doCompleteBookingData(distribution: "this_month");
      } else if (value == 'This year') {
        _homeController.doCompleteBookingData(distribution: "this_year");
      }
    }
  }

  Widget _customRangeDateButton({
    required String label,
    required DateTime? selected,
    required VoidCallback onTap,
  }) {
    final display =
        selected != null ? DateFormat.yMMMd().format(selected) : label;
    return SizedBox(
      height: 40,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          side: const BorderSide(color: Color(0xFF01AB4D)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          display,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextTheme.extraBold.copyWith(
            color: ColorConstant.blackColor,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  _noOfServiceYouOffer() {
    final filterList = overall == "0" ? upcomingDataList : dataList;
    final showCustomRange = _selectedFilter == _filterCustom;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 50,
            width: Get.width * 0.38,
            child: DropdownButtonFormField2<String>(
              key: ValueKey<String?>(overall),
              isExpanded: true,
              value: _selectedFilter,
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
                style: AppTextTheme.extraBold
                    .copyWith(color: ColorConstant.blackColor, fontSize: 13),
              ),
              items: filterList
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
              validator: (value) {
                if (value == null) {
                  return 'Today';
                }
                return null;
              },
              onChanged: _onFilterDropdownChanged,
              onSaved: (value) {
                /* selectedValue = value.toString();*/
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
          if (showCustomRange) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: Get.width * 0.78,
              child: Row(
                children: [
                  Expanded(
                    child: _customRangeDateButton(
                      label: 'Start',
                      selected: _customRangeStart,
                      onTap: _pickCustomStartDate,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _customRangeDateButton(
                      label: 'End',
                      selected: _customRangeEnd,
                      onTap: _pickCustomEndDate,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /*----------- Tab Bar variable  ----------- */
  String? overall;

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
            _selectedFilter = 'Today';
            _customRangeStart = null;
            _customRangeEnd = null;
            _homeController.doUpcomingData(distribution: "today");
          });
        } else if (overall == "1") {
          setState(() {
            _selectedFilter = 'Today';
            _customRangeStart = null;
            _customRangeEnd = null;
            _homeController.doCompleteBookingData(distribution: "all_time");
          });
        } else {
          setState(() {
            _selectedFilter = 'Today';
            _customRangeStart = null;
            _customRangeEnd = null;
            _homeController.doCancelData(distribution: "all_time");
          });
        }
      },
    );
  }
}
