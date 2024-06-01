import 'package:flutter/material.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/text_theme.dart';

class PortfolioPermissionDialog extends StatefulWidget {
  final VoidCallback cancel;
  final VoidCallback yes;
  const PortfolioPermissionDialog(
      {super.key, required this.cancel, required this.yes});

  @override
  State<PortfolioPermissionDialog> createState() =>
      _PortfolioPermissionDialogState();
}

class _PortfolioPermissionDialogState extends State<PortfolioPermissionDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.photo,
              color: ColorConstant.primaryColor,
              size: 35,
            ),
            const SizedBox(height: 15),
            Text(
              "Are you Ready ?",
              style: AppTextTheme.bold
                  .copyWith(color: ColorConstant.blackColor, fontSize: 16),
            ),
            const SizedBox(height: 15),
            Text(
              "Capture Your Customer Service Image And Upload",
              style: AppTextTheme.medium
                  .copyWith(color: ColorConstant.blackColor, fontSize: 12),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: widget.cancel,
                  child: Text(
                    "No",
                    style: AppTextTheme.medium
                        .copyWith(color: ColorConstant.redColor, fontSize: 18),
                  ),
                ),
                TextButton(
                  onPressed: widget.yes,
                  child: Text(
                    "Yes",
                    style: AppTextTheme.medium.copyWith(
                        color: ColorConstant.primaryColor, fontSize: 18),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
