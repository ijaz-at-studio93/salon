import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/text_theme.dart';

import '../../constant/assetsconstant.dart';

class BankDetailsPageListTileWidget extends StatelessWidget {
  final String bankName;
  final String accountType;
  final String accountNumber;
  final String ifscCode;
  final String branchName;
  final String accountHolderName;
  final String bankIconImage;
  final VoidCallback onTapDelete;

  const BankDetailsPageListTileWidget(
      {super.key,
      required this.bankName,
      required this.accountType,
      required this.accountNumber,
      required this.ifscCode,
      required this.branchName,
      required this.accountHolderName,
      required this.bankIconImage,
      required this.onTapDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: ColorConstant.dividerColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
                onPressed: onTapDelete,
                icon: const Icon(
                  Icons.delete,
                  color: ColorConstant.redColor,
                )),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Bank Name :",
                textScaler: const TextScaler.linear(0.85),
                style: AppTextTheme.bold
                    .copyWith(fontSize: 16, color: ColorConstant.blackColor),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: Get.width*0.5,
                    child: Text(
                      bankName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextTheme.medium.copyWith(
                          fontSize: 13, color: ColorConstant.blackColor),
                    ),
                  ),
                  const SizedBox(width: 5),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      height: 30,
                      width: 30,
                      fit: BoxFit.cover,
                      imageUrl: bankIconImage,
                      placeholder: (context, url) => const Image(
                        image: AssetImage(AssetsConstant.placeHolder),
                        height: 30,
                        width: 30,
                        fit: BoxFit.cover,
                      ),
                      errorWidget: (context, url, error) => const Image(
                        image: AssetImage(AssetsConstant.placeHolder),
                        height: 30,
                        width: 30,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          _myRowWidget(title: "Branch Name : ", name: branchName),
          const SizedBox(height: 10),
          _myRowWidget(title: "Account Number : ", name: accountNumber),
          const SizedBox(height: 10),
          _myRowWidget(title: "Ifsc Code : ", name: ifscCode),
          const SizedBox(height: 10),
          _myRowWidget(title: "Account Type : ", name: accountType),
          const SizedBox(height: 10),
          _myRowWidget(title: "AccountHolder Name : ", name: accountHolderName),
        ],
      ),
    );
  }

  /*--------------  My  Row  Widget -----------------*/
  _myRowWidget({required String title, required String name}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          textScaler: const TextScaler.linear(0.85),
          style: AppTextTheme.bold
              .copyWith(fontSize: 16, color: ColorConstant.blackColor),
        ),
        Text(
          name,
          style: AppTextTheme.medium
              .copyWith(fontSize: 14, color: ColorConstant.blackColor),
        ),
      ],
    );
  }
}
