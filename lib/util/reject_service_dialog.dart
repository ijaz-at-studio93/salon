import 'package:flutter/material.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/model/service_model/rejection_reason_model.dart';
import 'package:salon/project_specific/text_theme.dart';

class RejectServiceDiaLog extends StatefulWidget {
  final List<RejectionReason> reasons;
  final VoidCallback tapNo;
  final Function(String reasonId) tapYes;

  const RejectServiceDiaLog({
    super.key,
    required this.reasons,
    required this.tapNo,
    required this.tapYes,
  });

  @override
  State<RejectServiceDiaLog> createState() => _RejectServiceDiaLogState();
}

class _RejectServiceDiaLogState extends State<RejectServiceDiaLog> {
  String? _selectedReasonId;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(
                Icons.cancel_outlined,
                color: ColorConstant.redColor,
                size: 32,
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                "Reject Booking",
                style: AppTextTheme.bold
                    .copyWith(fontSize: 16, color: ColorConstant.blackColor),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                "Please select a reason for rejection.",
                style: AppTextTheme.medium
                    .copyWith(fontSize: 13, color: ColorConstant.blackColor),
                textAlign: TextAlign.center,
              ),
            ),
            if (widget.reasons.isNotEmpty) ...[
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 240),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: widget.reasons.map((reason) {
                      return RadioListTile<String>(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          reason.reason ?? '',
                          style: AppTextTheme.medium.copyWith(fontSize: 13),
                        ),
                        value: reason.id ?? '',
                        groupValue: _selectedReasonId,
                        activeColor: ColorConstant.primaryColor,
                        onChanged: (val) {
                          setState(() => _selectedReasonId = val);
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: widget.tapNo,
                  child: Text(
                    "Cancel",
                    style: AppTextTheme.bold
                        .copyWith(color: ColorConstant.redColor, fontSize: 15),
                  ),
                ),
                TextButton(
                  onPressed: widget.reasons.isEmpty || _selectedReasonId != null
                      ? () => widget.tapYes(_selectedReasonId ?? '')
                      : null,
                  child: Text(
                    "Reject",
                    style: AppTextTheme.bold.copyWith(
                      color: widget.reasons.isEmpty || _selectedReasonId != null
                          ? ColorConstant.primaryColor
                          : Colors.grey,
                      fontSize: 15,
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
}
