import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/page/adding_service/widget/reset_and_add_row_widget.dart';
import 'package:salon/page/stylist/add_stylist/select_service_page.dart';
import 'package:salon/project_specific/phone_field_widget.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/simple_text_field.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:salon/util/pick_image.dart';

class AddStylistPage extends StatefulWidget {
  const AddStylistPage({super.key});

  @override
  State<AddStylistPage> createState() => _AddStylistPageState();
}

class _AddStylistPageState extends State<AddStylistPage> {
  final _stylistName = TextEditingController();
  final _phoneNumber = TextEditingController();
  final _experience = TextEditingController();
  final _address = TextEditingController();
  final _email = TextEditingController();
  final _whatsappNumber = TextEditingController();
  final _aadharNumber = TextEditingController();
  final _panNumber = TextEditingController();
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
          Expanded(
            child: ListView(
              children: [
                _stylistProfilePhoto(),
                SimpleTextFieldWidget(
                    textEditingController: _stylistName,
                    hintText: "Tap To Enter",
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    title: "Stylist Name"),
                const SizedBox(height: 20),
                PhoneFieldWidget(
                    textEditingController: _phoneNumber,
                    hintText: "Tap To Enter",
                    textInputType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    title: "Phone Number"),
                const SizedBox(height: 20),
                _minimumExperience(
                    textEditingController: _experience,
                    hintText: "Tap To Enter",
                    textInputType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    title: ""),
                const SizedBox(height: 20),
                _bestAt(),
                const SizedBox(height: 20),
                _addressField(
                    textEditingController: _address,
                    hintText: "Tap To Enter",
                    textInputType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    title: "Address"),
                const SizedBox(height: 20),
                SimpleTextFieldWidget(
                    textEditingController: _email,
                    hintText: "sourabh@gmail.com",
                    textInputType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    title: "Email ID"),
                const SizedBox(height: 20),
                _dropDownButtonForFilter(),
                const SizedBox(height: 20),
                PhoneFieldWidget(
                    textEditingController: _whatsappNumber,
                    hintText: "Tap To Enter",
                    textInputType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    title: "Whatsapp Number"),
                const SizedBox(height: 20),
                SimpleTextFieldWidget(
                    textEditingController: _aadharNumber,
                    hintText: "For eg. 6667 8327 8738",
                    textInputType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    title: "Aadhar Number"),
                const SizedBox(height: 20),
                SimpleTextFieldWidget(
                    textEditingController: _panNumber,
                    hintText: "For eg. IHDH872873",
                    textInputType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    title: "PAN Card"),
              ],
            ),
          ),
          ResetAndAddRowWidget(
            reset: () {},
            add: () {
              Get.to(()=> const SelectServicePage());
            },
          )
        ],
      ),
    );
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
                const SizedBox(width: 5),
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

/*--------------- Dummy Data ---------*/
  final List<String> dataList = [
    'Both in home and saloon',
    'yesterday',
    'This Week',
    'This Month',
    'This year',
  ];

  /*--------------------- No. Of Service You Offer ------------------*/
  _dropDownButtonForFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Service offered",
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
                'Both in home and saloon',
                style: AppTextTheme.medium
                    .copyWith(color: ColorConstant.grayColor, fontSize: 13),
              ),
              items: dataList
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item,
                            style: AppTextTheme.medium.copyWith(
                                color: ColorConstant.blackColor, fontSize: 13)),
                      ))
                  .toList(),
              validator: (value) {
                if (value == null) {
                  return 'Today';
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
                  color: Colors.black,
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
          ),
        ],
      ),
    );
  }

  /*-------------- Best at  -------------*/
  _bestAt() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Best at",
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
          )
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
              ? Container(
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

  /*--------------- Minimum Experience ---------------*/
  int year = 1;
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
