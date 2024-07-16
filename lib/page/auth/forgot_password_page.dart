import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/auth_controller.dart';
import 'package:salon/page/auth/create_new_password.dart';
import 'package:salon/project_specific/button_widget.dart';
import 'package:salon/project_specific/progress_container_view.dart';
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
  final _authController = Get.find<AuthController>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.whiteColor,
      body: Column(
        children: [
          _headerWidget(),
          Obx(
            () => Expanded(
              child: ProgressContainerView(
                isProgressRunning: _authController.showProgress,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 35),
                      _mobileNumberWidget(
                          textEditingController: _mobileTextEditingController,
                          hintText: "10 digit mobile number",
                          title: "Enter Your Phone Number",
                          textInputType: TextInputType.phone,
                          textInputAction: TextInputAction.next),
                      const SizedBox(height: 15),
                      isOTPField
                          ? Column(
                              children: [
                                SimpleTextFieldWidget(
                                    textEditingController:
                                        _otpTextEditingController,
                                    hintText: "***********",
                                    textInputType: TextInputType.text,
                                    textInputAction: TextInputAction.done,
                                    onChanged: (val) {
                                      if (val.length == 6) {
                                        _authController.doVerifyOtp(
                                            mobileNO:
                                                _mobileTextEditingController
                                                    .text,
                                            cc: "91",
                                            verificationCode:
                                                _otpTextEditingController.text);
                                      }
                                    },
                                    title: "OTP"),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(right: 20, top: 15),
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
                                                style: AppTextTheme.medium
                                                    .copyWith(
                                                        color: ColorConstant
                                                            .redColor,
                                                        fontSize: 13),
                                              ),
                                            )
                                          : Text(
                                              "Retry in 00:${_start.toString()}",
                                              style: AppTextTheme.bold.copyWith(
                                                  fontSize: 14,
                                                  color: ColorConstant
                                                      .primaryColor),
                                            )
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
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
        timer.cancel();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  /*-------------- Mobile  number ---------------*/
  bool isOTPButton = false;
  bool isOTPField = false;
  _mobileNumberWidget({
    required TextEditingController textEditingController,
    required String hintText,
    required String title,
    required TextInputType textInputType,
    required TextInputAction textInputAction,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
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
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    "+91",
                    style: AppTextTheme.bold.copyWith(
                        fontSize: 13, color: ColorConstant.grayTextColor),
                  ),
                ),
                const SizedBox(width: 5),
                SizedBox(
                  width: Get.width * 0.6,
                  child: TextField(
                    onChanged: (val) {
                      if (val.length == 10) {
                        setState(() {
                          isOTPButton = true;
                        });
                      } else {
                        setState(() {
                          _otpTextEditingController.clear();
                          isOTPButton = false;
                          isOTPField = false;
                        });
                      }
                    },
                    controller: textEditingController,
                    keyboardType: textInputType,
                    textInputAction: textInputAction,
                    style: AppTextTheme.medium.copyWith(
                        color: ColorConstant.blackColor, fontSize: 13),
                    maxLength: 10,
                    decoration: InputDecoration(
                        // contentPadding: const EdgeInsets.only(bottom: 2),
                        border: InputBorder.none,
                        hintText: hintText,
                        counterText: "",
                        hintStyle: AppTextTheme.medium.copyWith(
                            color: ColorConstant.grayColor, fontSize: 13)),
                  ),
                ),
                isOTPButton
                    ? TextButton(
                        onPressed: () {
                          setState(() {
                            //TODO
                            //API CALLING HEAR
                            _authController.doSendOTP(
                                mobileNo: _mobileTextEditingController.text,
                                cc: "91");
                            isOTPField = true;
                            _start = 60;
                            startTimer();
                          });
                        },
                        child: Text(
                          "Get OTP",
                          style: AppTextTheme.bold.copyWith(
                              color: ColorConstant.primaryColor, fontSize: 13),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          )
        ],
      ),
    );
  }

  /*------------- doOtp --------*/
  doOtp() {
    if (_mobileTextEditingController.text.isEmpty) {
      showMessage("Please enter mobile number");
    } else if (_mobileTextEditingController.text.length != 10) {
      showMessage("Please enter  10 digit mobile number");
    } else if (_otpTextEditingController.text.isEmpty) {
      showMessage("Please enter Otp Number");
    } else if (_otpTextEditingController.text.length != 6) {
      showMessage("Please enter 6 Digit Otp Number");
    } else {
      if (_authController
              .otpVerifyModelResponseModel.data?.isVerificationCodeValid ??
          false) {
        Get.to(() => CreateNewPassword(
              mobileNo: _mobileTextEditingController.text,
              otpNo: _otpTextEditingController.text,
            ));
      }
    }
  }
}
