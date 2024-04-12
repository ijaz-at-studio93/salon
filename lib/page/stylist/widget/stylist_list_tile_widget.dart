import 'package:flutter/material.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/page/stylist/availiblity_sheet_page.dart';
import 'package:salon/project_specific/text_theme.dart';

class StylistListTileWidget extends StatelessWidget {
  final VoidCallback onPress;
  const StylistListTileWidget({super.key, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  "https://images.unsplash.com/photo-1548454782-15b189d129ab?q=80&w=1976&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                  height: 58,
                  width: 58,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Michael Johnson ",
                    style: AppTextTheme.medium
                        .copyWith(color: ColorConstant.blackColor, fontSize: 16),
                  ),
                  Row(
                    children: [
                      Text(
                        "Expert in",
                        style: AppTextTheme.medium.copyWith(
                            color: ColorConstant.grayTextColor, fontSize: 13),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "5 Services",
                        style: AppTextTheme.medium.copyWith(
                            color: ColorConstant.primaryColor, fontSize: 13),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: (){
                  showModalBottomSheet(
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32),
                            topRight: Radius.circular(32),
                          )),
                      context: context,
                      builder: (context) {
                        return const AvailiblitySheetPage();
                      });
                },
                child: Container(
                  padding:
                      const EdgeInsets.only(top: 8, right: 11, bottom: 8, left: 11),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(45),
                    border: Border.all(
                      color: ColorConstant.grayTextColor,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Set Availiblity",
                      style: AppTextTheme.regular.copyWith(
                          fontSize: 14, color: ColorConstant.grayTextColor),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Image.asset(AssetsConstant.dotVertical,
              width: 5,
                height: 19,
              ),
            ],
          )
        ],
      ),
    );
  }
}
