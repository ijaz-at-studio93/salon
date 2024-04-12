import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/api/dio_client.dart';
import 'package:salon/project_specific/button_widget.dart';
import 'package:salon/project_specific/simple_text_field.dart';
import 'package:salon/project_specific/text_theme.dart';

import '../../constant/color_constant.dart';
import '../profile/complete_profile_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _yourNameTextEditingController = TextEditingController();
  final _saloonNameTextEditingController = TextEditingController();
  final _saloonAddressTextEditingController = TextEditingController();
  final _emailTextEditingController = TextEditingController();
  final _mobileTextEditingController = TextEditingController();
  final _otpTextEditingController = TextEditingController();
  int _start = 60;

  bool isResendOTp = false;
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
                  const SizedBox(height: 10),
                  SimpleTextFieldWidget(
                      textEditingController: _yourNameTextEditingController,
                      hintText: "Enter Here",
                      textInputType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      title: "Your Name"),
                  const SizedBox(height: 20),
                  SimpleTextFieldWidget(
                      textEditingController: _saloonNameTextEditingController,
                      hintText: "Enter Here",
                      textInputType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      title: "Saloon Name"),
                  const SizedBox(height: 20),
                  _saloonAddress(
                      textEditingController:
                          _saloonAddressTextEditingController,
                      hintText: "address",
                      textInputType: TextInputType.text,
                      textInputAction: TextInputAction.none,
                      title: "Your Saloon Address"),
                  const SizedBox(height: 20),
                  _noOfServiceYouOffer(),
                  const SizedBox(height: 20),
                  _noOfEmploys(),
                  const SizedBox(height: 20),
                  SimpleTextFieldWidget(
                      textEditingController: _emailTextEditingController,
                      hintText: "example@gmail.com",
                      textInputType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      title: "Email Id"),
                  const SizedBox(height: 20),
                  _mobileNumberWidget(
                      textEditingController: _mobileTextEditingController,
                      hintText: "",
                      textInputType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      title: "Mobile Number"),
                  const SizedBox(height: 20),
                  isOTPField
                      ? Column(
                          children: [
                            SimpleTextFieldWidget(
                                textEditingController:
                                    _otpTextEditingController,
                                hintText: "",
                                textInputType: TextInputType.number,
                                textInputAction: TextInputAction.done,
                                title: "Enter OTP"),
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
                                            style: AppTextTheme.bold.copyWith(
                                                fontSize: 16,
                                                color: ColorConstant.redColor),
                                          ))
                                      : Text(
                                          "Retry in 00:${_start.toString()}",
                                          style: AppTextTheme.bold.copyWith(
                                              fontSize: 16,
                                              color: ColorConstant.redColor),
                                        ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ButtonWidget(
                        buttonTitleText: "Done",
                        onPress: () {
                          _doRegister();
                        }),
                  ),
                  const SizedBox(height: 30),
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
      padding: const EdgeInsets.only(top: 50, left: 21, right: 21, bottom: 35),
      decoration: const BoxDecoration(color: ColorConstant.primaryColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 35),
          Text(
            "Register Yourself",
            style: AppTextTheme.bold
                .copyWith(color: ColorConstant.whiteColor, fontSize: 23),
          ),
          const SizedBox(height: 10),
          Text(
            "Fill Your Basic Details",
            style: AppTextTheme.regular
                .copyWith(color: ColorConstant.whiteColor, fontSize: 16),
          )
        ],
      ),
    );
  }

  /*------------ Saloon Address TextField -----------*/
  _saloonAddress({
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
              height: 110,
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: ColorConstant.borderColor,
                ),
              ),
              child: TextField(
                controller: textEditingController,
                maxLines: 8,
                keyboardType: textInputType,
                textInputAction: textInputAction,
                style: AppTextTheme.medium
                    .copyWith(color: ColorConstant.blackColor, fontSize: 13),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 12, top: 15),
                    border: InputBorder.none,
                    hintText: hintText,
                    hintStyle: AppTextTheme.medium.copyWith(
                        color: ColorConstant.grayColor, fontSize: 13)),
              )),
        ],
      ),
    );
  }

  /*--------------- Dummy Data ---------*/
  final List<String> noOfService = [
    '<50',
    '<60',
    '<70',
    '<80',
    '<90',
  ];

  final List<String> noOfEmp = [
    '<50',
    '<60',
    '<70',
    '<80',
    '<90',
  ];

  /*--------------------- No. Of Service You Offer ------------------*/
  _noOfServiceYouOffer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "No. Of Service You Offer",
            style: AppTextTheme.regular
                .copyWith(fontSize: 13, color: ColorConstant.blackColor),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField2<String>(
            isExpanded: true,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            hint: Text(
              '<50',
              style: AppTextTheme.medium
                  .copyWith(color: ColorConstant.grayColor, fontSize: 13),
            ),
            items: noOfService
                .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item,
                          style: AppTextTheme.medium.copyWith(
                              color: ColorConstant.blackColor, fontSize: 13)),
                    ))
                .toList(),
            validator: (value) {
              if (value == null) {
                return '<50';
              }
              return null;
            },
            onChanged: (value) {
              //Do something when selected item is changed.
            },
            onSaved: (value) {
              /* selectedValue = value.toString();*/
            },
            buttonStyleData: const ButtonStyleData(
              padding: EdgeInsets.only(right: 8),
            ),
            iconStyleData: const IconStyleData(
              icon: Icon(
                Icons.arrow_drop_down,
                color: Colors.black45,
              ),
              iconSize: 24,
            ),
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              padding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ],
      ),
    );
  }

  /*------------------- No. of Employs --------------------*/
  _noOfEmploys() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "No. of Employs",
            style: AppTextTheme.regular
                .copyWith(fontSize: 13, color: ColorConstant.blackColor),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField2<String>(
            isExpanded: true,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            hint: Text(
              '<50',
              style: AppTextTheme.medium
                  .copyWith(color: ColorConstant.grayColor, fontSize: 13),
            ),
            items: noOfEmp
                .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item,
                          style: AppTextTheme.medium.copyWith(
                              color: ColorConstant.blackColor, fontSize: 13)),
                    ))
                .toList(),
            validator: (value) {
              if (value == null) {
                return '<50';
              }
              return null;
            },
            onChanged: (value) {
              //Do something when selected item is changed.
            },
            onSaved: (value) {
              /* selectedValue = value.toString();*/
            },
            buttonStyleData: const ButtonStyleData(
              padding: EdgeInsets.only(right: 8),
            ),
            iconStyleData: const IconStyleData(
              icon: Icon(
                Icons.arrow_drop_down,
                color: Colors.black45,
              ),
              iconSize: 24,
            ),
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              padding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ],
      ),
    );
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

  /*--------------------  Do Register --------------*/
  _doRegister() {
    if (_yourNameTextEditingController.text.isEmpty) {
      showMessage("Please enter your name");
      return;
    } else if (_saloonNameTextEditingController.text.isEmpty) {
      showMessage("Please enter saloon name");
      return;
    } else if (_saloonAddressTextEditingController.text.isEmpty) {
      showMessage("Please enter saloon address");
      return;
    } else if (_emailTextEditingController.text.isEmpty) {
      showMessage("Please enter email address");
      return;
    } else {
      final bool emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(_emailTextEditingController.text);
      if (!emailValid) {
        showMessage("Please enter valid email address");
        return;
      } else if (_mobileTextEditingController.text.isEmpty) {
        showMessage("Please enter mobile no");
        return;
      } else if (_mobileTextEditingController.text.length != 10) {
        showMessage("Please enter 10 digit mobile no");
        return;
      } else if (_otpTextEditingController.text.isEmpty) {
        showMessage("Please enter otp");
        return;
      } else if (_otpTextEditingController.text.length != 6) {
        showMessage("Please enter 6 digit otp");
        return;
      } else {
        Get.to(()=> const CompleteProfilePage());
      }
    }
  }
}
