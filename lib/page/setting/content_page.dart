import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/api_constant.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/model/artist_model/blog_data_get_model.dart';
import 'package:salon/page/setting/content_view_page.dart';
import 'package:salon/page/stylist_all_module/stylist_home_page/blog/network_video_view_widget.dart';
import 'package:salon/page/stylist_all_module/stylist_home_page/blog/offline_video_widget.dart';
import 'package:salon/project_specific/progressbar_view.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:salon/util/pick_image.dart';

class ContentPage extends StatefulWidget {
  const ContentPage({super.key});

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  final _homeController = Get.find<HomeController>();
  final _descriptionController = TextEditingController();

  final Rx<File?> _pickedFile = Rx<File?>(null);
  final RxBool _isVideo = false.obs;
  final RxBool _showUploadMediaError = false.obs;
  final RxBool _showUploadDescriptionError = false.obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _homeController.doGetSalonContentList();
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  // ── File selection ───────────────────────────────────────────────────────

  Future<void> _showPickOptions() async {
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
                  title: Text('Picture',
                      style: AppTextTheme.medium.copyWith(
                          color: ColorConstant.blackColor, fontSize: 16)),
                  onTap: () async {
                    Navigator.pop(ctx);
                    await _pickFile(isVideo: false);
                  },
                ),
                ListTile(
                  title: Text('Video',
                      style: AppTextTheme.medium.copyWith(
                          color: ColorConstant.blackColor, fontSize: 16)),
                  onTap: () async {
                    Navigator.pop(ctx);
                    await _pickFile(isVideo: true);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickFile({required bool isVideo}) async {
    try {
      if (isVideo) {
        await FileUtils.openPlatformVideoPicker(
          onSelectVideo: (File file) {
            _pickedFile.value = file;
            _isVideo.value = true;
            _showUploadMediaError.value = false;
          },
        );
      } else {
        await FileUtils.openPlatformImagePicker(
          onSelectImage: (File file) {
            _pickedFile.value = file;
            _isVideo.value = false;
            _showUploadMediaError.value = false;
          },
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Could not select file',
              style: AppTextTheme.regular
                  .copyWith(color: ColorConstant.whiteColor)),
        ));
      }
    }
  }

  // ── Upload ───────────────────────────────────────────────────────────────

