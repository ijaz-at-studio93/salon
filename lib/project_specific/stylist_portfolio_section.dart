import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/api_constant.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/stylist/stylist_controller.dart';
import 'package:salon/model/stylist/artist_portfolio_model.dart';
import 'package:salon/page/stylist_all_module/stylist_home_page/blog/offline_video_widget.dart';
import 'package:salon/page/stylist/widget/video_view_model_sheet.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:salon/util/pick_image.dart';

/// Portfolio grid on stylist home ([HomePage2]). Upload uses
/// `PUT artist/portfolio/sample-portfolio-upload` (`images` / `videos`). Max
/// [StylistController.portfolioMaxItems] entries shown.
class StylistPortfolioSection extends StatelessWidget {
  final List<Portfolio> items;

  const StylistPortfolioSection({
    super.key,
    required this.items,
  });

  int get _maxItems => StylistController.portfolioMaxItems;

  List<Portfolio> get _items =>
      items.length > _maxItems ? items.sublist(0, _maxItems) : items;

  void _openVideo(BuildContext context, Portfolio item) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      context: context,
      builder: (context) => VideoViewModelSheet(
        videoString: "${APIConstants.image}${item.video ?? ""}",
      ),
    );
  }

  Future<void> _showPickOptions(BuildContext context, StateSetter setModalState,
      void Function(File file, bool isVideo) onPicked) async {
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
                    try {
                      await FileUtils.openPlatformImagePicker(
                        onSelectImage: (File file) {
                          onPicked(file, false);
                          setModalState(() {});
                        },
                      );
                    } catch (_) {
                      if (context.mounted) {
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
                    try {
                      await FileUtils.openPlatformVideoPicker(
                        onSelectVideo: (File file) {
                          onPicked(file, true);
                          setModalState(() {});
                        },
                      );
                    } catch (_) {
                      if (context.mounted) {
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
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showUploadSheet(BuildContext context) {
    final stylistController = Get.find<StylistController>();
    File? pickedFile;
    var isVideo = false;
    final RxBool showUploadMediaError = false.obs;
    final RxBool showPortfolioLimitError = false.obs;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColorConstant.whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            void pick(File file, bool video) {
              pickedFile = file;
              isVideo = video;
            }

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(sheetCtx).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () =>
                          _showPickOptions(context, setModalState, pick),
                      child: Center(
                        child: pickedFile == null
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
                                  child: isVideo
                                      ? OfflineVideoWidget(
                                          videoString: pickedFile!.path,
                                        )
                                      : Image.file(
                                          pickedFile!,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () =>
                          _showPickOptions(context, setModalState, pick),
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
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        '${_items.length}/$_maxItems items',
                        style: AppTextTheme.regular.copyWith(
                          color: ColorConstant.grayTextColor,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Obx(
                      () => showPortfolioLimitError.value
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
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.error_outline,
                                      color: ColorConstant.redColor2,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Maximum $_maxItems portfolio items allowed. Remove an item to add another.',
                                        style: AppTextTheme.medium.copyWith(
                                          color: ColorConstant.redColor2,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    Obx(
                      () => showUploadMediaError.value
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
                          onPressed: stylistController.portfolioUploadBusy
                              ? null
                              : () {
                                  if (pickedFile == null) {
                                    setModalState(() {
                                      showUploadMediaError.value = true;
                                      showPortfolioLimitError.value = false;
                                    });
                                    return;
                                  }
                                  
                                  // Check portfolio limit locally
                                  final currentPortfolioItems = stylistController.getArtistPortfolioModel.data?.portfolio?.length ?? 0;
                                  if (currentPortfolioItems >= _maxItems) {
                                    setModalState(() {
                                      showUploadMediaError.value = false;
                                      showPortfolioLimitError.value = true;
                                    });
                                    return;
                                  }
                                  
                                  setModalState(() {
                                    showUploadMediaError.value = false;
                                    showPortfolioLimitError.value = false;
                                  });
                                  
                                  stylistController.doUploadPortfolioMedia(
                                    file: pickedFile!,
                                    isImage: !isVideo,
                                    callback: () {
                                      if (Navigator.canPop(sheetCtx)) {
                                        Navigator.pop(sheetCtx);
                                      }
                                    },
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: ColorConstant.primaryColor2,
                            foregroundColor:
                                const Color.fromARGB(255, 33, 21, 21),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: stylistController.portfolioUploadBusy
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
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = AppTextTheme.bold.copyWith(
      color: Colors.black,
      fontSize: 24,
      fontFamily: 'Outfit',
      fontWeight: FontWeight.w600,
      letterSpacing: 0.48,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Portfolio',
          textAlign: TextAlign.center,
          style: titleStyle,
        ),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.98,
          ),
          itemCount: _items.length + 1,
          itemBuilder: (context, i) {
            if (i == 0) {
              return GestureDetector(
                onTap: () => _showUploadSheet(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        AssetsConstant.productAddIcon,
                        width: 53,
                        height: 68,
                      ),
                      Text(
                        'Add',
                        style: AppTextTheme.regular.copyWith(
                          fontSize: 20,
                          color: ColorConstant.blackColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            final itemIndex = i - 1;
            return _portfolioTile(context, _items[itemIndex]);
          },
        ),
      ],
    );
  }

  Widget _portfolioTile(BuildContext context, Portfolio item) {
    final isVideo = item.isVideo ?? false;

    return Stack(
      fit: StackFit.expand,
      children: [
        if (isVideo)
          GestureDetector(
            onTap: () => _openVideo(context, item),
            child: Container(
              decoration: const BoxDecoration(
                color: ColorConstant.editButtonColor,
              ),
              child: Center(
                child: Image.asset(
                  AssetsConstant.playIcon,
                  height: 30,
                  width: 30,
                ),
              ),
            ),
          )
        else
          CachedNetworkImage(
            imageUrl: '${APIConstants.image}${item.image ?? ''}',
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
      ],
    );
  }
}
