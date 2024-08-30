import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salon/constant/api_constant.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/model/service_model/category_list_model.dart';
import 'package:salon/project_specific/text_theme.dart';

class CategoryListTileWidget extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final String name;
  final String description;
  final String serviceableGender;
  final String imageFemale;
  final String imageMale;
  const CategoryListTileWidget(
      {super.key,
      required this.onEdit,
      required this.name,
      required this.description,
      required this.serviceableGender,
      required this.imageFemale,
      required this.imageMale,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: ColorConstant.divider2Color.withOpacity(0.2)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: onEdit,
                child: Container(
                  color: Colors.transparent,
                  width: 30,
                  height: 30,
                  child: const Center(
                    child: Icon(
                      Icons.edit,
                      color: ColorConstant.primaryColor,
                      size: 25,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: onDelete,
                child: Container(
                  color: Colors.transparent,
                  width: 30,
                  height: 30,
                  child: const Center(
                    child: Icon(
                      Icons.delete,
                      color: ColorConstant.redColor,
                      size: 25,
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 5),
          serviceableGender == "unisex"
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        width: 66,
                        height: 66,
                        fit: BoxFit.cover,
                        imageUrl: "${APIConstants.image}$imageMale",
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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        width: 66,
                        height: 66,
                        fit: BoxFit.cover,
                        imageUrl: "${APIConstants.image}$imageFemale",
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
                  ],
                )
              : serviceableGender == "male"
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        width: 66,
                        height: 66,
                        fit: BoxFit.cover,
                        imageUrl: "${APIConstants.image}$imageMale",
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
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        width: 66,
                        height: 66,
                        fit: BoxFit.cover,
                        imageUrl: "${APIConstants.image}$imageFemale",
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
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Text(
                    "Category Name : ",
                    style: AppTextTheme.bold.copyWith(
                        fontSize: 14, color: ColorConstant.blackColor),
                  ),
                  Text(
                    name,
                    style: AppTextTheme.medium.copyWith(
                        fontSize: 14, color: ColorConstant.blackColor),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Gender : ",
                    style: AppTextTheme.bold.copyWith(
                        fontSize: 14, color: ColorConstant.blackColor),
                  ),
                  Text(
                    serviceableGender,
                    style: AppTextTheme.medium.copyWith(
                        fontSize: 14, color: ColorConstant.blackColor),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            description,
            style: AppTextTheme.medium
                .copyWith(fontSize: 14, color: ColorConstant.blackColor),
          ),
        ],
      ),
    );
  }
}
