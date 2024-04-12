import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/page/adding_service/add_product_page.dart';
import 'package:salon/page/adding_service/widget/add_service_check_box_list_tile_widget.dart';
import 'package:salon/page/adding_service/widget/reset_and_add_row_widget.dart';
import 'package:salon/project_specific/text_theme.dart';

import '../../project_specific/project_appbar.dart';

class AddServicePage extends StatefulWidget {
  const AddServicePage({super.key});

  @override
  State<AddServicePage> createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> {
  final _searchServiceEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.whiteColor,
      appBar: const AppBarWidget(
        nameOfScreen: "Add Service",
        isBackIcon: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _countRowWidget(),
          _searchAndService(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Text(
              "Suggested Service:",
              style: AppTextTheme.regular
                  .copyWith(color: ColorConstant.grayTextColor, fontSize: 14),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.separated(
                      separatorBuilder: (context, index) {
                        return const Divider(
                          endIndent: 20,
                          indent: 20,
                          color: ColorConstant.dividerColor,
                        );
                      },
                      itemCount: 15,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: AddServiceCheckBoxListTileWidget(),
                        );
                      }),
                ],
              ),
            ),
          ),
          ResetAndAddRowWidget(
            reset: () {},
            add: () {
              Get.to(()=> const AddProductPage());
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
                    style: AppTextTheme.bold
                        .copyWith(color: ColorConstant.whiteColor, fontSize: 16),
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
            padding: const EdgeInsets.only(right:60,left: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Select Service",
                  textScaler: const TextScaler.linear(0.85),
                  style: AppTextTheme.regular.copyWith(
                      color: ColorConstant.grayTextColor, fontSize: 12),
                ),
                Text(
                  "Add Prodcut",
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

  /*------------------ Search and Service ---------------*/
  _searchAndService() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: ShapeDecoration(
        color: ColorConstant.whiteColor,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFE1E1E1)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Image.asset(
            AssetsConstant.search,
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 5),
          SizedBox(
            width: Get.width * 0.6,
            child: TextField(
              controller: _searchServiceEditingController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search and add service",
                  hintStyle: AppTextTheme.regular.copyWith(
                      fontSize: 16, color: ColorConstant.grayTextColor)),
            ),
          ),
        ],
      ),
    );
  }
}
