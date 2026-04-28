import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/model/translation/salon_transaction_history_model.dart';
import 'package:salon/page/home/widget/transaction_details_page.dart';
import 'package:salon/page/home/widget/wallet_transaction_details_page.dart';
import 'package:salon/project_specific/progressbar_view.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:salon/util/NoItemsWidget.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:salon/constant/api_constant.dart';

class SalonWalletTransactionPage extends StatefulWidget {
  const SalonWalletTransactionPage({super.key});

  @override
  State<SalonWalletTransactionPage> createState() =>
      _SalonWalletTransactionPageState();
}

class _SalonWalletTransactionPageState
    extends State<SalonWalletTransactionPage> {
  final _homeController = Get.find<HomeController>();
  String _selectedFilter = 'All';
  bool _showDepositsOnly = false;
  bool _includeGST = true; // default checked

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _homeController.doGetSalonWalletTransactions(distribution: 'all_time');
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
          _filterBar(),
          const SizedBox(height: 10),
          Obx(
                () => Expanded(
              child: _homeController.showProgress
                  ? const ProgressBarView()
                  : _buildTransactionList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterBar() {
    final dashboardData = _homeController.getSalonDashboardModel.data;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// LEFT → dropdown
          _dropDownButtonForFilter(),

          /// RIGHT → checkboxes
          Row(
            children: [
              Row(
                children: [
                  Checkbox(
                    value: _showDepositsOnly,
                    visualDensity: VisualDensity.compact, // 👈 important
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onChanged: (val) {
                      setState(() {
                        _showDepositsOnly = val ?? false;
                      });
                    },
                  ),
                  const Text("Deposits"),
                ],
              ),
              SizedBox(width: 8,),
              if (dashboardData?.isGSTRegistered == true) ...[
                Row(
                  children: [
                    Checkbox(
                      value: _includeGST,
                      visualDensity: VisualDensity.compact, // 👈 important
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: (val) {
                        setState(() {
                          _includeGST = val ?? true;
                        });
                      },
                    ),
                    const Text("GST"),
                  ],
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }

  // Widget _buildTransactionList() {
  //   final allTransactions =
  //       _homeController.getSalonTransactionsHistoryModel.data ?? [];
  //
  //   List<SalonTransactionData> transactions = allTransactions;
  //
  //   /// 🔥 Deposits → only credits
  //   if (_showDepositsOnly) {
  //     transactions = transactions.where((tx) => tx.isCredit).toList();
  //   }
  //
  //   if (transactions.isEmpty) {
  //     return const NoItemsWidget(text: "No Transactions Found");
  //   }
  //
  //   return ListView.separated(
  //     separatorBuilder: (_, __) => const Divider(
  //       color: ColorConstant.dividerColor,
  //       indent: 20,
  //       endIndent: 20,
  //     ),
  //     itemCount: transactions.length,
  //     itemBuilder: (context, index) {
  //       final tx = transactions[index];
  //       return _transactionCard(tx);
  //     },
  //   );
  // }

  Widget _buildTransactionList() {
    final allTransactions =
        _homeController.getSalonTransactionsHistoryModel.data ?? [];

    List<SalonTransactionData> transactions = allTransactions;

    if (_showDepositsOnly) {
      transactions = transactions.where((tx) => tx.isCredit).toList();
    }

    if (transactions.isEmpty) {
      return const NoItemsWidget(text: "No Transactions Found");
    }

    /// 🔥 STEP 1: reverse → oldest → latest
    final ascList = List<SalonTransactionData>.from(transactions.reversed);

    /// 🔥 STEP 2: find first credit
    final firstCreditIndex =
    ascList.indexWhere((tx) => tx.isCredit);

    if (firstCreditIndex == -1) {
      return const NoItemsWidget(text: "No valid transactions");
    }

    /// 🔥 STEP 3: take from first credit → forward
    final filtered = ascList.sublist(firstCreditIndex);

    /// 🔥 STEP 4: forward calculation
    final dashboardData = _homeController.getSalonDashboardModel.data;
    double runningBalance =
    (dashboardData?.walletBalance ?? 0).toDouble();

    List<Widget> widgets = [];

    /// 🔥 IMPORTANT: iterate from latest → oldest
    for (int i = filtered.length - 1; i >= 0; i--) {
      final tx = filtered[i];
      final amount = (tx.amount ?? 0).toDouble();

      final balanceForRow = runningBalance;

      /// 🔥 safe signed logic
      final signedAmount =
      tx.isCredit ? amount.abs() : -amount.abs();

      runningBalance -= signedAmount;

      widgets.add(_transactionCard(tx, balanceForRow));
    }

    return ListView.separated(
      itemCount: widgets.length,
      separatorBuilder: (_, __) => const Divider(
        color: ColorConstant.dividerColor,
        indent: 20,
        endIndent: 20,
      ),
      itemBuilder: (context, index) => widgets[index],
    );
  }

  Widget _transactionCard(SalonTransactionData tx,double balance) {
    final isCredit = tx.isCredit;
    final rawAmount = tx.amount ?? 0;
    double displayAmount = rawAmount.abs();

    /// 🔥 GST OFF → apply TCS on BASE (correct logic)
    if (!_includeGST && tx.isDebit) {
      final baseAmount = displayAmount / 1.05; // remove GST
      final tcs = baseAmount * 0.01;           // 1% of base
      displayAmount = displayAmount - tcs;
    }

    final amountStr = tx.isCredit
        ? '+${displayAmount.toStringAsFixed(0)}'
        : '-${displayAmount.toStringAsFixed(0)}';
    final amountColor = isCredit
        ? const Color(0xFF8454E5)//
        : Colors.red;//const Color(0xFF01AB4D);
    final userName = tx.user?.name ?? '-';
    final date = _formatDate(tx.createdAt ?? '');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// LEFT CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Received From',
                  style: AppTextTheme.medium.copyWith(
                    color: ColorConstant.blackColor,
                    fontSize: 14,
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Stack(
                  children: [
                    /// LEFT → NAME
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        userName,
                        style: AppTextTheme.bold.copyWith(
                          color: ColorConstant.primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),


                    /// CENTER → BALANCE (true center)
                    Center(
                      child: Text(
                        "(Balance: ${balance.toStringAsFixed(0)})",
                        style: AppTextTheme.semibold.copyWith(
                          color: Colors.green,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Date : ',
                        style: AppTextTheme.regular.copyWith(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: date,
                        style: AppTextTheme.semibold.copyWith(
                          color: const Color(0xFF8454E5),
                          fontSize: 14,
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          /// RIGHT CONTENT
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amountStr,
                style: AppTextTheme.bold.copyWith(
                  color: amountColor,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              _viewButton(tx), // 👈 always show view button
            ],
          ),
        ],
      ),
    );
  }

  Widget _viewButton(SalonTransactionData tx) {
    return InkWell(
      onTap: () {
        if (tx.isCredit) {
          _showPaymentProofDialog(tx.paymentProof);
        } else {
          // navigate to booking detail
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => WalletTransactionDetailsPage(data: tx),
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 29, // 🔥 fixed height
        width: 61,  // 🔥 fixed width
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0x4D01AB4D), // 30% opacity
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFF01AB4D),
            width: 1,
          ),
        ),
        child: Text(
          'View',
          style: AppTextTheme.regular.copyWith(
            color: Colors.black, // 🔥 FIXED
            fontSize: 14,
            fontFamily: 'Outfit',
            fontWeight:FontWeight.w400
            // 🔥 closer to figma
          ),
        ),
      ),
    );
  }

  void _showPaymentProofDialog(String? paymentProof) {
    if (paymentProof == null || paymentProof.isEmpty) {
      Get.snackbar(
        'No Proof',
        'Payment proof not available',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: Get.height * 0.7,   // 🔥 increase here
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: '${APIConstants.image}$paymentProof',
                  //fit: BoxFit.contain,
                  placeholder: (context, url) => Container(
                    width: double.infinity,
                    height: Get.height * 0.7,
                    color: Colors.white,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: double.infinity,
                    height: Get.height * 0.7,
                    color: Colors.white,
                    child: const Center(
                      child: Icon(Icons.broken_image, size: 60, color: Colors.grey),
                    ),
                  ),
                ),
              )
            ),
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.black, size: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String date) {
    if (date.isEmpty) return '-';
    try {
      final dt = DateTime.parse(date);
      return DateFormat('MM/dd/yyyy').format(dt);
    } catch (_) {
      return '-';
    }
  }

  /*--------------- Filter Dropdown ---------*/
  final List<String> dataList = [
    'All',
    'Today',
    'Yesterday',
    'This Week',
    'This Month',
    'This Year',
  ];

  final Map<String, String> _filterMap = {
    'All': 'all_time',
    'Today': 'today',
    'Yesterday': 'yesterday',
    'This Week': 'this_week',
    'This Month': 'this_month',
    'This Year': 'this_year',
  };

  Widget _dropDownButtonForFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
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
            if (value == null) return;
            setState(() => _selectedFilter = value);
            final key = _filterMap[value] ?? 'all_time';
            _homeController.doGetSalonWalletTransactions(distribution: key);
          },
        ),
      ),
    );
  }
}