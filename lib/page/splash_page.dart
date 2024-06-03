import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/page/bottom_bar_page.dart';
import 'package:salon/page/stylist_all_module/stylist_bottom_bar_page.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:salon/util/shared_prefs.dart';
import 'auth/login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    startTime();


    super.initState();
  }

  /*------------ Route Time -----------*/
  startTime() async {
    var duration = const Duration(seconds: 4);
    return Timer(duration, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        color: ColorConstant.primaryColor,
        child: Center(
          child: Text(
            "SALON",
            style: AppTextTheme.bold
                .copyWith(color: ColorConstant.whiteColor, fontSize: 35),
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
}
