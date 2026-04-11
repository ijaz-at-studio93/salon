import 'package:flutter/material.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/model/service_model/rejection_reason_model.dart';
import 'package:salon/project_specific/text_theme.dart';

class RejectServiceDiaLog extends StatefulWidget {
  final List<RejectionReason> reasons;
  final VoidCallback tapNo;

  /// [reasonId] is the selected reason's UUID.
  /// [note] is only non-null when the salon typed a custom reason (OTHER selected).
  final Function(String reasonId, String? note) tapYes;

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
  bool _isOtherSelected = false;
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  bool get _canConfirm {
    if (_selectedReasonId == null) return false;
    if (_isOtherSelected && _noteController.text.trim().isEmpty) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
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
                constraints: const BoxConstraints(maxHeight: 220),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: widget.reasons.map((reason) {
                      return RadioListTile<String>(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          reason.label ?? '',
                          style: AppTextTheme.medium.copyWith(fontSize: 13),
                        ),
                        value: reason.id ?? '',
                        groupValue: _selectedReasonId,
                        activeColor: ColorConstant.primaryColor,
                        onChanged: (val) {
                          setState(() {
                            _selectedReasonId = val;
                            _isOtherSelected = reason.isOther;
                            if (!_isOtherSelected) _noteController.clear();
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
              if (_isOtherSelected) ...[
                const SizedBox(height: 8),
                TextField(
                  controller: _noteController,
                  maxLines: 2,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Enter your reason...',
                    hintStyle: AppTextTheme.medium
                        .copyWith(fontSize: 13, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  style: AppTextTheme.medium.copyWith(fontSize: 13),
                ),
              ],
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
                  onPressed: (widget.reasons.isEmpty || _canConfirm)
                      ? () => widget.tapYes(
                            _selectedReasonId ?? '',
                            _isOtherSelected
                                ? _noteController.text.trim()
                                : null,
                          )
                      : null,
                  child: Text(
                    "Reject",
                    style: AppTextTheme.bold.copyWith(
                      color: (widget.reasons.isEmpty || _canConfirm)
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
