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
            Center(
              child: Text(
                "Reason For Rejection",
                style: AppTextTheme.bold.copyWith(
                  color: ColorConstant.primaryColor2,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            if (widget.reasons.isNotEmpty) ...[
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 220),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: widget.reasons.map((reason) {
                      final isSelected = _selectedReasonId == reason.id;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedReasonId = reason.id;
                              _isOtherSelected = reason.isOther;
                              if (!_isOtherSelected) _noteController.clear();
                            });
                          },
                          child: Row(
                            children: [
                              _RadioCircle(
                                selected: isSelected,
                                onTap: () {
                                  setState(() {
                                    _selectedReasonId = reason.id;
                                    _isOtherSelected = reason.isOther;
                                    if (!_isOtherSelected) {
                                      _noteController.clear();
                                    }
                                  });
                                },
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  reason.label ?? '',
                                  style: AppTextTheme.medium.copyWith(
                                    color: ColorConstant.primaryColor2,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              if (_isOtherSelected) ...[
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: ColorConstant.grayColor.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _noteController,
                      autofocus: true,
                      maxLines: 2,
                      onChanged: (_) => setState(() {}),
                      style: AppTextTheme.semibold.copyWith(
                        color: ColorConstant.blackColor,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration.collapsed(
                        hintText: 'Write Your Own Remarks',
                        hintStyle: AppTextTheme.semibold.copyWith(
                          color: ColorConstant.grayTextColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (widget.reasons.isEmpty || _canConfirm)
                    ? () => widget.tapYes(
                          _selectedReasonId ?? '',
                          _isOtherSelected ? _noteController.text.trim() : null,
                        )
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstant.primaryColor2,
                  disabledBackgroundColor:
                      ColorConstant.primaryColor2.withValues(alpha: 0.4),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Confirm",
                  style: AppTextTheme.bold.copyWith(
                    color: ColorConstant.whiteColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RadioCircle extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;

  const _RadioCircle({required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: selected
                ? ColorConstant.primaryColor2
                : ColorConstant.grayColor,
            width: 2,
          ),
        ),
        child: selected
            ? Center(
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: ColorConstant.primaryColor2,
                    shape: BoxShape.circle,
                  ),
                ),
              )
            : null,
      ),
    );
  }
}
