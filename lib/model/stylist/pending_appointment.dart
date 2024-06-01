class PendingAppointmentsListModel {
  int? statusCode;
  bool? success;
  List<Data>? data;
  String? message;

  PendingAppointmentsListModel(
      {this.statusCode, this.success, this.data, this.message});

  PendingAppointmentsListModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
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

class Data {
  int? orderAmount;
  String? bookingOrderId;
  String? orderStatus;
  String? createdAt;
  String? updatedAt;
  String? finalizedAt;
  String? paymentStatus;
  Appointment? appointment;
  User? user;

  Data(
      {this.orderAmount,
        this.bookingOrderId,
        this.orderStatus,
        this.createdAt,
        this.updatedAt,
        this.finalizedAt,
        this.paymentStatus,
        this.appointment,
        this.user});

  Data.fromJson(Map<String, dynamic> json) {
    orderAmount = json['orderAmount'];
    bookingOrderId = json['bookingOrderId'];
    orderStatus = json['orderStatus'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    finalizedAt = json['finalizedAt'];
    paymentStatus = json['paymentStatus'];
    appointment = json['appointment'] != null
        ? Appointment.fromJson(json['appointment'])
        : null;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orderAmount'] = orderAmount;
    data['bookingOrderId'] = bookingOrderId;
    data['orderStatus'] = orderStatus;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['finalizedAt'] = finalizedAt;
    data['paymentStatus'] = paymentStatus;
    if (appointment != null) {
      data['appointment'] = appointment!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class Appointment {
  String? id;
  String? startsAt;
  String? endsAt;

  Appointment({this.id, this.startsAt, this.endsAt});

  Appointment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startsAt = json['startsAt'];
    endsAt = json['endsAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['startsAt'] = startsAt;
    data['endsAt'] = endsAt;
    return data;
  }
}

class User {
  String? id;
  String? name;
  String? profileImage;

  User({this.id, this.name, this.profileImage});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    profileImage = json['profileImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['profileImage'] = profileImage;
    return data;
  }
}


/*class PendingAppointmentsListModel {
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
}*/
