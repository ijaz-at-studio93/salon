import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salon/api/dio_client.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/auth_controller.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/page/stylist/add_stylist/select_service_page.dart';
import 'package:salon/project_specific/button_widget.dart';
import 'package:salon/project_specific/password_text_field.dart';
import 'package:salon/project_specific/phone_field_widget.dart';
import 'package:salon/project_specific/progressbar_view.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/simple_text_field.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:salon/util/pick_image.dart';

import '../../../constant/api_constant.dart';
import '../../location_pick/location_pick.dart';

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
  final _email = TextEditingController();
  final _experience = TextEditingController();
  final _address = TextEditingController();
  final _whatsappNumber = TextEditingController();
  final _panNumber = TextEditingController();
  final _password = TextEditingController();
  String gender = "";
  DateTime selectedDate = DateTime.now();
  String birthDate = "";
  File imagePath = File("");
  final _authController = Get.find<AuthController>();
  final _homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    if (widget.isBasicInfoUpdate) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _homeController.doGetArtiestDetails(
            artistId: widget.artistId,
            callback: () {
              _name.text =
                  _homeController.getArtiestDetailsModel.data?.name ?? "";
              _mobile.text =
                  _homeController.getArtiestDetailsModel.data?.mobile ?? "";
              _email.text =
                  _homeController.getArtiestDetailsModel.data?.email ?? "";
              _panNumber.text =
                  _homeController.getArtiestDetailsModel.data?.panCard ?? "";
              _experience.text = _homeController
                      .getArtiestDetailsModel.data?.experience
                      .toString() ??
                  "";
              _address.text =
                  _homeController.getArtiestDetailsModel.data?.address ?? "";
              _whatsappNumber.text =
                  _homeController.getArtiestDetailsModel.data?.whatsapp ?? "";
              gender =
                  _homeController.getArtiestDetailsModel.data?.gender ?? "";
              birthDate =
                  _homeController.getArtiestDetailsModel.data?.dob ?? "";
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
                        PhoneFieldWidget(
                            textEditingController: _mobile,
                            hintText: "Tap To Enter",
                            textInputType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            title: "Phone Number"),
                        const SizedBox(height: 20),
                        SimpleTextFieldWidget(
                            textEditingController: _email,
                            hintText: "sourabh@gmail.com",
                            textInputType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            title: "Email ID"),
                        const SizedBox(height: 20),
                        _minimumExperience(
                            textEditingController: _experience,
                            hintText: "Tap To Enter",
                            textInputType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            title: ""),
                        const SizedBox(height: 20),
                        _addressFiled(
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
                        PhoneFieldWidget(
                            textEditingController: _whatsappNumber,
                            hintText: "Tap To Enter",
                            textInputType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            title: "Whatsapp Number"),
                        const SizedBox(height: 20),
                        SimpleTextFieldWidget(
                            textEditingController: _panNumber,
                            hintText: "For eg. ABCDE1234F",
                            textInputType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            title: "PAN Card"),
                        const SizedBox(height: 20),
                        widget.isBasicInfoUpdate
                            ? const SizedBox()
                            : PasswordTextFieldWidget(
                                textEditingController: _password,
                                hintText: "*************",
                                textInputType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                title: "Password"),
                        widget.isBasicInfoUpdate
                            ? const SizedBox()
                            : const SizedBox(height: 20),
                        _homeService(),
                        const SizedBox(height: 20),
                        _selectGender(),
                        const SizedBox(height: 20),
                        _selectBirthDate(),
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
                  if (widget.isBasicInfoUpdate) {
                    _doUpdateStylist();
                  } else {
                    _doAddStylist();
                  }
                }),
          )
        ],
      ),
    );
  }

  /*------------------- doAdd Stylist Basic Detail ----------------------*/
  _doAddStylist() {
    if (_name.text.isEmpty) {
      showMessage("Please enter stylist-name");
      return;
    } else if (_mobile.text.isEmpty) {
      showMessage("Please enter phoneNumber");
      return;
    } else if (_mobile.text.length != 10) {
      showMessage("Please enter 10 digit phoneNumber");
      return;
    } else if (_email.text.isEmpty) {
      showMessage("Please enter email");
      return;
    } else {
      final bool emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(_email.text);
      if (!emailValid) {
        showMessage("Please enter valid email");
        return;
      } else if (_experience.text.isEmpty) {
        showMessage("Please enter your experience");
        return;
      } else if (_address.text.isEmpty) {
        showMessage("Please enter address");
        return;
      } else if (_whatsappNumber.text.isEmpty) {
        showMessage("Please enter whatsapp-number");
        return;
      } else if (_panNumber.text.isEmpty) {
        showMessage("Please enter panCardNumber");
        return;
      } else {
        final bool panCard =
            RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$').hasMatch(_panNumber.text);
        if (!panCard) {
          showMessage("Please enter valid panCardNumber");
          return;
        } else if (_password.text.isEmpty) {
          showMessage("Please enter password");
          return;
        } else if (_password.text.length < 8) {
          showMessage("Please enter 8 latter password");
          return;
        } else if (gender == "") {
          showMessage("Please  select gender");
          return;
        } else if (birthDate == "") {
          showMessage("Please select birthdate");
          return;
        } else if (imagePath.path.isEmpty) {
          showMessage("Please choose image");
          return;
        } else {
          Get.to(
            () => SelectServicePage(
              artistId: "",
              isUpdate: false,
              name: _name.text,
              phone: _mobile.text,
              email: _email.text,
              experience: _experience.text,
              address: _address.text,
              whatsappNo: _whatsappNumber.text,
              panNo: _panNumber.text,
              password: _password.text,
              isHomeService: isHomeServiceEnable,
              gender: gender,
              birthdate: birthDate,
              image: imagePath,
            ),
          );
        }
      }
    }
  }

  /*----------------  Update Stylist -----------*/
  _doUpdateStylist() {
    if (_name.text.isEmpty) {
      showMessage("Please enter stylist-name");
      return;
    } else if (_mobile.text.isEmpty) {
      showMessage("Please enter phoneNumber");
      return;
    } else if (_mobile.text.length != 10) {
      showMessage("Please enter 10 digit phoneNumber");
      return;
    } else if (_email.text.isEmpty) {
      showMessage("Please enter email");
      return;
    } else {
      final bool emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(_email.text);
      if (!emailValid) {
        showMessage("Please enter valid email");
        return;
      } else if (_experience.text.isEmpty) {
        showMessage("Please enter your experience");
        return;
      } else if (_address.text.isEmpty) {
        showMessage("Please enter address");
        return;
      } else if (_whatsappNumber.text.isEmpty) {
        showMessage("Please enter whatsapp-number");
        return;
      } else if (_panNumber.text.isEmpty) {
        showMessage("Please enter panCardNumber");
        return;
      } else {
        final bool panCard =
            RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$').hasMatch(_panNumber.text);
        if (!panCard) {
          showMessage("Please enter valid panCardNumber");
          return;
        } else if (gender == "") {
          showMessage("Please  select gender");
          return;
        } else if (birthDate == "") {
          showMessage("Please select birthdate");
          return;
        } else {
          _homeController.doUpdateStylistBasicInfo(
              artistId: widget.artistId,
              name: _name.text,
              mobile: _mobile.text,
              countryCode: "91",
              email: _email.text,
              experience: _experience.text,
              address: _address.text,
              whatsapp: _whatsappNumber.text,
              panCard: _panNumber.text,
              homeService: isHomeServiceEnable.toString(),
              gender: gender,
              dob: birthDate,
              image: imagePath,
              callback: () {
                Get.back();
                _homeController.doSalonArtistList();
              });
        }
      }
    }
  }

  /*---------------- Count Row Widget -------------*/
  _countRowWidget() {
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
                child: Center(
                  child: Text(
                    "1",
                    textScaler: const TextScaler.linear(0.85),
                    style: AppTextTheme.bold.copyWith(
                        color: ColorConstant.whiteColor, fontSize: 16),
                  ),
                ),
              ),
              Container(
                height: 2,
                width: 80,
                color: ColorConstant.primaryColor,
              ),
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ColorConstant.primaryColor,
                  ),
                ),
              ),
              Container(
                height: 2,
                width: 80,
                color: ColorConstant.grayTextColor,
              ),
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ColorConstant.grayTextColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(right: 60, left: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "basic info",
                  textScaler: const TextScaler.linear(0.85),
                  style: AppTextTheme.regular.copyWith(
                      color: ColorConstant.grayTextColor, fontSize: 12),
                ),
                Text(
                  "Select  Service",
                  textScaler: const TextScaler.linear(0.85),
                  style: AppTextTheme.regular.copyWith(
                      color: ColorConstant.grayTextColor, fontSize: 12),
                ),
                Text(
                  "Review",
                  textScaler: const TextScaler.linear(0.85),
                  style: AppTextTheme.regular.copyWith(
                      color: ColorConstant.grayTextColor, fontSize: 12),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  /*------------ is Home Service --------------*/
  bool isHomeServiceEnable = false;
  _homeService() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Home Service",
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
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: ColorConstant.borderColor,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
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
              ),
            ],
          ),
        ),
      ],
    );
  }

