import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/text_theme.dart';

class PlusIconSimpleTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final String title;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final bool readOnly;
  final GestureTapCallback onTap;
  const PlusIconSimpleTextField(
      {super.key,
      required this.textEditingController,
      required this.hintText,
      required this.title,
      required this.textInputType,
      required this.textInputAction, required this.readOnly, required this.onTap});

  @override
  State<PlusIconSimpleTextField> createState() =>
      _PlusIconSimpleTextFieldState();
}

class _PlusIconSimpleTextFieldState extends State<PlusIconSimpleTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: ColorConstant.borderColor,
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: Get.width * 0.8,
                    child: TextField(
                      onTap: widget.onTap,
                      readOnly: widget.readOnly,
                      canRequestFocus: false,
                      controller: widget.textEditingController,
                      keyboardType: widget.textInputType,
                      textInputAction: widget.textInputAction,
                      style: AppTextTheme.medium.copyWith(
                          color: ColorConstant.blackColor, fontSize: 13),
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(left: 12),
                          border: InputBorder.none,
                          hintText: widget.hintText,
                          hintStyle: AppTextTheme.medium.copyWith(
                              color: ColorConstant.grayColor, fontSize: 13)),
                    ),
                  ),
                  Icon(
                    Icons.add,
                    color: ColorConstant.idColor,
                  )
                ],
              )),
        ],
      ),
    );
  }
}
