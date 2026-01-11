import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
//import 'package:platform_device_id/platform_device_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/auth_controller.dart';
import 'package:salon/page/bottom_bar_page.dart';
import 'package:salon/page/stylist_all_module/stylist_bottom_bar_page.dart';
import 'package:salon/project_specific/progress_container_view.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:salon/util/app_conctant.dart';
import 'package:salon/util/shared_prefs.dart';
import 'package:url_launcher/url_launcher.dart';
import '../project_specific/button_widget.dart';
import 'auth/login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    getVersionApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => ProgressContainerView(
          isProgressRunning: _authController.showProgress,
          child: Container(
            height: Get.height,
            width: Get.width,
            color: ColorConstant.primaryColor,
            child: Center(
              child: Text(
                "Scuts for Business",
                style: AppTextTheme.bold
                    .copyWith(color: ColorConstant.whiteColor, fontSize: 35),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /*-------------- Route For Welcome Page -----------------*/
  route() {
    Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
            child: SharedPrefs.readBoolValue(PrefConstants.isUserLogin)
                ? SharedPrefs.readBoolValue(PrefConstants.isSalon)
                    ? const BottomBarPage()
                    : const StylistBottomBarPage()
                : const LoginPage(),
            alignment: Alignment.center,
            duration: const Duration(milliseconds: 800),
            // type: PageTransitionType.rightToLeftWithFade
            type: PageTransitionType.size),
        (route) => false);
  }

  /*---------------  Force Update Widget ---------------*/
  _forceUpdateDialog() async {
    return Get.defaultDialog(
        title: "ABOUT UPDATE",
        barrierDismissible: false,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  "1 . ",
                  style: AppTextTheme.bold
                      .copyWith(color: ColorConstant.blackColor, fontSize: 14),
                ),
                Text(
                  "Fix Some Bug",
                  style: AppTextTheme.medium
                      .copyWith(color: ColorConstant.grayColor, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Text(
                  "2 . ",
                  style: AppTextTheme.bold
                      .copyWith(color: ColorConstant.blackColor, fontSize: 14),
                ),
                Text(
                  "Improve Loading Experience",
                  style: AppTextTheme.medium
                      .copyWith(color: ColorConstant.grayColor, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Text(
                  "3 . ",
                  style: AppTextTheme.bold
                      .copyWith(color: ColorConstant.blackColor, fontSize: 14),
                ),
                Text(
                  "User Interface Bug Fixing",
                  style: AppTextTheme.medium
                      .copyWith(color: ColorConstant.grayColor, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Text(
                  "4 . ",
                  style: AppTextTheme.bold
                      .copyWith(color: ColorConstant.blackColor, fontSize: 14),
                ),
                Text(
                  "Crash Free App",
                  style: AppTextTheme.medium
                      .copyWith(color: ColorConstant.grayColor, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Text(
                  "5 . ",
                  style: AppTextTheme.bold
                      .copyWith(color: ColorConstant.blackColor, fontSize: 14),
                ),
                Text(
                  "New Navigation Interaction",
                  style: AppTextTheme.medium
                      .copyWith(color: ColorConstant.grayColor, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ButtonWidget(
                  buttonTitleText: "UPDATE",
                  onPress: () {
                    Get.back();
                    _launchURL();
                  }),
            )
          ],
        ));
  }

  /*--------------- Force Update Dialog -------------*/
  _normalUpdateDialog() async {
    return Get.defaultDialog(
      barrierDismissible: false,
      title: "Update Info",
      content: Text(
        "New Version Is Available . Please Update Application",
        style: AppTextTheme.medium
            .copyWith(color: ColorConstant.blackColor, fontSize: 12),
      ),
      confirm: TextButton(
          onPressed: () {
            Get.back();
            _launchURL();
          },
          child: Text(
            "UPDATE",
            style: AppTextTheme.medium
                .copyWith(color: ColorConstant.blackColor, fontSize: 14),
          )),
      cancel: TextButton(
          onPressed: () {
            route();
          },
          child: Text(
            "LATER",
            style: AppTextTheme.medium
                .copyWith(color: ColorConstant.redColor, fontSize: 14),
          )),
    );
  }

  /*------------------ GET VERSION APP -------------------*/
  void getVersionApp() async {
    //String? deviceId = await PlatformDeviceId.getDeviceId;
    // 💡 FIX START
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String? deviceId;

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor;
    }
    // 💡 FIX END

    SharedPrefs.writeValue(PrefConstants.deviceId, deviceId);
    String data = await getVersion();

    _authController.doAppUpdate(callback: () {
      if (_authController.getAppUpdateModel.data?.salonAppLatestVersion !=
          data) {
        if (_authController.getAppUpdateModel.data?.forceUpdateSalonApp ??
            false) {
          _forceUpdateDialog();
        } else {
          _normalUpdateDialog();
        }
      } else {
        route();
      }
    });
  }

  /*----------------- Open PlayStore -------------*/
  void _launchURL() async {
    const url =
        'https://play.google.com/store/apps/details?id=com.ananta.saloon';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
