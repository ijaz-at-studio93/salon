import 'package:flutter/material.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/text_theme.dart';

class AddProductListTileWidget extends StatefulWidget {
  final  VoidCallback onTap;
  const AddProductListTileWidget({super.key, required this.onTap});

  @override
  State<AddProductListTileWidget> createState() =>
      _AddProductListTileWidgetState();
}

class _AddProductListTileWidgetState extends State<AddProductListTileWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        height: 38,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Underarm shaving",
              style: AppTextTheme.medium
                  .copyWith(color: ColorConstant.blackColor, fontSize: 16),
            ),
            /*--------------- Edit and Add ------------------*/
            /*Row(
              children: [
                Container(
                  height: 26,
                  width: 76,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: ColorConstant.primaryColor,
                  ),
                  child: Center(
                    child: Text(
                      "2 Added",
                      style: AppTextTheme.regular
                          .copyWith(fontSize: 14, color: ColorConstant.whiteColor),
                    ),
                  ),
                ),
                Container(
                  height: 26,
                  width: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    border: Border.all(
                    color: ColorConstant.primaryColor,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(AssetsConstant.editIcon,
                        height: 14,
                        width: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Edit",
                        style: AppTextTheme.regular
                            .copyWith(fontSize: 14, color: ColorConstant.primaryColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),*/
            Container(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, bottom: 4, top: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                border: Border.all(
                  color: ColorConstant.primaryColor,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.add,
                    color: ColorConstant.primaryColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Add Product",
                    style: AppTextTheme.regular
                        .copyWith(color: ColorConstant.primaryColor, fontSize: 14),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
