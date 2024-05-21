import 'package:flutter/material.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/text_theme.dart';

class TimeSlotWidget extends StatefulWidget {
  final bool isSelected;
  final VoidCallback onPress;
  const TimeSlotWidget(
      {super.key, required this.isSelected, required this.onPress});

  @override
  State<TimeSlotWidget> createState() => _TimeSlotWidgetState();
}

class _TimeSlotWidgetState extends State<TimeSlotWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPress,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 45),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
              color: widget.isSelected
                  ? ColorConstant.primaryColor
                  : ColorConstant.borderColor2),
        ),
        child: Center(
          child: Text(
            "+15 Min",
            style: AppTextTheme.medium.copyWith(
                fontSize: 13,
                color: widget.isSelected
                    ? ColorConstant.primaryColor
                    : ColorConstant.blackColor),
          ),
        ),
      ),
    );
  }
}
