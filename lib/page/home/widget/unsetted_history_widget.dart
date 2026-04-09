import 'package:flutter/material.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/model/translation/translation_history_model.dart';
import 'package:salon/page/home/widget/transaction_details_page.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../constant/assetsconstant.dart';
import '../../../project_specific/text_theme.dart';

class UnsettedHistoryWidget extends StatefulWidget {
  final TransactionData transactionData;
  final bool showInternalIcon;

  const UnsettedHistoryWidget({
    super.key,
    required this.transactionData,
    this.showInternalIcon = true,
  });

  @override
  State<UnsettedHistoryWidget> createState() => _UnsettedHistoryWidgetState();
}

class _UnsettedHistoryWidgetState extends State<UnsettedHistoryWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // LEFT SECTION
        Row(
          children: [
            if (widget.showInternalIcon)
              Container(
                height: 54,
                width: 54,
                decoration: BoxDecoration(
                  color: ColorConstant.primaryColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Image.asset(
                    AssetsConstant.unsetted,
                    width: 24,
                    height: 24,
                  ),
                ),
              ),

            if (widget.showInternalIcon) const SizedBox(width: 10),

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
                  widget.transactionData.user?.name ?? "",
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

        // RIGHT SECTION (AMOUNT + TIME + VIEW BUTTON)
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "₹${widget.transactionData.items!.fold<double>(0.0,
                      (sum, item) => sum + (item.price ?? 0))}",
              textScaler: const TextScaler.linear(0.85),
              style: AppTextTheme.bold.copyWith(
                color: ColorConstant.blackColor,
                fontSize: 16,
              ),
            ),

            Text(
              timeago.format(
                DateTime.parse(widget.transactionData.createdAt ?? ""),
                locale: 'en',
              ),
              textScaler: const TextScaler.linear(0.85),
              style: AppTextTheme.medium.copyWith(
                color: ColorConstant.grayTextColor,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 4),

            // ⭐ SAME VIEW BUTTON STYLE AS BOOKING HISTORY + SETTLED
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TransactionDetailsPage(
                      data: widget.transactionData,
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