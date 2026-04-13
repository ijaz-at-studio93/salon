import 'dart:convert';

import 'package:flutter/cupertino.dart' show CupertinoSwitch;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:salon/api/home_api.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/model/availability/artiest_availability_get_model.dart';
import 'package:salon/model/availability/working_plan_model.dart';
import 'package:salon/project_specific/button_widget.dart';
import 'package:salon/project_specific/progressbar_view.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:salon/project_specific/text_theme.dart';
import 'package:salon/util/app_snackbar.dart';

/// Per-stylist availability hub (Today / Weekly / Exceptions) opened from Set Stylist Availability.
class StylistAvailabilityDetailPage extends StatefulWidget {
  final String artistId;
  final String stylistName;

  const StylistAvailabilityDetailPage({
    super.key,
    required this.artistId,
    required this.stylistName,
  });

  @override
  State<StylistAvailabilityDetailPage> createState() =>
      _StylistAvailabilityDetailPageState();
}

class _StylistAvailabilityDetailPageState
    extends State<StylistAvailabilityDetailPage> {
  int _tabIndex = 0;
  Availability? _availability;
  bool _loading = true;
  bool _savingToday = false;
  final Set<int> _savingWeekdays = {};
  bool _blockingException = false;
  String? _deletingBlockId;
  DateTime? _exceptionStartDate;
  DateTime? _exceptionEndDate;
  TimeOfDay? _exceptionTimeFrom;
  TimeOfDay? _exceptionTimeTo;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      // Fire both requests concurrently
      final availFuture =
          HomeAPI.getArtiestAvailability(artistId: widget.artistId);
      final slotsFuture =
          HomeAPI.getBlockedSlotsForArtist(artistId: widget.artistId);

      final availModel = await availFuture;

      List<ArtistBlockedSlot> slots = availModel.data?.blockedSlots ?? [];
      try {
        slots = await slotsFuture;
      } catch (_) {
        // Dedicated endpoint failed; fall back to whatever came with availability
      }

      if (!mounted) return;
      setState(() {
        _availability = availModel.data;
        _availability?.blockedSlots = slots;
      });
    } catch (_) {
      if (mounted) setState(() => _availability = null);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  static const List<(int weekday, String fullName)> _weeklyTabDays = [
    (DateTime.sunday, 'Sunday'),
    (DateTime.monday, 'Monday'),
    (DateTime.tuesday, 'Tuesday'),
    (DateTime.wednesday, 'Wednesday'),
    (DateTime.thursday, 'Thursday'),
    (DateTime.friday, 'Friday'),
    (DateTime.saturday, 'Saturday'),
  ];

  DayData? _dayDataForWeekday(Availability a, int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return a.monday;
      case DateTime.tuesday:
        return a.tuesday;
      case DateTime.wednesday:
        return a.wednesday;
      case DateTime.thursday:
        return a.thursday;
      case DateTime.friday:
        return a.friday;
      case DateTime.saturday:
        return a.saturday;
      case DateTime.sunday:
      default:
        return a.sunday;
    }
  }

  void _setDayData(Availability a, int weekday, DayData? d) {
    switch (weekday) {
      case DateTime.monday:
        a.monday = d;
        break;
      case DateTime.tuesday:
        a.tuesday = d;
        break;
      case DateTime.wednesday:
        a.wednesday = d;
        break;
      case DateTime.thursday:
        a.thursday = d;
        break;
      case DateTime.friday:
        a.friday = d;
        break;
      case DateTime.saturday:
        a.saturday = d;
        break;
      case DateTime.sunday:
      default:
        a.sunday = d;
    }
  }

  DayData? _todayDay() {
    final a = _availability;
    if (a == null) return null;
    return _dayDataForWeekday(a, DateTime.now().weekday);
  }

  bool _isDayOn(DayData? d) {
    if (d == null) return false;
    if (d.isSwitchOn == false) return false;
    final s = d.start?.trim() ?? '';
    final e = d.end?.trim() ?? '';
    return s.isNotEmpty && e.isNotEmpty;
  }

  DayData? _workingDayPayload(DayData? d) {
    if (d == null) return null;
    if (d.isSwitchOn == false) return null;
    final s = d.start?.trim() ?? '';
    final e = d.end?.trim() ?? '';
    if (s.isEmpty && e.isEmpty) return null;
    return DayData(
        start: d.start, end: d.end, breaks: d.breaks, isSwitchOn: d.isSwitchOn);
  }

  Map<String, dynamic> _patchMap(Availability a) {
    final plan = Availability(
      sunday: _workingDayPayload(a.sunday),
      monday: _workingDayPayload(a.monday),
      tuesday: _workingDayPayload(a.tuesday),
      wednesday: _workingDayPayload(a.wednesday),
      thursday: _workingDayPayload(a.thursday),
      friday: _workingDayPayload(a.friday),
      saturday: _workingDayPayload(a.saturday),
    );
    final w = WorkingPlanModel(workingPlan: plan);
    return jsonDecode(jsonEncode(w)) as Map<String, dynamic>;
  }

  Future<void> _onTodayToggle(bool value) async {
    final a = _availability;
    if (a == null) return;

    setState(() => _savingToday = true);
    try {
      if (value) {
        _setDayData(
          a,
          DateTime.now().weekday,
          DayData(start: "10:00", end: "21:00", breaks: []),
        );
      } else {
        _setDayData(a, DateTime.now().weekday, null);
      }

      final ok = await HomeAPI.updateArtiestAvailability(
        availability: _patchMap(a),
        artistId: widget.artistId,
      );
      if (!ok || !mounted) return;
      await _load();
    } catch (_) {
      if (mounted) await _load();
    } finally {
      if (mounted) setState(() => _savingToday = false);
    }
  }

  Future<void> _onWeekdayToggle(int weekday, bool value) async {
    final a = _availability;
    if (a == null) return;

    setState(() => _savingWeekdays.add(weekday));
    try {
      if (value) {
        _setDayData(
          a,
          weekday,
          DayData(start: "10:00", end: "21:00", breaks: []),
        );
      } else {
        _setDayData(a, weekday, null);
      }

      final ok = await HomeAPI.updateArtiestAvailability(
        availability: _patchMap(a),
        artistId: widget.artistId,
      );
      if (!ok || !mounted) return;
      await _load();
    } catch (_) {
      if (mounted) await _load();
    } finally {
      if (mounted) {
        setState(() => _savingWeekdays.remove(weekday));
      }
    }
  }

  String _formatRange(DayData? d) {
    if (!_isDayOn(d)) return "—";
    final s = d!.start?.trim() ?? '';
    final e = d.end?.trim() ?? '';
    if (s.isEmpty || e.isEmpty) return "—";
    return "${_to12h(s)} - ${_to12h(e)}";
  }

  String _to12h(String hhmm) {
    try {
      final dt = DateFormat("HH:mm").parse(hhmm);
      return DateFormat("h:mm a").format(dt);
    } catch (_) {
      return hhmm;
    }
  }

  String _todayTitle() {
    final now = DateTime.now();
    return DateFormat("EEEE, MMMM d").format(now);
  }

  Future<void> _openWeeklyEditor() async {
    setState(() => _tabIndex = 1);
  }

  Future<void> _openBlockSlot() async {
    setState(() => _tabIndex = 2);
  }

  DateTime get _todayDateOnly {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  bool _isSameCalendarDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// Time pickers only when start and end are the same calendar day and that day is today.
  bool get _exceptionShowTimeSection {
    final s = _exceptionStartDate;
    final e = _exceptionEndDate;
    if (s == null || e == null) return false;
    if (!_isSameCalendarDay(s, e)) return false;
    return _isSameCalendarDay(s, _todayDateOnly);
  }

  void _clearExceptionTimesIfHidden() {
    if (!_exceptionShowTimeSection) {
      _exceptionTimeFrom = null;
      _exceptionTimeTo = null;
    }
  }

  String? _exceptionDateDetail(DateTime? d) {
    if (d == null) return null;
    return DateFormat('MMM d, yyyy').format(d);
  }

  String? _exceptionTimeDetail(TimeOfDay? t) {
    if (t == null) return null;
    final base = DateTime.now();
    final dt = DateTime(base.year, base.month, base.day, t.hour, t.minute);
    return DateFormat('h:mm a').format(dt);
  }

  Future<void> _pickExceptionStartDate() async {
    final today = _todayDateOnly;
    final initial = _exceptionStartDate ?? today;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(today) ? today : initial,
      firstDate: today,
      lastDate: DateTime(today.year + 5),
    );
    if (picked == null) return;
    setState(() {
      final day = DateTime(picked.year, picked.month, picked.day);
      _exceptionStartDate = day;
      if (_exceptionEndDate == null || _exceptionEndDate!.isBefore(day)) {
        _exceptionEndDate = day;
      }
      _clearExceptionTimesIfHidden();
    });
  }

  Future<void> _pickExceptionEndDate() async {
    final today = _todayDateOnly;
    final start = _exceptionStartDate ?? today;
    final firstDate = start.isBefore(today) ? today : start;
    final initial = _exceptionEndDate ?? start;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(firstDate) ? firstDate : initial,
      firstDate: firstDate,
      lastDate: DateTime(today.year + 5),
    );
    if (picked == null) return;
    setState(() {
      _exceptionEndDate = DateTime(picked.year, picked.month, picked.day);
      _clearExceptionTimesIfHidden();
    });
  }

  Future<void> _pickExceptionTimeFrom() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _exceptionTimeFrom ?? const TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null) setState(() => _exceptionTimeFrom = picked);
  }

  Future<void> _pickExceptionTimeTo() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _exceptionTimeTo ?? const TimeOfDay(hour: 17, minute: 0),
    );
    if (picked != null) setState(() => _exceptionTimeTo = picked);
  }

  Future<void> _submitExceptionBlock() async {
    final sDate = _exceptionStartDate;
    final eDate = _exceptionEndDate;
    if (sDate == null || eDate == null) {
      showAppSnackbar(
        'Missing details',
        'Choose a start date and end date.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    if (eDate.isBefore(sDate)) {
      showAppSnackbar(
        'Invalid range',
        'End date must be on or after start date.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    late final DateTime start;
    late final DateTime end;

    if (_exceptionShowTimeSection) {
      final tf = _exceptionTimeFrom;
      final tt = _exceptionTimeTo;
      if (tf == null || tt == null) {
        showAppSnackbar(
          'Missing details',
          'Choose From and To times.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      start = DateTime(sDate.year, sDate.month, sDate.day, tf.hour, tf.minute);
      end = DateTime(eDate.year, eDate.month, eDate.day, tt.hour, tt.minute);
      if (!end.isAfter(start)) {
        showAppSnackbar(
          'Invalid range',
          'End time must be after start time.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
    } else {
      start = DateTime(sDate.year, sDate.month, sDate.day);
      end = DateTime(eDate.year, eDate.month, eDate.day, 23, 59, 59, 999);
      if (!end.isAfter(start)) {
        showAppSnackbar(
          'Invalid range',
          'End must be after start.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
    }

    setState(() => _blockingException = true);
    try {
      final postModel = await HomeAPI.blockSlotForArtist(
        artistId: widget.artistId,
        start: start,
        end: end,
      );
      if (!mounted) return;
      showAppSnackbar(
        'Blocked',
        'This period is marked unavailable.',
        snackPosition: SnackPosition.BOTTOM,
      );
      setState(() {
        _exceptionStartDate = null;
        _exceptionEndDate = null;
        _exceptionTimeFrom = null;
        _exceptionTimeTo = null;
      });
      await _load();
      if (!mounted) return;
      _ensureExceptionVisibleAfterCreate(
        postModel: postModel,
        start: start,
        end: end,
      );
    } catch (_) {
      if (mounted) {
        showAppSnackbar(
          'Error',
          'Could not block this period. Try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      if (mounted) setState(() => _blockingException = false);
    }
  }

  /// If GET omits blocked slots but POST returned them (or only times), show the new block.
  void _ensureExceptionVisibleAfterCreate({
    required ArtiestAvailabilityGetModel postModel,
    required DateTime start,
    required DateTime end,
  }) {
    final a = _availability;
    if (a == null) return;
    final existing = a.blockedSlots;
    if (existing != null && existing.isNotEmpty) return;

    final fromPost = postModel.data?.blockedSlots;
    if (fromPost != null && fromPost.isNotEmpty) {
      setState(() => a.blockedSlots = List<ArtistBlockedSlot>.from(fromPost));
      return;
    }

    setState(() {
      a.blockedSlots = [
        ArtistBlockedSlot(start: start, end: end, id: null),
      ];
    });
  }

  List<ArtistBlockedSlot> get _sortedBlockedSlots {
    final raw = _availability?.blockedSlots ?? const <ArtistBlockedSlot>[];
    final list = List<ArtistBlockedSlot>.from(raw);
    list.sort((a, b) {
      final as = a.start ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bs = b.start ?? DateTime.fromMillisecondsSinceEpoch(0);
      return as.compareTo(bs);
    });
    return list;
  }

  bool _isLikelyFullDayBlock(DateTime s, DateTime e) {
    if (!_isSameCalendarDay(s, e)) return false;
    final dayStart = DateTime(s.year, s.month, s.day);
    if (s.isAfter(dayStart.add(const Duration(seconds: 2)))) return false;
    return e.hour == 23 && e.minute >= 58;
  }

  Future<void> _deleteBlockedSlot(ArtistBlockedSlot slot) async {
    final id = slot.id;
    if (id == null || id.isEmpty) return;
    setState(() => _deletingBlockId = id);
    try {
      await HomeAPI.deleteArtistBlockedSlot(
        artistId: widget.artistId,
        blockId: id,
      );
      if (!mounted) return;
      showAppSnackbar(
        'Removed',
        'This exception was removed.',
        snackPosition: SnackPosition.BOTTOM,
      );
      await _load();
    } catch (_) {
      if (mounted) {
        showAppSnackbar(
          'Error',
          'Could not remove this exception. Try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      if (mounted) setState(() => _deletingBlockId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.stylistAvailabilityScreenBg,
      appBar: AppBarWidget(
        nameOfScreen: widget.stylistName,
        isBackIcon: true,
        rightWidget: Material(
          color: ColorConstant.lightGreyColor,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => Get.back(),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child:
                  Icon(Icons.close, size: 20, color: ColorConstant.blackColor),
            ),
          ),
        ),
      ),
      body: _loading
          ? const ProgressBarView()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: _SegmentBar(
                    selectedIndex: _tabIndex,
                    onChanged: (i) => setState(() => _tabIndex = i),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    child: _tabBody(),
                  ),
                ),
                if (_tabIndex == 0)
                  SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: ButtonWidget(
                        buttonTitleText: "+ Create Exception",
                        color: ColorConstant.primaryColor2,
                        onPress: _openBlockSlot,
                      ),
                    ),
                  ),
                if (_tabIndex == 2)
                  SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: _ExceptionBlockCta(
                        loading: _blockingException,
                        onPressed: _submitExceptionBlock,
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _tabBody() {
    switch (_tabIndex) {
      case 1:
        return _weeklyTabBody();
      case 2:
        return _exceptionsTabBody();
      case 0:
      default:
        return _weeklyColumn(showTodayCard: true);
    }
  }

  Widget _weeklyTabBody() {
    final a = _availability;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < _weeklyTabDays.length; i++) ...[
          if (i > 0) const SizedBox(height: 10),
          _WeeklyDaySwitchCard(
            dayName: _weeklyTabDays[i].$2,
            timeRange: a == null
                ? "—"
                : _formatRange(_dayDataForWeekday(a, _weeklyTabDays[i].$1)),
            on: a != null &&
                _isDayOn(_dayDataForWeekday(a, _weeklyTabDays[i].$1)),
            busy: _savingWeekdays.contains(_weeklyTabDays[i].$1),
            onToggle: (v) => _onWeekdayToggle(_weeklyTabDays[i].$1, v),
          ),
        ],
      ],
    );
  }

  Widget _exceptionsTabBody() {
    final slots = _sortedBlockedSlots;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (slots.isNotEmpty) ...[
          for (var i = 0; i < slots.length; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            _DisabledExceptionCard(
              slot: slots[i],
              deleting: _deletingBlockId == slots[i].id,
              onDelete: (slots[i].id != null && slots[i].id!.isNotEmpty)
                  ? () => _deleteBlockedSlot(slots[i])
                  : null,
              isLikelyFullDayBlock: _isLikelyFullDayBlock,
              isSameCalendarDay: _isSameCalendarDay,
            ),
          ],
          const SizedBox(height: 28),
        ],
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _ExceptionScreenshotField(
                  title: 'Start Date',
                  detail: _exceptionDateDetail(_exceptionStartDate),
                  onTap: _pickExceptionStartDate,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ExceptionScreenshotField(
                  title: 'End Date',
                  detail: _exceptionDateDetail(_exceptionEndDate),
                  onTap: _pickExceptionEndDate,
                ),
              ),
            ],
          ),
        ),
        if (_exceptionShowTimeSection) ...[
          const SizedBox(height: 28),
          Text(
            'Time',
            textAlign: TextAlign.center,
            style: AppTextTheme.bold.copyWith(
              color: ColorConstant.blackColor,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _ExceptionScreenshotField(
                    title: 'From',
                    detail: _exceptionTimeDetail(_exceptionTimeFrom),
                    onTap: _pickExceptionTimeFrom,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ExceptionScreenshotField(
                    title: 'To',
                    detail: _exceptionTimeDetail(_exceptionTimeTo),
                    onTap: _pickExceptionTimeTo,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _weeklyColumn({required bool showTodayCard}) {
    final todayOn = _isDayOn(_todayDay());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTodayCard) ...[
          Text(
            "Availability for Today",
            style: AppTextTheme.bold.copyWith(
              color: ColorConstant.blackColor,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _todayTitle(),
            style: AppTextTheme.regular.copyWith(
              color: ColorConstant.grayTextColor,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          _TodayCard(
            available: todayOn,
            busy: _savingToday,
            onToggle: _onTodayToggle,
          ),
          const SizedBox(height: 24),
        ],
        Text(
          "Weekly Availability",
          style: AppTextTheme.bold.copyWith(
            color: ColorConstant.blackColor,
            fontSize: 17,
          ),
        ),
        const SizedBox(height: 12),
        _WeeklyList(
          availability: _availability,
          formatRange: _formatRange,
          isOn: _isDayOn,
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: _openWeeklyEditor,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              foregroundColor: ColorConstant.primaryColor2,
            ),
            child: Text(
              "Manage Weekly Schedule >",
              style: AppTextTheme.semibold.copyWith(
                color: ColorConstant.primaryColor2,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Lists one created exception: date-range style or single-day timed style (Figma).
class _DisabledExceptionCard extends StatelessWidget {
  final ArtistBlockedSlot slot;
  final bool deleting;
  final VoidCallback? onDelete;
  final bool Function(DateTime s, DateTime e) isLikelyFullDayBlock;
  final bool Function(DateTime a, DateTime b) isSameCalendarDay;

  const _DisabledExceptionCard({
    required this.slot,
    required this.deleting,
    required this.onDelete,
    required this.isLikelyFullDayBlock,
    required this.isSameCalendarDay,
  });

  static final _dateFmt = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    final s = slot.start;
    final e = slot.end;
    if (s == null || e == null) return const SizedBox.shrink();

    final useRangeLayout =
        !isSameCalendarDay(s, e) || isLikelyFullDayBlock(s, e);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorConstant.whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Disabled',
                  style: AppTextTheme.bold.copyWith(
                    color: ColorConstant.exceptionDisabledLabel,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                if (useRangeLayout)
                  Wrap(
                    spacing: 16,
                    runSpacing: 6,
                    children: [
                      _kv(
                        'From : ',
                        _dateFmt.format(s),
                        valueColor: ColorConstant.exceptionDateViolet,
                      ),
                      _kv(
                        'To : ',
                        _dateFmt.format(e),
                        valueColor: ColorConstant.exceptionDateViolet,
                      ),
                    ],
                  )
                else ...[
                  _kv(
                    'On : ',
                    _dateFmt.format(s),
                    valueColor: ColorConstant.exceptionDateViolet,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 16,
                    runSpacing: 6,
                    children: [
                      _kv(
                        'From : ',
                        DateFormat('h:mm a').format(s),
                        valueColor: ColorConstant.exceptionTimePink,
                      ),
                      _kv(
                        'To : ',
                        DateFormat('h:mm a').format(e),
                        valueColor: ColorConstant.exceptionTimePink,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (onDelete != null) ...[
            const SizedBox(width: 8),
            Material(
              color: ColorConstant.exceptionDeleteRed,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: deleting ? null : onDelete,
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 44,
                  height: 44,
                  child: deleting
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: ColorConstant.whiteColor,
                          ),
                        )
                      : const Icon(
                          Icons.delete_outline,
                          color: ColorConstant.whiteColor,
                          size: 22,
                        ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _kv(String label, String value, {required Color valueColor}) {
    return RichText(
      text: TextSpan(
        style: AppTextTheme.regular.copyWith(
          color: ColorConstant.blackColor,
          fontSize: 14,
          height: 1.25,
        ),
        children: [
          TextSpan(text: label),
          TextSpan(
            text: value,
            style: AppTextTheme.semibold.copyWith(
              color: valueColor,
              fontSize: 14,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}

/// Weekly tab: one card per day with full name, time range, and switch.
class _WeeklyDaySwitchCard extends StatelessWidget {
  final String dayName;
  final String timeRange;
  final bool on;
  final bool busy;
  final ValueChanged<bool> onToggle;

  const _WeeklyDaySwitchCard({
    required this.dayName,
    required this.timeRange,
    required this.on,
    required this.busy,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: ColorConstant.whiteColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    dayName,
                    style: AppTextTheme.semibold.copyWith(
                      color: ColorConstant.blackColor,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    timeRange,
                    style: AppTextTheme.medium.copyWith(
                      color: ColorConstant.blackColor.withValues(
                        alpha: 0.6,
                      ),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            if (busy)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              CupertinoSwitch(
                value: on,
                onChanged: onToggle,
                activeTrackColor: ColorConstant.stylistStatusAvailable,
                inactiveTrackColor: ColorConstant.gray.withValues(alpha: 0.38),
                thumbColor: ColorConstant.whiteColor,
              ),
          ],
        ),
      ),
    );
  }
}

class _SegmentBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const _SegmentBar({
    required this.selectedIndex,
    required this.onChanged,
  });

  static const _labels = ["Today", "Weekly", "Exceptions"];

  @override
  Widget build(BuildContext context) {
    const barHeight = 48.0;
    final radius = BorderRadius.circular(barHeight / 2);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Must match Row's Expanded widths exactly (full width, equal thirds).
        final segmentW = constraints.maxWidth / _labels.length;

        return SizedBox(
          height: barHeight,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: ColorConstant.lightGreyColor.withValues(alpha: 0.7),
              borderRadius: radius,
            ),
            child: Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.antiAlias,
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOutCubic,
                  left: selectedIndex * segmentW,
                  top: 0,
                  bottom: 0,
                  width: segmentW,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: ColorConstant.whiteColor,
                      borderRadius: BorderRadius.circular(barHeight / 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.10),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: List.generate(_labels.length, (i) {
                    final sel = selectedIndex == i;
                    return Expanded(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => onChanged(i),
                          borderRadius: BorderRadius.circular(barHeight / 2),
                          splashColor: ColorConstant.primaryColor2
                              .withValues(alpha: 0.12),
                          highlightColor: ColorConstant.primaryColor2
                              .withValues(alpha: 0.06),
                          child: Center(
                            child: Text(
                              _labels[i],
                              style: AppTextTheme.semibold.copyWith(
                                fontSize: 14,
                                height: 1.2,
                                color: sel
                                    ? ColorConstant.primaryColor2
                                    : ColorConstant.grayTextColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TodayCard extends StatelessWidget {
  final bool available;
  final bool busy;
  final ValueChanged<bool> onToggle;

  const _TodayCard({
    required this.available,
    required this.busy,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: ColorConstant.whiteColor,
        borderRadius: BorderRadius.circular(12),
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
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: available
                  ? ColorConstant.stylistStatusAvailable
                  : ColorConstant.stylistStatusOff,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              available ? "Available Today" : "Unavailable Today",
              style: AppTextTheme.bold.copyWith(
                color: ColorConstant.blackColor,
                fontSize: 15,
              ),
            ),
          ),
          if (busy)
            const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            CupertinoSwitch(
              value: available,
              onChanged: onToggle,
              activeTrackColor: ColorConstant.stylistStatusAvailable,
              inactiveTrackColor: ColorConstant.gray.withValues(alpha: 0.38),
              thumbColor: ColorConstant.whiteColor,
            ),
        ],
      ),
    );
  }
}

class _WeeklyList extends StatelessWidget {
  final Availability? availability;
  final String Function(DayData?) formatRange;
  final bool Function(DayData?) isOn;

  const _WeeklyList({
    required this.availability,
    required this.formatRange,
    required this.isOn,
  });

  static const _days = [
    (DateTime.monday, "Mon"),
    (DateTime.tuesday, "Tue"),
    (DateTime.wednesday, "Wed"),
    (DateTime.thursday, "Thu"),
    (DateTime.friday, "Fri"),
    (DateTime.saturday, "Sat"),
    (DateTime.sunday, "Sun"),
  ];

  DayData? _day(Availability? a, int weekday) {
    if (a == null) return null;
    switch (weekday) {
      case DateTime.monday:
        return a.monday;
      case DateTime.tuesday:
        return a.tuesday;
      case DateTime.wednesday:
        return a.wednesday;
      case DateTime.thursday:
        return a.thursday;
      case DateTime.friday:
        return a.friday;
      case DateTime.saturday:
        return a.saturday;
      case DateTime.sunday:
      default:
        return a.sunday;
    }
  }

  @override
  Widget build(BuildContext context) {
    final a = availability;
    const radius = 10.0;
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        decoration: BoxDecoration(
          color: ColorConstant.whiteColor,
          borderRadius: BorderRadius.circular(radius),
          // border: Border.all(
          //   color: ColorConstant.borderColor,
          //   width: 1,
          // ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < _days.length; i++) ...[
                if (i > 0)
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: ColorConstant.blackColor.withValues(alpha: 0.3),
                  ),
                _WeeklyRow(
                  abbr: _days[i].$2,
                  on: isOn(_day(a, _days[i].$1)),
                  timeRange: formatRange(_day(a, _days[i].$1)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _WeeklyRow extends StatelessWidget {
  final String abbr;
  final bool on;
  final String timeRange;

  const _WeeklyRow({
    required this.abbr,
    required this.on,
    required this.timeRange,
  });

  static const _dayColWidth = 70.0;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: _dayColWidth,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: ColorConstant.primaryColor2.withValues(alpha: 0.3),
              border: Border(
                right: BorderSide(
                  color: ColorConstant.divider2Color.withValues(alpha: 0.9),
                  width: 1,
                ),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(
              abbr,
              style: AppTextTheme.bold.copyWith(
                color: ColorConstant.blackColor.withValues(alpha: 0.6),
                fontSize: 18,
                height: 1.1,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 10, 8),
              child: Row(
                children: [
                  _StatusPill(on: on),
                  const Spacer(),
                  Text(
                    timeRange,
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextTheme.regular.copyWith(
                      color: ColorConstant.grayTextColor,
                      fontSize: 18,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final bool on;

  const _StatusPill({required this.on});

  @override
  Widget build(BuildContext context) {
    final bg = on
        ? ColorConstant.stylistStatusAvailable
        : ColorConstant.stylistStatusOff;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        on ? "On" : "Off",
        style: AppTextTheme.bold.copyWith(
          color: ColorConstant.whiteColor,
          fontSize: 16,
          height: 1,
        ),
      ),
    );
  }
}

/// Primary action for the Exceptions tab (block slot API).
class _ExceptionBlockCta extends StatelessWidget {
  final bool loading;
  final VoidCallback onPressed;

  const _ExceptionBlockCta({
    required this.loading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorConstant.primaryColor2,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: loading ? null : onPressed,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 52,
          width: double.infinity,
          child: Center(
            child: loading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: ColorConstant.whiteColor,
                    ),
                  )
                : Text(
                    'Disable',
                    style: AppTextTheme.bold.copyWith(
                      fontSize: 16,
                      color: ColorConstant.whiteColor,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

/// Exceptions tab fields: bold black title, thin purple border (matches design).
class _ExceptionScreenshotField extends StatelessWidget {
  final String title;
  final String? detail;
  final VoidCallback onTap;

  const _ExceptionScreenshotField({
    required this.title,
    this.detail,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasDetail = detail != null && detail!.isNotEmpty;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: ColorConstant.whiteColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: ColorConstant.primaryColor2,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: AppTextTheme.bold.copyWith(
                  color: ColorConstant.blackColor,
                  fontSize: 16,
                ),
              ),
              if (hasDetail) ...[
                const SizedBox(height: 6),
                Text(
                  detail!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextTheme.regular.copyWith(
                    color: ColorConstant.grayTextColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
