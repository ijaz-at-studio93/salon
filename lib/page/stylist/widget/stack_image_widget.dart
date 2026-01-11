import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/api_constant.dart';
import 'package:salon/constant/color_constant.dart';
import '../../../constant/assetsconstant.dart';

class StackImageWidget extends StatelessWidget {
  final VoidCallback video;
  final bool isVideo;
  final String image;

  // Removed onTapEdit since edit is no longer used
  const StackImageWidget({
    super.key,
    required this.isVideo,
    required this.image,
    required this.video,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: isVideo
              ? GestureDetector(
            onTap: video,
            child: Container(
              height: Get.height * 0.2,
              decoration: const BoxDecoration(
                  color: ColorConstant.editButtonColor),
              child: Center(
                child: Image.asset(
                  AssetsConstant.playIcon,
                  height: 30,
                  width: 30,
                ),
              ),
            ),
          )
              : CachedNetworkImage(
            height: Get.height * 0.2,
            fit: BoxFit.cover,
            imageUrl: "${APIConstants.image}$image",
            placeholder: (context, url) => Image(
              image: const AssetImage(AssetsConstant.placeHolder),
              height: Get.height * 0.2,
              fit: BoxFit.cover,
            ),
            errorWidget: (context, url, error) => Image(
              image: const AssetImage(AssetsConstant.placeHolder),
              height: Get.height * 0.2,
              fit: BoxFit.cover,
            ),
          ),
        ),
        // 🧹 Removed the Positioned edit icon completely
      ],
    );
  }
}