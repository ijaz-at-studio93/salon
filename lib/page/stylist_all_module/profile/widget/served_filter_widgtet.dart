import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/page/stylist_all_module/profile/widget/filter_widget.dart';
import 'package:salon/project_specific/button_widget.dart';
import 'package:salon/project_specific/text_theme.dart';

class ServedFilterWidget extends StatefulWidget {
  final VoidCallback callback;
  const ServedFilterWidget({super.key, required this.callback});

  @override
  State<ServedFilterWidget> createState() => _ServedFilterWidgetState();
}

class _ServedFilterWidgetState extends State<ServedFilterWidget> {
  int selectedIndex = 0;
  int selectedServiceIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.25,
      width: Get.width,
      decoration: const BoxDecoration(
        color: ColorConstant.whiteColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          topLeft: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 71,
            width: Get.width,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(
              color: ColorConstant.primaryColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16),
                topLeft: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      "Cancel",
                      textScaler: const TextScaler.linear(0.85),
                      style: AppTextTheme.bold.copyWith(
                          color: ColorConstant.whiteColor, fontSize: 19),
                    )),
                Text(
                  "Filter",
                  textScaler: const TextScaler.linear(0.85),
                  style: AppTextTheme.bold
                      .copyWith(color: ColorConstant.whiteColor, fontSize: 19),
                ),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      "",
                      textScaler: const TextScaler.linear(0.85),
                      style: AppTextTheme.bold.copyWith(
                          color: ColorConstant.whiteColor, fontSize: 19),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 50,
            child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                itemCount: data.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return FilterWidget(
                    title: data[index],
                    isSelected: selectedIndex == index,
                    onPress: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                  );
                }),
          ),
        /*  Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              "Service Done",
              style: AppTextTheme.medium
                  .copyWith(color: ColorConstant.blackColor, fontSize: 16),
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                itemCount: serviceDone.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return FilterWidget(
                    title: serviceDone[index],
                    isSelected: selectedServiceIndex == index,
                    onPress: () {
                      setState(() {
                        selectedServiceIndex = index;
                      });
                    },
                  );
                }),
          ),
          const SizedBox(height: 16),*/
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ButtonWidget(
                buttonTitleText: "Apply",
                onPress: () {
                  Get.back(result: selectedIndex);
                  widget.callback();
                }),
          )
        ],
      ),
    );
  }

  /*---------- Filter Data List ----------*/
  List data = ["All", "Weekly", "Monthly", "Yearly"];

  List serviceDone = [
    "Both",
    "Home",
    "Saloon",
  ];
}
