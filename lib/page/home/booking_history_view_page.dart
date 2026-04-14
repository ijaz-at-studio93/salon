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
import 'package:salon/project_specific/progressbar_view.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:salon/util/appointment_accepted_dialog.dart';
import 'package:salon/util/appointment_rejected_dialog.dart';
import 'package:salon/util/booking_rejection_info_dialog.dart';
import 'package:salon/util/payment_instruction_dialog.dart';
import 'package:salon/util/reject_service_dialog.dart';
import '../../project_specific/project_appbar.dart';

class BookingHistoryViewpage extends StatefulWidget {
  final String appointmentId;
  final String status;

  /// From list row when opening details; used when the details API omits `appointment.artist` / `artists`.
  final String? listStylistName;
  final String? listStylistId;

  const BookingHistoryViewpage({
    super.key,
    required this.appointmentId,
    required this.status,
    this.listStylistName,
    this.listStylistId,
  });

  @override
  State<BookingHistoryViewpage> createState() => _BookingHistoryViewpageState();
}

class _BookingHistoryViewpageState extends State<BookingHistoryViewpage> {
  final _homeController = Get.find<HomeController>();

  static const Color _priceGreen = Color(0xFF15803D);

  List<User> _stylistOptions = [];
  List<AppointmentTimeSlot> _slotOptions = [];
  Set<String> _selectedStylistIds = {};
  int _maxStylistSelection = 0;
  int _selectedSlotIndex = 0;
  String? _selectionSyncKey;
  bool _salonArtistsMerged = false;
  bool _reasonDialogShown = false;
  bool _paymentInstructionDialogShown = false;

  /// Rejection / payment-info dialogs only after the initial open fetch, not after
  /// accept/reject refreshes (`doGetAppointmentDetailsModel` on the same visit).
  bool _allowOpenPageInfoDialogs = true;

