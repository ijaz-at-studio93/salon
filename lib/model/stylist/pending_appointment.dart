class PendingAppointmentsListModel {
  int? statusCode;
  bool? success;
  List<AppointmentsList>? data;
  String? message;

  PendingAppointmentsListModel(
      {this.statusCode, this.success, this.data, this.message});

  PendingAppointmentsListModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    if (json['data'] != null) {
      data = <AppointmentsList>[];
      json['data'].forEach((v) {
        data!.add(AppointmentsList.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class AppointmentsList {
  String? appointmentId;
  String? startsAt;
  String? endsAt;
  String? status;
  String? salonId;
  String? finalizedAt;
  String? salonServiceId;
  String? salonArtistId;
  int? price;
  Service? service;

  AppointmentsList(
      {this.appointmentId,
      this.startsAt,
      this.endsAt,
      this.status,
      this.salonId,
      this.finalizedAt,
      this.salonServiceId,
      this.salonArtistId,
      this.price,
      this.service});

  AppointmentsList.fromJson(Map<String, dynamic> json) {
    appointmentId = json['appointmentId'];
    startsAt = json['startsAt'];
    endsAt = json['endsAt'];
    status = json['status'];
    salonId = json['salonId'];
    finalizedAt = json['finalizedAt'];
    salonServiceId = json['salonServiceId'];
    salonArtistId = json['salonArtistId'];
    price = json['price'];
    service =
        json['service'] != null ? Service.fromJson(json['service']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['appointmentId'] = appointmentId;
    data['startsAt'] = startsAt;
    data['endsAt'] = endsAt;
    data['status'] = status;
    data['salonId'] = salonId;
    data['finalizedAt'] = finalizedAt;
    data['salonServiceId'] = salonServiceId;
    data['salonArtistId'] = salonArtistId;
    data['price'] = price;
    if (service != null) {
      data['service'] = service!.toJson();
    }
    return data;
  }
}

class Service {
  String? id;
  String? name;
  int? price;

  Service({this.id, this.name, this.price});

  Service.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    return data;
  }
}
