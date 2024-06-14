import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salon/constant/api_constant.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/model/service_model/category_list_model.dart';
import 'package:salon/project_specific/text_theme.dart';

class CategoryListTileWidget extends StatelessWidget {
  final CategoryDataList categoryDataList;
  final VoidCallback onPress;
  const CategoryListTileWidget(
      {super.key, required this.categoryDataList, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            width: 66,
            height: 66,
            fit: BoxFit.cover,
            imageUrl: categoryDataList.serviceableGender == "male"
                ? "${APIConstants.image}${categoryDataList.imageMale ?? ""}"
                : "${APIConstants.image}${categoryDataList.imageFemale ?? ""}",
            placeholder: (context, url) => const Image(
              image: AssetImage(AssetsConstant.placeHolder),
              width: 66,
              height: 66,
              fit: BoxFit.cover,
            ),
            errorWidget: (context, url, error) => const Image(
              image: AssetImage(AssetsConstant.placeHolder),
              width: 66,
              height: 66,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              categoryDataList.name ?? "",
              style: AppTextTheme.bold
                  .copyWith(fontSize: 14, color: ColorConstant.blackColor),
            ),
            Row(
              children: [
                Text(
                  "Gender : ",
                  style: AppTextTheme.bold
                      .copyWith(fontSize: 14, color: ColorConstant.blackColor),
                ),

                Text(
                  categoryDataList.serviceableGender ?? "",
                  style: AppTextTheme.medium
                      .copyWith(fontSize: 14, color: ColorConstant.blackColor),
                ),
              ],
            )
          ],
        ),

      ],
    );
  }
}
