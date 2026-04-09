import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/text_theme.dart';

class PasswordTextFieldWidget extends StatefulWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final String title;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  const PasswordTextFieldWidget(
      {super.key,
      required this.textEditingController,
      required this.hintText,
      required this.textInputType,
      required this.textInputAction,
      required this.title});

  @override
  State<PasswordTextFieldWidget> createState() =>
      _PasswordTextFieldWidgetState();
}

class _PasswordTextFieldWidgetState extends State<PasswordTextFieldWidget> {
  bool _isPasswordShow = true;

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
                    obscuringCharacter: '•',
                    obscureText: _isPasswordShow,
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
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isPasswordShow = !_isPasswordShow;
                    });
                  },
                  child: Icon(
                    _isPasswordShow
                        ? CupertinoIcons.eye_slash_fill
                        : CupertinoIcons.eye,
                    color: ColorConstant.grayTextColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
