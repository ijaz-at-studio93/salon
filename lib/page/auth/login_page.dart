import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/api/dio_client.dart';
import 'package:salon/controller/auth_controller.dart';
import 'package:salon/page/auth/forgot_password_page.dart';
import 'package:salon/page/auth/register_page.dart';
import 'package:salon/page/bottom_bar_page.dart';
import 'package:salon/page/stylist_all_module/stylist_bottom_bar_page.dart';
import 'package:salon/project_specific/button_widget.dart';
import 'package:salon/project_specific/password_text_field.dart';
import 'package:salon/project_specific/phone_field_widget.dart';
import 'package:salon/project_specific/progress_container_view.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:salon/util/shared_prefs.dart';
import '../../constant/color_constant.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _mobileTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();
  final _authController = Get.find<AuthController>();
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
                      _stylistAndSalon(),
                      const SizedBox(height: 20),
                      PhoneFieldWidget(
                          textEditingController: _mobileTextEditingController,
                          hintText: "Enter here",
                          title: "Mobile Number",
                          textInputType: TextInputType.phone,
                          textInputAction: TextInputAction.next),
                      const SizedBox(height: 15),
                      PasswordTextFieldWidget(
                          textEditingController: _passwordTextEditingController,
                          hintText: "**********",
                          textInputType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          title: "Enter Password"),
                      selectedStylistOrSalon == "1" ? Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Get.to(() => const ForGotPasswordPage());
                              },
                              child: Text(
                                "Forgot Password?",
                                style: AppTextTheme.medium.copyWith(
                                    color: ColorConstant.redColor,
                                    fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ) :  const SizedBox(height: 15),
                      const SizedBox(height: 15),
                      selectedStylistOrSalon == "1"
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Register with us-",
                                  style: AppTextTheme.medium.copyWith(
                                      fontSize: 13,
                                      color: ColorConstant.grayTextColor),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Get.to(() => const RegisterPage());
                                  },
                                  child: Text(
                                    "Register Now",
                                    style: AppTextTheme.medium.copyWith(
                                        fontSize: 16,
                                        color: ColorConstant.primaryColor),
                                  ),
                                )
                              ],
                            )
                          : const SizedBox(),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ButtonWidget(
                            buttonTitleText: "Continue",
                            onPress: () {
                              _doLogin();
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
      padding: const EdgeInsets.only(top: 50, left: 21, right: 21, bottom: 35),
      decoration: const BoxDecoration(color: ColorConstant.primaryColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 35),
          Text(
            "Login to \nyour Scuts Account",
            style: AppTextTheme.bold
                .copyWith(color: ColorConstant.whiteColor, fontSize: 23),
          ),
        ],
      ),
    );
  }

  /*----------- Tab Bar variable  ----------- */
  String? selectedStylistOrSalon = "1";

  /*----------- Switch Tab Stylist & Salon -------------------*/
  _stylistAndSalon() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
          color: ColorConstant.whiteColor,
          border: Border.all(color: ColorConstant.primaryColor, width: 2),
          borderRadius: BorderRadius.circular(10)),
      width: Get.width,
      padding: const EdgeInsets.all(2),
      child: CupertinoSlidingSegmentedControl(
          groupValue: selectedStylistOrSalon,
          thumbColor: ColorConstant.primaryColor,
          children: {
            "0": SizedBox(
              width: Get.width,
              height: Get.height * 0.06,
              child: Center(
                child: Text(
                  "Staff",
                  style: AppTextTheme.medium.copyWith(
                      fontSize: 16,
                      color: selectedStylistOrSalon == "0"
                          ? ColorConstant.whiteColor
                          : ColorConstant.grayTextColor),
                ),
              ),
            ),
            "1": Text(
              "Salon",
              style: AppTextTheme.medium.copyWith(
                  fontSize: 16,
                  color: selectedStylistOrSalon == "1"
                      ? ColorConstant.whiteColor
                      : ColorConstant.grayTextColor),
            ),
          },
          onValueChanged: (dynamic value) {
            setState(() {
              selectedStylistOrSalon = value;
              FocusManager.instance.primaryFocus?.unfocus();
              _mobileTextEditingController.clear();
              _passwordTextEditingController.clear();
            });
          }),
    );
  }

  /*-------------  doLogin -------------*/
  _doLogin() {
    if (_mobileTextEditingController.text.isEmpty) {
      showMessage("Please enter MobileNo");
    } else if (_mobileTextEditingController.text.length != 10) {
      showMessage("Please enter 10 digit  MobileNo");
    } else if (_passwordTextEditingController.text.isEmpty) {
      showMessage("Please enter password");
    } else {
      if (selectedStylistOrSalon == "0") {
        SharedPrefs.writeValue(PrefConstants.isSalon, false);
        SharedPrefs.writeValue(PrefConstants.isStylist, true);
        _authController.doLoginArtiest(
            mobileNo: _mobileTextEditingController.text,
            cc: "91",
            password: _passwordTextEditingController.text,
            callback: () {
              Get.off(() => const StylistBottomBarPage());
            });
      } else {
        SharedPrefs.writeValue(PrefConstants.isStylist, false);
        SharedPrefs.writeValue(PrefConstants.isSalon, true);
        _authController.doLogin(
            mobileNo: _mobileTextEditingController.text,
            cc: "91",
            password: _passwordTextEditingController.text,
            callback: () {
              Get.off(() => const BottomBarPage());
            });
      }
    }
  }
}
