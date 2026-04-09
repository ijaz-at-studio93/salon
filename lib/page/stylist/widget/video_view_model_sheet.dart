import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/page/stylist_all_module/stylist_home_page/blog/network_video_view_widget.dart';
import '../../../constant/color_constant.dart';
import '../../../project_specific/text_theme.dart';

class VideoViewModelSheet extends StatefulWidget {
  final String videoString;
  const VideoViewModelSheet({super.key, required this.videoString});

  @override
  State<VideoViewModelSheet> createState() => _VideoViewModelSheetState();
}

class _VideoViewModelSheetState extends State<VideoViewModelSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.7,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      CupertinoIcons.xmark_circle,
                      size: 40,
                    )),
                Text(
                  "",
                  textScaler: const TextScaler.linear(0.85),
                  style: AppTextTheme.bold.copyWith(
                    fontSize: 19,
                    color: ColorConstant.blackColor,
                  ),
                ),
                const SizedBox(),
                const SizedBox(),
              ],
            ),
          ),
          Expanded(
              child: NetworkVideoViewWidget(
            videoString: widget.videoString,
          )),
        ],
      ),
    );
  }
}
