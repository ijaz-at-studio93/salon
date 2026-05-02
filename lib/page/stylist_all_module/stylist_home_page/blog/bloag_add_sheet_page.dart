import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/stylist/stylist_controller.dart';
import 'package:salon/page/stylist_all_module/stylist_home_page/blog/offline_video_widget.dart';
import 'package:salon/page/stylist_all_module/profile/stylist_content_page.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:salon/util/pick_image.dart';

/// Bottom sheet opened from the stylist home FAB — layout matches salon [ContentPage] upload sheet.
class BlogAddSheetPage extends StatefulWidget {
  const BlogAddSheetPage({super.key});

  @override
  State<BlogAddSheetPage> createState() => _BlogAddSheetPageState();
}

class _BlogAddSheetPageState extends State<BlogAddSheetPage> {
  final _stylistController = Get.find<StylistController>();
  final _descriptionController = TextEditingController();

  final Rx<File?> _pickedFile = Rx<File?>(null);
  final RxBool _isVideo = false.obs;
  final RxBool _showUploadMediaError = false.obs;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

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
                  title: Text(
                    'Picture',
                    style: AppTextTheme.medium.copyWith(
                      color: ColorConstant.blackColor,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(ctx);
                    await _pickFile(isVideo: false);
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Could not select file',
              style: AppTextTheme.regular
                  .copyWith(color: ColorConstant.whiteColor),
            ),
          ),
        );
      }
    }
  }

  String _deriveTitle(String text) {
    final t = text.trim();
    if (t.isEmpty) return 'New post';
    final firstLine = t.split(RegExp(r'\r?\n')).first.trim();
    if (firstLine.length <= 100) return firstLine;
    return '${firstLine.substring(0, 97)}...';
  }

  String _deriveBody(String text) {
    final t = text.trim();
    if (t.length <= 200) return t;
    return t.substring(0, 200);
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

    final file = _pickedFile.value!;
    final isVid = _isVideo.value;
    _stylistController.doCreateBlog(
      title: _deriveTitle(_descriptionController.text.trim()),
      externalLink: '',
      body: _deriveBody(_descriptionController.text.trim()),
      description: _descriptionController.text.trim(),
      image: isVid ? File('') : file,
      video: isVid ? file : File(''),
      callback: () {
        Get.back();
        Get.to(() => const StylistContentPage());
      },
    );
    return true;
  }

  // ── Original approach with showMessage (commented for reference) ───────────────────────────────────────────
  /*
  void _submit() {
    final desc = _descriptionController.text.trim();
    if (_pickedFile.value == null) {
      showMessage('Please select a picture or video first');
      return;
    }
    if (desc.isEmpty) {
      showMessage('Please write a description');
      return;
    }

    final file = _pickedFile.value!;
    final isVid = _isVideo.value;
    _stylistController.doCreateBlog(
      title: _deriveTitle(desc),
      externalLink: '',
      body: _deriveBody(desc),
      description: desc,
      image: isVid ? File('') : file,
      video: isVid ? file : File(''),
      callback: () {
        Get.back();
        Get.to(() => const StylistContentPage());
      },
    );
  }
  */

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _showPickOptions,
              child: Center(
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
                                    videoString: _pickedFile.value!.path,
                                  )
                                : Image.file(
                                    _pickedFile.value!,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                ),
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
                    color: ColorConstant.primaryColor2,
                    width: 2,
                  ),
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
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _stylistController.showProgress ? null : () {
                    final didStartUpload = _doUpload(
                      sheetContext: context,
                      showInlineMediaError: true,
                    );
                    if (didStartUpload && Navigator.canPop(context)) {
                      Navigator.pop(context);
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
                  child: _stylistController.showProgress
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: ColorConstant.whiteColor,
                          ),
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
  }
}
