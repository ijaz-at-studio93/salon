import 'package:flutter/material.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/text_theme.dart';
import '../../../model/translation/translation_history_model.dart';

class TransactionDetailsPage extends StatelessWidget {
  final TransactionData data;

  const TransactionDetailsPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // ⭐ Commission Logic
    double totalPrice = data.items!.fold<double>(0.0,
            (sum, item) => sum + (item.price ?? 0)); //double.tryParse(data.orderAmount.toString()) ?? 0;
    double commissionPercent = 0;

    if (totalPrice <= 1500) {
      commissionPercent = 10;
    } else if (totalPrice <= 4000) {
      commissionPercent = 15;
    } else {
      commissionPercent = 20;
    }

    double deductedAmount = (totalPrice * commissionPercent) / 100;
    double receivable = totalPrice - deductedAmount;

    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      appBar: AppBar(
        backgroundColor: ColorConstant.primaryColor,
        title: const Text("Transaction Details"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // ⭐ BLOCK 1 — BASIC DETAILS
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _row("Order ID", data.idx ?? "N/A"),
                  const SizedBox(height: 10),
                  _row("Staff Name", data.appointment?.artist?.name ?? "N/A"),
                  const SizedBox(height: 10),
                  _row("Date & Time", data.createdAt ?? "N/A"),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ⭐ BLOCK 2 — SERVICE BREAKDOWN + TOTAL
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Service Breakdown",
                    style: AppTextTheme.bold.copyWith(
                      fontSize: 18,
                      color: ColorConstant.blackColor,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Service items list
                      ...data.items!.map((item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  item.service?.name ?? "",
                                  style: AppTextTheme.medium.copyWith(
                                    fontSize: 15,
                                    color: ColorConstant.blackColor,
                                  ),
                                ),
                              ),
                              Text(
                                "₹${(item.price ?? 0).toStringAsFixed(0)}",
                                style: AppTextTheme.medium.copyWith(
                                  fontSize: 15,
                                  color: ColorConstant.blackColor,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),

                      const SizedBox(height: 12),
                    ],
                  ),

                  const SizedBox(height: 10),
                  const Divider(thickness: 1, color: Colors.black12),
                  const SizedBox(height: 10),

                  // ⭐ TOTAL
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total",
                        style: AppTextTheme.bold.copyWith(
                          fontSize: 16,
                          color: ColorConstant.blackColor,
                        ),
                      ),
                      Text(
                        "₹${data.items!.fold<double>(0.0,
                                (sum, item) => sum + (item.price ?? 0))
                            .toStringAsFixed(0)}",
                        style: AppTextTheme.bold.copyWith(
                          fontSize: 16,
                          color: ColorConstant.blackColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ⭐ NEW BLOCK — DEDUCTABLE + RECEIVABLE
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ⭐ Deductable Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // UNDERLINE ONLY ON THE % VALUE
                      RichText(
                        text: TextSpan(
                          style: AppTextTheme.bold.copyWith(
                            fontSize: 16,
                            color: ColorConstant.blackColor,
                          ),
                          children: [
                            const TextSpan(text: "Deductable ("),
                            TextSpan(
                              text: "${commissionPercent.toStringAsFixed(0)}%",
                              style: const TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            const TextSpan(text: ")"),
                          ],
                        ),
                      ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "₹${deductedAmount.toStringAsFixed(1)}",
                            style: AppTextTheme.medium.copyWith(
                              fontSize: 15,
                              color: ColorConstant.blackColor,
                            ),
                          ),

                          const SizedBox(width: 8),

                          GestureDetector(
                            onTap: () {
                              showCommissionPopup(context);
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // ⭐ Info icon
                                Container(
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.blue,
                                      width: 1.4,
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "i",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 6),

                                // ⭐ PERFECTLY CENTER ALIGNED TEXT
                                Baseline(
                                  baseline: 14,
                                  baselineType: TextBaseline.alphabetic,
                                  child: const Text(
                                    "Know More",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // ⭐ Receivable
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Receivable",
                        style: AppTextTheme.bold.copyWith(
                          fontSize: 16,
                          color: ColorConstant.blackColor,
                        ),
                      ),
                      Text(
                        "₹${receivable.toStringAsFixed(1)}",
                        style: AppTextTheme.bold.copyWith(
                          fontSize: 17,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  // ⭐ Animated Popup (fade + scale)
  void showCommissionPopup(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(0.4),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation1, animation2) => const SizedBox(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedValue = Curves.easeOutBack.transform(animation.value);

        return Transform.scale(
          scale: curvedValue,
          child: Opacity(
            opacity: animation.value,
            child: Center(
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                elevation: 12,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Commission Structure",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 18),

                      _popupLine("0 - 1500", "10%"),
                      const SizedBox(height: 8),
                      _popupLine("1500 - 4000", "15%"),
                      const SizedBox(height: 8),
                      _popupLine("Above 4000", "20%"),

                      const SizedBox(height: 20),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: ColorConstant.primaryColor,
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "OK",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Popup line builder
  Widget _popupLine(String range, String percent) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(range, style: const TextStyle(fontSize: 16)),
        Text(percent, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ],
    );
  }

  // ⭐ UPDATED VALUE COLORS — DARKER
  Widget _row(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "$title :",
          style: AppTextTheme.medium.copyWith(
            fontSize: 16,
            color: ColorConstant.blackColor,
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: AppTextTheme.bold.copyWith(     // 🔥 Darker + bolder
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}