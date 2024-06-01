class PendingAppointmentsListModel {
  int? statusCode;
  bool? success;
  List<OrderData>? data;
  String? message;

  PendingAppointmentsListModel(
      {this.statusCode, this.success, this.data, this.message});

  PendingAppointmentsListModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    if (json['data'] != null) {
      data = <OrderData>[];
      json['data'].forEach((v) {
        data!.add(OrderData.fromJson(v));
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

class OrderData {
  int? orderAmount;
  String? bookingOrderId;
  String? idx;
  String? orderStatus;
  String? createdAt;
  String? updatedAt;
  String? finalizedAt;
  String? paymentStatus;
  Appointment? appointment;
  User? user;

  OrderData(
      {this.orderAmount,
      this.bookingOrderId,
      this.idx,
      this.orderStatus,
      this.createdAt,
      this.updatedAt,
      this.finalizedAt,
      this.paymentStatus,
      this.appointment,
      this.user});

  OrderData.fromJson(Map<String, dynamic> json) {
    orderAmount = json['orderAmount'];
    bookingOrderId = json['bookingOrderId'];
    idx = json['idx'];
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
    data['idx'] = idx;
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
  Artist? artist;

  Appointment({this.id, this.startsAt, this.endsAt, this.artist});

  Appointment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startsAt = json['startsAt'];
    endsAt = json['endsAt'];
    artist = json['artist'] != null ? Artist.fromJson(json['artist']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['startsAt'] = startsAt;
    data['endsAt'] = endsAt;
    if (artist != null) {
      data['artist'] = artist!.toJson();
    }
    return data;
  }
}

class Artist {
  String? id;
  String? name;

  Artist({this.id, this.name});

  Artist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
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
