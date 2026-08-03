import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salon/api/dio_client.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/page/stylist_all_module/profile/stylist_profile_page.dart';
import 'package:salon/page/stylist_all_module/stylist_home_page/blog/bloag_add_sheet_page.dart';
import 'package:salon/page/stylist_all_module/stylist_home_page/bokking_overview/stylist_booking_over_view_page.dart';
import 'package:salon/project_specific/status_bar_color_appbar.dart';
import 'package:salon/util/notification_service.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'stylist_home_page/stylist_home_page_2.dart';

class StylistBottomBarPage extends StatefulWidget {
  const StylistBottomBarPage({super.key});

  @override
  State<StylistBottomBarPage> createState() => _StylistBottomBarPageState();
}

class _StylistBottomBarPageState extends State<StylistBottomBarPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Reaching here means there is a home screen to push onto, so any deep link
    // or notification held during launch or sign-in can now open.
    AppLaunchGate.markRouted();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _canPopNow,
      onPopInvoked: (bool didPop) {
        if (!didPop) {
          tapBackAgainToCloseApp();
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: defaultStatusBarOverlayStyle(context),
        child: Scaffold(
          backgroundColor: ColorConstant.bgColor,
          body: _selectedIndex == 0
            ? const HomePage2()
            : _selectedIndex == 1
                ? const StylistBookingOverViewPage()
                : const StylistProfilePage(),
        extendBody: false,
        floatingActionButton: _selectedIndex == 0
            ? FloatingActionButton(
                onPressed: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    backgroundColor: ColorConstant.whiteColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    context: context,
                    builder: (context) => const BlogAddSheetPage(),
                  );
                },
                backgroundColor: ColorConstant.primaryColor,
                child: const Center(
                  child: Icon(
                    Icons.add,
                    size: 40,
                    color: ColorConstant.whiteColor,
                  ),
                ),
              )
            : const SizedBox(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          showUnselectedLabels: true,
          showSelectedLabels: true,
          unselectedLabelStyle: AppTextTheme.medium
              .copyWith(color: ColorConstant.grayTextColor, fontSize: 13),
          selectedLabelStyle: AppTextTheme.medium
              .copyWith(color: ColorConstant.primaryColor, fontSize: 13),
          selectedItemColor: ColorConstant.primaryColor,
          unselectedItemColor: ColorConstant.grayTextColor,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                AssetsConstant.home,
                height: 24,
                width: 24,
                color: _selectedIndex == 0
                    ? ColorConstant.primaryColor
                    : ColorConstant.grayTextColor,
              ),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                AssetsConstant.booking,
                height: 24,
                width: 24,
                color: _selectedIndex == 1
                    ? ColorConstant.primaryColor
                    : ColorConstant.grayTextColor,
              ),
              label: 'Bookings',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                AssetsConstant.setting,
                height: 24,
                width: 24,
                color: _selectedIndex == 2
                    ? ColorConstant.primaryColor
                    : ColorConstant.grayTextColor,
              ),
              label: 'Settings',
            ),
          ],
          onTap: (val) {
            setState(() {
              _selectedIndex = val;
            });
          },
        ),
      ),
      ),
    );
  }

  bool _canPopNow = false;
  DateTime? _currentBackPressTime;

  /*---------------  TapBack Button ----------------*/
  void tapBackAgainToCloseApp() {
    DateTime now = DateTime.now();
    if (_currentBackPressTime == null ||
        now.difference(_currentBackPressTime!) > const Duration(seconds: 3)) {
      _currentBackPressTime = now;
      showMessage("Tap back again to close the app");
      setState(() {
        _canPopNow = true; // Temporarily let user exit app on the next back tap
      });
      Future.delayed(
        const Duration(seconds: 3),
        () {
          setState(() {
            _canPopNow = false;
            _currentBackPressTime = null;
          });
        },
      );
    }
  }
}
