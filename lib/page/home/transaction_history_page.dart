import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/page/home/widget/transaction_history_widget.dart';
import 'package:salon/page/home/widget/unsetted_history_widget.dart';
import 'package:salon/project_specific/progressbar_view.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:salon/util/NoItemsWidget.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  final _homeController = Get.find<HomeController>();
  String? overall = "0";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _homeController.doGetTransactionHistory(distribution: "all_time");
      _homeController.doGetTransactionUnsettledHistory(
          distribution: "all_time");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      appBar: AppBarWidget(
        nameOfScreen: "Transaction History",
        isBackIcon: Navigator.of(context).canPop(),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          _stylistAndSalon(),
          const SizedBox(height: 10),
          _amountAndFilterBar(),
          const SizedBox(height: 10),
          Obx(
            () => Expanded(
              child: _homeController.showProgress
                  ? const ProgressBarView()
                  : overall == "0"
                      ? _buildAllTabList()
                      : overall == "1"
                          ? _buildSettledList()
                          : _buildUnsettledList(),
            ),
          ),
        ],
      ),
    );
  }

  /*----------- Tab Bar variable  ----------- */
  Widget _stylistAndSalon() {
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
          "0": _buildTabText("All", "0"),
          "1": _buildTabText("Settled", "1"),
          "2": _buildTabText("Unsettled", "2"),
        },
        onValueChanged: (dynamic value) {
          overall = value;
          setState(() {
            if (overall == "0") {
              _homeController.doGetTransactionHistory(distribution: "all_time");
              _homeController.doGetTransactionUnsettledHistory(
                  distribution: "all_time");
            } else if (overall == "1") {
              _homeController.doGetTransactionHistory(distribution: "all_time");
            } else if (overall == "2") {
              _homeController.doGetTransactionUnsettledHistory(
                  distribution: "all_time");
            }
          });
        },
      ),
    );
  }

  Widget _buildTabText(String label, String value) {
    return SizedBox(
      width: Get.width,
      height: Get.height * 0.06,
      child: Center(
        child: Text(
          label,
          style: AppTextTheme.medium.copyWith(
            fontSize: 16,
            color: overall == value
                ? ColorConstant.blackColor
                : ColorConstant.grayTextColor,
          ),
        ),
      ),
    );
  }

  /*-------------- Amount Summary + Filter Bar -------------*/
  _amountAndFilterBar() {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 💰 Total Amount Display
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Static label text
                Text(
                  "Total Amount: ",
                  style: AppTextTheme.bold.copyWith(
                    color: ColorConstant.blackColor,
                    fontSize: 16,
                  ),
                ),

                // Dynamic amount only (green and reactive)
                Obx(() {
                  double totalAmount = _calculateTotalAmount();
                  return Text(
                    "₹${totalAmount.toStringAsFixed(2)}",
                    style: AppTextTheme.bold.copyWith(
                      color: Colors.green, // 💚 Green for amount
                      fontSize: 16,
                    ),
                  );
                }),
              ],
            ),
          ),

          // Dropdown Filter
          _dropDownButtonForFilter(),
        ],
      ),
    );
  }

  /*------------------- "All" Tab -------------------*/
  /*------------------- "All" Tab -------------------*/
  Widget _buildAllTabList() {
    final settledList = _homeController.getTransactionsHistoryModel.data ?? [];
    final unsettledList =
        _homeController.getTransactionsUnsettleHistoryModel.data ?? [];

    final totalCount = settledList.length + unsettledList.length;

    if (totalCount == 0) {
      return const NoItemsWidget(text: "No Transactions Found");
    }

    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(
        color: ColorConstant.dividerColor,
        indent: 40,
        endIndent: 20,
      ),
      itemCount: totalCount,
      itemBuilder: (context, index) {
        if (index < settledList.length) {
          // ✅ Settled item (same alignment)
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _doubleArrowIcon(),
                const SizedBox(width: 12),
                Expanded(
                  child: TransactionHistoryWidget(
                    transactionData: settledList[index],
                    showInternalIcon: false,
                  ),
                ),
              ],
            ),
          );
        } else {
          // ✅ Unsettled item (same alignment)
          final adjustedIndex = index - settledList.length;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _doubleArrowIcon(),
                const SizedBox(width: 12),
                Expanded(
                  child: UnsettedHistoryWidget(
                    transactionData: unsettledList[adjustedIndex],
                    showInternalIcon: false,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  /*------------------- "Settled" Tab -------------------*/
  Widget _buildSettledList() {
    final settledData = _homeController.getTransactionsHistoryModel.data ?? [];
    if (settledData.isEmpty) {
      return const NoItemsWidget(text: "No Settled Data Found");
    }

    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(
        color: ColorConstant.dividerColor,
        indent: 40,
        endIndent: 20,
      ),
      itemCount: settledData.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: TransactionHistoryWidget(
            transactionData: settledData[index],
            showInternalIcon: true,
          ),
        );
      },
    );
  }

  /*------------------- "Unsettled" Tab -------------------*/
  Widget _buildUnsettledList() {
    final unsettledData =
        _homeController.getTransactionsUnsettleHistoryModel.data ?? [];
    if (unsettledData.isEmpty) {
      return const NoItemsWidget(text: "No Unsettled Data Found");
    }

    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(
        color: ColorConstant.dividerColor,
        indent: 40,
        endIndent: 20,
      ),
      itemCount: unsettledData.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: UnsettedHistoryWidget(
            transactionData: unsettledData[index],
            showInternalIcon: true,
          ),
        );
      },
    );
  }

  /*------------------- Double Arrow Icon -------------------*/
  Widget _doubleArrowIcon() {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: ColorConstant.primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.sync_alt,
        color: Colors.white,
        size: 26,
      ),
    );
  }

  /*--------------- Filter Dropdown ---------*/
  final List<String> dataList = [
    'All',
    'Today',
    'yesterday',
    'This Week',
    'This Month',
    'This year',
  ];

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
            style: AppTextTheme.medium.copyWith(
              color: ColorConstant.grayColor,
              fontSize: 13,
            ),
          ),
          items: dataList
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: AppTextTheme.medium.copyWith(
                      color: ColorConstant.blackColor,
                      fontSize: 13,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (overall == "0") {
              _applyFilter(value, both: true);
            } else if (overall == "1") {
              _applyFilter(value, settledOnly: true);
            } else if (overall == "2") {
              _applyFilter(value, unsettledOnly: true);
            }
          },
        ),
      ),
    );
  }

  /*--------------------- Filter Helper ------------------*/
  void _applyFilter(String? value,
      {bool both = false,
      bool settledOnly = false,
      bool unsettledOnly = false}) {
    final map = {
      'All': 'all_time',
      'Today': 'today',
      'yesterday': 'yesterday',
      'This Week': 'this_week',
      'This Month': 'this_month',
      'This year': 'this_year',
    };

    final key = map[value] ?? 'all_time';

    if (both) {
      _homeController.doGetTransactionHistory(distribution: key);
      _homeController.doGetTransactionUnsettledHistory(distribution: key);
    } else if (settledOnly) {
      _homeController.doGetTransactionHistory(distribution: key);
    } else if (unsettledOnly) {
      _homeController.doGetTransactionUnsettledHistory(distribution: key);
    }
  }

  /*--------------------- Amount Calculator ------------------*/
  double _calculateTotalAmount() {
    double total = 0.0;

    if (overall == "0") {
      final settled = _homeController.getTransactionsHistoryModel.data ?? [];
      final unsettled =
          _homeController.getTransactionsUnsettleHistoryModel.data ?? [];

      total += settled.fold(
        0.0,
        (sum, item) =>
            sum +
            (double.tryParse(item.items!
                    .fold<double>(0.0, (sum, item) => sum + (item.price ?? 0))
                    .toString()) ??
                0.0),
      );

      total += unsettled.fold(
        0.0,
        (sum, item) =>
            sum +
            (double.tryParse(item.items!
                    .fold<double>(0.0, (sum, item) => sum + (item.price ?? 0))
                    .toString()) ??
                0.0),
      );
    } else if (overall == "1") {
      final settled = _homeController.getTransactionsHistoryModel.data ?? [];
      total += settled.fold(
        0.0,
        (sum, item) =>
            sum +
            (double.tryParse(item.items!
                    .fold<double>(0.0, (sum, item) => sum + (item.price ?? 0))
                    .toString()) ??
                0.0),
      );
    } else if (overall == "2") {
      final unsettled =
          _homeController.getTransactionsUnsettleHistoryModel.data ?? [];
      total += unsettled.fold(
        0.0,
        (sum, item) =>
            sum +
            (double.tryParse(item.items!
                    .fold<double>(0.0, (sum, item) => sum + (item.price ?? 0))
                    .toString()) ??
                0.0),
      );
    }

    return total;
  }
}
