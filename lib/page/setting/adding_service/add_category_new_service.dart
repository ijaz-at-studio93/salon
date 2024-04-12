import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/page/setting/adding_service/widget/add_category_list_tile_widget.dart';
import 'package:salon/project_specific/text_theme.dart';

import '../../../constant/assetsconstant.dart';

class AddCategoryNewService extends StatefulWidget {
  const AddCategoryNewService({super.key});

  @override
  State<AddCategoryNewService> createState() => _AddCategoryNewServiceState();
}

class _AddCategoryNewServiceState extends State<AddCategoryNewService> {
  final _serviceTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.5,
      width: Get.width,
      decoration: const BoxDecoration(
        color: ColorConstant.whiteColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          topLeft: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
                      style: AppTextTheme.regular.copyWith(
                          color: ColorConstant.whiteColor, fontSize: 19),
                    )),
                Text(
                  "Add Category",
                  textScaler: const TextScaler.linear(0.85),
                  style: AppTextTheme.bold
                      .copyWith(color: ColorConstant.whiteColor, fontSize: 19),
                ),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.add,
                      color: ColorConstant.whiteColor,
                    ))
              ],
            ),
          ),
          const SizedBox(height: 10),
          _searchAndService(),
          const SizedBox(height: 10),
          Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            color: ColorConstant.lightColor,
            child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Suggested Category:",style: AppTextTheme.regular.copyWith(
                  color: ColorConstant.primaryColor,
                  fontSize: 13
                ),),
                Text("1 Selected",style: AppTextTheme.bold.copyWith(
                  fontSize: 13,
                  color: ColorConstant.primaryColor
                ),),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.separated(
                      separatorBuilder: (context, index) {
                        return const Divider(
                          endIndent: 20,
                          indent: 20,
                          color: ColorConstant.dividerColor,
                        );
                      },
                      itemCount: 15,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: AddCategoryListTileWidget(),
                        );
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /*------------------ Search and Service ---------------*/
  _searchAndService() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: ShapeDecoration(
        color: ColorConstant.whiteColor,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFE1E1E1)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Image.asset(
            AssetsConstant.search,
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 5),
          SizedBox(
            width: Get.width * 0.8,
            child: TextField(
              controller: _serviceTextEditingController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search and add service",
                  hintStyle: AppTextTheme.regular.copyWith(
                      fontSize: 16, color: ColorConstant.grayTextColor)),
            ),
          ),
        ],
      ),
    );
  }
}
