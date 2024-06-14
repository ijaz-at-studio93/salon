class SalonAvailability {
  int? statusCode;
  bool? success;
  SalonAvailabilityData? data;
  String? message;

  SalonAvailability({this.statusCode, this.success, this.data, this.message});

  SalonAvailability.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    data = json['data'] != null ? SalonAvailabilityData.fromJson(json['data']) : null;
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

class SalonAvailabilityData {
  SalonDay? sunday;
  SalonDay? monday;
  SalonDay? tuesday;
  SalonDay? wednesday;
  SalonDay? thursday;
  SalonDay? friday;
  SalonDay? saturday;

  SalonAvailabilityData(
      {this.sunday,
      this.monday,
      this.tuesday,
      this.wednesday,
      this.thursday,
      this.friday,
      this.saturday});

  SalonAvailabilityData.fromJson(Map<String, dynamic> json) {
    sunday = json['sunday'] != null ? SalonDay.fromJson(json['sunday']) : null;
    monday = json['monday'] != null ? SalonDay.fromJson(json['monday']) : null;
    tuesday =
        json['tuesday'] != null ? SalonDay.fromJson(json['tuesday']) : null;
    wednesday =
        json['wednesday'] != null ? SalonDay.fromJson(json['wednesday']) : null;
    thursday =
        json['thursday'] != null ? SalonDay.fromJson(json['thursday']) : null;
    friday = json['friday'] != null ? SalonDay.fromJson(json['friday']) : null;
    saturday =
        json['saturday'] != null ? SalonDay.fromJson(json['saturday']) : null;
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

class SalonDay {
  String? start;
  String? end;
  bool? isSwitchOn;
  List<SalonBreaks>? breaks;

  SalonDay({this.start, this.end, this.breaks,this.isSwitchOn});

  SalonDay.fromJson(Map<String, dynamic> json) {
    start = json['start'];
    end = json['end'];
    if (json['breaks'] != null) {
      breaks = <SalonBreaks>[];
      json['breaks'].forEach((v) {
        breaks!.add(SalonBreaks.fromJson(v));
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

class SalonBreaks {
  String? start;
  String? end;

  SalonBreaks({this.start, this.end});

  SalonBreaks.fromJson(Map<String, dynamic> json) {
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
