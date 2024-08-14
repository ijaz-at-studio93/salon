import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/page/bank_account/add_bank_account_page.dart';
import 'package:salon/project_specific/button_widget.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';

class AddNewFreshAccountPage extends StatefulWidget {
  const AddNewFreshAccountPage({super.key});

  @override
  State<AddNewFreshAccountPage> createState() => _AddNewFreshAccountPageState();
}

class _AddNewFreshAccountPageState extends State<AddNewFreshAccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      appBar: const AppBarWidget(
        nameOfScreen: "Account Details",
        isBackIcon: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AssetsConstant.image11,
                  height: 300,
                  width: Get.width,
                  fit: BoxFit.fitHeight,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    "It seems to be no account linked. please link to explore more",
                    textAlign: TextAlign.center,
                    style: AppTextTheme.medium.copyWith(
                        fontSize: 19, color: ColorConstant.grayTextColor),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: ButtonWidget(
              buttonTitleText: "Add New bank Account",
              onPress: () {
                Get.to(()=> const AddBankAccountPage());
              },
            ),
          )
        ],
      ),
    );
  }
}
