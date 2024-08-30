import 'package:flutter/material.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../model/translation/translation_history_model.dart';

class TransactionHistoryWidget extends StatelessWidget {
  final TransactionData transactionData;
  const TransactionHistoryWidget({super.key, required this.transactionData});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
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
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Received From",
                  style: AppTextTheme.medium
                      .copyWith(color: ColorConstant.blackColor, fontSize: 13),
                ),
                Text(
                  transactionData.user?.name ?? "",
                  textScaler: const TextScaler.linear(0.85),
                  style: AppTextTheme.medium.copyWith(
                      fontSize: 16, color: ColorConstant.grayTextColor),
                ),
              ],
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "₹${transactionData.orderAmount}",
              textScaler: const TextScaler.linear(0.85),
              style: AppTextTheme.bold
                  .copyWith(color: ColorConstant.blackColor, fontSize: 16),
            ),
            Text(
              timeago.format(DateTime.parse(transactionData.createdAt ?? ""), locale: 'en'),
              textScaler: const TextScaler.linear(0.85),
              style: AppTextTheme.medium
                  .copyWith(color: ColorConstant.grayTextColor, fontSize: 16),
            ),
          ],
        )
      ],
    );
  }
}
