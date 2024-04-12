import 'package:flutter/material.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';

class DocumentSubmittedPage extends StatefulWidget {
  const DocumentSubmittedPage({super.key});

  @override
  State<DocumentSubmittedPage> createState() => _DocumentSubmittedPageState();
}

class _DocumentSubmittedPageState extends State<DocumentSubmittedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      appBar: const AppBarWidget(
        nameOfScreen: "Under Process",
        isBackIcon: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AssetsConstant.clockImage,
                  height: 150,
                  width: 150,
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 45),
                  child: Text(
                    "Verification is under Process . Your account will be activated withing 24 hrs.",
                    textScaler: const TextScaler.linear(0.85),
                    textAlign: TextAlign.center,
                    style: AppTextTheme.medium.copyWith(
                        color: ColorConstant.grayTextColor, fontSize: 19),
                  ),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AssetsConstant.callIcon,
                height: 24,
                width: 24,
                color: ColorConstant.primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                "Contact Us",
                style: AppTextTheme.medium
                    .copyWith(fontSize: 19, color: ColorConstant.primaryColor),
              )
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
