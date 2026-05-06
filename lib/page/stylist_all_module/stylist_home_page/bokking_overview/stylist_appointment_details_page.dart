import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salon/constant/api_constant.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/stylist/stylist_controller.dart';
import 'package:salon/model/stylist/appoimrnt_details_model.dart' as detail;
import 'package:salon/project_specific/progressbar_view.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:salon/util/pick_image.dart';
import 'package:salon/util/screen_bottom_insets.dart';

/// Stylist-facing appointment details: ID, date/time, customer, service cards, Take Pictures.
class StylistAppointmentDetailsPage extends StatefulWidget {
  final String appointmentId;
  final VoidCallback callback;

  const StylistAppointmentDetailsPage({
    super.key,
    required this.appointmentId,
    required this.callback,
  });

  @override
  State<StylistAppointmentDetailsPage> createState() =>
      _StylistAppointmentDetailsPageState();
}

class _StylistAppointmentDetailsPageState
    extends State<StylistAppointmentDetailsPage> {
  final _stylistController = Get.find<StylistController>();

  static final _labelStyle = AppTextTheme.bold.copyWith(
    color: ColorConstant.blackColor,
    fontSize: 14,
  );

  static final _valuePurple = AppTextTheme.bold.copyWith(
    color: ColorConstant.primaryColor2,
    fontSize: 14,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _stylistController.doAppointmentsDetailsModel(
        appointmentId: widget.appointmentId,
      );
    });
  }

  String _displayId(detail.Data? data) {
    return data?.idx?.trim() ?? '';
  }

  String _formatDate(String? iso) {
    if (iso == null || iso.isEmpty) return '--';
    try {
      return DateFormat('dd/MM/yyyy').format(DateTime.parse(iso));
    } catch (_) {
      return '--';
    }
  }

  bool _shouldShowTakePicturesButton() {
    final data = _stylistController.getAppointmentsDetailsModel.data;
    return (data?.allowPortfolioUpload ?? false) &&
        !(data?.isPortfolioUploaded ?? false);
  }

  Future<void> _onTakePicturesPressed() async {
    try {
      Get.dialog(
        Center(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    final file = await FileUtils.openCameraForImage();
                    await _stylistController.doUploadImage(
                      appointmentId: widget.appointmentId,
                      multiplePath: [file.path],
                      multiplePathVideo: const [],
                      callback: widget.callback,
                    );
                    //get the appointment details again
                    _stylistController.doAppointmentsDetailsModel(
                      appointmentId: widget.appointmentId,
                    );
                  },
                  child: const Text("Photo (Camera)"),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    final file = await FileUtils.openCameraForVideo();
                    await _stylistController.doUploadImage(
                      appointmentId: widget.appointmentId,
                      multiplePath: const [],
                      multiplePathVideo: [file.path],
                      callback: widget.callback,
                    );
                    //get the appointment details again
                    _stylistController.doAppointmentsDetailsModel(
                      appointmentId: widget.appointmentId,
                    );
                  },
                  child: const Text("Video (Camera)"),
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: true,
      );
    } catch (_) {
      // Cancelled picker or no image selected.
    }
  }

  String _formatTime(String? iso) {
    if (iso == null || iso.isEmpty) return '--';
    try {
      return DateFormat('h:mm a').format(DateTime.parse(iso));
    } catch (_) {
      return '--';
    }
  }

  List<String> _productNames(detail.Data? data) {
    final items = data?.items;
    if (items == null) return [];
    return items
        .where(
            (e) => e.isService == false && (e.product?.name ?? '').isNotEmpty)
        .map((e) => e.product!.name!)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.whiteColor,
      appBar: AppBarWidget(
        nameOfScreen: 'Appointment Details',
        title: Obx(() {
          final details = _stylistController.getAppointmentsDetailsModel;
          if (_stylistController.showProgress) {
            return const SizedBox.shrink();
          }
          final data = details.data;
          return Text.rich(
            TextSpan(
              children: [
                TextSpan(text: 'ID : ', style: _labelStyle),
                TextSpan(
                  text: _displayId(data),
                  style: _valuePurple,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          );
        }),
        isBackIcon: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Obx(
              () {
                // Subscribe to appointment details + loading flag.
                final details = _stylistController.getAppointmentsDetailsModel;
                if (_stylistController.showProgress) {
                  return const ProgressBarView();
                }
                final data = details.data;
                final services =
                    data?.items?.where((e) => e.isService == true).toList() ??
                        [];
                final products = _productNames(data);
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Date :', style: _labelStyle),
                                const SizedBox(height: 4),
                                Text(
                                  _formatDate(data?.appointment?.startsAt),
                                  style: _valuePurple.copyWith(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Time :', style: _labelStyle),
                              const SizedBox(height: 4),
                              Text(
                                _formatTime(data?.appointment?.startsAt),
                                style: _valuePurple.copyWith(
                                  fontSize: 16,
                                  color: ColorConstant.bookingPriceMagenta2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      Text(
                        'Customer Details',
                        textAlign: TextAlign.center,
                        style: AppTextTheme.bold.copyWith(
                          color: ColorConstant.blackColor,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                          decorationColor: ColorConstant.blackColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: 'Name : ', style: _labelStyle),
                            TextSpan(
                              text: data?.user?.name?.trim().isNotEmpty == true
                                  ? data!.user!.name!
                                  : '--',
                              style: _valuePurple.copyWith(
                                fontSize: 16,
                                color: ColorConstant.bookingPriceMagenta2,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 28),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Services',
                          style: AppTextTheme.bold.copyWith(
                            color: ColorConstant.grayTextColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (services.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: Text(
                            'No services listed.',
                            style: AppTextTheme.regular.copyWith(
                              color: ColorConstant.grayTextColor,
                              fontSize: 14,
                            ),
                          ),
                        )
                      else
                        ...services.asMap().entries.map(
                              (e) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _ServiceLineCard(
                                  item: e.value,
                                  productLines:
                                      e.key == 0 ? products : const [],
                                ),
                              ),
                            ),
                      SizedBox(
                        height: ScreenBottomInsets
                            .scrollEndPaddingForStackedBottomAction(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Obx(() {
            if (_stylistController.showProgress ||
                !_stylistController.shouldShowTakePicturesButton) {
              return const SizedBox.shrink();
            }
            final enabled = _shouldShowTakePicturesButton();
            return ScreenBottomActionArea(
              child: Material(
                color: enabled
                    ? ColorConstant.primaryColor2
                    : ColorConstant.lightGreyColor,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: enabled ? _onTakePicturesPressed : null,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.camera_alt_rounded,
                          color: ColorConstant.whiteColor,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Take Pictures',
                          style: AppTextTheme.bold.copyWith(
                            color: ColorConstant.whiteColor,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _ServiceLineCard extends StatelessWidget {
  final detail.Items item;
  final List<String> productLines;

  const _ServiceLineCard({
    required this.item,
    required this.productLines,
  });

  @override
  Widget build(BuildContext context) {
    final svc = item.service;
    final categoryLabel = svc?.categories != null &&
            svc!.categories!.isNotEmpty &&
            (svc.categories!.first.name ?? '').isNotEmpty
        ? '(${svc.categories!.first.name})'
        : '';

    final imageUrl = (svc?.image ?? '').isEmpty
        ? null
        : '${APIConstants.image}${svc!.image}';

    final duration = svc?.duration;
    final durationLine =
        duration != null && duration > 0 ? '${duration}mins' : '';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorConstant.viewDetailsColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: Container(
              width: 56,
              height: 56,
              color: ColorConstant.whiteColor,
              child: imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => const Center(
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (_, __, ___) => Icon(
                        Icons.spa_outlined,
                        color:
                            ColorConstant.grayTextColor.withValues(alpha: 0.5),
                      ),
                    )
                  : Icon(
                      Icons.spa_outlined,
                      color: ColorConstant.grayTextColor.withValues(alpha: 0.5),
                      size: 28,
                    ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Service Name :',
                  style: AppTextTheme.regular.copyWith(
                    color: ColorConstant.grayTextColor,
                    fontSize: 13,
                  ),
                ),
                if (categoryLabel.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    categoryLabel,
                    style: AppTextTheme.medium.copyWith(
                      color: ColorConstant.primaryColor2,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  svc?.name ?? '--',
                  textAlign: TextAlign.start,
                  style: AppTextTheme.bold.copyWith(
                    color: ColorConstant.blackColor,
                    fontSize: 14,
                  ),
                ),
                if (productLines.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    productLines.join(', '),
                    textAlign: TextAlign.right,
                    style: AppTextTheme.semibold.copyWith(
                      color: ColorConstant.blackColor,
                      fontSize: 13,
                    ),
                  ),
                ],
                if (durationLine.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    durationLine,
                    textAlign: TextAlign.right,
                    style: AppTextTheme.semibold.copyWith(
                      color: ColorConstant.blackColor,
                      fontSize: 13,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
