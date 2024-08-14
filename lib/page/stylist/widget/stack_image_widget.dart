import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/api_constant.dart';
import 'package:salon/constant/color_constant.dart';
import '../../../constant/assetsconstant.dart';

class StackImageWidget extends StatelessWidget {
  final VoidCallback onTapEdit;
  final VoidCallback video;
  final bool isVideo;
  final String image;
  const StackImageWidget(
      {super.key,
      required this.onTapEdit,
      required this.isVideo,
      required this.image,
      required this.video});

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
        Positioned(
            right: 0,
            top: -15,
            child: GestureDetector(
              onTap: onTapEdit,
              child: Container(
                height: 40,
                width: 40,
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: ColorConstant.whiteColor,
                  shape: BoxShape.circle,
                ),
                child: Container(
                  height: 20,
                  width: 20,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorConstant.editButtonColor,
                  ),
                  child: Center(
                    child: Image.asset(
                      AssetsConstant.editIcon,
                      height: 10,
                      width: 10,
                    ),
                  ),
                ),
              ),
            ))
      ],
    );
  }
}
