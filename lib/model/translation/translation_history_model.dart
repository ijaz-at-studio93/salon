import '../salon_review_model/salon_review_by_artiest_model.dart';

class TransactionsHistoryModel {
  int? statusCode;
  bool? success;
  List<TransactionData>? data;
  String? message;

  TransactionsHistoryModel(
      {this.statusCode, this.success, this.data, this.message});

  TransactionsHistoryModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    if (json['data'] != null) {
      data = <TransactionData>[];
      json['data'].forEach((v) {
        data!.add(TransactionData.fromJson(v));
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

class TransactionData {
  double? orderAmount;
  String? bookingOrderId;
  String? idx;
  String? createdAt;
  String? orderStatus;
  User? user;
  Appointment? appointment;
  List<TransactionItem>? items;



  TransactionData(
      {this.orderAmount,
        this.bookingOrderId,
        this.idx,
        this.createdAt,
        this.orderStatus,
        this.user,
        this.appointment,
        this.items});

  TransactionData.fromJson(Map<String, dynamic> json) {
    orderAmount = double.parse(json['orderAmount'].toString());
    bookingOrderId = json['bookingOrderId'];
    idx = json['idx'];
    createdAt = json['createdAt'];
    orderStatus = json['orderStatus'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    appointment = json['appointment'] != null
        ? Appointment.fromJson(json['appointment'])
        : null;
    if (json['items'] != null) {
      items = <TransactionItem>[];
      json['items'].forEach((v) {
        items!.add(TransactionItem.fromJson(v));
      });
    }


  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orderAmount'] = orderAmount;
    data['bookingOrderId'] = bookingOrderId;
    data['idx'] = idx;
    data['createdAt'] = createdAt;
    data['orderStatus'] = orderStatus;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (appointment != null) {
      data['appointment'] = appointment!.toJson();
    }
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }


    return data;
  }
}

class Appointment {
  String? id;
  String? salonArtistId;
  Artist? artist;

  Appointment({this.id, this.salonArtistId, this.artist});

  Appointment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    salonArtistId = json['salonArtistId'];
    artist =
    json['artist'] != null ? Artist.fromJson(json['artist']) : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['salonArtistId'] = salonArtistId;
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
class TransactionItem {
  double? price;
  String? id;
  String? salonServiceId;
  Service? service;

  TransactionItem({this.price, this.id, this.salonServiceId, this.service});

  TransactionItem.fromJson(Map<String, dynamic> json) {
    price = double.parse(json['price'].toString());
    id = json['id'];
    salonServiceId = json['salonServiceId'];
    service = json['service'] != null
        ? Service.fromJson(json['service'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    data['id'] = id;
    data['salonServiceId'] = salonServiceId;
    if (service != null) {
      data['service'] = service!.toJson();
    }
    return data;
  }
}

class Service {
  String? id;
  String? name;

  Service({this.id, this.name});

  Service.fromJson(Map<String, dynamic> json) {
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