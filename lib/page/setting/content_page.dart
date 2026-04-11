import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:salon/util/pick_image.dart';

class ContentPage extends StatefulWidget {
  const ContentPage({super.key});

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  Future<void> _showUploadOptions() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: ColorConstant.whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(
                    'Picture',
                    style: AppTextTheme.medium.copyWith(
                      color: ColorConstant.blackColor,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(ctx);
                    await _pickPicture();
                  },
                ),
                ListTile(
                  title: Text(
                    'Video',
                    style: AppTextTheme.medium.copyWith(
                      color: ColorConstant.blackColor,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(ctx);
                    await _pickVideo();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickPicture() async {
    try {
      await FileUtils.openPlatformImagePicker(onSelectImage: (File file) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Picture selected',
              style: AppTextTheme.regular
                  .copyWith(color: ColorConstant.whiteColor),
            ),
          ),
        );
      });
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Could not select picture',
              style: AppTextTheme.regular
                  .copyWith(color: ColorConstant.whiteColor),
            ),
          ),
        );
      }
    }
  }

  Future<void> _pickVideo() async {
    try {
      await FileUtils.openPlatformVideoPicker(onSelectVideo: (File file) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Video selected',
              style: AppTextTheme.regular
                  .copyWith(color: ColorConstant.whiteColor),
            ),
          ),
        );
      });
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Could not select video',
              style: AppTextTheme.regular
                  .copyWith(color: ColorConstant.whiteColor),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.whiteColor,
      appBar: const AppBarWidget(
        nameOfScreen: 'Content',
        isBackIcon: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AssetsConstant.contentUploadIllustration,
                      width: 160,
                      fit: BoxFit.contain,
                    ),
                    Text(
                      'Upload a Picture or Video',
                      textAlign: TextAlign.center,
                      textScaler: const TextScaler.linear(0.85),
                      style: AppTextTheme.extraBold.copyWith(
                        color: ColorConstant.grayTextColor,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                20, 0, 20, 16 + MediaQuery.paddingOf(context).bottom),
            child: SizedBox(
              width: Get.width,
              child: ElevatedButton(
                onPressed: _showUploadOptions,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: ColorConstant.bookingCardBorderPurple,
                  foregroundColor: ColorConstant.whiteColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Upload',
                  style: AppTextTheme.extraBold.copyWith(
                    color: ColorConstant.whiteColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
