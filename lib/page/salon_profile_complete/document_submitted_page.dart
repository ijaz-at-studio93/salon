import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/project_specific/progress_container_view.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentSubmittedPage extends StatefulWidget {
  const DocumentSubmittedPage({super.key});

  @override
  State<DocumentSubmittedPage> createState() => _DocumentSubmittedPageState();
}

class _DocumentSubmittedPageState extends State<DocumentSubmittedPage> {
  final _homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      appBar: const AppBarWidget(
        nameOfScreen: "Under Process",
        isBackIcon: false,
      ),
      body: RefreshIndicator(
        onRefresh: getTradLogData,
        child: Obx(
          () => ProgressContainerView(
            isProgressRunning: _homeController.showProgress,
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RefreshIndicator(
                      onRefresh: getTradLogData,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            AssetsConstant.clockImage,
                            height: 150,
                            width: 150,
                          ),
                          const SizedBox(height: 40),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 45),
                            child: Text(
                              "Verification is under Process . Your account will be activated withing 24 hrs.",
                              textScaler: const TextScaler.linear(0.85),
                              textAlign: TextAlign.center,
                              style: AppTextTheme.medium.copyWith(
                                  color: ColorConstant.grayTextColor,
                                  fontSize: 19),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
                Positioned(
                  bottom: 35,
                  right: 0,
                  left: 0,
                  child: GestureDetector(
                    onTap: () {
                      _launchDialer(
                          phoneNumber: _homeController.getEligibilityModel.data
                                  ?.contactDetails?.contactUsMobile ??
                              "");
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AssetsConstant.callIcon,
                          height: 24,
                          width: 24,
                          color: ColorConstant.primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Contact Us",
                          style: AppTextTheme.medium.copyWith(
                              fontSize: 19, color: ColorConstant.primaryColor),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /*======================= LaunchDialer =========================*/
  Future<void> _launchDialer({required String phoneNumber}) async {
    final Uri url = Uri.parse('tel:$phoneNumber');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  /*------------- Get Tread Log Data ------------*/
  Future getTradLogData() async {
    _homeController.doCheckEligibility(callback: () {
      _homeController.doGetSalonDashBoard(distribution: "all_time");
    });
  }
}
