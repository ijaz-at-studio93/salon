import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/api_constant.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/model/artist_model/blog_data_get_model.dart';
import 'package:salon/page/stylist_all_module/stylist_home_page/blog/network_video_view_widget.dart';
import 'package:salon/page/stylist_all_module/stylist_home_page/blog/offline_video_widget.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:salon/util/pick_image.dart';

class ContentViewPage extends StatefulWidget {
  final BlogData item;
  const ContentViewPage({super.key, required this.item});

  @override
  State<ContentViewPage> createState() => _ContentViewPageState();
}

class _ContentViewPageState extends State<ContentViewPage> {
  final _homeController = Get.find<HomeController>();

  // reactive local copy of the item so the page reflects edits immediately
  late final Rx<BlogData> _item;

  // edit state
  final _editDescController = TextEditingController();
  final Rx<File?> _editPickedFile = Rx<File?>(null);
  final RxBool _editIsVideo = false.obs;

  @override
  void initState() {
    super.initState();
    _item = widget.item.obs;
    _editDescController.text = widget.item.description ?? '';
  }

  @override
  void dispose() {
    _editDescController.dispose();
    super.dispose();
  }

  // ── File picker for edit ─────────────────────────────────────────────────

  Future<void> _showEditPickOptions() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: ColorConstant.whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
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
                  await _pickEditFile(isVideo: false);
                },
              ),
              ListTile(
                title: Text('Video',
                    style: AppTextTheme.medium.copyWith(
                        color: ColorConstant.blackColor, fontSize: 16)),
                onTap: () async {
                  Navigator.pop(ctx);
                  await _pickEditFile(isVideo: true);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickEditFile({required bool isVideo}) async {
    try {
      if (isVideo) {
        await FileUtils.openPlatformVideoPicker(
          onSelectVideo: (File file) {
            _editPickedFile.value = file;
            _editIsVideo.value = true;
          },
        );
      } else {
        await FileUtils.openPlatformImagePicker(
          onSelectImage: (File file) {
            _editPickedFile.value = file;
            _editIsVideo.value = false;
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

  // ── Edit bottom sheet ─────────────────────────────────────────────────────

  void _showEditSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColorConstant.whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(sheetCtx).viewInsets.bottom),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // media preview (existing or newly picked)
              GestureDetector(
                onTap: _showEditPickOptions,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    height: 180,
                    width: double.infinity,
                    child: Obx(() {
                      if (_editPickedFile.value != null) {
                        return _editIsVideo.value
                            ? OfflineVideoWidget(
                                videoString: _editPickedFile.value!.path)
                            : Image.file(_editPickedFile.value!,
                                fit: BoxFit.cover);
                      }
                      // show existing content
                      final isVideo = widget.item.video != null &&
                          widget.item.video!.isNotEmpty;
                      if (isVideo) {
                        return NetworkVideoViewWidget(
                          videoString:
                              '${APIConstants.image}${widget.item.video}',
                        );
                      }
                      return CachedNetworkImage(
                        imageUrl:
                            '${APIConstants.image}${widget.item.image ?? ""}',
                        fit: BoxFit.cover,
                        placeholder: (_, __) =>
                            Container(color: Colors.grey.shade200),
                        errorWidget: (_, __, ___) =>
                            Container(color: Colors.grey.shade200),
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  'Tap on photo or video to change',
                  style: AppTextTheme.regular.copyWith(
                      color: ColorConstant.grayTextColor, fontSize: 12),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Description',
                style: AppTextTheme.medium
                    .copyWith(color: ColorConstant.blackColor, fontSize: 14),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _editDescController,
                maxLines: 3,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                        color: ColorConstant.bookingCardBorderPurple),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                        color: ColorConstant.bookingCardBorderPurple),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                        color: ColorConstant.bookingCardBorderPurple, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _homeController.showContentProgress
                        ? null
                        : () {
                            final newDesc = _editDescController.text.trim();
                            final newFile = _editPickedFile.value;
                            final newIsVideo = _editIsVideo.value;
                            _homeController.doUpdateSalonContent(
                              contentId: _item.value.id ?? '',
                              description: newDesc,
                              file: newFile,
                              isVideo: newIsVideo,
                              callback: () {
                                // optimistically update the local item
                                _item.value = BlogData(
                                  id: _item.value.id,
                                  title: _item.value.title,
                                  description: newDesc.isNotEmpty
                                      ? newDesc
                                      : _item.value.description,
                                  image: _item.value.image,
                                  video: _item.value.video,
                                  createdAt: _item.value.createdAt,
                                  body: _item.value.body,
                                  viewCount: _item.value.viewCount,
                                  likeCount: _item.value.likeCount,
                                  externalLink: _item.value.externalLink,
                                  artist: _item.value.artist,
                                );
                                _editPickedFile.value = null;
                                if (Navigator.canPop(sheetCtx)) {
                                  Navigator.pop(sheetCtx);
                                }
                                _homeController.doGetSalonContentList();
                              },
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: ColorConstant.bookingCardBorderPurple,
                      foregroundColor: ColorConstant.whiteColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _homeController.showContentProgress
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: ColorConstant.whiteColor),
                          )
                        : Text(
                            'Save',
                            style: AppTextTheme.extraBold.copyWith(
                                color: ColorConstant.whiteColor, fontSize: 16),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Delete ────────────────────────────────────────────────────────────────

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete',
            style:
                AppTextTheme.medium.copyWith(color: ColorConstant.blackColor)),
        content: Text('Are you sure you want to delete this content?',
            style: AppTextTheme.medium
                .copyWith(color: ColorConstant.blueGrayColor, fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel',
                style: AppTextTheme.medium
                    .copyWith(color: ColorConstant.redColor, fontSize: 14)),
          ),
          TextButton(
            onPressed: () {
              _homeController.doDeleteSalonContent(
                contentId: widget.item.id ?? '',
                callback: () {
                  Navigator.pop(ctx); // close dialog
                  Get.back(); // go back to grid
                  _homeController.doGetSalonContentList();
                },
              );
            },
            child: Text('Yes',
                style: AppTextTheme.medium
                    .copyWith(color: ColorConstant.primaryColor, fontSize: 14)),
          ),
        ],
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _statBadge({
    required String icon,
    required Color bgColor,
    required int count,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Image.asset(icon, width: 20, height: 20),
          ),
          const SizedBox(width: 5),
          Text(
            '$count',
            style:
                AppTextTheme.bold.copyWith(color: Colors.white, fontSize: 13),
          ),
        ],
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final safeTop = MediaQuery.of(context).padding.top;
    final safeBottom = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        final item = _item.value;
        final isVideo = item.video != null && item.video!.isNotEmpty;

        return Stack(
          fit: StackFit.expand,
          children: [
            // ── Full-screen media ──────────────────────────────────────────
            if (isVideo)
              NetworkVideoViewWidget(
                videoString: '${APIConstants.image}${item.video}',
              )
            else
              CachedNetworkImage(
                imageUrl: '${APIConstants.image}${item.image ?? ""}',
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(color: Colors.grey.shade800),
                errorWidget: (_, __, ___) =>
                    Container(color: Colors.grey.shade800),
              ),

            // ── Top gradient scrim ─────────────────────────────────────────
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: safeTop + 80,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black54, Colors.transparent],
                  ),
                ),
              ),
            ),

            // ── Top bar: back + avatar/name + delete ───────────────────────
            Positioned(
              top: safeTop + 8,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: const Icon(Icons.arrow_back_ios_new,
                            color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 10),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey.shade400,
                        backgroundImage: (item.artist?.profileImage != null &&
                                item.artist!.profileImage!.isNotEmpty)
                            ? NetworkImage(
                                '${APIConstants.image}${item.artist!.profileImage}')
                            : null,
                        child: (item.artist?.profileImage == null ||
                                item.artist!.profileImage!.isEmpty)
                            ? const Icon(Icons.person,
                                color: Colors.white, size: 20)
                            : null,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'By ${item.artist?.name ?? ""}',
                        style: AppTextTheme.bold
                            .copyWith(color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: _confirmDelete,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.delete_outline,
                          color: Colors.white, size: 22),
                    ),
                  ),
                ],
              ),
            ),

            // ── Bottom gradient scrim ──────────────────────────────────────
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 200 + safeBottom,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black87, Colors.transparent],
                  ),
                ),
              ),
            ),

            // ── Bottom-right: likes, views, edit ──────────────────────────
            Positioned(
              bottom: safeBottom + 60,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _statBadge(
                    icon: AssetsConstant.likeIcon,
                    bgColor: ColorConstant.redColor2,
                    count: item.likeCount ?? 0,
                  ),
                  const SizedBox(height: 10),
                  _statBadge(
                    icon: AssetsConstant.viewIcon,
                    bgColor: const Color.fromARGB(0, 179, 89, 89),
                    count: item.viewCount ?? 0,
                  ),
                  const SizedBox(height: 14),
                  GestureDetector(
                    onTap: _showEditSheet,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 9),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade700,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Edit',
                        style: AppTextTheme.bold
                            .copyWith(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Bottom description ─────────────────────────────────────────
            Positioned(
              bottom: safeBottom + 12,
              left: 16,
              right: 80,
              child: Text(
                item.description ?? '',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: AppTextTheme.regular
                    .copyWith(color: Colors.white, fontSize: 13),
              ),
            ),
          ],
        );
      }),
    );
  }
}
