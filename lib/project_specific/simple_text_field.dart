import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salon/project_specific/text_theme.dart';
import '../constant/color_constant.dart';

class SimpleTextFieldWidget extends StatefulWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final String title;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onChanged;
  final double horizontalPadding;
  final int? maxLength;
  final bool showCounter;
  final List<TextInputFormatter>? inputFormatters;

  const SimpleTextFieldWidget(
      {super.key,
      required this.textEditingController,
      required this.hintText,
      required this.textInputType,
      required this.textInputAction,
      required this.title,
      this.onChanged,
      this.horizontalPadding = 20,
      this.maxLength,
      this.showCounter = false,
      this.inputFormatters});

  @override
  State<SimpleTextFieldWidget> createState() => _SimpleTextFieldWidgetState();
}

class _SimpleTextFieldWidgetState extends State<SimpleTextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: AppTextTheme.regular
                .copyWith(fontSize: 13, color: ColorConstant.blackColor),
          ),
          const SizedBox(height: 12),
          Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: ColorConstant.borderColor,
                ),
              ),
              child: TextField(
                onChanged: widget.onChanged,
                controller: widget.textEditingController,
                keyboardType: widget.textInputType,
                textInputAction: widget.textInputAction,
                maxLength: widget.maxLength,
                inputFormatters: widget.inputFormatters,
                style: AppTextTheme.medium
                    .copyWith(color: ColorConstant.blackColor, fontSize: 13),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 12),
                    border: InputBorder.none,
                    hintText: widget.hintText,
                    counterText:
                        widget.showCounter ? null : (widget.maxLength != null ? "" : null),
                    hintStyle: AppTextTheme.medium.copyWith(
                        color: ColorConstant.grayColor, fontSize: 13)),
              )),
        ],
      ),
    );
  }
}
