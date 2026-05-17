import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/model/service_model/pending_appointments_list_model.dart';
import 'package:salon/project_specific/text_theme.dart';

class CancelledBookingHistoryWidget extends StatefulWidget {
  final VoidCallback onPress;
  final OrderData orderData;
  const CancelledBookingHistoryWidget(
      {super.key, required this.onPress, required this.orderData});

  @override
  State<CancelledBookingHistoryWidget> createState() =>
      _CancelledBookingHistoryWidgetState();
}

class _CancelledBookingHistoryWidgetState
    extends State<CancelledBookingHistoryWidget> {
  static const _labelStyle = TextStyle(
    fontWeight: FontWeight.w700,
    color: Colors.black,
    fontSize: 15,
  );

  @override
  Widget build(BuildContext context) {
    final o = widget.orderData;
    final idx = o.idx?.trim() ?? '';
    final scheduleSource = (o.appointment?.startsAt?.isNotEmpty == true)
        ? o.appointment!.startsAt!
        : (o.appointment?.selectedSlots?.isNotEmpty == true
            ? o.appointment!.selectedSlots!.first
            : '');
    final dateStr = _convertBookingDate(scheduleSource);
    final timeStr = _formatTimeLabel(scheduleSource);
    final stylistDetails = o.appointment?.stylistDetails;
    final stylistName = (stylistDetails != null && stylistDetails.isNotEmpty)
        ? stylistDetails
            .map((s) => s.name ?? '')
            .where((n) => n.isNotEmpty)
            .join(', ')
        : (o.appointment?.artist?.name?.isNotEmpty == true
            ? o.appointment!.artist!.name!
            : 'No stylist preference');
    final priceStr = o.orderAmount?.toStringAsFixed(0) ?? '0';

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: ColorConstant.whiteColor,
        border: Border.all(
          color: ColorConstant.bookingCardBorderPurple,
          width: 1,
        ),
        boxShadow: ColorConstant.appointmentCardElevation,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (idx.isNotEmpty) ...[
                  _inlineLabelValue(
                    label: 'ID : ',
                    value: idx,
                    valueColor: ColorConstant.bookingValuePurple,
                    maxValueWidth: Get.width * 0.38,
                  ),
                  const SizedBox(height: 6),
                ],
                _inlineLabelValue(
                  label: 'Date : ',
                  value: dateStr,
                  valueColor: ColorConstant.bookingValuePurple,
                ),
                const SizedBox(height: 6),
                _inlineLabelValue(
                  label: 'Stylist : ',
                  value: stylistName,
                  valueColor: ColorConstant.bookingValuePurple,
                ),
                const SizedBox(height: 6),
                RichText(
                  text: TextSpan(
                    style: AppTextTheme.bold.copyWith(
                      fontSize: 15,
                      color: ColorConstant.bookingPriceMagenta2,
                    ),
                    children: [
                      const TextSpan(
                        text: 'ApproxPrice : ',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(text: priceStr),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _inlineLabelValue(
                label: 'Time - ',
                value: timeStr,
                valueColor: ColorConstant.bookingValuePurple,
                alignEnd: true,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Status : ', style: _labelStyle.copyWith(fontSize: 13)),
                  Text(
                    o.orderStatus == 'salon_rejected' ? 'Rejected' : 'Cancelled',
                    style: AppTextTheme.bold.copyWith(
                      fontSize: 13,
                      color: Colors.red,//ColorConstant.bookingStatusCancelled,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _viewButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _inlineLabelValue({
    required String label,
    required String value,
    required Color valueColor,
    bool alignEnd = false,
    double? maxValueWidth,
  }) {
    if (alignEnd) {
      return Align(
        alignment: Alignment.centerRight,
        child: RichText(
          textAlign: TextAlign.end,
          text: TextSpan(
            style: _labelStyle.copyWith(fontSize: 15),
            children: [
              TextSpan(text: label),
              TextSpan(
                text: value,
                style: AppTextTheme.bold.copyWith(
                  fontSize: 15,
                  color: valueColor,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (maxValueWidth != null) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: _labelStyle.copyWith(fontSize: 15)),
          SizedBox(
            width: maxValueWidth,
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextTheme.bold.copyWith(
                fontSize: 15,
                color: valueColor,
              ),
            ),
          ),
        ],
      );
    }

    return RichText(
      text: TextSpan(
        style: _labelStyle.copyWith(fontSize: 15),
        children: [
          TextSpan(
            text: label,
            style: AppTextTheme.semibold.copyWith(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: value,
            style: AppTextTheme.bold.copyWith(
              fontSize: 15,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _viewButton() {
    return Material(
      color: ColorConstant.bookingViewMintBg,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: widget.onPress,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: ColorConstant.lightGreenColor),
          ),
          child: Text(
            'View',
            style: AppTextTheme.bold.copyWith(
              color: ColorConstant.lightGreenColor,
              fontSize: 17,
            ),
          ),
        ),
      ),
    );
  }

  String _formatTimeLabel(String date) {
    if (date.isEmpty) return '';
    final dateTime = DateTime.parse(date);
    return DateFormat('h : mm a').format(dateTime);
  }

  String _convertBookingDate(String dateTime) {
    if (dateTime.isEmpty) return '';
    final date = DateTime.parse(dateTime);
    return DateFormat('dd/MM/yyyy').format(date);
  }
}
