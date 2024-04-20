import 'package:flutter/cupertino.dart';

import 'package:salon/project_specific/text_theme.dart';

import '../../../../constant/color_constant.dart';

class AddCategoryListTileWidget extends StatefulWidget {
  const AddCategoryListTileWidget({super.key});

  @override
  State<AddCategoryListTileWidget> createState() =>
      _AddCategoryListTileWidgetState();
}

class _AddCategoryListTileWidgetState extends State<AddCategoryListTileWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Underarm shaving",
            style: AppTextTheme.medium
                .copyWith(color: ColorConstant.blackColor, fontSize: 16),
          ),

          /* Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ColorConstant.lightColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Icon(
                  Icons.add,
                  color: ColorConstant.primaryColor,
                   size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  "Add Category",
                  style: AppTextTheme.regular.copyWith(
                      color: ColorConstant.primaryColor, fontSize: 14),
                )
              ],
            ),
          ),*/
          const Icon(
            CupertinoIcons.check_mark,
            color: ColorConstant.primaryColor,
            size: 18,
          ),
        ],
      ),
    );
  }
}