/*--------------- Dummy Data ---------*/
  final List<String> dataList = ["MALE", "FEMALE", "OTHER"];

  /*--------------------- No. Of Service You Offer ------------------*/
  _selectGender() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Gender",
            style: AppTextTheme.regular
                .copyWith(fontSize: 13, color: ColorConstant.blackColor),
          ),
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
                        onTap: () {
                          gender = item;
                        },
                        child: Text(item,
                            style: AppTextTheme.medium.copyWith(
                                color: ColorConstant.blackColor, fontSize: 13)),
                      ))
                  .toList(),
              validator: (value) {
                if (value == null) {
                  return 'Select Gender';
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
              dropdownStyleData: DropdownStyleData(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              menuItemStyleData: const MenuItemStyleData(
                padding: EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /*----------------------- selectBirthdate BirthDate --------------------*/
  _selectBirthDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Birthdate",
            style: AppTextTheme.regular
                .copyWith(fontSize: 13, color: ColorConstant.blackColor),
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            _selectDate(context);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                Text(
                  birthDate == "" ? "BirthDate" : birthDate,
                  style: AppTextTheme.medium.copyWith(
                      color: birthDate == ""
                          ? ColorConstant.grayTextColor
                          : ColorConstant.blackColor,
                      fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /*---------------  Date Picker --------------*/
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        String inputDateStr = selectedDate.toString();
        DateTime inputDate = DateTime.parse(inputDateStr);
        DateFormat outputFormat = DateFormat('yyyy-MM-dd');
        String outPutDateFromShow = outputFormat.format(inputDate);
        birthDate = outPutDateFromShow;
      });
    }
  }

  /*----------- Profile Photo -------------*/

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
              ? widget.isBasicInfoUpdate
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        imageUrl:
                            "${APIConstants.image}${_homeController.getArtiestDetailsModel.data?.profileImage ?? ""}",
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
                  : Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: ColorConstant.grayTextColor.withOpacity(0.3),
                        shape: BoxShape.circle,
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

  /*------------ Saloon Address TextField -----------*/
  _addressField({
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

  /*------------ Saloon Address TextField -----------*/
  _addressFiled({
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

  /*--------------- Minimum Experience ---------------*/

  _minimumExperience({
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
            "Experience",
            style: AppTextTheme.regular
                .copyWith(fontSize: 13, color: ColorConstant.blackColor),
          ),
          const SizedBox(height: 12),
          Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              width: Get.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: ColorConstant.borderColor,
                ),
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
                            contentPadding: const EdgeInsets.only(bottom: 2),
                            border: InputBorder.none,
                            hintText: hintText,
                            counterText: "",
                            hintStyle: AppTextTheme.medium.copyWith(
                                color: ColorConstant.grayColor, fontSize: 13)),
                      )),
                  Text(
                    "in Years",
                    style: AppTextTheme.regular.copyWith(
                        color: ColorConstant.primaryColor, fontSize: 13),
                  )
                ],
              )),
        ],
      ),
    );
  }
}
