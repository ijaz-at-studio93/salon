import 'dart:async';
import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/api/dio_client.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/controller/auth_controller.dart';
import 'package:salon/page/bottom_bar_page.dart';
import 'package:salon/page/location_pick/location_pick.dart';
import 'package:salon/project_specific/button_widget.dart';
import 'package:salon/project_specific/password_text_field.dart';
import 'package:salon/project_specific/phone_field_widget.dart';
import 'package:salon/project_specific/progress_container_view.dart';
import 'package:salon/project_specific/simple_text_field.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:salon/util/pick_image.dart';
import '../../constant/color_constant.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _yourName = TextEditingController();
  final _describe = TextEditingController();
  final _email = TextEditingController();
  final _mobile = TextEditingController();
  final _address = TextEditingController();
  final _ownerName = TextEditingController();
  final _ownerEmail = TextEditingController();
  final _ownerMobile = TextEditingController();
  final _password = TextEditingController();
  final _verificationCode = TextEditingController();
  final _description = TextEditingController();
  String serviceOfferSlab = "";
  String employeeSlab = "";
  double geolocationLat = 0.0;
  double geolocationLng = 0.0;
  final _authController = Get.find<AuthController>();
  int _start = 60;

  bool isResendOTp = false;

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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Text(
                          "Salon Detail",
                          style: AppTextTheme.bold.copyWith(
                              color: ColorConstant.blackColor, fontSize: 16),
                        ),
                      ),
                      SimpleTextFieldWidget(
                          textEditingController: _yourName,
                          hintText: "Enter Here",
                          textInputType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          title: "Name"),
                      const SizedBox(height: 20),
                      _saloonAddress(
                          onTap: () {},
                          textEditingController: _describe,
                          hintText: "describe",
                          textInputType: TextInputType.text,
                          textInputAction: TextInputAction.none,
                          title: "Describe"),
                      const SizedBox(height: 20),
                      SimpleTextFieldWidget(
                          textEditingController: _email,
                          hintText: "example@gmail.com",
                          textInputType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          title: "Email Id"),
                      const SizedBox(height: 20),
                      _mobileNumberWidget(
                          textEditingController: _mobile,
                          hintText: "Enter Here",
                          textInputType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          title: "Mobile No"),
                      const SizedBox(height: 20),
                      isOTPField
                          ? Column(
                              children: [
                                SimpleTextFieldWidget(
                                    onChanged: (val) {
                                      if (val.length == 6) {
                                        _authController.doVerifyOtp(
                                            mobileNO: _mobile.text,
                                            cc: "91",
                                            verificationCode: val);
                                      }
                                    },
                                    textEditingController: _verificationCode,
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
                                                  _authController.doSendOTP(
                                                      mobileNo: _mobile.text,
                                                      cc: "91");
                                                  _verificationCode.clear();
                                                });
                                              },
                                              child: Text(
                                                "Resend",
                                                style: AppTextTheme.bold
                                                    .copyWith(
                                                        fontSize: 16,
                                                        color: ColorConstant
                                                            .redColor),
                                              ))
                                          : Text(
                                              "Retry in 00:${_start.toString()}",
                                              style: AppTextTheme.bold.copyWith(
                                                  fontSize: 16,
                                                  color:
                                                      ColorConstant.redColor),
                                            ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                      _saloonAddress(
                          onTap: () {
                            Get.to(() => LocationPickPage(
                                  callback: () {
                                    _address.text =
                                        _authController.salonCurrentAddress;
                                  },
                                ));
                          },
                          textEditingController: _address,
                          hintText: "address",
                          textInputType: TextInputType.text,
                          textInputAction: TextInputAction.none,
                          title: "Address"),
                      const SizedBox(height: 20),
                      _homeService(),
                      const SizedBox(height: 20),
                      _salonType(),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Text(
                          "Owner Detail",
                          style: AppTextTheme.bold.copyWith(
                              color: ColorConstant.blackColor, fontSize: 16),
                        ),
                      ),
                      SimpleTextFieldWidget(
                          textEditingController: _ownerName,
                          hintText: "Enter Here",
                          textInputType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          title: "Owner Name"),
                      const SizedBox(height: 20),
                      SimpleTextFieldWidget(
                          textEditingController: _ownerEmail,
                          hintText: "example@gmail.com",
                          textInputType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          title: "Owner Email-Id"),
                      const SizedBox(height: 20),
                      PhoneFieldWidget(
                          textEditingController: _ownerMobile,
                          hintText: "Enter Here",
                          textInputType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          title: "Owner Mobile Number"),
                      const SizedBox(height: 20),
                      PasswordTextFieldWidget(
                          textEditingController: _password,
                          hintText: "***********",
                          textInputType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          title: "Password"),
                      const SizedBox(height: 20),
                      _noOfServiceYouOffer(),
                      const SizedBox(height: 20),
                      _noOfEmploys(),
                      const SizedBox(height: 20),
                      _salonImage(),
                      const SizedBox(height: 20),
                      _saloonAddress(
                          onTap: () {},
                          textEditingController: _description,
                          hintText: "Enter Here",
                          textInputType: TextInputType.text,
                          textInputAction: TextInputAction.none,
                          title: "Description"),
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
    required VoidCallback onTap,
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
                onTap: onTap,
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

  /*------------ is Home Service --------------*/
  int serviceSelect = 0;

  _homeService() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Provide Service",
            style: AppTextTheme.regular
                .copyWith(fontSize: 13, color: ColorConstant.blackColor),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: 50,
          width: Get.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    serviceSelect = 0;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorConstant.blackColor),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              color: serviceSelect == 0
                                  ? ColorConstant.primaryColor
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Home",
                        style: AppTextTheme.regular.copyWith(
                            fontSize: 13, color: ColorConstant.blackColor),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    serviceSelect = 1;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorConstant.blackColor),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              color: serviceSelect == 1
                                  ? ColorConstant.primaryColor
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Salon",
                        style: AppTextTheme.regular.copyWith(
                            fontSize: 13, color: ColorConstant.blackColor),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    serviceSelect = 2;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorConstant.blackColor),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              color: serviceSelect == 2
                                  ? ColorConstant.primaryColor
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Both",
                        style: AppTextTheme.regular.copyWith(
                            fontSize: 13, color: ColorConstant.blackColor),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          /*decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: ColorConstant.borderColor,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              */ /*Text(
                "Is home service",
                style: AppTextTheme.regular
                    .copyWith(fontSize: 13, color: ColorConstant.blackColor),
              ),
              CupertinoSwitch(
                activeColor: ColorConstant.primaryColor,
                value: isHomeServiceEnable,
                onChanged: (value) {
                  setState(() {
                    isHomeServiceEnable =
                        value; // Update the CupertinoSwitch state
                  });
                },
              ),*/ /*
            ],
          ),*/
        ),
      ],
    );
  }

  /*--------------- Dummy Data ---------*/

  final List<String> noOfService = [
    'less than 10',
    '10-20',
    '20-30',
    '30-40',
    '40-50',
    'more than 50'
  ];

  final List<String> noOfEmp = [
    'less than 5',
    '5-10',
    '10-15',
    '15-20',
    'more than 20',
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
              serviceOfferSlab = value!;
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
              employeeSlab = value ?? "";
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
                          _verificationCode.clear();
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
                            _authController.doSendOTP(
                                mobileNo: _mobile.text, cc: "91");
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

  /*----------------- Service Image --------------*/
  File imagePath = File("");

  _salonImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Salon Image ",
            style: AppTextTheme.regular
                .copyWith(fontSize: 13, color: ColorConstant.blackColor),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              FileUtils.openPlatformImagePicker(onSelectImage: (file) {
                setState(() {
                  imagePath = file;
                });
              });
            },
            child: Container(
              height: 165,
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: ColorConstant.borderColor,
                ),
              ),
              child: imagePath.path.isEmpty
                  ? Center(
                      child: Image.asset(
                        AssetsConstant.uploadIcon,
                        height: 24,
                        width: 24,
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        imagePath,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
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

  int selectSalonType = 0;

  /*------------------- Salon type ----------------*/
  _salonType() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Salon Type",
            style: AppTextTheme.regular
                .copyWith(fontSize: 13, color: ColorConstant.blackColor),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectSalonType = 0;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorConstant.blackColor),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              color: selectSalonType == 0
                                  ? ColorConstant.primaryColor
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Male",
                        style: AppTextTheme.regular.copyWith(
                            fontSize: 13, color: ColorConstant.blackColor),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectSalonType = 1;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorConstant.blackColor),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              color: selectSalonType == 1
                                  ? ColorConstant.primaryColor
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Female",
                        style: AppTextTheme.regular.copyWith(
                            fontSize: 13, color: ColorConstant.blackColor),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectSalonType = 2;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorConstant.blackColor),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              color: selectSalonType == 2
                                  ? ColorConstant.primaryColor
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Unisex",
                        style: AppTextTheme.regular.copyWith(
                            fontSize: 13, color: ColorConstant.blackColor),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /*--------------------  Do Register --------------*/
  _doRegister() {
    if (_yourName.text.isEmpty) {
      showMessage("Please enter your name");
      return;
    } else if (_describe.text.isEmpty) {
      showMessage("Please describe field to fill");
      return;
    } else if (_email.text.isEmpty) {
      showMessage("Please enter emil-id");
      return;
    } else {
      final bool emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(_email.text);
      if (!emailValid) {
        showMessage("Please enter valid email address");
        return;
      } else if (_mobile.text.isEmpty) {
        showMessage("Please enter mobile no");
        return;
      } else if (_mobile.text.length != 10) {
        showMessage("Please enter 10 digit mobile no");
        return;
      } else if (_verificationCode.text.isEmpty) {
        showMessage("Please enter otp");
        return;
      } else if (_verificationCode.text.length != 6) {
        showMessage("Please enter 6 digit otp");
        return;
      } else if (_address.text.isEmpty) {
        showMessage("Please enter address");
        return;
      } else if (_ownerName.text.isEmpty) {
        showMessage("Please enter owner-name");
        return;
      } else if (_ownerEmail.text.isEmpty) {
        showMessage("Please enter owner-email id");
        return;
      } else {
        final bool emailValid = RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(_ownerEmail.text);

        if (!emailValid) {
          showMessage("Please enter valid owner email address");
          return;
        } else if (_ownerMobile.text.isEmpty) {
          showMessage("Please enter ownerMobile");
          return;
        } else if (_ownerMobile.text.length != 10) {
          showMessage("Please enter 10 digit mobile no");
          return;
        } else if (serviceOfferSlab == "") {
          showMessage("Please Select no ofService");
          return;
        } else if (employeeSlab == "") {
          showMessage("Please Select no emp");
          return;
        } else if (imagePath.path == "") {
          showMessage("Please upload saloon Image");
          return;
        } else if (_description.text.isEmpty) {
          showMessage("Please enter Description");
          return;
        } else {
          _authController.doRegister(
            name: _yourName.text,
            describe: _describe.text,
            email: _email.text,
            countryCode: "91",
            mobile: _mobile.text,
            address: _address.text,
            ownerName: _ownerName.text,
            ownerEmail: _ownerEmail.text,
            ownerCountryCode: "91",
            ownerMobile: _ownerMobile.text,
            password: _password.text,
            verificationCode: _verificationCode.text,
            serviceOfferSlab: serviceOfferSlab,
            employeeSlab: employeeSlab,
            image: File(imagePath.path),
            geolocationLat: _authController.salonAddressLat.toString(),
            geolocationLng: _authController.salonAddressLan.toString(),
            description: _description.text,
            serviceGender: selectSalonType == 0
                ? "male"
                : selectSalonType == 1
                    ? "female"
                    : "unisex",
            homeService: serviceSelect == 0
                ? "home"
                : serviceSelect == 1
                    ? "salon"
                    : "both",
            callback: () {
              Get.to(() => const BottomBarPage());
            },
          );
        }
      }
    }
  }
}
