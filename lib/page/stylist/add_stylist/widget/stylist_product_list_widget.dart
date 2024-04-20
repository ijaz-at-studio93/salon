import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/text_theme.dart';

class StylistProductListWidget extends StatelessWidget {
  final VoidCallback onPress;
  const StylistProductListWidget({super.key, required this.onPress});

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
                  "Low Fade Hair Cut ",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: AppTextTheme.bold
                      .copyWith(color: ColorConstant.blackColor, fontSize: 16),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "₹399",
                style: AppTextTheme.bold
                    .copyWith(color: ColorConstant.blackColor, fontSize: 16),
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
                  'n publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a....',
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
              const SizedBox(height: 10),
            ],
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              "https://images.unsplash.com/photo-1525299374597-911581e1bdef?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
              width: 108,
              height: 123,
              fit: BoxFit.cover,
            ),
          )
        ],
      ),
    );
  }
}
