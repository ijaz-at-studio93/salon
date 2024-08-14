import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:salon/constant/color_constant.dart';
import 'package:salon/page/home/widget/transaction_history_widget.dart';
import 'package:salon/page/home/widget/unsetted_history_widget.dart';
import 'package:salon/project_specific/progressbar_view.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:salon/util/NoItemsWidget.dart';

import '../../controller/home_controller.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  final _homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _homeController.doGetTransactionHistory(distribution: "all_time");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      appBar: const AppBarWidget(
        nameOfScreen: "Transaction History",
        isBackIcon: false,
      ),
      body: Column(
        children: [
          /* _searchAndService(),*/
          const SizedBox(height: 10),
          _stylistAndSalon(),
          const SizedBox(height: 10),
          _downloadWidget(),
          const SizedBox(height: 10),
          Obx(
            () => Expanded(
                child: _homeController.showProgress
                    ? const ProgressBarView()
                    : overall == "0"
                        ? _homeController.getTransactionsHistoryModel.data
                                    ?.isEmpty ??
                                false
                            ? const NoItemsWidget(
                                text: "No Settled Data Found",
                              )
                            : ListView.separated(
                                separatorBuilder: (context, index) {
                                  return const Divider(
                                      color: ColorConstant.dividerColor,
                                      indent: 40,
                                      endIndent: 20);
                                },
                                shrinkWrap: true,
                                itemCount: _homeController
                                        .getTransactionsHistoryModel
                                        .data
                                        ?.length ??
                                    0,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 5),
                                    child: TransactionHistoryWidget(
                                      transactionData: _homeController
                                          .getTransactionsHistoryModel
                                          .data![index],
                                    ),
                                  );
                                },
                              )
                        : _homeController.getTransactionsUnsettleHistoryModel
                                    .data?.isEmpty ??
                                false
                            ? const NoItemsWidget(
                                text: "No Unsettled Data Found",
                              )
                            : ListView.separated(
                                separatorBuilder: (context, index) {
                                  return const Divider(
                                      color: ColorConstant.dividerColor,
                                      indent: 40,
                                      endIndent: 20);
                                },
                                shrinkWrap: true,
                                itemCount: _homeController
                                        .getTransactionsUnsettleHistoryModel
                                        .data
                                        ?.length ??
                                    0,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 5),
                                    child: UnsettedHistoryWidget(
                                      transactionData: _homeController
                                          .getTransactionsUnsettleHistoryModel
                                          .data![index],
                                    ),
                                  );
                                },
                              )),
          )
        ],
      ),
    );
  }

  /*----------- Tab Bar variable  ----------- */
  String? overall = "0";

  /*------------------- Switch Tab Stylist & Salon -------------------*/
  _stylistAndSalon() {
    return Container(
      color: ColorConstant.whiteColor,
      width: Get.width,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: CupertinoSlidingSegmentedControl(
          backgroundColor: ColorConstant.gray,
          padding: const EdgeInsets.all(6),
          groupValue: overall,
          thumbColor: ColorConstant.whiteColor,
          children: {
            "0": SizedBox(
              width: Get.width,
              height: Get.height * 0.06,
              child: Center(
                child: Text(
                  "Settled",
                  style: AppTextTheme.medium.copyWith(
                      fontSize: 16,
                      color: overall == "0"
                          ? ColorConstant.blackColor
                          : ColorConstant.grayTextColor),
                ),
              ),
            ),
            "1": Text(
              "Unsettled",
              style: AppTextTheme.medium.copyWith(
                  fontSize: 16,
                  color: overall == "1"
                      ? ColorConstant.blackColor
                      : ColorConstant.grayTextColor),
            ),
          },
          onValueChanged: (dynamic value) {
            overall = value;
            if (overall == "0") {
              setState(() {
                _homeController.doGetTransactionHistory(
                    distribution: "all_time");
              });
            } else {
              setState(() {
                _homeController.doGetTransactionUnsettledHistory(
                    distribution: "all_time");
              });
            }
          }),
    );
  }

  /*-------------- Download Row  widget -------------*/
  _downloadWidget() {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          /*GestureDetector(
            onTap: () {},
            child: Container(
              height: 50,
              margin: const EdgeInsets.only(right: 20, left: 20),
              padding: const EdgeInsets.only(right: 20, left: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: ColorConstant.dividerColor),
              ),
              child: Center(
                child: Text(
                  "Download Statement",
                  style: AppTextTheme.medium
                      .copyWith(color: ColorConstant.blackColor, fontSize: 14),
                ),
              ),
            ),
          ),*/
          _dropDownButtonForFilter(),
        ],
      ),
    );
  }

  /*--------------- Dummy Data ---------*/
  final List<String> dataList = [
    'All',
    'Today',
    'yesterday',
    'This Week',
    'This Month',
    'This year',
  ];

  /*--------------------- No. Of Service You Offer ------------------*/
  _dropDownButtonForFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 50,
        width: Get.width * 0.4,
        child: DropdownButtonFormField2<String>(
          isExpanded: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          hint: Text(
            'All',
            style: AppTextTheme.medium
                .copyWith(color: ColorConstant.grayColor, fontSize: 13),
          ),
          items: dataList
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item,
                        style: AppTextTheme.medium.copyWith(
                            color: ColorConstant.blackColor, fontSize: 13)),
                  ))
              .toList(),
          validator: (value) {
            if (value == null) {
              return value;
            }
            return null;
          },
          onChanged: (value) {
            if (overall == "0") {
              if (value == 'All') {
                _homeController.doGetTransactionHistory(
                    distribution: "all_time");
              } else if (value == 'Today') {
                _homeController.doGetTransactionHistory(distribution: "today");
              } else if (value == 'yesterday') {
                _homeController.doGetTransactionHistory(
                    distribution: "yesterday");
              } else if (value == 'This Week') {
                _homeController.doGetTransactionHistory(
                    distribution: "this_week");
              } else if (value == 'This Month') {
                _homeController.doGetTransactionHistory(
                    distribution: "this_month");
              } else if (value == 'This year') {
                _homeController.doGetTransactionHistory(
                    distribution: "this_year");
              }
            } else {
              if (value == 'All') {
                _homeController.doGetTransactionUnsettledHistory(
                    distribution: "all_time");
              } else if (value == 'Today') {
                _homeController.doGetTransactionUnsettledHistory(
                    distribution: "today");
              } else if (value == 'yesterday') {
                _homeController.doGetTransactionUnsettledHistory(
                    distribution: "yesterday");
              } else if (value == 'This Week') {
                _homeController.doGetTransactionUnsettledHistory(
                    distribution: "this_week");
              } else if (value == 'This Month') {
                _homeController.doGetTransactionUnsettledHistory(
                    distribution: "this_month");
              } else if (value == 'This year') {
                _homeController.doGetTransactionUnsettledHistory(
                    distribution: "this_year");
              }
            }
          },
          onSaved: (value) {},
          buttonStyleData: const ButtonStyleData(
            padding: EdgeInsets.only(right: 8),
          ),
          iconStyleData: const IconStyleData(
            icon: Icon(
              Icons.arrow_drop_down,
              color: Colors.black,
            ),
            iconSize: 24,
          ),
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            padding: EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
      ),
    );
  }

/*------------------ Search and Service ---------------*/
/*  _searchAndService() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
            width: Get.width * 0.8,
            child: TextField(
              controller: _historyTextEditingController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "",
                  hintStyle: AppTextTheme.regular.copyWith(
                      fontSize: 16, color: ColorConstant.grayTextColor)),
            ),
          ),
        ],
      ),
    );
  }*/
}
