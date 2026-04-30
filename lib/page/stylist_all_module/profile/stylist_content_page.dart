import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/api/dio_client.dart';
import 'package:salon/constant/api_constant.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/stylist/stylist_controller.dart';
import 'package:salon/model/artist_model/blog_data_get_model.dart';
import 'package:salon/page/blog/insights_detail_page.dart';
import 'package:salon/page/stylist_all_module/stylist_home_page/blog/network_video_view_widget.dart';
import 'package:salon/page/stylist_all_module/stylist_home_page/blog/offline_video_widget.dart';
import 'package:salon/project_specific/progressbar_view.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:salon/util/NoItemsWidget.dart';
import 'package:salon/util/pick_image.dart';

/// Stylist "Content" list — `artist/blog/list`, opens from profile or after creating content.
class StylistContentPage extends StatefulWidget {
  const StylistContentPage({super.key});

  @override
  State<StylistContentPage> createState() => _StylistContentPageState();
}

class _StylistContentPageState extends State<StylistContentPage> {
  final _stylistController = Get.find<StylistController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _stylistController.doGetBlog();
    });
  }

  String _badgeLabel(BlogData item) {
    final salonName = item.artist?.salon?.name?.trim();
    final artistName = item.artist?.name?.trim();
    if (salonName != null && salonName.isNotEmpty) {
      return 'On $salonName';
    }
    if (artistName != null && artistName.isNotEmpty) {
      return artistName;
    }
    return 'Content';
  }

  void _openDetail(BlogData item) {
    final hasVideo = item.video != null && item.video!.isNotEmpty;
    Get.to(() => InsightsDetailPage(
          video: hasVideo ? '${APIConstants.image}${item.video}' : '',
          body: item.description ?? '',
          title: item.title ?? '',
          subTitle: item.body ?? '',
          image: (!hasVideo && item.image != null && item.image!.isNotEmpty)
              ? '${APIConstants.image}${item.image}'
              : '',
        ));
  }

  void _showEditSheet(BlogData item) {
    final id = item.id;
    if (id == null || id.isEmpty) {
      showMessage('Missing content id');
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColorConstant.whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _BlogEditBottomSheet(
        item: item,
        onSaved: () => Navigator.pop(ctx),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.gray,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorConstant.whiteColor,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: ColorConstant.blackColor,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Content',
          style: AppTextTheme.bold.copyWith(
            color: ColorConstant.blackColor,
            fontSize: 19,
          ),
        ),
      ),
      body: Obx(
        () => _stylistController.showProgress
            ? const ProgressBarView()
            : _buildList(),
      ),
    );
  }

  Widget _buildList() {
    final items = _stylistController.getBlogDataGetModelModel.data;
    if (items == null || items.isEmpty) {
      return const NoItemsWidget(text: 'No content yet.');
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _ContentCard(
          item: item,
          badgeLabel: _badgeLabel(item),
          onOpenDetail: () => _openDetail(item),
          onEdit: () => _showEditSheet(item),
        );
      },
    );
  }
}

class _BlogEditBottomSheet extends StatefulWidget {
  const _BlogEditBottomSheet({
    required this.item,
    required this.onSaved,
  });

  final BlogData item;
  final VoidCallback onSaved;

  @override
  State<_BlogEditBottomSheet> createState() => _BlogEditBottomSheetState();
}

class _BlogEditBottomSheetState extends State<_BlogEditBottomSheet> {
  final _stylistController = Get.find<StylistController>();
  late final TextEditingController _descCtrl;
  File? _pickedFile;
  bool _pickedIsVideo = false;
  bool _submitting = false;

