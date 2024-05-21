import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/text_theme.dart';

import '../../../../constant/assetsconstant.dart';

class CategoryListTileWidget extends StatefulWidget {
  final String name;
  final String description;
  final String gender;
  final String image;
  const CategoryListTileWidget(
      {super.key,
      required this.name,
      required this.description,
      required this.gender,
      required this.image});

  @override
  State<CategoryListTileWidget> createState() => _CategoryListTileWidgetState();
}

class _CategoryListTileWidgetState extends State<CategoryListTileWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: Get.width * 0.6,
              child: Text(
                widget.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textScaler: const TextScaler.linear(0.85),
                style: AppTextTheme.bold
                    .copyWith(color: ColorConstant.blackColor, fontSize: 17),
              ),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Text(
                  "Service Gender : ",
                  textScaler: const TextScaler.linear(0.85),
                  style: AppTextTheme.bold
                      .copyWith(color: ColorConstant.blackColor, fontSize: 16),
                ),
                Text(
                  widget.gender,
                  textScaler: const TextScaler.linear(0.85),
                  style: AppTextTheme.medium
                      .copyWith(color: ColorConstant.grayColor, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 13),
            Dash(
              direction: Axis.horizontal,
              length: Get.width * 0.6,
              dashLength: 2,
              dashColor: ColorConstant.grayTextColor,
            ),
            const SizedBox(height: 13),
            SizedBox(
              width: Get.width * 0.5,
              child: ReadMoreText(
                widget.description,
                trimMode: TrimMode.Line,
                style: AppTextTheme.medium
                    .copyWith(color: ColorConstant.grayTextColor, fontSize: 14),
                trimLines: 2,
                colorClickableText: ColorConstant.primaryColor,
                trimCollapsedText: 'more',
                trimExpandedText: 'Show less',
                moreStyle: AppTextTheme.medium
                    .copyWith(fontSize: 15, color: ColorConstant.primaryColor),
              ),
            ),
          ],
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                width: 108,
                height: 123,
                fit: BoxFit.cover,
                imageUrl: widget.image,
                placeholder: (context, url) => const Image(
                  image: AssetImage(AssetsConstant.placeHolder),
                  width: 108,
                  height: 123,
                  fit: BoxFit.cover,
                ),
                errorWidget: (context, url, error) => const Image(
                  image: AssetImage(AssetsConstant.placeHolder),
                  width: 108,
                  height: 123,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
