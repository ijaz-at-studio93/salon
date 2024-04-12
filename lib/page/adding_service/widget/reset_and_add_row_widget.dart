import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/text_theme.dart';

class ResetAndAddRowWidget extends StatefulWidget {
  final VoidCallback reset;
  final VoidCallback add;
  final String? buttonRest;
  final String? buttonAdd;
  const ResetAndAddRowWidget(
      {super.key, required this.reset, required this.add,this.buttonRest = "Reset",this.buttonAdd = "Add",});

  @override
  State<ResetAndAddRowWidget> createState() => _ResetAndAddRowWidgetState();
}

class _ResetAndAddRowWidgetState extends State<ResetAndAddRowWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: widget.reset,
              child: Container(
                height: 48,
                width: Get.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: ColorConstant.primaryColor,
                  ),
                ),
                child: Center(
                  child: Text(
                    widget.buttonRest ?? "Reset",
                    style: AppTextTheme.regular.copyWith(
                        color: ColorConstant.primaryColor, fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: widget.add,
              child: Container(
                height: 48,
                width: Get.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: ColorConstant.primaryColor,
                ),
                child: Center(
                  child: Text(
                    widget.buttonAdd ?? "Add" ,
                    style: AppTextTheme.regular
                        .copyWith(color: ColorConstant.whiteColor, fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
