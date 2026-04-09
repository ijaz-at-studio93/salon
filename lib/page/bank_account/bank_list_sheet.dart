import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/api_constant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/page/bank_account/bank_list_widget.dart';
import 'package:salon/project_specific/progressbar_view.dart';
import 'package:salon/project_specific/text_theme.dart';

import '../../constant/variable_constant.dart';

class BankListSheet extends StatefulWidget {
  final VoidCallback callback;
  const BankListSheet({super.key, required this.callback});

  @override
  State<BankListSheet> createState() => _BankListSheetState();
}

class _BankListSheetState extends State<BankListSheet> {
  final _homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

      bankName = "";
      bankImage = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.6,
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
                const SizedBox(),
                Text(
                  "Bank List",
                  textScaler: const TextScaler.linear(0.85),
                  style: AppTextTheme.bold
                      .copyWith(color: ColorConstant.whiteColor, fontSize: 19),
                ),
                const SizedBox(),
              ],
            ),
          ),
          const SizedBox(height: 15),
          // Expanded(
          //   child: Obx(
          //     () => _homeController.showProgress
          //         ? const ProgressBarView()
          //         : ListView.builder(
          //             shrinkWrap: true,
          //             itemCount: _homeController.bankModelList.length,
          //             itemBuilder: (context, index) {
          //               return BankListWidget(
          //                 onTap: () {
          //                   bankName =
          //                       _homeController.bankModelList[index].name ?? "";
          //                   bankImage = _homeController
          //                           .bankModelList[index].bankIconImage ??
          //                       "";
          //                   widget.callback.call();
          //                   Get.back();
          //                 },
          //                 title:
          //                     _homeController.bankModelList[index].name ?? "",
          //                 image:
          //                     "${APIConstants.image}${_homeController.bankModelList[index].bankIconImage ?? ""}",
          //               );
          //             }),
          //   ),
          // ),
        ],
      ),
    );
  }
}
