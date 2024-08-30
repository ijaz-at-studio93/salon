import 'package:flutter/material.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/model/translation/translation_history_model.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../constant/assetsconstant.dart';
import '../../../project_specific/text_theme.dart';

class UnsettedHistoryWidget extends StatefulWidget {
  final TransactionData transactionData;
  const UnsettedHistoryWidget({super.key, required this.transactionData});

  @override
  State<UnsettedHistoryWidget> createState() => _UnsettedHistoryWidgetState();
}

class _UnsettedHistoryWidgetState extends State<UnsettedHistoryWidget> {
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
                  AssetsConstant.unsetted,
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
                  widget.transactionData.user?.name ?? "",
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
              "₹${widget.transactionData.orderAmount}",
              textScaler: const TextScaler.linear(0.85),
              style: AppTextTheme.bold
                  .copyWith(color: ColorConstant.blackColor, fontSize: 16),
            ),
            Text(
              timeago.format(
                DateTime.parse(widget.transactionData.createdAt ?? ""),
                locale: 'en',
              ),
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
