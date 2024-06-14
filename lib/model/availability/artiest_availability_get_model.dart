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
    data = json['data'] != null ? Availability.fromJson(json['data']) : null;
    message = json['message'];
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

class Availability {
  DayData? sunday;
  DayData? monday;
  DayData? tuesday;
  DayData? wednesday;
  DayData? thursday;
  DayData? friday;
  DayData? saturday;

  Availability(
      {this.sunday,
      this.monday,
      this.tuesday,
      this.wednesday,
      this.thursday,
      this.friday,
      this.saturday});

  Availability.fromJson(Map<String, dynamic> json) {
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

  DayData({this.start, this.end,this.isSwitchOn, this.breaks});

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
