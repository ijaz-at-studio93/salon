import 'package:flutter/material.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/text_theme.dart';

class CancellationReasonDialog extends StatefulWidget {
  const CancellationReasonDialog({super.key});

  @override
  State<CancellationReasonDialog> createState() =>
      _CancellationReasonDialogState();
}

class _CancellationReasonDialogState extends State<CancellationReasonDialog> {
  static const List<String> _predefinedReasons = [
    'Stylist Not Available',
    'Slot Not Available',
    'Salon is Completely Occupied',
  ];

  int _selectedIndex = 0;
  final TextEditingController _remarksController = TextEditingController();

  /// -1 = custom remark option index
  static const int _customIndex = 3;

  @override
  void dispose() {
    _remarksController.dispose();
    super.dispose();
  }

  String get _selectedReason {
    if (_selectedIndex == _customIndex) {
      return _remarksController.text.trim();
    }
    return _predefinedReasons[_selectedIndex];
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
            // ── Title ──
            Center(
              child: Text(
                'Reason For Cancellation',
                textAlign: TextAlign.center,
                style: AppTextTheme.bold.copyWith(
                  color: ColorConstant.primaryColor2,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Predefined radio options ──
            ..._predefinedReasons.asMap().entries.map((entry) {
              final idx = entry.key;
              final label = entry.value;
              return _RadioOption(
                label: label,
                selected: _selectedIndex == idx,
                onTap: () => setState(() => _selectedIndex = idx),
              );
            }),

            // ── Custom remark option ──
            Row(
              children: [
                _RadioCircle(
                  selected: _selectedIndex == _customIndex,
                  onTap: () => setState(() => _selectedIndex = _customIndex),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedIndex = _customIndex),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: ColorConstant.grayColor.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _selectedIndex == _customIndex
                          ? TextField(
                              controller: _remarksController,
                              autofocus: true,
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
                            )
                          : Text(
                              _remarksController.text.isEmpty
                                  ? 'Write Your Own Remarks'
                                  : _remarksController.text,
                              style: AppTextTheme.semibold.copyWith(
                                color: ColorConstant.grayTextColor,
                                fontSize: 14,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── Confirm button ──
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(_selectedReason);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstant.primaryColor2,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Confirm',
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

// ── Helpers ──────────────────────────────────────────────────────────────────

class _RadioOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _RadioOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          _RadioCircle(selected: selected, onTap: onTap),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onTap,
            child: Text(
              label,
              style: AppTextTheme.medium.copyWith(
                color: ColorConstant.primaryColor2,
                fontSize: 15,
              ),
            ),
          ),
        ],
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
