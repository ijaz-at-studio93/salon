// import 'package:flutter/material.dart';
// import 'package:salon/model/translation/salon_transaction_history_model.dart';
// import 'package:salon/constant/color_constant.dart';
// import 'package:salon/project_specific/text_theme.dart';
// import 'package:intl/intl.dart';
//
// class WalletTransactionDetailsPage extends StatelessWidget {
//   final SalonTransactionData data;
//
//   const WalletTransactionDetailsPage({
//     super.key,
//     required this.data,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final date = _formatDate(data.createdAt ?? '');
//     final time = _formatTime(data.createdAt ?? '');
//     double totalAmount = data.items?.fold<double>(
//       0.0,
//           (sum, item) => sum + (item.price ?? 0),
//     ) ??
//         (data.amount ?? 0);
//
//     return Scaffold(
//       backgroundColor: ColorConstant.bgColor,
//       appBar: AppBar(
//         backgroundColor: ColorConstant.primaryColor,
//         title: const Text("Transaction Details"),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//
//             /// 🔥 BLOCK 1 — BASIC DETAILS
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(16),
//               decoration: _cardDecoration(),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _row("Transaction ID", data.idx ?? "-"),
//                   const SizedBox(height: 10),
//                   _row("User", data.user?.name ?? "-"),
//                   const SizedBox(height: 10),
//                   _row("Type", data.isCredit ? "Credit" : "Debit"),
//                   const SizedBox(height: 10),
//                   _row("Date", date),
//                   const SizedBox(height: 6),
//                   _row("Time", time),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 16),
//
//             /// 🔥 BLOCK 2 — SERVICE BREAKDOWN (if exists)
//             if (data.items != null && data.items!.isNotEmpty)
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(16),
//                 decoration: _cardDecoration(),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Service Breakdown",
//                       style: AppTextTheme.bold.copyWith(
//                         fontSize: 18,
//                         color: ColorConstant.blackColor,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//
//                     ...data.items!.map((item) {
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 4),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Expanded(
//                               child: Text(
//                                 item.service?.name ?? "-",
//                                 style: AppTextTheme.medium.copyWith(
//                                   fontSize: 15,
//                                   color: ColorConstant.blackColor,
//                                 ),
//                               ),
//                             ),
//                             Text(
//                               "₹${(item.price ?? 0).toStringAsFixed(0)}",
//                               style: AppTextTheme.medium.copyWith(
//                                 fontSize: 15,
//                                 color: ColorConstant.blackColor,
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }).toList(),
//
//                     const SizedBox(height: 10),
//                     const Divider(),
//                     const SizedBox(height: 10),
//
//                     /// TOTAL
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "Total",
//                           style: AppTextTheme.bold.copyWith(fontSize: 16,color: ColorConstant.blackColor,),
//                         ),
//                         Text(
//                           "₹${totalAmount.toStringAsFixed(0)}",
//                           style: AppTextTheme.bold.copyWith(fontSize: 16,color: ColorConstant.blackColor,),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//
//             const SizedBox(height: 16),
//
//             // /// 🔥 BLOCK 3 — FINAL AMOUNT
//             // Container(
//             //   width: double.infinity,
//             //   padding: const EdgeInsets.all(16),
//             //   decoration: _cardDecoration(),
//             //   child: Row(
//             //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //     children: [
//             //       Text(
//             //         "Final Amount",
//             //         style: AppTextTheme.bold.copyWith(fontSize: 16),
//             //       ),
//             //       Text(
//             //         "${data.isCredit ? '+' : '-'}₹${(data.amount ?? 0).toStringAsFixed(0)}",
//             //         style: AppTextTheme.bold.copyWith(
//             //           fontSize: 18,
//             //           color: data.isCredit
//             //               ? const Color(0xFF8454E5)
//             //               : Colors.red,
//             //         ),
//             //       ),
//             //     ],
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   String _formatDate(String date) {
//     if (date.isEmpty) return '-';
//     try {
//       final dt = DateTime.parse(date);
//       return DateFormat('MM/dd/yyyy').format(dt);
//     } catch (_) {
//       return '-';
//     }
//   }
//
//   String _formatTime(String date) {
//     if (date.isEmpty) return '-';
//     try {
//       final dt = DateTime.parse(date).toLocal(); // 👈 IMPORTANT
//       return DateFormat('HH:mm').format(dt); // 👈 hours + minutes only (24hr)
//     } catch (_) {
//       return '-';
//     }
//   }
//
//   /// 🔥 Reusable Card Decoration
//   BoxDecoration _cardDecoration() {
//     return BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(14),
//       border: Border.all(color: Colors.grey.shade300),
//     );
//   }
//
//   /// 🔥 Row UI
//   Widget _row(String title, String value) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           "$title :",
//           style: AppTextTheme.medium.copyWith(
//             fontSize: 14,
//             color: ColorConstant.blackColor,
//           ),
//         ),
//         Flexible(
//           child: Text(
//             value,
//             textAlign: TextAlign.right,
//             style: AppTextTheme.bold.copyWith(
//               fontSize: 14,
//               color: Colors.black87,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:salon/model/translation/salon_transaction_history_model.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:intl/intl.dart';

class WalletTransactionDetailsPage extends StatelessWidget {
  final SalonTransactionData data;

  const WalletTransactionDetailsPage({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final date = _formatDate(data.createdAt ?? '');
    final time = _formatTime(data.createdAt ?? '');

    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      appBar: AppBar(
        backgroundColor: ColorConstant.primaryColor,
        title: const Text("Transaction Details"),
      ),

      /// 🔥 BODY FIXED STRUCTURE
      body: Column(
        children: [

          /// 🔥 SCROLLABLE CONTENT
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  /// 🔥 BLOCK 1 — BASIC DETAILS
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: _cardDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // _row("Transaction ID", data.idx ?? "-"),
                        // const SizedBox(height: 10),
                        _row("User", data.userName ?? "-"),
                        const SizedBox(height: 10),
                        _row("Type", data.isCredit ? "Credit" : "Debit"),
                        const SizedBox(height: 10),
                        _row("Date", date),
                        const SizedBox(height: 6),
                        _row("Time", time),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// 🔥 BLOCK 2 — SERVICE BREAKDOWN (if exists)
                  if (data.items != null && data.items!.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: _cardDecoration(),
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

                          ...data.items!.map((item) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.service?.name ?? "-",
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
                        ],
                      ),
                    ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          /// 🔥 FINAL AMOUNT (FIXED BOTTOM)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Paid Amount = ",
                  style: AppTextTheme.bold.copyWith(
                    fontSize: 16,
                    color: ColorConstant.blackColor,
                  ),
                ),
                //const SizedBox(width: 20),
                Text(
                  "₹${(data.amount ?? 0).abs().toStringAsFixed(0)}",
                  style: AppTextTheme.bold.copyWith(
                    fontSize: 18,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
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

  String _formatTime(String date) {
    if (date.isEmpty) return '-';
    try {
      final dt = DateTime.parse(date).toLocal();
      return DateFormat('HH:mm').format(dt);
    } catch (_) {
      return '-';
    }
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Colors.grey.shade300),
    );
  }

  Widget _row(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "$title :",
          style: AppTextTheme.medium.copyWith(
            fontSize: 14,
            color: ColorConstant.blackColor,
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: AppTextTheme.bold.copyWith(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}