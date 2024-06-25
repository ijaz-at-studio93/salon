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
        data!.add(new Data.fromJson(v));
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
  String? idx;
  String? orderStatus;
  String? createdAt;
  String? updatedAt;
  String? finalizedAt;
  String? paymentStatus;
  bool? isHomeService;
  Appointment? appointment;
  User? user;

  Data(
      {this.orderAmount,
      this.bookingOrderId,
      this.idx,
      this.orderStatus,
      this.createdAt,
      this.updatedAt,
      this.finalizedAt,
      this.paymentStatus,
      this.isHomeService,
      this.appointment,
      this.user});

  Data.fromJson(Map<String, dynamic> json) {
    orderAmount = json['orderAmount'];
    bookingOrderId = json['bookingOrderId'];
    idx = json['idx'];
    orderStatus = json['orderStatus'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    finalizedAt = json['finalizedAt'];
    paymentStatus = json['paymentStatus'];
    isHomeService = json['isHomeService'];
    appointment = json['appointment'] != null
        ? new Appointment.fromJson(json['appointment'])
        : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orderAmount'] = orderAmount;
    data['bookingOrderId'] = bookingOrderId;
    data['idx'] = idx;
    data['orderStatus'] = orderStatus;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['finalizedAt'] = finalizedAt;
    data['paymentStatus'] = paymentStatus;
    data['isHomeService'] = isHomeService;
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
  String? gender;

  User({this.id, this.name, this.profileImage, this.gender});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    profileImage = json['profileImage'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['profileImage'] = profileImage;
    data['gender'] = gender;
    return data;
  }
}
