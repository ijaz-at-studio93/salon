import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/home_controller.dart';
import 'package:salon/model/availability/salon_avibility_model.dart';
import 'package:salon/model/availability/salon_working_plain_model.dart';
import 'package:salon/project_specific/progressbar_view.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';

class SalonAvailabilityPage extends StatefulWidget {
  const SalonAvailabilityPage({super.key});

  @override
  State<SalonAvailabilityPage> createState() => _SalonAvailabilityPageState();
}

class _SalonAvailabilityPageState extends State<SalonAvailabilityPage> {
  final _homeController = Get.find<HomeController>();

  static const List<String> _days = [
    'sunday',
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
  ];

  /// Retrieve [SalonDay] for a given day key from the controller.
  SalonDay? _dayData(String day) {
    final data = _homeController.getSalonAvailability.data;
    switch (day) {
      case 'sunday':
        return data?.sunday;
      case 'monday':
        return data?.monday;
      case 'tuesday':
        return data?.tuesday;
      case 'wednesday':
        return data?.wednesday;
      case 'thursday':
        return data?.thursday;
      case 'friday':
        return data?.friday;
      case 'saturday':
        return data?.saturday;
    }
    return null;
  }

  /// Write updated [SalonDay] back into the controller for a given day key.
  void _setDayData(String day, SalonDay? salonDay) {
    final data = _homeController.getSalonAvailability.data;
    if (data == null) return;
    switch (day) {
      case 'sunday':
        data.sunday = salonDay;
        break;
      case 'monday':
        data.monday = salonDay;
        break;
      case 'tuesday':
        data.tuesday = salonDay;
        break;
      case 'wednesday':
        data.wednesday = salonDay;
        break;
      case 'thursday':
        data.thursday = salonDay;
        break;
      case 'friday':
        data.friday = salonDay;
        break;
      case 'saturday':
        data.saturday = salonDay;
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _homeController.doGetSalonAvailability();
    });
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  String _to24h(TimeOfDay t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String _to12h(String? time24) {
    if (time24 == null || time24.isEmpty) return '--:-- --';
    try {
      final dt = DateFormat('HH:mm').parse(time24);
      return DateFormat('h:mm a').format(dt);
    } catch (_) {
      return time24;
    }
  }

  Future<void> _pickTime(String day, bool isStart, SalonDay current) async {
    final parts = (isStart ? current.start : current.end)?.split(':');
    final initial = (parts != null && parts.length == 2)
        ? TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]))
        : TimeOfDay.now();

    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
        child: child!,
      ),
    );

    if (picked == null) return;

    setState(() {
      final updated = SalonDay(
        start: isStart ? _to24h(picked) : current.start,
        end: isStart ? current.end : _to24h(picked),
        breaks: current.breaks,
        isSwitchOn: current.isSwitchOn,
      );
      _setDayData(day, updated);
    });
  }

  void _onToggle(String day, bool value) {
    setState(() {
      if (value) {
        // Enable with default hours
        _setDayData(
          day,
          SalonDay(
            start: '10:00',
            end: '21:00',
            breaks: _dayData(day)?.breaks ?? [],
            isSwitchOn: true,
          ),
        );
      } else {
        final existing = _dayData(day);
        _setDayData(
          day,
          SalonDay(
            start: existing?.start,
            end: existing?.end,
            breaks: existing?.breaks,
            isSwitchOn: false,
          ),
        );
      }
    });
  }

  void _onUpdate() {
    final data = _homeController.getSalonAvailability.data;
    if (data == null) return;

    SalonDay? filtered(SalonDay? d) =>
        (d == null || d.isSwitchOn == false) ? null : d;

    final plan = SalonWorkingPlanModel(
      workingPlan: SalonAvailabilityData(
        sunday: filtered(data.sunday),
        monday: filtered(data.monday),
        tuesday: filtered(data.tuesday),
        wednesday: filtered(data.wednesday),
        thursday: filtered(data.thursday),
        friday: filtered(data.friday),
        saturday: filtered(data.saturday),
      ),
    );

    final payload = jsonDecode(jsonEncode(plan)) as Map<String, dynamic>;
    _homeController.doUpdateSalonAvailability(
      availability: payload,
      callback: () => _homeController.doGetSalonAvailability(),
    );
  }

  // ── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      appBar: AppBarWidget(
        nameOfScreen: 'Salon Availability',
        isBackIcon: true,
        actions: [
          TextButton(
            onPressed: _onUpdate,
            child: Text(
              'UPDATE',
              style: AppTextTheme.bold.copyWith(
                color: ColorConstant.primaryColor2,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Obx(
        () => _homeController.showProgress
            ? const ProgressBarView()
            : ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                itemCount: _days.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => _DayCard(
                  day: _days[i],
                  dayData: _dayData(_days[i]),
                  to12h: _to12h,
                  onToggle: (v) => _onToggle(_days[i], v),
                  onTimeTap: (isStart) {
                    final d = _dayData(_days[i]);
                    if (d != null && d.isSwitchOn == true) {
                      _pickTime(_days[i], isStart, d);
                    }
                  },
                ),
              ),
      ),
    );
  }
}

// ── Day Card ─────────────────────────────────────────────────────────────────

class _DayCard extends StatelessWidget {
  final String day;
  final SalonDay? dayData;
  final String Function(String?) to12h;
  final ValueChanged<bool> onToggle;
  final ValueChanged<bool> onTimeTap; // true = start, false = end

  const _DayCard({
    required this.day,
    required this.dayData,
    required this.to12h,
    required this.onToggle,
    required this.onTimeTap,
  });

  bool get _isOn => dayData?.isSwitchOn == true;

  String get _timeRange {
    final s = to12h(dayData?.start);
    final e = to12h(dayData?.end);
    return '$s - $e';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: ColorConstant.whiteColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Day info ───────────────────────────────────────────────────────
          Expanded(
            child: GestureDetector(
              onTap: () => onTimeTap(true), // tap row = pick start
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _capitalise(day),
                    style: AppTextTheme.bold.copyWith(
                      color: ColorConstant.blackColor,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isOn ? _timeRange : '--:-- -- - --:-- --',
                    style: AppTextTheme.medium.copyWith(
                      color: ColorConstant.grayTextColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Toggle ────────────────────────────────────────────────────────
          CupertinoSwitch(
            value: _isOn,
            activeTrackColor: ColorConstant.lightGreenColor,
            inactiveTrackColor: ColorConstant.redColor2,
            onChanged: onToggle,
          ),
        ],
      ),
    );
  }

  static String _capitalise(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}
