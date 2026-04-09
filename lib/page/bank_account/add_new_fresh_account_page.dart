import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/api_constant.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/constant/variable_constant.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/page/bank_account/add_bank_account_page.dart';
import 'package:salon/page/bank_account/bank_details_page_list_tile_widget.dart';
import 'package:salon/project_specific/button_widget.dart';
import 'package:salon/project_specific/progressbar_view.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';

class AddNewFreshAccountPage extends StatefulWidget {
  const AddNewFreshAccountPage({super.key});

  @override
  State<AddNewFreshAccountPage> createState() => _AddNewFreshAccountPageState();
}

class _AddNewFreshAccountPageState extends State<AddNewFreshAccountPage> {
  final _homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _homeController.doGetBankAccountDetails();
      bankName = "";
      bankImage = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      appBar: const AppBarWidget(
        nameOfScreen: "Account Details",
        isBackIcon: true,
      ),
      body: Obx(
        () => _homeController.showProgress
            ? const ProgressBarView()
            : Column(
                children: [
                  _homeController.getSalonBankAccountList.data?.isEmpty ?? false
                      ? Expanded(
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                child: Text(
                                  "It seems to be no account linked. please link to explore more",
                                  textAlign: TextAlign.center,
                                  style: AppTextTheme.medium.copyWith(
                                      fontSize: 19,
                                      color: ColorConstant.grayTextColor),
                                ),
                              )
                            ],
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _homeController
                                      .getSalonBankAccountList.data?.length ??
                                  0,
                              itemBuilder: (context, i) {
                                return BankDetailsPageListTileWidget(
                                  onTapDelete: () {
                                    _homeController.doDeleteBankAccount(
                                        accountId: _homeController
                                                .getSalonBankAccountList
                                                .data?[i]
                                                .id ??
                                            "",
                                        callback: () {
                                          _homeController
                                              .doGetBankAccountDetails();
                                        });
                                  },
                                  accountHolderName: _homeController
                                          .getSalonBankAccountList
                                          .data?[i]
                                          .accountHolderName ??
                                      "",
                                  accountNumber: _homeController
                                          .getSalonBankAccountList
                                          .data?[i]
                                          .accountNumber ??
                                      "",
                                  accountType: _homeController
                                          .getSalonBankAccountList
                                          .data?[i]
                                          .accountType ??
                                      "",
                                  bankIconImage:
                                      "${APIConstants.image}${_homeController.getSalonBankAccountList.data?[i].bankIconImage ?? ""}",
                                  bankName: _homeController
                                          .getSalonBankAccountList
                                          .data?[i]
                                          .bankName ??
                                      "",
                                  branchName: _homeController
                                          .getSalonBankAccountList
                                          .data?[i]
                                          .branchName ??
                                      "",
                                  ifscCode: _homeController
                                          .getSalonBankAccountList
                                          .data?[i]
                                          .ifscCode ??
                                      "",
                                );
                              })),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    child: ButtonWidget(
                      buttonTitleText: "Add New bank Account",
                      onPress: () {
                        Get.to(() => AddBankAccountPage(
                              callback: () {
                                _homeController.doGetBankAccountDetails();
                              },
                            ));
                      },
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
