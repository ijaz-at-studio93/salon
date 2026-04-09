import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/page/stylist/availiblity_stylist_page.dart';
import 'package:salon/page/stylist/widget/stylist_edit_bottom_sheet.dart';
import 'package:salon/project_specific/text_theme.dart';

class StylistListTileWidget extends StatelessWidget {
  final VoidCallback onPress;
  final String image;
  final String name;
  final String id;
  final VoidCallback callback;

  const StylistListTileWidget(
      {super.key,
      required this.onPress,
      required this.image,
      required this.name,
      required this.id, required this.callback});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CachedNetworkImage(
                  height: 58,
                  width: 58,
                  fit: BoxFit.cover,
                  imageUrl: image,
                  placeholder: (context, url) => const Image(
                    image: AssetImage(AssetsConstant.placeHolder),
                    height: 58,
                    width: 58,
                    fit: BoxFit.cover,
                  ),
                  errorWidget: (context, url, error) => const Image(
                    image: AssetImage(AssetsConstant.placeHolder),
                    height: 58,
                    width: 58,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTextTheme.medium.copyWith(
                        color: ColorConstant.blackColor, fontSize: 16),
                  ),
                /*  Row(
                    children: [
                      Text(
                        "Expert in",
                        style: AppTextTheme.medium.copyWith(
                            color: ColorConstant.grayTextColor, fontSize: 13),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "5 Services",
                        style: AppTextTheme.medium.copyWith(
                            color: ColorConstant.primaryColor, fontSize: 13),
                      )
                    ],
                  )*/
                ],
              )
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(() => AvailabilitySheetPage(
                        artiestId: id,
                      ));
                },
                child: Container(
                  padding: const EdgeInsets.only(
                      top: 8, right: 11, bottom: 8, left: 11),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(45),
                    border: Border.all(
                      color: ColorConstant.grayTextColor,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Set Availiblity",
                      style: AppTextTheme.regular.copyWith(
                          fontSize: 14, color: ColorConstant.grayTextColor),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              PopupMenuButton<String>(
                onSelected: (val) {
                  if (val == "Edit") {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        enableDrag: false,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        )),
                        context: context,
                        builder: (context) {
                          return StylistEditBottomSheet(
                            artistId: id,
                          );
                        });
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            "Delete",
                            style: AppTextTheme.medium
                                .copyWith(color: ColorConstant.blackColor),
                          ),
                          content: Text(
                            "Are you sure you want to delete stylist",
                            style: AppTextTheme.medium.copyWith(
                                color: ColorConstant.blueGrayColor,
                                fontSize: 14),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text(
                                  "Cancel",
                                  style: AppTextTheme.medium.copyWith(
                                      color: ColorConstant.redColor,
                                      fontSize: 14),
                                )),
                            TextButton(
                                onPressed: () {
                                  Get.back();
                                  callback.call();
                                },
                                child: Text(
                                  "Yes",
                                  style: AppTextTheme.medium.copyWith(
                                      color: ColorConstant.primaryColor,
                                      fontSize: 14),
                                )),
                          ],
                        );
                      },
                    );
                  }
                },
                itemBuilder: (BuildContext context) {
                  return {'Edit', 'Delete'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ), /* Image.asset(
                AssetsConstant.dotVertical,
                width: 5,
                height: 19,
              ),*/
            ],
          )
        ],
      ),
    );
  }
}