  bool _doUpload({
    required BuildContext sheetContext,
    bool showInlineMediaError = false,
  }) {
    if (_pickedFile.value == null) {
      if (showInlineMediaError) {
        _showUploadMediaError.value = true;
        return false;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please select a picture or video first',
            style:
                AppTextTheme.regular.copyWith(color: ColorConstant.whiteColor)),
      ));
      return false;
    }

    if (_descriptionController.text.trim().isEmpty) {
      if (showInlineMediaError) {
        _showUploadDescriptionError.value = true;
        return false;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please write a description',
            style:
                AppTextTheme.regular.copyWith(color: ColorConstant.whiteColor)),
      ));
      return false;
    }

    _homeController.doCreateSalonContent(
      description: _descriptionController.text.trim(),
      file: _pickedFile.value,
      isVideo: _isVideo.value,
      callback: () {
        _pickedFile.value = null;
        _isVideo.value = false;
        _showUploadMediaError.value = false;
        _showUploadDescriptionError.value = false;
        _descriptionController.clear();
        _homeController.doGetSalonContentList();
      },
    );
    return true;
  }

  // ── Upload bottom sheet (used by "+" button on grid) ─────────────────────

  void _showUploadSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColorConstant.whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) {
        // Reset state when sheet opens
        _showUploadMediaError.value = false;
        _showUploadDescriptionError.value = false;
        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(sheetCtx).viewInsets.bottom),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // illustration / preview — tappable with remove option
                GestureDetector(
                  onTap: _showPickOptions,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Center(
                        child: Obx(
                          () => _pickedFile.value == null
                              ? Image.asset(
                                  AssetsConstant.contentUploadIllustration,
                                  width: 140,
                                  fit: BoxFit.contain,
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: SizedBox(
                                    height: 140,
                                    width: 140,
                                    child: _isVideo.value
                                        ? OfflineVideoWidget(
                                            videoString: _pickedFile.value!.path)
                                        : Image.file(_pickedFile.value!,
                                            fit: BoxFit.cover),
                                  ),
                                ),
                        ),
                      ),
                      // Remove button for selected media
                      Obx(
                        () => _pickedFile.value != null
                            ? Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    _pickedFile.value = null;
                                    _isVideo.value = false;
                                    _showUploadMediaError.value = false;
                                  },
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // tappable text
                GestureDetector(
                  onTap: _showPickOptions,
                  child: Center(
                    child: Text(
                      'Upload a Picture or Video',
                      textAlign: TextAlign.center,
                      textScaler: const TextScaler.linear(0.85),
                      style: AppTextTheme.extraBold.copyWith(
                        decoration: TextDecoration.underline,
                        color: ColorConstant.grayTextColor,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Write Description',
                  style: AppTextTheme.medium
                      .copyWith(color: ColorConstant.blackColor, fontSize: 14),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _descriptionController,
                  maxLines: 3,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: ColorConstant.primaryColor2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: ColorConstant.primaryColor2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                          color: ColorConstant.primaryColor2, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Obx(
                  () => _showUploadMediaError.value
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: ColorConstant.redColor2
                                  .withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: ColorConstant.redColor2,
                              ),
                            ),
                            child: Text(
                              'Please select a picture or video first',
                              style: AppTextTheme.medium.copyWith(
                                color: ColorConstant.redColor2,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                Obx(
                  () => _showUploadDescriptionError.value
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: ColorConstant.redColor2
                                  .withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: ColorConstant.redColor2,
                              ),
                            ),
                            child: Text(
                              'Please write a description',
                              style: AppTextTheme.medium.copyWith(
                                color: ColorConstant.redColor2,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (_homeController.showContentProgress || _pickedFile.value == null)
                          ? null
                          : () {
                              _showUploadMediaError.value = false;
                              _showUploadDescriptionError.value = false;
                              final didStartUpload =
                                  _doUpload(
                                sheetContext: sheetCtx,
                                showInlineMediaError: true,
                              );
                              if (didStartUpload &&
                                  Navigator.canPop(sheetCtx)) {
                                Navigator.pop(sheetCtx);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: ColorConstant.primaryColor2,
                        foregroundColor: ColorConstant.whiteColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _homeController.showContentProgress
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: ColorConstant.whiteColor,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Uploading...',
                                  style: AppTextTheme.extraBold.copyWith(
                                    color: ColorConstant.whiteColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            )
                          : Text(
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
          ),
        );
      },
    );
  }

  // ── Widgets ──────────────────────────────────────────────────────────────

  Widget _emptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: _showPickOptions,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: Obx(
                    () => _pickedFile.value == null
                        ? Image.asset(
                            AssetsConstant.contentUploadIllustration,
                            width: 160,
                            fit: BoxFit.contain,
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              height: 160,
                              width: 160,
                              child: _isVideo.value
                                  ? OfflineVideoWidget(
                                      videoString: _pickedFile.value!.path)
                                  : Image.file(_pickedFile.value!,
                                      fit: BoxFit.cover),
                            ),
                          ),
                  ),
                ),
                // Remove button for selected media
                Obx(
                  () => _pickedFile.value != null
                      ? Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              _pickedFile.value = null;
                              _isVideo.value = false;
                              _showUploadMediaError.value = false;
                            },
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _showPickOptions,
            child: Center(
              child: Text(
                'Upload a Picture or Video',
                textAlign: TextAlign.center,
                textScaler: const TextScaler.linear(0.85),
                style: AppTextTheme.extraBold.copyWith(
                  decoration: TextDecoration.underline,
                  color: ColorConstant.grayTextColor,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'Write Description',
            style: AppTextTheme.medium
                .copyWith(color: ColorConstant.blackColor, fontSize: 14),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _descriptionController,
            maxLines: 3,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: ColorConstant.primaryColor2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: ColorConstant.primaryColor2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                    color: ColorConstant.primaryColor2, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _uploadButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 0, 20, 16 + MediaQuery.paddingOf(context).bottom),
      child: Obx(
        () => SizedBox(
          width: Get.width,
          child: ElevatedButton(
            onPressed: (_homeController.showContentProgress || _pickedFile.value == null)
                ? null
                : () {
                    _showUploadMediaError.value = false;
                    _showUploadDescriptionError.value = false;
                    _doUpload(sheetContext: context);
                  },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: ColorConstant.primaryColor2,
              foregroundColor: ColorConstant.whiteColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _homeController.showContentProgress
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: ColorConstant.whiteColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Uploading...',
                        style: AppTextTheme.extraBold.copyWith(
                          color: ColorConstant.whiteColor,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  )
                : Text(
                    'Upload',
                    style: AppTextTheme.extraBold.copyWith(
                      color: ColorConstant.whiteColor,
                      fontSize: 16,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _contentCard(BlogData item) {
    final bool isVideo = item.video != null && item.video!.isNotEmpty;
    return GestureDetector(
      onTap: () => Get.to(() => ContentViewPage(item: item)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // media
            if (isVideo)
              NetworkVideoViewWidget(
                videoString: '${APIConstants.image}${item.video}',
                showThumbnail: true,
                autoplay: false,
              )
            else
              CachedNetworkImage(
                imageUrl: '${APIConstants.image}${item.image ?? ""}',
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey.shade200,
                  child: const Image(
                    image: AssetImage(AssetsConstant.placeHolder),
                    fit: BoxFit.cover,
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey.shade200,
                  child: const Image(
                    image: AssetImage(AssetsConstant.placeHolder),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            // bottom gradient
            Positioned(
              bottom: 0,
              // left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black54, Colors.transparent],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // view count
                    Row(
                      children: [
                        Image.asset(
                          AssetsConstant.viewIcon,
                          width: 11,
                          height: 11,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${item.viewCount ?? 0}',
                          style: AppTextTheme.regular
                              .copyWith(color: Colors.white, fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              // left: 0,
              left: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black54, Colors.transparent],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // view count
                    Row(
                      children: [
                        Image.asset(
                          AssetsConstant.likeIcon,
                          width: 11,
                          height: 11,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${item.likeCount ?? 0}',
                          style: AppTextTheme.regular
                              .copyWith(color: Colors.white, fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.blackColor,
      appBar: const AppBarWidget(
        nameOfScreen: 'Content',
        isBackIcon: true,
      ),
      body: Obx(
        () {
          if (_homeController.showContentProgress) {
            return const ProgressBarView();
          }

          final items = _homeController.getBlogDataGetModel.data;

          // ── Empty state ──
          if (items == null || items.isEmpty) {
            return Column(
              children: [
                Expanded(child: _emptyState()),
                _uploadButton(),
              ],
            );
          }

          // ── Grid with floating "+" button ──
          return Stack(
            children: [
              GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                  mainAxisExtent: 180,
                ),
                itemCount: items.length,
                itemBuilder: (context, i) => _contentCard(items[i]),
              ),
              // centered "+" button
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: GestureDetector(
                    onTap: _showUploadSheet,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: ColorConstant.whiteColor,
                          width: 6,
                        ),
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        color: ColorConstant.whiteColor,
                        size: 54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
