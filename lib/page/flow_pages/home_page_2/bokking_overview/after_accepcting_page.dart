import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/page/adding_service/widget/reset_and_add_row_widget.dart';
import 'package:salon/page/flow_pages/home_page_2/bokking_overview/upload_photo_page.dart';
import 'package:salon/page/flow_pages/home_page_2/bokking_overview/widget/item_checkbox_widget.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';

class AfterAcceptingPage extends StatefulWidget {
  const AfterAcceptingPage({super.key});

  @override
  State<AfterAcceptingPage> createState() => _AfterAcceptingPageState();
}

class _AfterAcceptingPageState extends State<AfterAcceptingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.whiteColor,
      appBar: const AppBarWidget(
        nameOfScreen: "ID: 79828AH8918",
        isBackIcon: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _timingWidget(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: Text(
                      "Items",
                      style: AppTextTheme.medium.copyWith(
                          color: ColorConstant.grayTextColor, fontSize: 16),
                    ),
                  ),
                  ListView.builder(
                      itemCount: 5,
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, i) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: ItemCheckBoxWidget(),
                        );
                      }),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: Text(
                      "Terms & Condition",
                      style: AppTextTheme.medium.copyWith(
                          color: ColorConstant.grayTextColor, fontSize: 16),
                    ),
                  ),
                  ListView.builder(
                      itemCount: 10,
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${index + 1}.",
                                style: AppTextTheme.medium.copyWith(
                                    color: ColorConstant.grayTextColor,
                                    fontSize: 12),
                              ),
                              const SizedBox(width: 5),
                              SizedBox(
                                width: Get.width * 0.84,
                                child: Text(
                                  "Acceptance of Terms: By using this app, you agree to abide by these terms and conditions.",
                                  style: AppTextTheme.medium.copyWith(
                                      color: ColorConstant.grayTextColor,
                                      fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                ],
              ),
            ),
          ),
          ResetAndAddRowWidget(
            add: () {
              Get.to(()=> const UploadPhotoPage());
            },
            reset: () {},
            buttonRest: "Skip & Continue",
            buttonAdd: "Take Photos",
          )
        ],
      ),
    );
  }

  /*----------- timing widget ------------*/
  _timingWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 40,
      color: ColorConstant.bgColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Timing",
            style: AppTextTheme.medium
                .copyWith(color: ColorConstant.grayTextColor, fontSize: 16),
          ),
          Text(
            "30:00:00",
            style: AppTextTheme.bold
                .copyWith(color: ColorConstant.primaryColor, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
