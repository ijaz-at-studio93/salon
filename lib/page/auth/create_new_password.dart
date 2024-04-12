import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/api/dio_client.dart';
import 'package:salon/page/auth/login_page.dart';
import 'package:salon/project_specific/button_widget.dart';
import 'package:salon/project_specific/password_text_field.dart';
import 'package:salon/project_specific/text_theme.dart';

import '../../constant/color_constant.dart';

class CreateNewPassword extends StatefulWidget {
  const CreateNewPassword({super.key});

  @override
  State<CreateNewPassword> createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPassword> {
  final _newPasswordTextEditingController = TextEditingController();
  final _confirmPasswordTextEditingController = TextEditingController();
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
                  PasswordTextFieldWidget(
                      textEditingController: _newPasswordTextEditingController,
                      hintText: "**********",
                      textInputType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      title: "Create a New Password"),
                  const SizedBox(height: 15),
                  PasswordTextFieldWidget(
                      textEditingController: _newPasswordTextEditingController,
                      hintText: "**********",
                      textInputType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      title: "Confirm Password"),
                  const SizedBox(height: 35),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ButtonWidget(
                        buttonTitleText: "Done",
                        onPress: () {
                          doChangePassword();
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
            "Create \nYour Password",
            style: AppTextTheme.bold
                .copyWith(color: ColorConstant.whiteColor, fontSize: 23),
          ),
        ],
      ),
    );
  }

  /*------------  do Change Password--------*/
  doChangePassword() {
    if (_newPasswordTextEditingController.text.isEmpty) {
      showMessage("Please enter new Password");
    } else if (_confirmPasswordTextEditingController.text.isEmpty) {
      showMessage("Please enter confirm Password");
    } else if (_newPasswordTextEditingController.text !=
        _confirmPasswordTextEditingController.text) {
      showMessage("New password did`t match confirm-Password");
    } else {
      Get.offAll(() => const LoginPage());
    }
  }
}
