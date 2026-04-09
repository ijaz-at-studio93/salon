import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/api/dio_client.dart';
import 'package:salon/constant/api_constant.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/auth_controller.dart';
import 'package:salon/project_specific/button_widget.dart';
import 'package:salon/project_specific/progress_container_view.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/simple_text_field.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:salon/util/pick_image.dart';

import '../../../project_specific/phone_field_widget.dart';
import '../../location_pick/location_pick.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _authController = Get.find<AuthController>();

  final _fullName = TextEditingController();
  final _email = TextEditingController();
  final _mobileNo = TextEditingController();
  final _verificationCode = TextEditingController();

  final _ownerMobileNo = TextEditingController();
  final _address = TextEditingController();
  final _description = TextEditingController();

  bool isResendOTp = false;
  int _start = 60;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _authController.doGetSalonProfile(callback: () {
        _fullName.text = _authController.getGetSalonProfile.data?.name ?? "";
        _email.text = _authController.getGetSalonProfile.data?.email ?? "";
        _mobileNo.text = _authController.getGetSalonProfile.data?.mobile ?? "";
        _ownerMobileNo.text =
            _authController.getGetSalonProfile.data?.ownerMobile ?? "";
        _address.text = _authController.getGetSalonProfile.data?.address ?? "";
        _description.text =
            _authController.getGetSalonProfile.data?.description ?? "";
        serviceSelect = _authController.getGetSalonProfile.data?.homeService ==
                "home"
            ? 0
            : _authController.getGetSalonProfile.data?.homeService == "salon"
                ? 1
                : 2;

        _authController.salonAddressLat = _authController
            .getGetSalonProfile.data?.geoLocationPoint?.coordinates?[1];
        _authController.salonAddressLan = _authController
            .getGetSalonProfile.data?.geoLocationPoint?.coordinates?[0];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.whiteColor,
      appBar: const AppBarWidget(
        nameOfScreen: "Edit Profile",
        isBackIcon: true,
      ),
      body: Column(
        children: [
          Obx(
            () => Expanded(
              child: ProgressContainerView(
                isProgressRunning: _authController.showProgress,
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  children: [
                    _stylistProfilePhoto(),
                    const SizedBox(height: 15),
                    SimpleTextFieldWidget(
                        textEditingController: _fullName,
                        hintText: "Enter Here......",
                        textInputType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        title: "Full Name"),
                    _dividerWidget(),
                    SimpleTextFieldWidget(
                        textEditingController: _email,
                        hintText: "example@gmail.com",
                        textInputType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        title: "Email Id"),
                    _dividerWidget(),
                    _mobileNumberWidget(
                        textEditingController: _mobileNo,
                        hintText: "Enter Here",
                        textInputType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        title: "Mobile No"),
                    _dividerWidget(),
                    isOTPField
                        ? Column(
                            children: [
                              SimpleTextFieldWidget(
                                  onChanged: (val) {
                                    if (val.length == 6) {
                                      _authController.doVerifyOtp(
                                          mobileNO: _mobileNo.text,
                                          cc: "91",
                                          verificationCode: val);

                                      if (_authController
                                              .otpVerifyModelResponseModel
                                              .data
                                              ?.isVerificationCodeValid ??
                                          false) {
                                        timer?.cancel();
                                      }
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
                                                    mobileNo: _mobileNo.text,
                                                    cc: "91");
                                                _verificationCode.clear();
                                              });
                                            },
                                            child: Text(
                                              "Resend",
                                              style: AppTextTheme.bold.copyWith(
                                                  fontSize: 16,
                                                  color:
                                                      ColorConstant.redColor),
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
                    _dividerWidget(),
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
                    PhoneFieldWidget(
                        textEditingController: _ownerMobileNo,
                        hintText: "Enter Here",
                        textInputType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        title: "Owner Mobile Number"),
                    _dividerWidget(),
                    _saloonAddress(
                        onTap: () {},
                        textEditingController: _description,
                        hintText: "Enter Here",
                        textInputType: TextInputType.text,
                        textInputAction: Platform.isAndroid
                            ? TextInputAction.none
                            : TextInputAction.done,
                        title: "Description"),
                    _dividerWidget(),
                    _homeService()
                    /*Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Portfolio",
                            style: AppTextTheme.medium.copyWith(
                                color: ColorConstant.grayTextColor, fontSize: 16),
                          ),
                          Row(
                            children: [
                              Text(
                                "See Activity",
                                style: AppTextTheme.bold.copyWith(
                                    fontSize: 16,
                                    color: ColorConstant.primaryColor),
                              ),
                              const SizedBox(width: 2),
                              const Icon(
                                CupertinoIcons.arrowshape_turn_up_right_fill,
                                color: ColorConstant.primaryColor,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),*/
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: ButtonWidget(
                buttonTitleText: "Save",
                onPress: () {
                  doUpdateProfile();
                }),
          ),
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
          margin: const EdgeInsets.symmetric(horizontal: 20),
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

  /*----------- Profile Photo -------------*/
  File imagePath = File("");
  _stylistProfilePhoto() {
    return GestureDetector(
      onTap: () {
        FileUtils.openPlatformImagePicker(onSelectImage: (file) {
          setState(() {
            imagePath = file;
          });
        });
      },
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          imagePath.path == ""
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CachedNetworkImage(
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    imageUrl:
                        "${APIConstants.image}${_authController.getGetSalonProfile.data?.image ?? ""}",
                    placeholder: (context, url) => const Image(
                      image: AssetImage(AssetsConstant.placeHolder),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    errorWidget: (context, url, error) => const Image(
                      image: AssetImage(AssetsConstant.placeHolder),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.file(
                    imagePath,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
          Positioned(
            bottom: 10,
            left: 70,
            right: 0,
            child: Container(
              width: 38,
              height: 38,
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                  color: ColorConstant.whiteColor, shape: BoxShape.circle),
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                    color: ColorConstant.editButtonColor,
                    shape: BoxShape.circle),
                child: Center(
                  child: Image.asset(
                    AssetsConstant.editIcon,
                    width: 16,
                    height: 16,
                  ),
                ),
              ),
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
                  width: Get.width * 0.55,
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
                                mobileNo: _mobileNo.text, cc: "91");
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
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          isResendOTp = true;
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  /*------------- Divider ----------*/
  _dividerWidget() {
    return const SizedBox(height: 10);
  }

  /*-------------------  do  Update Profile -----------------*/
  doUpdateProfile() {
    if (_fullName.text.isEmpty) {
      showMessage("Please Enter Full Name");
      return;
    } else if (_email.text.isEmpty) {
      showMessage("Please Enter Email-Address");
      return;
    } else {
      final bool emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(_email.text);
      if (!emailValid) {
        showMessage("Please enter valid email address");
        return;
      } else if (isOTPField) {
        if (_mobileNo.text.isEmpty) {
          showMessage("Please enter Mobile No");
          return;
        } else if (_verificationCode.text.isEmpty) {
          showMessage("Please enter Verification Code");
          return;
        } else if (_verificationCode.text.length != 6) {
          showMessage("Please enter 6 Digit Verification Code");
          return;
        } else {
          _authController.doUpdateSalonProfile(
              name: _fullName.text,
              email: _email.text,
              countryCode: "91",
              mobile: _mobileNo.text,
              address: _address.text,
              ownerCountryCode: "91",
              ownerMobile: _ownerMobileNo.text,
              verificationCode: _verificationCode.text,
              image: imagePath.path.isEmpty ? null : File(imagePath.path),
              geolocationLat: _authController.salonAddressLat.toString(),
              geolocationLng: _authController.salonAddressLan.toString(),
              description: _description.text,
              homeService: serviceSelect == 0
                  ? "home"
                  : serviceSelect == 1
                      ? "salon"
                      : "both",
              callback: () {
                _authController.doGetSalonProfile(callback: () {
                  Navigator.pop(context);
                });
              });
        }
      } else if (_ownerMobileNo.text.isEmpty) {
        showMessage("Please enter Owner Mobile No");
        return;
      } else if (_ownerMobileNo.text.length != 10) {
        showMessage("Please enter  10 Digit Owner Mobile No");
        return;
      } else {
        _authController.doUpdateSalonProfile(
            name: _fullName.text,
            email: _email.text,
            countryCode: "91",
            mobile: "",
            address: _address.text,
            ownerCountryCode: "91",
            ownerMobile: _ownerMobileNo.text,
            verificationCode: "",
            image: imagePath.path.isEmpty ? null : File(imagePath.path),
            geolocationLat: _authController.salonAddressLat.toString(),
            geolocationLng: _authController.salonAddressLan.toString(),
            description: _description.text,
            homeService: serviceSelect == 0
                ? "home"
                : serviceSelect == 1
                    ? "salon"
                    : "both",
            callback: () {
              _authController.doGetSalonProfile(callback: () {
                Navigator.pop(context);
              });
            });
      }
    }
  }
}
