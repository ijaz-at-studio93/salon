import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/text_theme.dart';

class ServiceListTileWidget extends StatefulWidget {
  final String image;
  final String name;
  final String gender;
  final String time;
  final bool isHomeService;
  const ServiceListTileWidget(
      {super.key,
      required this.image,
      required this.name,
      required this.gender,
      required this.time,
      required this.isHomeService});

  @override
  State<ServiceListTileWidget> createState() => _ServiceListTileWidgetState();
}

class _ServiceListTileWidgetState extends State<ServiceListTileWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
          color: ColorConstant.review.withOpacity(0.8),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CachedNetworkImage(
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  imageUrl: widget.image,
                  placeholder: (context, url) => const Image(
                    image: AssetImage(AssetsConstant.placeHolder),
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                  errorWidget: (context, url, error) => const Image(
                    image: AssetImage(AssetsConstant.placeHolder),
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Service Name : ",
                        style: AppTextTheme.medium.copyWith(
                            color: ColorConstant.grayTextColor, fontSize: 13),
                      ),
                      Text(
                        widget.name,
                        style: AppTextTheme.bold.copyWith(
                            color: ColorConstant.blackColor, fontSize: 13),
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        "price : ",
                        style: AppTextTheme.medium.copyWith(
                            color: ColorConstant.grayTextColor, fontSize: 13),
                      ),
                      Text(
                        widget.name,
                        style: AppTextTheme.bold.copyWith(
                            color: ColorConstant.blackColor, fontSize: 13),
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        "Gender : ",
                        style: AppTextTheme.medium.copyWith(
                            color: ColorConstant.grayTextColor, fontSize: 13),
                      ),
                      Text(
                        widget.gender,
                        style: AppTextTheme.bold.copyWith(
                            color: ColorConstant.blackColor, fontSize: 13),
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        "Duration : ",
                        style: AppTextTheme.medium.copyWith(
                            color: ColorConstant.grayTextColor, fontSize: 13),
                      ),
                      Text(
                        widget.time,
                        style: AppTextTheme.bold.copyWith(
                            color: ColorConstant.blackColor, fontSize: 13),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: [
              const Icon(Icons.home),
              const SizedBox(height: 5),
              Text(
                "${widget.isHomeService}",
                style: AppTextTheme.bold
                    .copyWith(color: ColorConstant.blackColor, fontSize: 13),
              )
            ],
          )
        ],
      ),
    );
  }
}
