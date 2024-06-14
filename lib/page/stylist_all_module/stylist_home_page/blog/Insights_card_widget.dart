import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/api_constant.dart';
import 'package:salon/model/artist_model/blog_data_get_model.dart';
import '../../../../constant/assetsconstant.dart';
import '../../../../constant/color_constant.dart';
import '../../../../project_specific/text_theme.dart';

class InsightsCardWidget extends StatefulWidget {
  final VoidCallback onPress;
  final BlogData blogData;
  const InsightsCardWidget(
      {super.key, required this.onPress, required this.blogData});

  @override
  State<InsightsCardWidget> createState() => _InsightsCardWidgetState();
}

class _InsightsCardWidgetState extends State<InsightsCardWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CachedNetworkImage(
                  width: Get.width,
                  height: Get.height * 0.25,
                  fit: BoxFit.fitWidth,
                  imageUrl: "${APIConstants.image}${widget.blogData.image}",
                  placeholder: (context, url) => Image(
                    image: const AssetImage(AssetsConstant.placeHolder),
                    width: Get.width,
                    height: Get.height * 0.25,
                    fit: BoxFit.fitWidth,
                  ),
                  errorWidget: (context, url, error) => Image(
                    image: const AssetImage(AssetsConstant.placeHolder),
                    width: Get.width,
                    height: Get.height * 0.25,
                    fit: BoxFit.fitWidth,
                  ),
                ),

              ],
            ),
            const SizedBox(height: 20),
            Text(
              widget.blogData.title ?? "",
              style: AppTextTheme.medium
                  .copyWith(color: ColorConstant.blackColor, fontSize: 16),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                /*  Row(
                  children: [
                    const Icon(
                      Icons.remove_red_eye,
                      color: ColorConstant.grayTextColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "708 Views",
                      style: AppTextTheme.medium.copyWith(
                          color: ColorConstant.grayTextColor, fontSize: 13),
                    ),
                  ],
                ),*/
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        "${APIConstants.image}${widget.blogData.artist?.profileImage ?? ""}",
                        height: 17,
                        width: 17,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.blogData.artist?.name ?? "",
                      style: AppTextTheme.bold.copyWith(
                          color: ColorConstant.blackColor, fontSize: 12),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
