import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/auth_controller.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/page/stylist/add_stylist/select_service_page.dart';
import 'package:salon/project_specific/button_widget.dart';
import 'package:salon/project_specific/password_text_field.dart';
import 'package:salon/project_specific/progressbar_view.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/simple_text_field.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:salon/util/pick_image.dart';
import '../../../constant/api_constant.dart';

class AddStylistPage extends StatefulWidget {
  final String artistId;
  final bool isBasicInfoUpdate;
  const AddStylistPage(
      {super.key, required this.artistId, required this.isBasicInfoUpdate});

  @override
  State<AddStylistPage> createState() => _AddStylistPageState();
}

class _AddStylistPageState extends State<AddStylistPage> {
  final _name = TextEditingController();
  final _mobile = TextEditingController();
  final _experience = TextEditingController();
  final _password = TextEditingController();
  final _verificationCode = TextEditingController();
  final _languages = TextEditingController();

  String gender = "";
  File imagePath = File("");
  bool isHomeServiceEnable = false;
  bool isOTPButton = false;
  bool isOTPField = false;
  int _start = 60;
  bool isResendOTp = false;

  final _authController = Get.find<AuthController>();
  final _homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    if (widget.isBasicInfoUpdate) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _homeController.doGetArtiestDetails(
            artistId: widget.artistId,
            callback: () {
              _name.text =
                  _homeController.getArtiestDetailsModel.data?.name ?? "";
              _mobile.text =
                  _homeController.getArtiestDetailsModel.data?.mobile ?? "";
              _experience.text = _homeController
                  .getArtiestDetailsModel.data?.experience
                  .toString() ??
                  "";
              gender =
                  _homeController.getArtiestDetailsModel.data?.gender ?? "";
              isHomeServiceEnable =
                  _homeController.getArtiestDetailsModel.data?.homeService ??
                      false;
            });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.whiteColor,
      appBar: const AppBarWidget(
        nameOfScreen: "Add Stylist",
        isBackIcon: true,
      ),
      body: Column(
        children: [
          _countRowWidget(),
          Obx(
                () => Expanded(
              child: _homeController.showProgress
                  ? const ProgressBarView()
                  : ListView(
                children: [
                  _stylistProfilePhoto(),
                  SimpleTextFieldWidget(
                      textEditingController: _name,
                      hintText: "Tap To Enter",
                      textInputType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      title: "Stylist Name"),
                  const SizedBox(height: 20),
                  _mobileNumberWidget(
                      textEditingController: _mobile,
                      hintText: "Enter Here",
                      textInputType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      title: "Phone Number"),
                  const SizedBox(height: 20),
                  if (isOTPField) _otpField(),
                  const SizedBox(height: 20),
                  _minimumExperience(
                      textEditingController: _experience,
                      hintText: "Tap To Enter",
                      textInputType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      title: ""),
                  const SizedBox(height: 20),
                  if (!widget.isBasicInfoUpdate)
                    PasswordTextFieldWidget(
                        textEditingController: _password,
                        hintText: "*************",
                        textInputType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        title: "Password"),
                  if (!widget.isBasicInfoUpdate)
                    const SizedBox(height: 20),
                  _selectGender(),
                  const SizedBox(height: 20),
                  _languagesKnown(),
                  const SizedBox(height: 20),
                  _homeService(),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ButtonWidget(
                buttonTitleText: widget.isBasicInfoUpdate ? "Update" : "Add",
                onPress: () {
                  widget.isBasicInfoUpdate
                      ? _doUpdateStylist()
                      : _doAddStylist();
                }),
          )
        ],
      ),
    );
  }

  /*---------------- Add Stylist Logic ----------------*/
  _doAddStylist() {
    if (_name.text.isEmpty) return showMessage("Please enter stylist name");
    if (_mobile.text.isEmpty) return showMessage("Please enter phone number");
    if (_mobile.text.length != 10) {
      return showMessage("Please enter valid 10 digit phone number");
    }
    if (_experience.text.isEmpty) {
      return showMessage("Please enter experience");
    }
    if (_password.text.isEmpty) return showMessage("Please enter password");
    if (_password.text.length < 8) {
      return showMessage("Password must be at least 8 characters long");
    }
    if (gender.isEmpty) return showMessage("Please select gender");
    if (_languages.text.isEmpty) {
      return showMessage("Please enter languages known");
    }
    if (imagePath.path.isEmpty) return showMessage("Please choose image");

    Get.to(
          () => SelectServicePage(
        artistId: "",
        isUpdate: false,
        name: _name.text,
        phone: _mobile.text,
        experience: _experience.text,
        whatsappNo: "9999999999",
        password: _password.text,
        isHomeService: isHomeServiceEnable,
        gender: gender,

        image: imagePath,
      ),
    );
  }

  /*---------------- Update Stylist Logic ----------------*/
  _doUpdateStylist() {
    if (_name.text.isEmpty) return showMessage("Please enter stylist name");
    if (_mobile.text.isEmpty) return showMessage("Please enter phone number");
    if (_mobile.text.length != 10) {
      return showMessage("Please enter valid 10 digit phone number");
    }
    if (_experience.text.isEmpty) {
      return showMessage("Please enter experience");
    }
    if (gender.isEmpty) return showMessage("Please select gender");
    if (_languages.text.isEmpty) {
      return showMessage("Please enter languages known");
    }

    _homeController.doUpdateStylistBasicInfo(
        artistId: widget.artistId,
        name: _name.text,
        mobile: _mobile.text,
        countryCode: "91",
        experience: _experience.text,
        whatsapp: "9999999999",
        homeService: isHomeServiceEnable.toString(),
        gender: gender,
        image: imagePath,
        callback: () {
          Get.back();
          _homeController.doSalonArtistList();
        });
  }

  /*---------------- Mobile Number + OTP ----------------*/
  Widget _mobileNumberWidget({
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
          Text(title,
              style: AppTextTheme.regular
                  .copyWith(fontSize: 13, color: ColorConstant.blackColor)),
          const SizedBox(height: 12),
          Container(
            height: 50,
            width: Get.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ColorConstant.borderColor),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                Text("+91",
                    style: AppTextTheme.bold.copyWith(
                        fontSize: 13, color: ColorConstant.grayTextColor)),
                const SizedBox(width: 5),
                SizedBox(
                  width: Get.width * 0.6,
                  child: TextField(
                    onChanged: (val) {
                      if (val.length == 10) {
                        setState(() => isOTPButton = true);
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
                    maxLength: 10,
                    style: AppTextTheme.medium
                        .copyWith(color: ColorConstant.blackColor, fontSize: 13),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: hintText,
                      counterText: "",
                      hintStyle: AppTextTheme.medium.copyWith(
                          color: ColorConstant.grayColor, fontSize: 13),
                    ),
                  ),
                ),
                if (isOTPButton)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _authController.doSendArtiestOtp(
                            mobileNo: _mobile.text, callback: () {});
                        isOTPField = true;
                        _start = 60;
                        startTimer();
                      });
                    },
                    child: Text("Get OTP",
                        style: AppTextTheme.bold.copyWith(
                            color: ColorConstant.primaryColor, fontSize: 13)),
                  )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _otpField() {
    return Column(
      children: [
        SimpleTextFieldWidget(
            onChanged: (val) {
              if (val.length == 6) {
                _authController.doVerifyArtiestOtp(
                    callback: () {}, mobileNo: _mobile.text, otp: val);
              }
            },
            textEditingController: _verificationCode,
            hintText: "",
            textInputType: TextInputType.number,
            textInputAction: TextInputAction.done,
            title: "Enter OTP"),
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
                      _authController.doSendOTP(
                          mobileNo: _mobile.text, cc: "91");
                      _verificationCode.clear();
                    });
                  },
                  child: Text("Resend",
                      style: AppTextTheme.bold.copyWith(
                          fontSize: 16, color: ColorConstant.redColor)))
                  : Text("Retry in 00:${_start.toString()}",
                  style: AppTextTheme.bold.copyWith(
                      fontSize: 16, color: ColorConstant.redColor)),
            ],
          ),
        ),
      ],
    );
  }

  startTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() => isResendOTp = true);
        timer.cancel();
      } else {
        setState(() => _start--);
      }
    });
  }

  /*---------------- Gender ----------------*/
  final List<String> dataList = ["MALE", "FEMALE", "OTHER"];
  Widget _selectGender() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Gender",
              style: AppTextTheme.regular
                  .copyWith(fontSize: 13, color: ColorConstant.blackColor)),
          const SizedBox(height: 12),
          SizedBox(
            height: 50,
            width: Get.width,
            child: DropdownButtonFormField2<String>(
              isExpanded: true,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                  const BorderSide(color: ColorConstant.dividerColor),
                  borderRadius: BorderRadius.circular(15),
                ),
                border: OutlineInputBorder(
                  borderSide:
                  const BorderSide(color: ColorConstant.dividerColor),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              hint: Text(
                widget.isBasicInfoUpdate ? gender : 'Select Gender',
                style: AppTextTheme.medium.copyWith(
                    color: widget.isBasicInfoUpdate
                        ? ColorConstant.blackColor
                        : ColorConstant.grayColor,
                    fontSize: 13),
              ),
              items: dataList
                  .map((item) => DropdownMenuItem<String>(
                value: item,
                onTap: () => gender = item,
                child: Text(item,
                    style: AppTextTheme.medium.copyWith(
                        color: ColorConstant.blackColor, fontSize: 13)),
              ))
                  .toList(),
              onChanged: (_) {},
            ),
          ),
        ],
      ),
    );
  }

  /*---------------- Languages Known ----------------*/
  Widget _languagesKnown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Languages Known",
              style: AppTextTheme.regular
                  .copyWith(fontSize: 13, color: ColorConstant.blackColor)),
          const SizedBox(height: 12),
          Container(
            height: 50,
            width: Get.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ColorConstant.borderColor),
            ),
            child: TextField(
              controller: _languages,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 12),
                border: InputBorder.none,
                hintText: "e.g. English, Hindi, Telugu",
                hintStyle: AppTextTheme.medium.copyWith(
                    color: ColorConstant.grayColor, fontSize: 13),
              ),
              style: AppTextTheme.medium.copyWith(
                  color: ColorConstant.blackColor, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  /*---------------- Home Service ----------------*/
  Widget _homeService() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text("Home Service",
              style: AppTextTheme.regular
                  .copyWith(fontSize: 13, color: ColorConstant.blackColor)),
        ),
        const SizedBox(height: 12),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: 50,
          width: Get.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: ColorConstant.borderColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Is home service",
                  style: AppTextTheme.regular
                      .copyWith(fontSize: 13, color: ColorConstant.blackColor)),
              CupertinoSwitch(
                activeColor: ColorConstant.primaryColor,
                value: isHomeServiceEnable,
                onChanged: (value) =>
                    setState(() => isHomeServiceEnable = value),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /*---------------- Experience ----------------*/
  Widget _minimumExperience({
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
          Text("Experience",
              style: AppTextTheme.regular
                  .copyWith(fontSize: 13, color: ColorConstant.blackColor)),
          const SizedBox(height: 12),
          Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ColorConstant.borderColor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: Get.width * 0.72,
                      child: TextField(
                        controller: textEditingController,
                        keyboardType: textInputType,
                        textInputAction: textInputAction,
                        style: AppTextTheme.medium.copyWith(
                            color: ColorConstant.blackColor, fontSize: 13),
                        maxLength: 10,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: hintText,
                            counterText: "",
                            hintStyle: AppTextTheme.medium.copyWith(
                                color: ColorConstant.grayColor, fontSize: 13)),
                      )),
                  Text("in Years",
                      style: AppTextTheme.regular.copyWith(
                          color: ColorConstant.primaryColor, fontSize: 13))
                ],
              )),
        ],
      ),
    );
  }

  /*---------------- Profile Photo ----------------*/
  Widget _stylistProfilePhoto() {
    return GestureDetector(
      onTap: () {
        FileUtils.openPlatformImagePicker(onSelectImage: (file) {
          setState(() => imagePath = file);
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          imagePath.path == ""
              ? widget.isBasicInfoUpdate
              ? ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: CachedNetworkImage(
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              imageUrl:
              "${APIConstants.image}${_homeController.getArtiestDetailsModel.data?.profileImage ?? ""}",
              placeholder: (context, url) =>
              const Image(image: AssetImage(AssetsConstant.placeHolder)),
              errorWidget: (context, url, error) =>
              const Image(image: AssetImage(AssetsConstant.placeHolder)),
            ),
          )
              : Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
                color:
                ColorConstant.grayTextColor.withOpacity(0.3),
                shape: BoxShape.circle),
          )
              : ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.file(imagePath,
                width: 100, height: 100, fit: BoxFit.cover),
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

  /*---------------- Stepper Header ----------------*/
  Widget _countRowWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 20,
                width: 20,
                decoration: const BoxDecoration(
                    color: ColorConstant.primaryColor, shape: BoxShape.circle),
                child: const Center(
                    child: Text("1",
                        style:
                        TextStyle(color: Colors.white, fontSize: 14))),
              ),
              Container(height: 2, width: 80, color: ColorConstant.primaryColor),
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                    Border.all(color: ColorConstant.primaryColor)),
              ),
              Container(height: 2, width: 80, color: ColorConstant.grayTextColor),
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                    Border.all(color: ColorConstant.grayTextColor)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Text("basic info",
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text("Select Service",
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text("Review",
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /*---------------- Message Function ----------------*/
  void showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}