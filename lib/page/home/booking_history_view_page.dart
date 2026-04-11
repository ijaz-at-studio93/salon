import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salon/api/dio_client.dart' show showSnackBar;
import 'package:salon/api/home_api.dart';
import 'package:salon/constant/api_constant.dart';
import 'package:salon/constant/assetsconstant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/model/service_model/appointment_details_model.dart';
import 'package:salon/page/home/upload_image.dart';
import 'package:salon/project_specific/progressbar_view.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:salon/util/appointment_accepted_dialog.dart';
import 'package:salon/util/appointment_rejected_dialog.dart';
import 'package:salon/util/reject_service_dialog.dart';

import '../../project_specific/project_appbar.dart';
import '../stylist_all_module/stylist_home_page/bokking_overview/widget/portfolio_permission_dialog.dart';

class BookingHistoryViewpage extends StatefulWidget {
  final String appointmentId;
  final String status;

  const BookingHistoryViewpage({
    super.key,
    required this.appointmentId,
    required this.status,
  });

  @override
  State<BookingHistoryViewpage> createState() => _BookingHistoryViewpageState();
}

class _BookingHistoryViewpageState extends State<BookingHistoryViewpage> {
  final _homeController = Get.find<HomeController>();

  static const Color _priceGreen = Color(0xFF15803D);

