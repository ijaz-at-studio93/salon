import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salon/api/home_api.dart';
import 'package:salon/constant/api_constant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/model/availability/artiest_availability_get_model.dart';
import 'package:salon/model/stylist/artiest_list_model.dart' as artist_list;
import 'package:salon/page/stylist/stylist_availability_detail_page.dart';
import 'package:salon/project_specific/progressbar_view.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';

enum _StylistTodayStatus { loading, off, available, partial }

class SetStylistAvailabilityPage extends StatefulWidget {
  const SetStylistAvailabilityPage({super.key});

  @override
  State<SetStylistAvailabilityPage> createState() =>
      _SetStylistAvailabilityPageState();
}

class _SetStylistAvailabilityPageState
    extends State<SetStylistAvailabilityPage> {
  final _homeController = Get.find<HomeController>();
  final Map<String, _StylistTodayStatus> _statusByArtistId = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _homeController.doSalonArtistList();
      final list = _homeController.getSalonArtistListModel.data ?? [];
      if (!mounted) return;
      await _loadTodayStatuses(list);
    });
  }

  DayData? _todayData(Availability? a) {
    switch (DateTime.now().weekday) {
      case DateTime.monday:
        return a?.monday;
      case DateTime.tuesday:
        return a?.tuesday;
      case DateTime.wednesday:
        return a?.wednesday;
      case DateTime.thursday:
        return a?.thursday;
      case DateTime.friday:
        return a?.friday;
      case DateTime.saturday:
        return a?.saturday;
      case DateTime.sunday:
        return a?.sunday;
      default:
        return null;
    }
  }

  _StylistTodayStatus _classifyDay(DayData? day) {
    if (day == null) return _StylistTodayStatus.off;
    final s = day.start?.trim() ?? '';
    final e = day.end?.trim() ?? '';
    if (s.isEmpty || e.isEmpty) return _StylistTodayStatus.off;
    final breaks = day.breaks;
    if (breaks != null && breaks.isNotEmpty) {
      return _StylistTodayStatus.partial;
    }
    return _StylistTodayStatus.available;
  }

  Future<void> _refreshSingleArtistStatus(String id) async {
    setState(() => _statusByArtistId[id] = _StylistTodayStatus.loading);
    try {
      final model = await HomeAPI.getArtiestAvailability(artistId: id);
      final status = _classifyDay(_todayData(model.data));
      if (!mounted) return;
      setState(() => _statusByArtistId[id] = status);
    } catch (_) {
      if (!mounted) return;
      setState(() => _statusByArtistId[id] = _StylistTodayStatus.off);
    }
  }

  Future<void> _loadTodayStatuses(List<artist_list.Data> artists) async {
    for (final a in artists) {
      final id = a.id;
      if (id == null || id.isEmpty) continue;
      setState(() => _statusByArtistId[id] = _StylistTodayStatus.loading);
    }

    await Future.wait(artists.map((a) async {
      final id = a.id;
      if (id == null || id.isEmpty) return;
      try {
        final model = await HomeAPI.getArtiestAvailability(artistId: id);
        final status = _classifyDay(_todayData(model.data));
        if (!mounted) return;
        setState(() => _statusByArtistId[id] = status);
      } catch (_) {
        if (!mounted) return;
        setState(() => _statusByArtistId[id] = _StylistTodayStatus.off);
      }
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.stylistAvailabilityScreenBg,
      appBar: const AppBarWidget(
        nameOfScreen: "Set Stylist Availability",
        isBackIcon: true,
      ),
      body: Obx(
        () => _homeController.showProgress
            ? const ProgressBarView()
            : _buildList(),
      ),
    );
  }

  Widget _buildList() {
    final artists = _homeController.getSalonArtistListModel.data ?? [];
    if (artists.isEmpty) {
      return Center(
        child: Text(
          "No stylists yet",
          style: AppTextTheme.regular.copyWith(
            color: ColorConstant.grayTextColor,
            fontSize: 15,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: artists.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final artist = artists[index];
        final id = artist.id ?? "";
        final status = _statusByArtistId[id] ?? _StylistTodayStatus.loading;
        return _StylistAvailabilityCard(
          name: artist.name ?? "",
          imageUrl:
              artist.profileImage != null && artist.profileImage!.isNotEmpty
                  ? "${APIConstants.image}${artist.profileImage}"
                  : "",
          status: status,
          onManage: () async {
            if (id.isEmpty) return;
            await Get.to(
              () => StylistAvailabilityDetailPage(
                artistId: id,
                stylistName: artist.name ?? "",
              ),
            );
            if (!mounted) return;
            await _refreshSingleArtistStatus(id);
          },
        );
      },
    );
  }
}

class _StylistAvailabilityCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final _StylistTodayStatus status;
  final VoidCallback onManage;

  const _StylistAvailabilityCard({
    required this.name,
    required this.imageUrl,
    required this.status,
    required this.onManage,
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
            _Avatar(url: imageUrl),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTextTheme.bold.copyWith(
                      color: ColorConstant.blackColor,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _StatusTag(status: status),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _ManageButton(onPressed: onManage),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String url;

  const _Avatar({required this.url});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: url.isEmpty
          ? Container(
              width: 56,
              height: 56,
              color: ColorConstant.stylistAvailabilityAvatarPlaceholder,
            )
          : CachedNetworkImage(
              imageUrl: url,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                width: 56,
                height: 56,
                color: ColorConstant.stylistAvailabilityAvatarPlaceholder,
              ),
              errorWidget: (_, __, ___) => Container(
                width: 56,
                height: 56,
                color: ColorConstant.stylistAvailabilityAvatarPlaceholder,
              ),
            ),
    );
  }
}

class _StatusTag extends StatelessWidget {
  final _StylistTodayStatus status;

  const _StatusTag({required this.status});

  @override
  Widget build(BuildContext context) {
    late Color bg;
    late String label;

    switch (status) {
      case _StylistTodayStatus.loading:
        bg = ColorConstant.grayTextColor.withValues(alpha: 0.85);
        label = "…";
        break;
      case _StylistTodayStatus.off:
        bg = ColorConstant.stylistStatusOff;
        label = "• off Today";
        break;
      case _StylistTodayStatus.available:
        bg = ColorConstant.stylistStatusAvailable;
        label = "• Available Today";
        break;
      case _StylistTodayStatus.partial:
        bg = ColorConstant.stylistStatusPartial;
        label = "• Partially Available Today";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: AppTextTheme.medium.copyWith(
          color: ColorConstant.whiteColor,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _ManageButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _ManageButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorConstant.primaryColor2.withValues(alpha: 0.4),
      borderRadius: BorderRadius.circular(100),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(100),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: ColorConstant.primaryColor2),
          ),
          child: Text(
            "Manage",
            style: AppTextTheme.semibold.copyWith(
              color: ColorConstant.primaryColor2,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