  /// Tracks [HomeController.showProgress] so we react once when a fetch finishes,
  /// not on every [Obx] rebuild (see `doGetAppointmentDetailsModel` finally block).
  bool? _previousShowProgress;

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
      _previousShowProgress = null;
      _allowOpenPageInfoDialogs = true;
      _reasonDialogShown = false;
      _paymentInstructionDialogShown = false;
      _selectionSyncKey = null;
      _salonArtistsMerged = false;
      _stylistOptions = [];
      _slotOptions = [];
      _selectedStylistIds = {};
      _maxStylistSelection = 0;
      _selectedSlotIndex = 0;
    }
  }

  void _syncSelectionsIfNeeded(Data data) {
    final key =
        '${widget.appointmentId}_${data.bookingId ?? ''}_${data.orderStatus ?? ''}';
    if (_selectionSyncKey == key) return;

    final appt = data.appointment;
    if (appt == null) {
      _stylistOptions = [];
      _slotOptions = [];
      _selectedStylistIds = {};
      _maxStylistSelection = 0;
      _selectedSlotIndex = 0;
      _selectionSyncKey = key;
      setState(() {});
      return;
    }

    _slotOptions = _slotsFromAppointment(appt);
    _stylistOptions = _stylistsFromAppointmentWithListFallback(appt);

    final preferredIds = appt.stylistIds ?? [];
    _maxStylistSelection = preferredIds.length;
    _selectedStylistIds = preferredIds.toSet();

    _selectedSlotIndex = _defaultSlotIndex(appt);

    _selectionSyncKey = key;
    setState(() {});

    if (data.orderStatus == 'pending' &&
        !_salonArtistsMerged &&
        (appt.artists == null || appt.artists!.isEmpty)) {
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

  /// Same as [_stylistsFromAppointment], but uses list-row stylist when details omit artist data.
  List<User> _stylistsFromAppointmentWithListFallback(Appointment appt) {
    final base = _stylistsFromAppointment(appt);
    if (base.isNotEmpty) return base;
    final fallback = _listStylistAsUser();
    return fallback != null ? [fallback] : [];
  }

  User? _listStylistAsUser() {
    final name = widget.listStylistName?.trim() ?? '';
    if (name.isEmpty) return null;
    return User(id: widget.listStylistId, name: name);
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
          _stylistsFromAppointmentWithListFallback(appt),
          salonUsers,
        );
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
        final loading = _homeController.showProgress;
        final data = _homeController.getAppointmentDetailsModel.data;
        if (_previousShowProgress == true && !loading && data != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            final d = _homeController.getAppointmentDetailsModel.data;
            if (d == null) return;
            _syncSelectionsIfNeeded(d);
            if (_allowOpenPageInfoDialogs) {
              _maybeShowRejectionDialog(d);
              _maybeShowPaymentInstructionDialog(d);
              _allowOpenPageInfoDialogs = false;
            }
          });
        }
        _previousShowProgress = loading;
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
                      if (data?.cancellationReason != null &&
                          isCustomerCancelled)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Text(
                            'Cancelled!',
                            style: AppTextTheme.extraBold.copyWith(
                              color: ColorConstant.redColor2,
                              fontSize: 30,
                            ),
                          ),
                        )
                      else if (data?.cancellationReason != null &&
                          isSalonRejected)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Text(
                            'Rejected!',
                            style: AppTextTheme.extraBold.copyWith(
                              color: ColorConstant.redColor2,
                              fontSize: 30,
                            ),
                          ),
                        )
                      else ...[
                        const Divider(
                          color: ColorConstant.blackColor,
                          thickness: 2,
                          height: 1,
                        ),
                        _buildTotalRow(),
                        _buildBottomActions(),
                      ]
                    ],
                  ),
                ),
        );
      },
    );
  }

  bool get isCustomerCancelled =>
      _homeController.getAppointmentDetailsModel.data?.orderStatus ==
      'user_cancelled';

  bool get isSalonRejected =>
      _homeController.getAppointmentDetailsModel.data?.orderStatus ==
      'salon_rejected';

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
        Row(
          children: [
            Text(
              'Stylist Name :',
              style: AppTextTheme.bold.copyWith(
                color: ColorConstant.blackColor,
                fontSize: 14,
              ),
            ),
            if (_pendingSelectable)
              Text(
                ' (You can change staff)',
                style: AppTextTheme.semibold.copyWith(
                  color: ColorConstant.grayTextColor,
                  fontSize: 14,
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        if (_maxStylistSelection == 0)
          Text(
            'No stylist preference',
            style: AppTextTheme.medium.copyWith(
              color: ColorConstant.grayTextColor,
              fontSize: 14,
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(_stylistOptions.length, (i) {
              final u = _stylistOptions[i];
              final id = u.id ?? '';
              final label = u.name ?? '—';
              final isSelected = _selectedStylistIds.contains(id);
              return _selectionChip(
                label,
                selected: isSelected,
                onTap: _pendingSelectable
                    ? () {
                        setState(() {
                          if (isSelected) {
                            _selectedStylistIds.remove(id);
                          } else if (_selectedStylistIds.length <
                              _maxStylistSelection) {
                            _selectedStylistIds.add(id);
                          } else {
                            showSnackBar(
                              message:
                                  'Max $_maxStylistSelection stylist(s) allowed.',
                            );
                          }
                        });
                      }
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
        Row(
          children: [
            Text(
              'Time : ',
              style: AppTextTheme.bold.copyWith(
                color: ColorConstant.blackColor,
                fontSize: 14,
              ),
            ),
            if (_pendingSelectable)
              Text(
                ' (Select one slot)',
                style: AppTextTheme.semibold.copyWith(
                  color: ColorConstant.grayTextColor,
                  fontSize: 14,
                ),
              ),
          ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
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
        const SizedBox(height: 8),
        RichText(
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
        boxShadow: ColorConstant.appointmentCardElevation,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: SizedBox(
                        width: context.width * .3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Service Name : ',
                              style: AppTextTheme.medium.copyWith(
                                color: ColorConstant.blackColor
                                    .withValues(alpha: 0.6),
                                fontSize: 14,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "(${service?.getGender() ?? ''})",
                                  style: AppTextTheme.medium.copyWith(
                                    color: ColorConstant.primaryColor2,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: SizedBox(
                        width: context.width * .3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Service Category : ',
                              style: AppTextTheme.medium.copyWith(
                                color: ColorConstant.blackColor
                                    .withValues(alpha: 0.6),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        service?.categories?.map((e) => e.name).join(', ') ??
                            '',
                        style: AppTextTheme.semibold.copyWith(
                          color: ColorConstant.blackColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: SizedBox(
                        width: context.width * .3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Service Price : ',
                              style: AppTextTheme.medium.copyWith(
                                color: ColorConstant.blackColor
                                    .withValues(alpha: 0.6),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${service?.price ?? 0}',
                        style: AppTextTheme.semibold.copyWith(
                          color: ColorConstant.lightGreenColor,
                          fontSize: 14,
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
    );
  }

  Widget _productCard(Items item) {
    final product = item.product;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColorConstant.reviewCardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: ColorConstant.appointmentCardElevation,
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
                style: AppTextTheme.extraBold.copyWith(
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
    // if (data?.orderAmount != null) {
    //   return data!.orderAmount!;
    // }
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

  static const _cancelledStatuses = {
    'salon_rejected',
    'user_cancelled',
    'cancelled',
  };

  void _maybeShowRejectionDialog(Data data) {
    if (_reasonDialogShown) return;
    // Guard against stale data from a previously viewed appointment
    if (data.appointmentId != widget.appointmentId) return;
    final status = data.orderStatus ?? '';
    if (!_cancelledStatuses.contains(status)) return;

    final reason = data.cancellationReason;
    final label = reason?.label ?? '';
    if (label.isEmpty) return;

    _reasonDialogShown = true;
    showDialog(
      context: context,
      builder: (_) => BookingRejectionInfoDialog(
        reasonLabel: label,
        note: data.cancellationNote ?? '',
        isSalonRejected: isSalonRejected,
      ),
    );
  }

  void _maybeShowPaymentInstructionDialog(Data data) {
    if (_paymentInstructionDialogShown) return;
    if (data.appointmentId != widget.appointmentId) return;
    if (data.orderStatus != 'confirmed') return;

    _paymentInstructionDialogShown = true;
    showDialog(
      context: context,
      builder: (_) => const PaymentInstructionDialog(),
    );
  }

  Widget _buildBottomActions() {
    final orderStatus =
        _homeController.getAppointmentDetailsModel.data?.orderStatus;
    final hideForTerminal = orderStatus == 'completed' || isCustomerCancelled;

    if (hideForTerminal) {
      return const SizedBox.shrink();
    }

    if (orderStatus == 'pending') {
      return Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 20,
        ),
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
                        tapYes: (reasonId, note) {
                          Navigator.of(dialogContext).pop();
                          _homeController.doBookingApprove(
                            appointmentId: widget.appointmentId,
                            status: 'salon_rejected',
                            rejectionReasonId:
                                reasonId.isNotEmpty ? reasonId : null,
                            rejectionRemark: note,
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
                    if (_maxStylistSelection > 0 &&
                        _selectedStylistIds.length < _maxStylistSelection) {
                      showSnackBar(
                        message:
                            'Please select $_maxStylistSelection stylist(s).',
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
                      stylistIds: _maxStylistSelection > 0
                          ? _selectedStylistIds.toList()
                          : null,
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

    // if (orderStatus == 'confirmed') {
    //   return Padding(
    //     padding: const EdgeInsets.symmetric(horizontal: 20),
    //     child: SizedBox(
    //       width: double.infinity,
    //       height: 48,
    //       child: ElevatedButton(
    //         style: ElevatedButton.styleFrom(
    //           backgroundColor: ColorConstant.primaryColor,
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(12),
    //           ),
    //         ),
    //         onPressed: () async {
    //           _homeController.doScanQrcode(
    //             appointmentId: widget.appointmentId,
    //             callback: () {
    //               final allow = _homeController.getAllowPortfolioUploadModel
    //                       .data?.allowPortfolioUpload ==
    //                   true;
    //               WidgetsBinding.instance.addPostFrameCallback((_) {
    //                 if (allow) {
    //                   Get.dialog(
    //                     PortfolioPermissionDialog(
    //                       yes: () {
    //                         Get.back();
    //                         Get.to(() => UploadImagePage(
    //                             appointmentId: widget.appointmentId));
    //                       },
    //                       cancel: () {
    //                         Get.back();
    //                         Get.back();
    //                       },
    //                     ),
    //                     barrierDismissible: false,
    //                   );
    //                 } else {
    //                   Get.back();
    //                 }
    //               });
    //               _homeController.doUpcomingData();
    //               showSnackBar(
    //                 message: 'Booking completed successfully!',
    //               );
    //             },
    //           );
    //         },
    //         child: Text(
    //           'Mark As Done',
    //           style: AppTextTheme.bold.copyWith(
    //             fontSize: 16,
    //             color: Colors.white,
    //           ),
    //         ),
    //       ),
    //     ),
    //   );
    // }

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
