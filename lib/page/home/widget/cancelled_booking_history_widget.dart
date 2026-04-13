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
    fontSize: 14,
  );

  @override
  Widget build(BuildContext context) {
    final o = widget.orderData;
    final idx = o.idx?.trim() ?? '';
    final dateSource = (o.finalizedAt != null && o.finalizedAt!.isNotEmpty)
        ? o.finalizedAt!
        : (o.appointment?.startsAt ?? '');
    final dateStr = _convertBookingDate(dateSource);
    final timeStr = _formatTimeLabel(o.appointment?.startsAt ?? '');
    final stylistName = o.appointment?.artist?.name ?? '';
    final priceStr = '₹${o.orderAmount?.toStringAsFixed(0) ?? '0'}';

    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: ColorConstant.whiteColor,
        border: Border.all(
          color: ColorConstant.bookingCardBorderPurple,
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: ColorConstant.bookingShadow,
            offset: Offset(0, 2),
            blurRadius: 6,
            spreadRadius: 0,
          ),
        ],
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
                  const SizedBox(height: 8),
                ],
                _inlineLabelValue(
                  label: 'Date : ',
                  value: dateStr,
                  valueColor: ColorConstant.bookingValuePurple,
                ),
                const SizedBox(height: 8),
                _inlineLabelValue(
                  label: 'Stylist : ',
                  value: stylistName,
                  valueColor: ColorConstant.bookingValuePurple,
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    style: AppTextTheme.bold.copyWith(
                      fontSize: 14,
                      color: ColorConstant.bookingPriceMagenta,
                    ),
                    children: [
                      const TextSpan(
                        text: 'Price : ',
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
              const SizedBox(height: 10),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Status : ', style: _labelStyle.copyWith(fontSize: 13)),
                  Text(
                    'Cancelled',
                    style: AppTextTheme.bold.copyWith(
                      fontSize: 13,
                      color: ColorConstant.bookingStatusCancelled,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
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
            style: _labelStyle.copyWith(fontSize: 13),
            children: [
              TextSpan(text: label),
              TextSpan(
                text: value,
                style: AppTextTheme.bold.copyWith(
                  fontSize: 13,
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
          Text(label, style: _labelStyle.copyWith(fontSize: 13)),
          SizedBox(
            width: maxValueWidth,
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextTheme.bold.copyWith(
                fontSize: 13,
                color: valueColor,
              ),
            ),
          ),
        ],
      );
    }

    return RichText(
      text: TextSpan(
        style: _labelStyle.copyWith(fontSize: 13),
        children: [
          TextSpan(
            text: label,
            style: AppTextTheme.semibold.copyWith(
              fontSize: 13,
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: value,
            style: AppTextTheme.bold.copyWith(
              fontSize: 13,
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
              fontSize: 16,
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
    return DateFormat('MM/dd/yyyy').format(date);
  }
}
