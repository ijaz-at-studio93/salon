import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/auth_controller.dart';
import 'package:salon/project_specific/text_theme.dart';

class LogOutDialogWidget extends StatefulWidget {
  const LogOutDialogWidget({super.key});

  @override
  State<LogOutDialogWidget> createState() => _LogOutDialogWidgetState();
}

class _LogOutDialogWidgetState extends State<LogOutDialogWidget> {
  final _authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AssetsConstant.logout,
              height: 24,
              width: 24,
            ),
            Text(
              "Are You Sure?",
              style: AppTextTheme.bold
                  .copyWith(color: ColorConstant.blackColor, fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              "Do you want to  Logout?",
              style: AppTextTheme.medium
                  .copyWith(color: ColorConstant.grayTextColor, fontSize: 16),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    "Cancel",
                    style: AppTextTheme.medium
                        .copyWith(color: ColorConstant.redColor, fontSize: 16),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _authController.resetApp();
                    Get.back();
                  },
                  child: Text(
                    "Done",
                    style: AppTextTheme.medium.copyWith(
                        color: ColorConstant.primaryColor, fontSize: 16),
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
