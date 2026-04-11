import 'package:flutter/material.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/text_theme.dart';

class BookingRejectionInfoDialog extends StatelessWidget {
  final String reasonLabel;
  final String? note;
  final bool isSalonRejected;

  const BookingRejectionInfoDialog({
    super.key,
    required this.reasonLabel,
    this.note,
    required this.isSalonRejected,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        decoration: BoxDecoration(
          color: ColorConstant.whiteColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: ColorConstant.primaryColor2,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Title ──
            Center(
              child: Text(
                isSalonRejected
                    ? 'Reason For Rejection'
                    : 'Reason For Cancellation',
                textAlign: TextAlign.center,
                style: AppTextTheme.semibold.copyWith(
                  color: ColorConstant.primaryColor2,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 36),
            Text(
              isSalonRejected ? 'Salon Remarks:' : 'Customer Remarks:',
              textAlign: TextAlign.center,
              style: AppTextTheme.semibold.copyWith(
                color: ColorConstant.blackColor,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            // ── Selected reason row ──
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      reasonLabel,
                      style: AppTextTheme.semibold.copyWith(
                        color: ColorConstant.primaryColor2,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Custom remarks row (matches CancellationReasonDialog layout) ──
            if (note != null && note!.isNotEmpty)
              Row(
                children: [
                  _buildFilledRadio(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: ColorConstant.grayColor.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Write Your Own Remarks',
                            style: AppTextTheme.semibold.copyWith(
                              color: ColorConstant.grayTextColor,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            note!,
                            style: AppTextTheme.semibold.copyWith(
                              color: ColorConstant.blackColor,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilledRadio() {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: ColorConstant.primaryColor2,
          width: 2,
        ),
      ),
      child: Center(
        child: Container(
          width: 12,
          height: 12,
          decoration: const BoxDecoration(
            color: ColorConstant.primaryColor2,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
