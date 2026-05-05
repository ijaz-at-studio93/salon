import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/api/dio_client.dart';
import 'package:salon/constant/api_constant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/model/stylist/all_salon_staff_model.dart';
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
  final _addBtnKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _homeController.doSalonArtistList();
    });
  }

  void _showAddStylistMenu(BuildContext context) {
    final box = _addBtnKey.currentContext!.findRenderObject() as RenderBox;
    final offset = box.localToGlobal(Offset.zero);
    final size = box.size;

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + size.height + 4,
        offset.dx + size.width,
        0,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      items: [
        PopupMenuItem(
          value: 'new',
          child: Text(
            'New',
            style: AppTextTheme.medium.copyWith(
              fontSize: 14,
              color: ColorConstant.blackColor,
            ),
          ),
        ),
        PopupMenuItem(
          value: 'existing',
          child: Text(
            'Existing',
            style: AppTextTheme.medium.copyWith(
              fontSize: 14,
              color: ColorConstant.blackColor,
            ),
          ),
        ),
      ],
    ).then((value) {
      if (value == 'new') {
        Get.to(
          () => const AddStylistPage(
            isBasicInfoUpdate: false,
            artistId: '',
          ),
        );
      } else if (value == 'existing') {
        _showExistingStylistDialog(context);
      }
    });
  }

  void _showExistingStylistDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => _AddExistingStylistDialog(
        onAdd: (sId) {
          _homeController.doAddExistingArtistBySId(
            sId: sId,
            callback: () {
              showMessage("Stylist added successfully");
              _homeController.doSalonArtistList();
            },
          );
        },
      ),
    );
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
                      key: _addBtnKey,
                      color: ColorConstant.lightColor,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () => _showAddStylistMenu(context),
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
                            onEdit: () {
                              if (id.isEmpty) return;
                              Get.to(
                                () => AddStylistPage(
                                  artistId: id,
                                  isBasicInfoUpdate: true,
                                ),
                              );
                            },
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

/*──────────────── Add Existing Stylist Dialog ─────────────────*/

class _AddExistingStylistDialog extends StatefulWidget {
  final void Function(String sId) onAdd;

  const _AddExistingStylistDialog({required this.onAdd});

  @override
  State<_AddExistingStylistDialog> createState() =>
      _AddExistingStylistDialogState();
}

class _AddExistingStylistDialogState extends State<_AddExistingStylistDialog> {
  final _homeController = Get.find<HomeController>();
  final _sidController = TextEditingController();

  StaffData? _preview;
  bool _isFetching = false;
  String? _errorMsg;
  bool _isSelected = false;
  Timer? _debounce;

  @override
  void dispose() {
    _sidController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    final val = value.trim().toUpperCase();
    if (val.length != 11 || !val.startsWith('S') || val.startsWith('SI')) {
      setState(() {
        _preview = null;
        _errorMsg = null;
        _isSelected = false;
      });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 600), () => _lookup(val));
  }

  Future<void> _lookup(String sId) async {
    setState(() {
      _isFetching = true;
      _preview = null;
      _errorMsg = null;
      _isSelected = false;
    });
    try {
      final result = await _homeController.doLookupArtistBySId(sId: sId);
      if (!mounted) return;
      if (result != null) {
        setState(() => _preview = result);
      } else {
        setState(() => _errorMsg = "No stylist found with this ID");
      }
    } catch (_) {
      if (mounted) {
        setState(() => _errorMsg = "No stylist found with this ID");
      }
    } finally {
      if (mounted) setState(() => _isFetching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              "Enter SId",
              style: AppTextTheme.bold.copyWith(
                fontSize: 20,
                color: ColorConstant.blackColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Enter stylist ID to search and select",
              style: AppTextTheme.regular.copyWith(
                fontSize: 14,
                color: ColorConstant.grayTextColor,
              ),
            ),
            const SizedBox(height: 20),

            // Pill input
            SizedBox(
              width: context.width * 0.5,
              child: TextField(
                controller: _sidController,
                textCapitalization: TextCapitalization.characters,
                onChanged: _onChanged,
                decoration: InputDecoration(
                  hintText: "e.g. S699019DQBZ",
                  hintStyle: AppTextTheme.regular.copyWith(
                    color: ColorConstant.grayTextColor,
                    fontSize: 14,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                        color: ColorConstant.primaryColor2, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                        color: ColorConstant.primaryColor2, width: 1.5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 22),

            // Preview / status row
            if (_isFetching)
              const Padding(
                padding: EdgeInsets.only(bottom: 22),
                child: SizedBox(
                  height: 28,
                  width: 28,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            else if (_errorMsg != null) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 22),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _errorMsg!,
                      style: AppTextTheme.semibold.copyWith(
                        color: ColorConstant.redColor2,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ] else if (_preview != null) ...[
              GestureDetector(
                onTap: () {
                  setState(() => _isSelected = !_isSelected);
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isSelected ? Colors.green : Colors.grey.shade300,
                      width: _isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Selection checkbox with green tick
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: _isSelected ? Colors.green : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _isSelected
                                ? Colors.green
                                : Colors.grey.shade400,
                            width: 2,
                          ),
                        ),
                        child: _isSelected
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 16,
                              )
                            : null,
                      ),
                      const SizedBox(width: 14),
                      // Stylist info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ClipOval(
                                  child: _preview!.profileImage != null &&
                                          _preview!.profileImage!.isNotEmpty
                                      ? CachedNetworkImage(
                                          imageUrl:
                                              "${APIConstants.image}${_preview!.profileImage}",
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                          placeholder: (_, __) =>
                                              _placeholder(),
                                          errorWidget: (_, __, ___) =>
                                              _placeholder(),
                                        )
                                      : _placeholder(),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _preview!.name ?? "",
                                    style: AppTextTheme.semibold.copyWith(
                                      fontSize: 16,
                                      color: ColorConstant.blackColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 22),
            ],

            // Add Stylist button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_preview == null || !_isSelected)
                    ? null
                    : () {
                        Get.back();
                        widget.onAdd(_sidController.text.trim().toUpperCase());
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstant.primaryColor2,
                  disabledBackgroundColor:
                      ColorConstant.primaryColor2.withValues(alpha: 0.4),
                  foregroundColor: Colors.white,
                  disabledForegroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.person_add,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Add Stylist",
                      style: AppTextTheme.bold
                          .copyWith(fontSize: 16, color: Colors.white),
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

  Widget _placeholder() => Container(
        width: 54,
        height: 54,
        color: ColorConstant.stylistAvailabilityAvatarPlaceholder,
      );
}

/*──────────────────────────────────────────────────────────────*/

class _ManageStylistCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  const _ManageStylistCard({
    required this.name,
    required this.imageUrl,
    required this.onEdit,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorConstant.whiteColor,
      elevation: 1,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: ColorConstant.whiteColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
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
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                const SizedBox(width: 8),
                Material(
                  color: ColorConstant.lightColor,
                  borderRadius: BorderRadius.circular(100),
                  child: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        onEdit();
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Text(
                          'Edit',
                          style: AppTextTheme.medium.copyWith(
                            color: ColorConstant.blackColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.zero,
                    icon: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: ColorConstant.borderColor),
                      ),
                      child: const Icon(
                        Icons.more_vert,
                        color: ColorConstant.blackColor,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
