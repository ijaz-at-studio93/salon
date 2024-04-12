import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/page/auth/create_new_password.dart';
import 'package:salon/project_specific/button_widget.dart';
import 'package:salon/project_specific/phone_field_widget.dart';
import 'package:salon/project_specific/simple_text_field.dart';
import 'package:salon/project_specific/text_theme.dart';

import '../../api/dio_client.dart';

class ForGotPasswordPage extends StatefulWidget {
  const ForGotPasswordPage({super.key});

  @override
  State<ForGotPasswordPage> createState() => _ForGotPasswordPageState();
}

class _ForGotPasswordPageState extends State<ForGotPasswordPage> {
  final _mobileTextEditingController = TextEditingController();
  final _otpTextEditingController = TextEditingController();
  int _start = 60;
  bool isResendOTp = false;

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.whiteColor,
      body: Column(
        children: [
          _headerWidget(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 35),
                  PhoneFieldWidget(
                      textEditingController: _mobileTextEditingController,
                      hintText: "10 digit mobile number",
                      title: "Enter Your Phone Number",
                      textInputType: TextInputType.phone,
                      textInputAction: TextInputAction.next),
                  const SizedBox(height: 15),
                  SimpleTextFieldWidget(
                      textEditingController: _otpTextEditingController,
                      hintText: "***********",
                      textInputType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      title: "OTP"),
                  Padding(
                    padding: const EdgeInsets.only(right: 20, top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        isResendOTp
                            ? TextButton(
                                onPressed: () {
                                  setState(() {
                                    _start = 60;
                                    isResendOTp = false;
                                    startTimer();
                                  });
                                },
                                child: Text(
                                  "Resend",
                                  style: AppTextTheme.medium.copyWith(
                                      color: ColorConstant.redColor,
                                      fontSize: 13),
                                ),
                              )
                            : Text(
                                "Retry in 00:${_start.toString()}",
                                style: AppTextTheme.bold.copyWith(
                                    fontSize: 14,
                                    color: ColorConstant.primaryColor),
                              )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 35),
                    child: ButtonWidget(
                        buttonTitleText: "Verify",
                        onPress: () {
                          doOtp();
                        }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /*---------- header widget ---------*/
  _headerWidget() {
    return Container(
      width: Get.width,
      height: Get.height * 0.23,
      padding: const EdgeInsets.only(top: 45, left: 21, right: 21),
      decoration: const BoxDecoration(color: ColorConstant.primaryColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  height: 34,
                  width: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ColorConstant.whiteColor,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: ColorConstant.whiteColor,
                      size: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 35),
          Text(
            "Login to \nyour Scout Account",
            style: AppTextTheme.bold
                .copyWith(color: ColorConstant.whiteColor, fontSize: 23),
          ),
        ],
      ),
    );
  }

  /*--------------  Start Timer --------------*/
  startTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          isResendOTp = true;
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  /*------------- doOtp --------*/
  doOtp() {
    if (_mobileTextEditingController.text.isEmpty) {
      showMessage("Please enter mobile number");
    } else if (_mobileTextEditingController.text.length != 10) {
      showMessage("Please enter  10 digit mobile number");
    } else if (_otpTextEditingController.text.isEmpty) {
      showMessage("Please enter Otp");
    } else {
      Get.to(()=> const CreateNewPassword());
    }
  }
}
