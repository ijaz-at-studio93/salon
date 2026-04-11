import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/constant/api_constant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/page/stylist/add_stylist/add_stylist_page.dart';
import 'package:salon/project_specific/progressbar_view.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';

/// Salon owner screen: list stylists with add/remove actions.
class ManageStylistPage extends StatefulWidget {
  const ManageStylistPage({super.key});

  @override
  State<ManageStylistPage> createState() => _ManageStylistPageState();
}

class _ManageStylistPageState extends State<ManageStylistPage> {
  final _homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _homeController.doSalonArtistList();
    });
  }

  void _confirmRemove(BuildContext context, String artistId) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Delete",
            style:
                AppTextTheme.medium.copyWith(color: ColorConstant.blackColor),
          ),
          content: Text(
            "Are you sure you want to delete stylist",
            style: AppTextTheme.medium.copyWith(
              color: ColorConstant.blueGrayColor,
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                "Cancel",
                style: AppTextTheme.medium.copyWith(
                  color: ColorConstant.redColor2,
                  fontSize: 14,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                _homeController.doDeleteArtiest(
                  callback: () {
                    _homeController.doSalonArtistList();
                  },
                  artistId: artistId,
                );
              },
              child: Text(
                "Yes",
                style: AppTextTheme.medium.copyWith(
                  color: ColorConstant.primaryColor2,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.manageStylistScreenBg,
      appBar: const AppBarWidget(
        nameOfScreen: "Manage Stylists",
        isBackIcon: true,
      ),
      body: Obx(
        () {
          if (_homeController.showProgress) {
            return const ProgressBarView();
          }
          final artists = _homeController.getSalonArtistListModel.data ?? [];
          final count = artists.length;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$count Stylist${count == 1 ? '' : '\'s'} found",
                      style: AppTextTheme.regular.copyWith(
                        color: ColorConstant.blackColor,
                        fontSize: 15,
                      ),
                    ),
                    Material(
                      color: ColorConstant.lightColor,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () {
                          Get.to(
                            () => const AddStylistPage(
                              isBasicInfoUpdate: false,
                              artistId: "",
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: ColorConstant.primaryColor2,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.add,
                                size: 18,
                                color: ColorConstant.primaryColor2,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "Add Stylist",
                                style: AppTextTheme.semibold.copyWith(
                                  color: ColorConstant.primaryColor2,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: artists.isEmpty
                    ? Center(
                        child: Text(
                          "No stylists yet",
                          style: AppTextTheme.regular.copyWith(
                            color: ColorConstant.grayTextColor,
                            fontSize: 15,
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        itemCount: artists.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final artist = artists[index];
                          final id = artist.id ?? "";
                          final imageUrl = artist.profileImage != null &&
                                  artist.profileImage!.isNotEmpty
                              ? "${APIConstants.image}${artist.profileImage}"
                              : "";
                          return _ManageStylistCard(
                            name: artist.name ?? "",
                            imageUrl: imageUrl,
                            onRemove: () {
                              if (id.isEmpty) return;
                              _confirmRemove(context, id);
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ManageStylistCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final VoidCallback onRemove;

  const _ManageStylistCard({
    required this.name,
    required this.imageUrl,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: ColorConstant.whiteColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipOval(
              child: imageUrl.isEmpty
                  ? Container(
                      width: 56,
                      height: 56,
                      color: ColorConstant.stylistAvailabilityAvatarPlaceholder,
                    )
                  : CachedNetworkImage(
                      imageUrl: imageUrl,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        width: 56,
                        height: 56,
                        color:
                            ColorConstant.stylistAvailabilityAvatarPlaceholder,
                      ),
                      errorWidget: (_, __, ___) => Container(
                        width: 56,
                        height: 56,
                        color:
                            ColorConstant.stylistAvailabilityAvatarPlaceholder,
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                style: AppTextTheme.bold.copyWith(
                  color: ColorConstant.blackColor,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: ColorConstant.redColor2.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(100),
              child: InkWell(
                onTap: onRemove,
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: ColorConstant.redColor2),
                  ),
                  child: Text(
                    "Remove",
                    style: AppTextTheme.semibold.copyWith(
                      color: ColorConstant.redColor2,
                      fontSize: 14,
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
