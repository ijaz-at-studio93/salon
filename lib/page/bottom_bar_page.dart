import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/page/home/booking_history_page.dart';
import 'package:salon/page/home/home_page.dart';
import 'package:salon/page/setting/adding_service/add_service_bottm_sheet_page.dart';
import 'package:salon/page/setting/content_page.dart';
import 'package:salon/page/setting/my_details_page.dart';
import '../api/dio_client.dart';
import '../constant/assetsconstant.dart';
import '../constant/color_constant.dart';
import '../project_specific/status_bar_color_appbar.dart';
import '../project_specific/text_theme.dart';
import 'home/transaction_history_page.dart';

class BottomBarPage extends StatefulWidget {
  const BottomBarPage({super.key});

  @override
  State<BottomBarPage> createState() => _BottomBarPageState();
}

class _BottomBarPageState extends State<BottomBarPage> {
  int _selectedIndex = 0;
  final _homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _canPopNow,
      onPopInvoked: (didPop) {
        if (!didPop) {
          tapBackAgainToCloseApp();
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: defaultStatusBarOverlayStyle(context),
        child: Scaffold(
          backgroundColor: ColorConstant.bgColor,
          body: _selectedIndex == 0
            ? const Homepage()
            : _selectedIndex == 1
                ? const BookingHistoryPage()
                : _selectedIndex == 3
                    ? const TransactionHistoryPage()
                    : const MyDetailsPage(),
        extendBody: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColorFiltered(
                colorFilter:
                    const ColorFilter.mode(Colors.transparent, BlendMode.srcIn),
                child: FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: ColorConstant.primaryColor,
                  child: Image.asset(AssetsConstant.contentBtnIcon),
                ),
              ),
              FloatingActionButton(
                heroTag: 'Add Btn',
                onPressed: () {
                  if (_homeController.getEligibilityModel.data?.isApproved ??
                      false) {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        )),
                        context: context,
                        builder: (context) {
                          return const AddServiceBottomSheetPage();
                        });
                  }
                },
                backgroundColor: ColorConstant.primaryColor,
                child: const Center(
                  child: Icon(
                    Icons.add,
                    size: 40,
                    color: ColorConstant.whiteColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 45),
                child: FloatingActionButton(
                  heroTag: 'Content Btn',
                  onPressed: () {
                    // navigate to content page
                    Get.to(() => const ContentPage());
                  },
                  backgroundColor: ColorConstant.primaryColor,
                  child: Image.asset(AssetsConstant.contentBtnIcon),
                ),
              ),
            ],
          ),
        ),
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
                AssetsConstant.home,
                height: 24,
                width: 24,
                color: Colors.transparent,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                AssetsConstant.transactions,
                height: 24,
                width: 24,
                color: _selectedIndex == 3
                    ? ColorConstant.primaryColor
                    : ColorConstant.grayTextColor,
              ),
              label: 'Transactions',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                AssetsConstant.setting,
                height: 24,
                width: 24,
                color: _selectedIndex == 4
                    ? ColorConstant.primaryColor
                    : ColorConstant.grayTextColor,
              ),
              label: 'Settings',
            ),
          ],
          onTap: (val) {
            if (_homeController.getEligibilityModel.data?.isApproved ?? false) {
              setState(() {
                if (val == 2) {
                  _selectedIndex = 3;
                } else {
                  _selectedIndex = val;
                }
              });
            }
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
