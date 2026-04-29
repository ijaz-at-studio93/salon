import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/text_theme.dart';

/// White elevated card: customer name + time, date + services, optional View button.
class StylistAppointmentOverviewCard extends StatelessWidget {
  final String customerName;
  final String startTimeIso;
  final int serviceCount;
  final VoidCallback? onView;

  const StylistAppointmentOverviewCard({
    super.key,
    required this.customerName,
    required this.startTimeIso,
    required this.serviceCount,
    this.onView,
  });

  String _formatTime() {
    if (startTimeIso.isEmpty) return '--';
    try {
      return DateFormat('h:mm a').format(DateTime.parse(startTimeIso));
    } catch (_) {
      return '--';
    }
  }

  String _formatDate() {
    if (startTimeIso.isEmpty) return '--';
    try {
      return DateFormat('dd/MM/yyyy').format(DateTime.parse(startTimeIso));
    } catch (_) {
      return '--';
    }
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = AppTextTheme.bold.copyWith(
      color: ColorConstant.blackColor,
      fontSize: 14,
    );
    final nameTimeStyle = AppTextTheme.bold.copyWith(
      color: ColorConstant.appointmentCardNameTime,
      fontSize: 16,
    );
    final dateServicesStyle = AppTextTheme.bold.copyWith(
      color: ColorConstant.appointmentCardDateServices,
      fontSize: 20,
    );

    final displayName =
        customerName.trim().isEmpty ? '--' : customerName.trim();

    return Material(
      color: ColorConstant.whiteColor,
      elevation: 1,
      borderRadius: BorderRadius.circular(5),
      clipBehavior: Clip.antiAlias,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: Colors.black.withValues(alpha: 0.10),
            ),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: 'Customer Name : ', style: labelStyle),
                        TextSpan(text: displayName, style: nameTimeStyle),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _formatTime(),
                  style: nameTimeStyle,
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: 'Date : ', style: labelStyle),
                        TextSpan(text: _formatDate(), style: dateServicesStyle),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'Services : ', style: labelStyle),
                      TextSpan(
                        text: '$serviceCount',
                        style: dateServicesStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (onView != null) ...[
              const SizedBox(height: 16),
              Material(
                color: ColorConstant.appointmentCardViewButton,
                borderRadius: BorderRadius.circular(24),
                child: InkWell(
                  onTap: onView,
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    height: 40,
                    decoration: ShapeDecoration(
                      color: const Color(0xFF8454E5),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1,
                          color: Color(0xFF8454E5),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'View',
                        style: AppTextTheme.bold.copyWith(
                          color: ColorConstant.whiteColor,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
