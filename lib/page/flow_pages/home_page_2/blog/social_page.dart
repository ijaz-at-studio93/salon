import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/project_appbar.dart';

import '../../../../project_specific/text_theme.dart';
import 'Insights_card_widget.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({super.key});

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.whiteColor,
      appBar: const AppBarWidget(
        nameOfScreen: "Post Blog",
        isBackIcon: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          SizedBox(
            height: 50,
            width: Get.width,
            child: ListView.builder(
                padding: const EdgeInsets.only(left: 20),
                itemCount: 10,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, i) {
                  return Container(
                    padding: const EdgeInsets.only(right: 25,left: 25),
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                          color: ColorConstant.grayTextColor, width: 1),
                    ),
                    child: Center(
                      child: Text(
                        "New",
                        style: AppTextTheme.medium.copyWith(
                            color: ColorConstant.blackColor, fontSize: 13),
                      ),
                    ),
                  );
                }),
          ),
          Expanded(
            child: ListView.separated(
                separatorBuilder: (context, i) {
                  return const Divider(
                    thickness: 2,
                    color: ColorConstant.dividerColor,
                    indent: 20,
                    endIndent: 20,
                  );
                },
                shrinkWrap: true,
                itemCount: 5,
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                itemBuilder: (context, i) {
                  return InsightsCardWidget(
                    onPress: () {},
                  );
                }),
          ),
        ],
      ),
    );
  }
}
