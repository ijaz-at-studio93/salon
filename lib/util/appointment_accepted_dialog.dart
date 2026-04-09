import 'package:flutter/material.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/text_theme.dart';

class AppointmentAcceptedDialog extends StatelessWidget {
  const AppointmentAcceptedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 32),
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
          children: [
            Text(
              'Appointment Accepted',
              textAlign: TextAlign.center,
              style: AppTextTheme.bold.copyWith(
                color: ColorConstant.blackColor,
                fontSize: 30,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Successfully',
              textAlign: TextAlign.center,
              style: AppTextTheme.bold.copyWith(
                color: ColorConstant.lightGreenColor,
                fontSize: 34,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 24),
            Image.asset(
              AssetsConstant.appointmentAcceptedGif,
              width: 80,
              height: 80,
            ),
          ],
        ),
      ),
    );
  }
}
