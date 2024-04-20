import 'package:flutter/cupertino.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/text_theme.dart';

class SelectServiceWidget extends StatelessWidget {
  const SelectServiceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Hair Cut",
            style: AppTextTheme.medium
                .copyWith(color: ColorConstant.blackColor, fontSize: 16),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(65),
              color: ColorConstant.lightRedColor,
            ),
            child: Row(

              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Remove",
                  style: AppTextTheme.regular
                      .copyWith(color: ColorConstant.redColor, fontSize: 13),
                ),
                const SizedBox(width: 2),
                const Icon(
                  CupertinoIcons.xmark,
                  size: 15,
                  color: ColorConstant.redColor,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
