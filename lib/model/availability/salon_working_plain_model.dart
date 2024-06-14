import 'package:salon/model/availability/salon_avibility_model.dart';

class SalonWorkingPlanModel {
  SalonAvailabilityData? workingPlan;

  SalonWorkingPlanModel({this.workingPlan});

  SalonWorkingPlanModel.fromJson(Map<String, dynamic> json) {
    workingPlan = json['workingPlan'] != null
        ? SalonAvailabilityData.fromJson(json['workingPlan'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (workingPlan != null) {
      data['workingPlan'] = workingPlan!.toJson();
    }
    return data;
  }
}

class WorkingPlan {
  DayWorkData? sunday;
  DayWorkData? monday;
  DayWorkData? tuesday;
  DayWorkData? wednesday;
  DayWorkData? thursday;
  DayWorkData? friday;
  DayWorkData? saturday;

  WorkingPlan(
      {this.sunday,
      this.monday,
      this.tuesday,
      this.wednesday,
      this.thursday,
      this.friday,
      this.saturday});

  WorkingPlan.fromJson(Map<String, dynamic> json) {
    sunday =
        json['sunday'] != null ? DayWorkData.fromJson(json['sunday']) : null;
    monday =
        json['monday'] != null ? DayWorkData.fromJson(json['monday']) : null;
    tuesday =
        json['tuesday'] != null ? DayWorkData.fromJson(json['tuesday']) : null;
    wednesday = json['wednesday'] != null
        ? DayWorkData.fromJson(json['wednesday'])
        : null;
    thursday = json['thursday'] != null
        ? DayWorkData.fromJson(json['thursday'])
        : null;
    friday =
        json['friday'] != null ? DayWorkData.fromJson(json['friday']) : null;
    saturday = json['saturday'] != null
        ? DayWorkData.fromJson(json['saturday'])
        : null;
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

class DayWorkData {
  String? start;
  String? end;
  List<BreaksData>? breaks;

  DayWorkData({this.start, this.end, this.breaks});

  DayWorkData.fromJson(Map<String, dynamic> json) {
    start = json['start'];
    end = json['end'];
    if (json['breaks'] != null) {
      breaks = <BreaksData>[];
      json['breaks'].forEach((v) {
        breaks!.add(BreaksData.fromJson(v));
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

class BreaksData {
  String? start;
  String? end;

  BreaksData({this.start, this.end});

  BreaksData.fromJson(Map<String, dynamic> json) {
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
