import 'package:flutter/material.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/text_theme.dart';

class CustomTabItem {
  final String value;
  final String label;

  const CustomTabItem({required this.value, required this.label});
}

class CustomTabBar extends StatelessWidget {
  final List<CustomTabItem> tabs;
  final String selectedValue;
  final ValueChanged<String> onChanged;

  final double horizontalMargin;

  final double verticalMargin;

  const CustomTabBar({
    super.key,
    required this.tabs,
    required this.selectedValue,
    required this.onChanged,
    this.horizontalMargin = 20,
    this.verticalMargin = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: horizontalMargin, vertical: verticalMargin),
      decoration: BoxDecoration(
        color: ColorConstant.whiteColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: ColorConstant.grayTextColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: tabs
            .map((tab) => _TabItem(
                  tab: tab,
                  isSelected: selectedValue == tab.value,
                  onTap: () => onChanged(tab.value),
                ))
            .toList(),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final CustomTabItem tab;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabItem({
    required this.tab,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: isSelected
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(
                    color: ColorConstant.primaryColor,
                    width: 1,
                  ),
                )
              : null,
          child: Center(
            child: Text(
              tab.label,
              style: AppTextTheme.bold.copyWith(
                fontSize: 13,
                color: ColorConstant.blackColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
