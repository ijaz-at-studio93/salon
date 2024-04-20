import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/page/flow_pages/home_page_2/blog/post_blog_page.dart';
import 'package:salon/project_specific/text_theme.dart';

class BlogAddSheetPage extends StatefulWidget {
  const BlogAddSheetPage({super.key});

  @override
  State<BlogAddSheetPage> createState() => _BlogAddSheetPageState();
}

class _BlogAddSheetPageState extends State<BlogAddSheetPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.36,
      width: Get.width,
      decoration: const BoxDecoration(
        color: ColorConstant.whiteColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          topLeft: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 71,
            width: Get.width,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(
              color: ColorConstant.primaryColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16),
                topLeft: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                Text(
                  "What you want to add?",
                  textScaler: const TextScaler.linear(0.85),
                  style: AppTextTheme.bold
                      .copyWith(color: ColorConstant.whiteColor, fontSize: 19),
                ),
                IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      CupertinoIcons.xmark,
                      color: ColorConstant.whiteColor,
                    ))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: GestureDetector(
              onTap: () {
                Get.back();
                Get.to(()=> const PostBlogPage());
              },
              child: Container(
                padding: const EdgeInsets.all(53),
                decoration: BoxDecoration(
                    color: ColorConstant.whiteColor,
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: ColorConstant.addServiceBorderColor)),
                child: Center(
                  child: Image.asset(
                    AssetsConstant.blogs,
                    height: 54,
                    width: 54,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
