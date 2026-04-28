import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/page/home/salon_wallet_transaction_history_page.dart';
import 'old_transaction_history_page.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  final _homeController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
  final isUpfront = _homeController.getSalonDashboardModel.data?.isUpfront ?? false;

  if (isUpfront) {
    return const SalonWalletTransactionPage(); // 👈 new page
  } else {
    return OldTransactionHistoryPage(); // 👈 existing page
  }
  }
}