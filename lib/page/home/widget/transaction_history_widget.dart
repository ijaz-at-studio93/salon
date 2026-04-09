import 'package:flutter/material.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/page/home/widget/transaction_details_page.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../model/translation/translation_history_model.dart';

class TransactionHistoryWidget extends StatelessWidget {
  final TransactionData transactionData;
  final bool showInternalIcon; // show purple icon or not

  const TransactionHistoryWidget({
    super.key,
    required this.transactionData,
    this.showInternalIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // LEFT SIDE
        Row(
          children: [
            if (showInternalIcon)
              Container(
                height: 54,
                width: 54,
                decoration: BoxDecoration(
                  color: ColorConstant.primaryColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Image.asset(
                    AssetsConstant.receivedIcon,
                    width: 24,
                    height: 24,
                  ),
                ),
              ),

            if (showInternalIcon) const SizedBox(width: 10),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Received From",
                  style: AppTextTheme.medium.copyWith(
                    color: ColorConstant.blackColor,
                    fontSize: 13,
                  ),
                ),
                Text(
                  transactionData.user?.name ?? "",
                  textScaler: const TextScaler.linear(0.85),
                  style: AppTextTheme.medium.copyWith(
                    fontSize: 16,
                    color: ColorConstant.grayTextColor,
                  ),
                ),
              ],
            ),
          ],
        ),

        // RIGHT SIDE COLUMN (AMOUNT + TIME + VIEW)
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Amount
            Text(
              "₹${transactionData.items!.fold<double>(0.0,
                      (sum, item) => sum + (item.price ?? 0))}",
              textScaler: const TextScaler.linear(0.85),
              style: AppTextTheme.bold.copyWith(
                color: ColorConstant.blackColor,
                fontSize: 16,
              ),
            ),

            // Time
            Text(
              timeago.format(
                DateTime.parse(transactionData.createdAt ?? ""),
                locale: 'en',
              ),
              textScaler: const TextScaler.linear(0.85),
              style: AppTextTheme.medium.copyWith(
                color: ColorConstant.grayTextColor,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 4),

            // ⭐ VIEW BUTTON (Same style as your Booking History)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TransactionDetailsPage(
                      data: transactionData,
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.red,
                    width: 1,
                  ),
                ),
                child: Text(
                  "View",
                  style: AppTextTheme.medium.copyWith(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}