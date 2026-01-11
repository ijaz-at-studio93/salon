import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:salon/constant/color_constant.dart';

import '../../controller/home_controller.dart';

class BlockSlotPage extends StatefulWidget {
  final String artistId;
  final VoidCallback? onBlocked;
  const BlockSlotPage({super.key, required this.artistId, this.onBlocked});

  @override
  State<BlockSlotPage> createState() => _BlockSlotPageState();
}

class _BlockSlotPageState extends State<BlockSlotPage> {
  final _homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _homeController.doGetArtiestAvailability(artistId: widget.artistId);
    });
  }
  DateTime? _start;
  DateTime? _end;
  bool _loading = false;

  String _format(DateTime? dt) {
    if (dt == null) return "__/__/____ - __:__";
    return DateFormat('dd/MM/yyyy - h:mm a').format(dt);
  }

  Future<DateTime?> _pickDateTime({required DateTime? initial}) async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1);
    final lastDate = DateTime(now.year + 5);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initial ?? now,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate == null) return null;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: initial != null
          ? TimeOfDay(hour: initial.hour, minute: initial.minute)
          : TimeOfDay(hour: now.hour, minute: now.minute),
    );

    if (pickedTime == null) return null;

    return DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
  }

  Future<void> _selectStart() async {
    final picked = await _pickDateTime(initial: _start);
    if (picked != null) {
      setState(() => _start = picked);
      // If end exists and is before start, clear end
      if (_end != null && _end!.isBefore(_start!)) {
        setState(() => _end = null);
      }
    }
  }

  Future<void> _selectEnd() async {
    final picked = await _pickDateTime(initial: _end ?? _start);
    if (picked != null) {
      setState(() => _end = picked);
    }
  }

  Future<void> _blockSlot() async {
    if (_start == null) {
      Get.snackbar('Invalid', 'Please select start time',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (_end == null) {
      Get.snackbar('Invalid', 'Please select end time',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (!_end!.isAfter(_start!)) {
      Get.snackbar('Invalid', 'End time must be after start time',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    setState(() => _loading = true);
    try {
      // TODO: replace this placeholder with your real API call.
      // Example:
      await _homeController.doBlockArtiestAvailability(artistId: widget.artistId, start: _start, end: _end);
      await Future.delayed(const Duration(milliseconds: 900));

      // on success:
      widget.onBlocked?.call();
      Get.back(result: true); // return true to caller
    } catch (e) {
      Get.snackbar('Error', 'Failed to block slot. Try again.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        nameOfScreen: "Block Slot",
        isBackIcon: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Choose time slots below to block staff',
                  style: AppTextTheme.bold.copyWith(
                    fontSize: 16,
                    color: ColorConstant.blueGrayColor, // << set color
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),

                // START PICKER LABEL
                Text(
                  'Select Start Time',
                  style: AppTextTheme.bold.copyWith(
                    fontSize: 16,
                    color: ColorConstant.blueGrayColor, // << set color
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstant.whiteColor,
                    side: BorderSide(color: ColorConstant.borderColor),
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  onPressed: _selectStart,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_format(_start),
                          style: AppTextTheme.regular.copyWith(
                              fontSize: 15, color: ColorConstant.blackColor)),
                      Icon(Icons.arrow_drop_down, color: ColorConstant.blackColor),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // END PICKER LABEL (explicit color)
                Text(
                  'Select End Time',
                  style: AppTextTheme.bold.copyWith(
                    fontSize: 16,
                    color: ColorConstant.blueGrayColor, // << set color
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstant.whiteColor,
                    side: BorderSide(color: ColorConstant.borderColor),
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  onPressed: _selectEnd,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_format(_end),
                          style: AppTextTheme.regular.copyWith(
                              fontSize: 15, color: ColorConstant.blackColor)),
                      Icon(Icons.arrow_drop_down, color: ColorConstant.blackColor),
                    ],
                  ),
                ),

                const Spacer(),

                // Bottom note / validation hint
                Text(
                  'Blocking slot of staff',
                  style: AppTextTheme.medium.copyWith(fontSize: 12, color: ColorConstant.grayColor),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),

          // Bottom fixed Block Slot button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _blockSlot,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstant.primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: _loading
                        ? const SizedBox(
                        height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : Text('Block Slot', style: AppTextTheme.bold.copyWith(fontSize: 16, color: Colors.white)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
