import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/page/stylist_all_module/widget/service_count_filter_widget.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'widget/service_count_list_tile_widget.dart';
import 'widget/service_count_row_widget.dart';

class ServiceCountPage extends StatefulWidget {
  const ServiceCountPage({super.key});

  @override
  State<ServiceCountPage> createState() => _ServiceCountPageState();
}

class _ServiceCountPageState extends State<ServiceCountPage> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.whiteColor,
      appBar: const AppBarWidget(
        nameOfScreen: "Add Stylist",
        isBackIcon: true,
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ServiceCountRowWidget(
                    image: AssetsConstant.receiveDoneIcon,
                    title: "Service Done",
                    titleValue: "12",
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ServiceCountRowWidget(
                    image: AssetsConstant.topRatedDoneIcon,
                    title: "Top Rated ",
                    titleValue: "Hair Cut",
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Text(
              "Service List",
              style: AppTextTheme.medium
                  .copyWith(color: ColorConstant.blackColor, fontSize: 16),
            ),
          ),
          SizedBox(
            height: 50,
            width: Get.width,
            child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: (context, i) {
                  return ServiceCountFilterWidget(
                    onPress: () {
                      setState(() {
                        selectedIndex = i;
                      });
                    },
                    isSelected: selectedIndex == i,
                  );
                }),
          ),
          ListView.builder(
              itemCount: 5,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, i) {
                return const ServiceCountListTileWidget();
              })
        ],
      ),
    );
  }
}
