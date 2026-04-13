import 'package:flutter/material.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/text_theme.dart';

class PaymentInstructionDialog extends StatelessWidget {
  const PaymentInstructionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: BoxDecoration(
          color: ColorConstant.whiteColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: ColorConstant.primaryColor2,
            width: 2,
          ),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _InstructionText(
              'Tell the complete Bill Amount to the customer after the Service',
            ),
            SizedBox(height: 24),
            _InstructionText(
              'Ask them to enter the Amount in the App & Pay it.',
            ),
            SizedBox(height: 24),
            _InstructionText(
              'Check the Payment In the Customer Phone',
            ),
          ],
        ),
      ),
    );
  }
}

class _InstructionText extends StatelessWidget {
  final String text;

  const _InstructionText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: AppTextTheme.bold.copyWith(
        color: ColorConstant.primaryColor2,
        fontSize: 22,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}
