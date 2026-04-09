import 'package:flutter/material.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/text_theme.dart';

class RejectServiceDiaLog extends StatefulWidget {
  final VoidCallback tapNo;
  final VoidCallback tapYes;

  const RejectServiceDiaLog(
      {super.key, required this.tapNo, required this.tapYes});

  @override
  State<RejectServiceDiaLog> createState() => _RejectServiceDiaLogState();
}

class _RejectServiceDiaLogState extends State<RejectServiceDiaLog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            const Icon(
              Icons.delete,
              color: ColorConstant.redColor,
            ),
            const SizedBox(height: 10),
            Text(
              "Are you sure?",
              style: AppTextTheme.bold
                  .copyWith(fontSize: 16, color: ColorConstant.blackColor),
            ),
            const SizedBox(height: 15),
            Text(
              "You want to reject this booking appointment.",
              style: AppTextTheme.medium
                  .copyWith(fontSize: 14, color: ColorConstant.blackColor),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: widget.tapNo,
                  child: Text(
                    "No",
                    style: AppTextTheme.bold
                        .copyWith(color: ColorConstant.redColor, fontSize: 16),
                  ),
                ),
                TextButton(
                  onPressed: widget.tapYes,
                  child: Text(
                    "Yes",
                    style: AppTextTheme.bold.copyWith(
                        color: ColorConstant.primaryColor, fontSize: 16),
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
