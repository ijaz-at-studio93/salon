class ArtiestAvailabilityGetModel {
  int? statusCode;
  bool? success;
  Availability? data;
  String? message;

  ArtiestAvailabilityGetModel(
      {this.statusCode, this.success, this.data, this.message});

  ArtiestAvailabilityGetModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    final raw = json['data'];
    if (raw is Map<String, dynamic>) {
      data = Availability.fromJson(raw, responseEnvelope: json);
    } else {
      data = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

/// Blocked / exception interval returned with artist availability (optional).
class ArtistBlockedSlot {
  String? id;
  DateTime? start;
  DateTime? end;

  ArtistBlockedSlot({this.id, this.start, this.end});

  static DateTime? _parseInstant(dynamic v) {
    if (v == null) return null;
    if (v is String) {
      final t = DateTime.tryParse(v);
      if (t != null) return t;
      return null;
    }
    if (v is int) {
      if (v > 2000000000000) return DateTime.fromMillisecondsSinceEpoch(v);
      if (v > 100000000000) return DateTime.fromMillisecondsSinceEpoch(v);
      return DateTime.fromMillisecondsSinceEpoch(v * 1000);
    }
    if (v is double) return _parseInstant(v.toInt());
    if (v is Map) {
      final nested = v['\$date'] ?? v['date'] ?? v['iso'] ?? v['value'];
      return _parseInstant(nested);
    }
    return null;
  }

  ArtistBlockedSlot.fromJson(Map<String, dynamic> json) {
    final rawId = json['_id'] ?? json['id'] ?? json['blockId'];
    id = rawId?.toString();
    final s = json['start'] ?? json['startsAt'] ?? json['from'];
    final e = json['end'] ?? json['endsAt'] ?? json['to'];
    start = _parseInstant(s);
    end = _parseInstant(e);
  }
}

class Availability {
  DayData? sunday;
  DayData? monday;
  DayData? tuesday;
  DayData? wednesday;
  DayData? thursday;
  DayData? friday;
  DayData? saturday;
  List<ArtistBlockedSlot>? blockedSlots;

  Availability(
      {this.sunday,
      this.monday,
      this.tuesday,
      this.wednesday,
      this.thursday,
      this.friday,
      this.saturday,
      this.blockedSlots});

  static const List<String> _weekdayKeys = [
    'sunday',
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
  ];

  static const List<String> _blockListKeys = [
    'blockedSlots',
    'blockedSlot',
    'exceptions',
    'blocks',
    'blocked',
    'unavailablePeriods',
    'timeOff',
    'artistBlockedSlots',
    'availabilityExceptions',
  ];

  static Map<String, dynamic> _calendarMap(Map<String, dynamic> json) {
    final wp = json['workingPlan'];
    if (wp is Map<String, dynamic>) {
      return wp;
    }
    return json;
  }

  static bool _hasAnyWeekday(Map<String, dynamic> cal) {
    for (final k in _weekdayKeys) {
      if (cal[k] != null) return true;
    }
    return false;
  }

  static List<ArtistBlockedSlot> _blocksFromList(dynamic raw) {
    if (raw is! List) return [];
    final out = <ArtistBlockedSlot>[];
    for (final v in raw) {
      if (v is Map) {
        final b = ArtistBlockedSlot.fromJson(Map<String, dynamic>.from(v));
        if (b.start != null && b.end != null) out.add(b);
      }
    }
    return out;
  }

  static List<ArtistBlockedSlot> _collectBlocksFromMap(Map<String, dynamic>? m) {
    if (m == null) return [];
    final seen = <String>{};
    final out = <ArtistBlockedSlot>[];
    void addAll(List<ArtistBlockedSlot> list) {
      for (final b in list) {
        final key =
            '${b.start?.toIso8601String()}_${b.end?.toIso8601String()}_${b.id}';
        if (seen.add(key)) out.add(b);
      }
    }

    for (final key in _blockListKeys) {
      addAll(_blocksFromList(m[key]));
    }
    return out;
  }

  /// [responseEnvelope] is the full API JSON (e.g. `{ data, statusCode }`) so we
  /// can merge `blockedSlots` that sit next to `data` instead of inside it.
  Availability.fromJson(Map<String, dynamic> json,
      {Map<String, dynamic>? responseEnvelope}) {
    final cal = _calendarMap(json);
    final hasDays = _hasAnyWeekday(cal);

    if (hasDays) {
      sunday = cal['sunday'] != null ? DayData.fromJson(cal['sunday']) : null;
      monday = cal['monday'] != null ? DayData.fromJson(cal['monday']) : null;
      tuesday =
          cal['tuesday'] != null ? DayData.fromJson(cal['tuesday']) : null;
      wednesday =
          cal['wednesday'] != null ? DayData.fromJson(cal['wednesday']) : null;
      thursday =
          cal['thursday'] != null ? DayData.fromJson(cal['thursday']) : null;
      friday = cal['friday'] != null ? DayData.fromJson(cal['friday']) : null;
      saturday =
          cal['saturday'] != null ? DayData.fromJson(cal['saturday']) : null;
    } else {
      sunday = json['sunday'] != null ? DayData.fromJson(json['sunday']) : null;
      monday = json['monday'] != null ? DayData.fromJson(json['monday']) : null;
      tuesday =
          json['tuesday'] != null ? DayData.fromJson(json['tuesday']) : null;
      wednesday =
          json['wednesday'] != null ? DayData.fromJson(json['wednesday']) : null;
      thursday =
          json['thursday'] != null ? DayData.fromJson(json['thursday']) : null;
      friday = json['friday'] != null ? DayData.fromJson(json['friday']) : null;
      saturday =
          json['saturday'] != null ? DayData.fromJson(json['saturday']) : null;
    }

    final merged = <ArtistBlockedSlot>[];
    merged.addAll(_collectBlocksFromMap(json));
    if (responseEnvelope != null) {
      merged.addAll(_collectBlocksFromMap(responseEnvelope));
    }

    if (merged.isEmpty &&
        json['start'] != null &&
        json['end'] != null &&
        !hasDays) {
      final one = ArtistBlockedSlot.fromJson(json);
      if (one.start != null && one.end != null) {
        merged.add(one);
      }
    }

    if (merged.isNotEmpty) {
      blockedSlots = _dedupeBlocks(merged);
    }
  }

  static List<ArtistBlockedSlot> _dedupeBlocks(List<ArtistBlockedSlot> list) {
    final seen = <String>{};
    final out = <ArtistBlockedSlot>[];
    for (final b in list) {
      final key =
          '${b.id}_${b.start?.millisecondsSinceEpoch}_${b.end?.millisecondsSinceEpoch}';
      if (seen.add(key)) out.add(b);
    }
    return out;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (sunday != null) {
      data['sunday'] = sunday!.toJson();
    }
    if (monday != null) {
      data['monday'] = monday!.toJson();
    }
    if (tuesday != null) {
      data['tuesday'] = tuesday!.toJson();
    }
    if (wednesday != null) {
      data['wednesday'] = wednesday!.toJson();
    }
    if (thursday != null) {
      data['thursday'] = thursday!.toJson();
    }
    if (friday != null) {
      data['friday'] = friday!.toJson();
    }
    if (saturday != null) {
      data['saturday'] = saturday!.toJson();
    }
    return data;
  }
}

class DayData {
  String? start;
  String? end;
  bool? isSwitchOn;
  List<Breaks>? breaks;

  DayData({this.start, this.end, this.isSwitchOn, this.breaks});

  DayData.fromJson(Map<String, dynamic> json) {
    start = json['start'];
    end = json['end'];
    if (json['breaks'] != null) {
      breaks = <Breaks>[];
      json['breaks'].forEach((v) {
        breaks!.add(Breaks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start'] = start;
    data['end'] = end;
    if (breaks != null) {
      data['breaks'] = breaks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Breaks {
  String? start;
  String? end;

  Breaks({this.start, this.end});

  Breaks.fromJson(Map<String, dynamic> json) {
    start = json['start'];
    end = json['end'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start'] = start;
    data['end'] = end;
    return data;
  }
}