  List<User> _stylistOptions = [];
  List<AppointmentTimeSlot> _slotOptions = [];
  int _selectedStylistIndex = 0;
  int _selectedSlotIndex = 0;
  String? _selectionSyncKey;
  bool _salonArtistsMerged = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _homeController.doGetAppointmentDetailsModel(
        appointmentId: widget.appointmentId,
      );
      if (widget.status == 'pending') {
        _homeController.doGetRejectionReasons();
      }
    });
  }

  @override
  void didUpdateWidget(BookingHistoryViewpage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.appointmentId != widget.appointmentId) {
      _selectionSyncKey = null;
      _salonArtistsMerged = false;
      _stylistOptions = [];
      _slotOptions = [];
      _selectedStylistIndex = 0;
      _selectedSlotIndex = 0;
    }
  }

  void _syncSelectionsIfNeeded(Data data) {
    final key =
        '${widget.appointmentId}_${data.bookingId ?? ''}_${data.orderStatus ?? ''}';
    if (_selectionSyncKey == key) return;

    final appt = data.appointment;
    if (appt == null) return;

    _slotOptions = _slotsFromAppointment(appt);
    _stylistOptions = _stylistsFromAppointment(appt);

    _selectedStylistIndex = _defaultStylistIndex(appt.artist?.id);
    _selectedSlotIndex = _defaultSlotIndex(appt);

    _selectionSyncKey = key;
    setState(() {});

    if (data.orderStatus == 'pending' && !_salonArtistsMerged) {
      _mergeSalonArtistsIfNeeded(data);
    }
  }

  List<User> _stylistsFromAppointment(Appointment appt) {
    if (appt.artists != null && appt.artists!.isNotEmpty) {
      return List<User>.from(appt.artists!);
    }
    if (appt.artist != null) {
      return [appt.artist!];
    }
    return [];
  }

  List<AppointmentTimeSlot> _slotsFromAppointment(Appointment appt) {
    if (appt.timeSlots != null && appt.timeSlots!.isNotEmpty) {
      return List<AppointmentTimeSlot>.from(appt.timeSlots!);
    }
    if ((appt.startsAt ?? '').isNotEmpty) {
      return [
        AppointmentTimeSlot(startsAt: appt.startsAt, endsAt: appt.endsAt),
      ];
    }
    return [];
  }

  int _defaultStylistIndex(String? preferredArtistId) {
    if (_stylistOptions.isEmpty) return 0;
    if (preferredArtistId != null) {
      final i = _stylistOptions.indexWhere((u) => u.id == preferredArtistId);
      if (i >= 0) return i;
    }
    return 0;
  }

  int _defaultSlotIndex(Appointment appt) {
    if (_slotOptions.isEmpty) return 0;
    final idx = _slotOptions.indexWhere((s) => s.startsAt == appt.startsAt);
    if (idx >= 0) return idx;
    return 0;
  }

  Future<void> _mergeSalonArtistsIfNeeded(Data data) async {
    if (data.orderStatus != 'pending' || _salonArtistsMerged) return;
    final appt = data.appointment;
    if (appt == null) return;
    if (appt.artists != null && appt.artists!.length > 1) {
      _salonArtistsMerged = true;
      return;
    }

    try {
      final model = await HomeAPI.getSalonArtiestListData();
      final salonUsers = (model.data ?? [])
          .map(
            (e) => User(
              id: e.id,
              name: e.name,
              profileImage: e.profileImage,
            ),
          )
          .toList();
      if (!mounted) return;
      setState(() {
        _salonArtistsMerged = true;
        _stylistOptions = _mergeStylistLists(
          _stylistsFromAppointment(appt),
          salonUsers,
        );
        _selectedStylistIndex = _defaultStylistIndex(appt.artist?.id);
      });
    } catch (_) {
      if (mounted) {
        setState(() => _salonArtistsMerged = true);
      }
    }
  }

  List<User> _mergeStylistLists(List<User> base, List<User> extra) {
    final seen = <String>{};
    final out = <User>[];
    for (final u in base) {
      final id = u.id ?? '';
      if (id.isEmpty || seen.contains(id)) continue;
      seen.add(id);
      out.add(u);
    }
    for (final u in extra) {
      final id = u.id ?? '';
      if (id.isEmpty || seen.contains(id)) continue;
      seen.add(id);
      out.add(u);
    }
    return out;
  }

  bool get _pendingSelectable =>
      _homeController.getAppointmentDetailsModel.data?.orderStatus == 'pending';

  String _timeSlotLabel(AppointmentTimeSlot s) {
    final a = s.startsAt ?? '';
    if (a.isEmpty) return '—';
    final ta = convertDate(date: a);
    return ta;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final data = _homeController.getAppointmentDetailsModel.data;
        if (!_homeController.showProgress && data != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            _syncSelectionsIfNeeded(data);
          });
        }
        return Scaffold(
          backgroundColor: ColorConstant.whiteColor,
          appBar: AppBarWidget(
            nameOfScreen: 'Booking',
            title: _buildIdHeader(),
            isBackIcon: true,
          ),
          body: _homeController.showProgress
              ? const ProgressBarView()
              : SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: CustomScrollView(
                          slivers: [
                            SliverToBoxAdapter(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 16, 20, 0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    // _buildIdHeader(),
                                    // const SizedBox(height: 20),
                                    _buildDateRow(),
                                    const SizedBox(height: 8),
                                    _buildStylistSection(),
                                    const SizedBox(height: 8),
                                    _buildTimeSection(),
                                    const SizedBox(height: 16),
                                    _buildCustomerHeading(),
                                    const SizedBox(height: 16),
                                    _buildCustomerRow(),
                                    const SizedBox(height: 20),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Services',
                                        style: AppTextTheme.bold.copyWith(
                                          color: ColorConstant.grayTextColor,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                  ],
                                ),
                              ),
                            ),
                            SliverPadding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, i) {
                                    final data = _homeController
                                        .getAppointmentDetailsModel.data;
                                    final item = data?.items?[i];
                                    if (item == null) {
                                      return const SizedBox.shrink();
                                    }
                                    final isService = item.isService ?? false;
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 12),
                                      child: isService
                                          ? _serviceCard(item)
                                          : _productCard(item),
                                    );
                                  },
                                  childCount: _homeController
                                          .getAppointmentDetailsModel
                                          .data
                                          ?.items
                                          ?.length ??
                                      0,
                                ),
                              ),
                            ),
                            const SliverToBoxAdapter(
                              child: SizedBox(height: 16),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: ColorConstant.blackColor,
                        thickness: 2,
                        height: 1,
                      ),
                      _buildTotalRow(),
                      _buildBottomActions(),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildIdHeader() {
    final idx = _homeController.getAppointmentDetailsModel.data?.idx ?? '';
    return RichText(
      textAlign: TextAlign.right,
      text: TextSpan(
        children: [
          TextSpan(
            text: 'ID : ',
            style: AppTextTheme.medium.copyWith(
              color: ColorConstant.blackColor,
              fontSize: 18,
            ),
          ),
          TextSpan(
            text: idx,
            style: AppTextTheme.semibold.copyWith(
              color: ColorConstant.primaryColor2,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRow() {
    final appt = _homeController.getAppointmentDetailsModel.data?.appointment;
    final slot = (_slotOptions.isNotEmpty &&
            _selectedSlotIndex >= 0 &&
            _selectedSlotIndex < _slotOptions.length)
        ? _slotOptions[_selectedSlotIndex]
        : null;
    final startsAt = slot?.startsAt ?? appt?.startsAt ?? '';
    final dateStr = convertBooingDateFormat(dateTime: startsAt);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: AppTextTheme.semibold.copyWith(
              color: ColorConstant.blackColor,
              fontSize: 14,
            ),
            children: [
              const TextSpan(text: 'Date : \n'),
              TextSpan(
                text: dateStr.isEmpty ? '—' : dateStr,
                style: AppTextTheme.bold.copyWith(
                  color: ColorConstant.primaryColor2,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStylistSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Stylist Name :',
          style: AppTextTheme.bold.copyWith(
            color: ColorConstant.blackColor,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _stylistOptions.isEmpty
              ? [
                  Text(
                    '—',
                    style: AppTextTheme.medium.copyWith(
                      color: ColorConstant.grayTextColor,
                      fontSize: 14,
                    ),
                  ),
                ]
              : List.generate(_stylistOptions.length, (i) {
                  final u = _stylistOptions[i];
                  final label = u.name ?? '—';
                  return _selectionChip(
                    label,
                    selected: i == _selectedStylistIndex,
                    onTap: _pendingSelectable
                        ? () => setState(() => _selectedStylistIndex = i)
                        : null,
                  );
                }),
        ),
      ],
    );
  }

  Widget _buildTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Time:',
          style: AppTextTheme.bold.copyWith(
            color: ColorConstant.blackColor,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _slotOptions.isEmpty
              ? [
                  Text(
                    '—',
                    style: AppTextTheme.medium.copyWith(
                      color: ColorConstant.grayTextColor,
                      fontSize: 14,
                    ),
                  ),
                ]
              : List.generate(_slotOptions.length, (i) {
                  final slot = _slotOptions[i];
                  return _selectionChip(
                    _timeSlotLabel(slot),
                    selected: i == _selectedSlotIndex,
                    onTap: _pendingSelectable
                        ? () => setState(() => _selectedSlotIndex = i)
                        : null,
                  );
                }),
        ),
      ],
    );
  }

  Widget _buildCustomerHeading() {
    return Center(
      child: Text(
        'Customer Details',
        style: AppTextTheme.bold.copyWith(
          color: ColorConstant.blackColor,
          fontSize: 18,
          decoration: TextDecoration.underline,
          decorationColor: ColorConstant.blackColor,
        ),
      ),
    );
  }

  Widget _buildCustomerRow() {
    final name =
        _homeController.getAppointmentDetailsModel.data?.user?.name ?? '';
    final phone =
        _homeController.getAppointmentDetailsModel.data?.user?.mobile ?? '';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              style: AppTextTheme.semibold.copyWith(
                color: ColorConstant.blackColor,
                fontSize: 16,
              ),
              children: [
                const TextSpan(text: 'Name : '),
                TextSpan(
                  text: name.isEmpty ? '—' : name,
                  style: AppTextTheme.bold.copyWith(
                    color: ColorConstant.bookingPriceMagenta2,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            textAlign: TextAlign.right,
            text: TextSpan(
              style: AppTextTheme.semibold.copyWith(
                color: ColorConstant.blackColor,
                fontSize: 16,
              ),
              children: [
                const TextSpan(text: 'Phone Number : '),
                TextSpan(
                  text: phone.isEmpty ? '—' : phone,
                  style: AppTextTheme.bold.copyWith(
                    color: ColorConstant.bookingPriceMagenta2,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _serviceCard(Items item) {
    final service = item.service;
    final duration = service?.duration;
    final nameLine = [
      service?.name ?? '',
      if (duration != null && duration > 0) '${duration}mins',
    ].where((e) => e.isNotEmpty).join(' ');

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColorConstant.lightGreyColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: CachedNetworkImage(
              width: 52,
              height: 52,
              fit: BoxFit.cover,
              imageUrl: '${APIConstants.image}${service?.image ?? ''}',
              placeholder: (context, url) => const Image(
                image: AssetImage(AssetsConstant.placeHolder),
                width: 52,
                height: 52,
                fit: BoxFit.cover,
              ),
              errorWidget: (context, url, error) => const Image(
                image: AssetImage(AssetsConstant.placeHolder),
                width: 52,
                height: 52,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Service Name : ',
                      style: AppTextTheme.medium.copyWith(
                        color: ColorConstant.blackColor.withValues(alpha: 0.6),
                        fontSize: 14,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        nameLine.isEmpty ? '—' : nameLine,
                        style: AppTextTheme.semibold.copyWith(
                          color: ColorConstant.blackColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Service Price : ',
                        style: AppTextTheme.medium.copyWith(
                          color:
                              ColorConstant.blackColor.withValues(alpha: 0.6),
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(
                        text: '${service?.price ?? 0}',
                        style: AppTextTheme.semibold.copyWith(
                          color: ColorConstant.lightGreenColor,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _productCard(Items item) {
    final product = item.product;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColorConstant.reviewCardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: CachedNetworkImage(
              width: 52,
              height: 52,
              fit: BoxFit.cover,
              imageUrl: '${APIConstants.image}${product?.image ?? ''}',
              placeholder: (context, url) => const Image(
                image: AssetImage(AssetsConstant.placeHolder),
                width: 52,
                height: 52,
                fit: BoxFit.cover,
              ),
              errorWidget: (context, url, error) => const Image(
                image: AssetImage(AssetsConstant.placeHolder),
                width: 52,
                height: 52,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    style: AppTextTheme.medium.copyWith(
                      color: ColorConstant.grayTextColor,
                      fontSize: 13,
                    ),
                    children: [
                      const TextSpan(text: 'Product Name : '),
                      TextSpan(
                        text: product?.name ?? '—',
                        style: AppTextTheme.bold.copyWith(
                          color: ColorConstant.blackColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    style: AppTextTheme.medium.copyWith(
                      color: ColorConstant.grayTextColor,
                      fontSize: 13,
                    ),
                    children: [
                      const TextSpan(text: 'Price : '),
                      TextSpan(
                        text: '${product?.price ?? 0}',
                        style: AppTextTheme.bold.copyWith(
                          color: _priceGreen,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow() {
    final data = _homeController.getAppointmentDetailsModel.data;
    final total = _computeTotal(data);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: AppTextTheme.bold.copyWith(
              color: ColorConstant.blackColor,
              fontSize: 15,
            ),
            children: [
              const TextSpan(text: 'Total Price = '),
              TextSpan(
                text:
                    'Rs. ${total.toStringAsFixed(total == total.roundToDouble() ? 0 : 2)}',
                style: AppTextTheme.bold.copyWith(
                  color: ColorConstant.lightGreenColor,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _computeTotal(Data? data) {
    if (data?.orderAmount != null) {
      return data!.orderAmount!;
    }
    return data?.items?.fold<double>(0.0, (sum, item) {
          final p = item.isService == true
              ? (item.service?.price ?? 0).toDouble()
              : (item.product?.price ?? 0).toDouble();
          return sum + p;
        }) ??
        0;
  }

  Widget _selectionChip(
    String label, {
    required bool selected,
    VoidCallback? onTap,
  }) {
    final child = Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color:
            selected ? ColorConstant.primaryColor2 : ColorConstant.whiteColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: ColorConstant.primaryColor2,
          width: 0.5,
        ),
      ),
      child: Text(
        label,
        style: AppTextTheme.medium.copyWith(
          color:
              selected ? ColorConstant.whiteColor : ColorConstant.primaryColor2,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
    if (onTap == null) {
      return child;
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: child,
      ),
    );
  }

  Widget _buildBottomActions() {
    final orderStatus =
        _homeController.getAppointmentDetailsModel.data?.orderStatus;
    final hideForTerminal =
        orderStatus == 'completed' || orderStatus == 'user_cancelled';

    if (hideForTerminal) {
      return const SizedBox.shrink();
    }

    if (orderStatus == 'pending') {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstant.redColor2,
                    foregroundColor: ColorConstant.whiteColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (dialogContext) => RejectServiceDiaLog(
                        reasons: _homeController.getRejectionReasonsList,
                        tapNo: () => Navigator.of(dialogContext).pop(),
                        tapYes: (reasonId) {
                          Navigator.of(dialogContext).pop();
                          _homeController.doBookingApprove(
                            appointmentId: widget.appointmentId,
                            status: 'salon_artist_rejected',
                            rejectionReasonId: reasonId.isNotEmpty ? reasonId : null,
                            callback: () {
                              _homeController.doGetAppointmentDetailsModel(
                                appointmentId: widget.appointmentId,
                              );
                              _homeController.doUpcomingData();
                              showDialog(
                                context: context,
                                builder: (_) =>
                                    const AppointmentRejectedDialog(),
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                  child: Text(
                    'Reject',
                    style: AppTextTheme.bold.copyWith(
                      fontSize: 16,
                      color: ColorConstant.whiteColor,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstant.primaryColor2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (_stylistOptions.isEmpty ||
                        _selectedStylistIndex < 0 ||
                        _selectedStylistIndex >= _stylistOptions.length) {
                      showSnackBar(message: 'Please select a stylist.');
                      return;
                    }
                    final artistId = _stylistOptions[_selectedStylistIndex].id;
                    if ((artistId ?? '').isEmpty) {
                      showSnackBar(
                        message: 'Selected stylist is missing an id.',
                      );
                      return;
                    }
                    if (_slotOptions.isEmpty ||
                        _selectedSlotIndex < 0 ||
                        _selectedSlotIndex >= _slotOptions.length) {
                      showSnackBar(message: 'Please select a time slot.');
                      return;
                    }
                    final slot = _slotOptions[_selectedSlotIndex];
                    _homeController.doBookingApprove(
                      appointmentId: widget.appointmentId,
                      status: 'confirmed',
                      stylistIds: [artistId!],
                      startsAt: slot.startsAt,
                      endsAt: slot.endsAt,
                      callback: () {
                        _homeController.doGetAppointmentDetailsModel(
                          appointmentId: widget.appointmentId,
                        );
                        _homeController.doUpcomingData();
                        showDialog(
                          context: context,
                          builder: (_) => const AppointmentAcceptedDialog(),
                        );
                      },
                    );
                  },
                  child: Text(
                    'Accept',
                    style: AppTextTheme.bold.copyWith(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (orderStatus == 'confirmed') {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorConstant.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              _homeController.doScanQrcode(
                appointmentId: widget.appointmentId,
                callback: () {
                  final allow = _homeController.getAllowPortfolioUploadModel
                          .data?.allowPortfolioUpload ==
                      true;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (allow) {
                      Get.dialog(
                        PortfolioPermissionDialog(
                          yes: () {
                            Get.back();
                            Get.to(() => UploadImagePage(
                                appointmentId: widget.appointmentId));
                          },
                          cancel: () {
                            Get.back();
                            Get.back();
                          },
                        ),
                        barrierDismissible: false,
                      );
                    } else {
                      Get.back();
                    }
                  });
                  _homeController.doUpcomingData();
                  showSnackBar(
                    message: 'Booking completed successfully!',
                  );
                },
              );
            },
            child: Text(
              'Mark As Done',
              style: AppTextTheme.bold.copyWith(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  /*---------------- Convert Date Time ------------*/
  String convertDate({required String date}) {
    if (date == '') return '';
    final dateTime = DateTime.parse(date);
    return DateFormat('h:mm a').format(dateTime);
  }

  /*------------------------ Convert Booking Date ---------------*/
  String convertBooingDateFormat({required String dateTime}) {
    if (dateTime == '') return '';
    final date = DateTime.parse(dateTime);
    return DateFormat('dd/MM/yyyy').format(date);
  }
}
