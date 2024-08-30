import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/text_theme.dart';

class BankListWidget extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback onTap;
  const BankListWidget(
      {super.key,
      required this.title,
      required this.image,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: AppTextTheme.medium
            .copyWith(color: ColorConstant.blackColor, fontSize: 13),
      ),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: CachedNetworkImage(
          height: 30,
          width: 30,
          fit: BoxFit.cover,
          imageUrl: image,
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
    );
  }
}