  bool get _existingIsVideo =>
      widget.item.video != null && widget.item.video!.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _descCtrl = TextEditingController(text: widget.item.description ?? '');
  }

  @override
  void dispose() {
    _descCtrl.dispose();
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
            setState(() {
              _pickedFile = file;
              _pickedIsVideo = true;
            });
          },
        );
      } else {
        await FileUtils.openPlatformImagePicker(
          onSelectImage: (File file) {
            setState(() {
              _pickedFile = file;
              _pickedIsVideo = false;
            });
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

  Future<void> _save() async {
    final id = widget.item.id;
    if (id == null || id.isEmpty) {
      showMessage('Missing content id');
      return;
    }

    final desc = _descCtrl.text.trim();
    final initialDesc = (widget.item.description ?? '').trim();
    final descChanged = desc != initialDesc;
    final hasNewFile = _pickedFile != null;

    if (!descChanged && !hasNewFile) {
      showMessage('No changes to save');
      return;
    }

    setState(() => _submitting = true);
    try {
      await _stylistController.doUpdateArtistBlog(
        blogId: id,
        description: desc,
        image: hasNewFile && !_pickedIsVideo ? _pickedFile : null,
        video: hasNewFile && _pickedIsVideo ? _pickedFile : null,
        onSuccess: widget.onSaved,
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: ColorConstant.primaryColor2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: ColorConstant.primaryColor2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide:
            const BorderSide(color: ColorConstant.primaryColor2, width: 2),
      ),
    );
  }

  Widget _mediaBlock() {
    if (_pickedFile != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 160,
          width: double.infinity,
          child: _pickedIsVideo
              ? OfflineVideoWidget(videoString: _pickedFile!.path)
              : Image.file(_pickedFile!, fit: BoxFit.cover),
        ),
      );
    }

    if (_existingIsVideo) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 160,
          width: double.infinity,
          child: NetworkVideoViewWidget(
            videoString: '${APIConstants.image}${widget.item.video}',
          ),
        ),
      );
    }

    if (widget.item.image != null && widget.item.image!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl: '${APIConstants.image}${widget.item.image}',
          height: 160,
          width: double.infinity,
          fit: BoxFit.cover,
          placeholder: (_, __) => Container(
            height: 160,
            color: ColorConstant.reviewCardColor,
            child:
                const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
          errorWidget: (_, __, ___) => Container(
            height: 160,
            color: ColorConstant.reviewCardColor,
            alignment: Alignment.center,
            child: Image.asset(
              AssetsConstant.placeHolder,
              fit: BoxFit.contain,
            ),
          ),
        ),
      );
    }

    return Image.asset(
      AssetsConstant.contentUploadIllustration,
      height: 140,
      fit: BoxFit.contain,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Edit content',
              style: AppTextTheme.bold.copyWith(
                color: ColorConstant.blackColor,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Content file',
              style: AppTextTheme.medium.copyWith(
                color: ColorConstant.blackColor,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _showPickOptions,
              child: Column(
                children: [
                  Center(child: _mediaBlock()),
                  const SizedBox(height: 10),
                  Text(
                    'Replace picture or video',
                    textAlign: TextAlign.center,
                    textScaler: const TextScaler.linear(0.85),
                    style: AppTextTheme.extraBold.copyWith(
                      decoration: TextDecoration.underline,
                      color: ColorConstant.grayTextColor,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Description',
              style: AppTextTheme.medium.copyWith(
                color: ColorConstant.blackColor,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descCtrl,
              maxLines: 4,
              decoration: _fieldDecoration('Description'),
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitting ? null : _save,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: ColorConstant.primaryColor2,
                  foregroundColor: ColorConstant.whiteColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _submitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: ColorConstant.whiteColor,
                        ),
                      )
                    : Text(
                        'Save',
                        style: AppTextTheme.extraBold.copyWith(
                          color: ColorConstant.whiteColor,
                          fontSize: 16,
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

class _ContentCard extends StatelessWidget {
  const _ContentCard({
    required this.item,
    required this.badgeLabel,
    required this.onOpenDetail,
    required this.onEdit,
  });

  final BlogData item;
  final String badgeLabel;
  final VoidCallback onOpenDetail;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final hasVideo = item.video != null && item.video!.isNotEmpty;
    final hasImage = !hasVideo && item.image != null && item.image!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        decoration: BoxDecoration(
          color: ColorConstant.whiteColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: ColorConstant.appointmentCardElevation,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onOpenDetail,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: ShapeDecoration(
                            color: Colors.black.withValues(alpha: 0.30),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                          ),
                          child: Text(
                            badgeLabel,
                            style: AppTextTheme.bold.copyWith(
                              color: ColorConstant.whiteColor,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        if (hasImage)
                          Builder(builder: (context) {
                            print('${APIConstants.image}${item.image}');
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: '${APIConstants.image}${item.image}',
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (_, __) => Container(
                                  height: 120,
                                  color: ColorConstant.reviewCardColor,
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                                errorWidget: (_, __, ___) => Container(
                                  height: 120,
                                  color: ColorConstant.reviewCardColor,
                                  child: const Image(
                                    image:
                                        AssetImage(AssetsConstant.placeHolder),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          }),
                        if ((item.description ?? '').isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            item.description ?? '',
                            style: AppTextTheme.medium.copyWith(
                              color: ColorConstant.grayTextColor,
                              fontSize: 13,
                              height: 1.35,
                            ),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onEdit,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: ColorConstant.editButtonColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Edit',
                          style: AppTextTheme.bold.copyWith(
                            color: ColorConstant.primaryColor2,
                            fontSize: 14,
                          ),
                        ),
                      ),
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
}
