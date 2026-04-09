import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/text_theme.dart';

class ServiceOfferedListTileWidget extends StatelessWidget {
  final VoidCallback onPress;
  final String name;
  final String description;
  final String image;
  const ServiceOfferedListTileWidget(
      {super.key,
      required this.onPress,
      required this.name,
      required this.description,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: Get.width * 0.6,
                child: Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: AppTextTheme.bold
                      .copyWith(color: ColorConstant.blackColor, fontSize: 16),
                ),
              ),
              const SizedBox(height: 10),
              Dash(
                direction: Axis.horizontal,
                length: Get.width * 0.6,
                dashLength: 2,
                dashColor: const Color(0xffCFCFCF),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: Get.width * 0.6,
                child: ReadMoreText(
                  description,
                  trimMode: TrimMode.Line,
                  style: AppTextTheme.medium.copyWith(
                      height: 1.5,
                      color: ColorConstant.grayTextColor,
                      fontSize: 14),
                  trimLines: 2,
                  colorClickableText: ColorConstant.primaryColor,
                  trimCollapsedText: 'more',
                  trimExpandedText: 'Show less',
                  moreStyle: AppTextTheme.medium.copyWith(
                      fontSize: 15, color: ColorConstant.primaryColor),
                ),
              ),
            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              width: 108,
              height: 115,
              fit: BoxFit.cover,
              imageUrl: image,
              placeholder: (context, url) => const Image(
                image: AssetImage(AssetsConstant.placeHolder),
                width: 108,
                height: 115,
                fit: BoxFit.cover,
              ),
              errorWidget: (context, url, error) => const Image(
                image: AssetImage(AssetsConstant.placeHolder),
                width: 108,
                height: 115,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
