class SalonTransactionsHistoryModel {
  int? statusCode;
  bool? success;
  List<SalonTransactionData>? data;
  String? message;

  SalonTransactionsHistoryModel(
      {this.statusCode, this.success, this.data, this.message});

  SalonTransactionsHistoryModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    if (json['data'] != null) {
      data = <SalonTransactionData>[];
      json['data'].forEach((v) {
        data!.add(SalonTransactionData.fromJson(v));
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

class SalonTransactionData {
  String? type; // 'DEBIT' or 'CREDIT'
  double? amount;
  String? bookingOrderId;
  String? idx;
  String? createdAt;
  String? orderStatus;
  String? paymentProof;
  SalonTransactionUser? user;
  SalonTransactionAppointment? appointment;
  List<SalonTransactionItem>? items;

  SalonTransactionData({
    this.type,
    this.amount,
    this.bookingOrderId,
    this.idx,
    this.createdAt,
    this.orderStatus,
    this.paymentProof,
    this.user,
    this.appointment,
    this.items,
  });

  bool get isCredit => type == 'CREDIT';
  bool get isDebit => type == 'DEBIT';

  SalonTransactionData.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    amount = json['amount'] != null
        ? double.parse(json['amount'].toString())
        : null;
    bookingOrderId = json['bookingOrderId'];
    idx = json['idx'];
    createdAt = json['createdAt'];
    orderStatus = json['orderStatus'];
    paymentProof = json['paymentProof'];
    user = json['user'] != null
        ? SalonTransactionUser.fromJson(json['user'])
        : null;
    appointment = json['appointment'] != null
        ? SalonTransactionAppointment.fromJson(json['appointment'])
        : null;
    if (json['items'] != null) {
      items = <SalonTransactionItem>[];
      json['items'].forEach((v) {
        items!.add(SalonTransactionItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['amount'] = amount;
    data['bookingOrderId'] = bookingOrderId;
    data['idx'] = idx;
    data['createdAt'] = createdAt;
    data['orderStatus'] = orderStatus;
    data['paymentProof'] = paymentProof;
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

class SalonTransactionUser {
  String? id;
  String? name;

  SalonTransactionUser({this.id, this.name});

  SalonTransactionUser.fromJson(Map<String, dynamic> json) {
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

class SalonTransactionAppointment {
  String? id;
  String? salonArtistId;
  SalonTransactionArtist? artist;

  SalonTransactionAppointment({this.id, this.salonArtistId, this.artist});

  SalonTransactionAppointment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    salonArtistId = json['salonArtistId'];
    artist = json['artist'] != null
        ? SalonTransactionArtist.fromJson(json['artist'])
        : null;
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

class SalonTransactionArtist {
  String? id;
  String? name;

  SalonTransactionArtist({this.id, this.name});

  SalonTransactionArtist.fromJson(Map<String, dynamic> json) {
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

class SalonTransactionItem {
  double? price;
  String? id;
  String? salonServiceId;
  SalonTransactionService? service;

  SalonTransactionItem({this.price, this.id, this.salonServiceId, this.service});

  SalonTransactionItem.fromJson(Map<String, dynamic> json) {
    price = json['price'] != null
        ? double.parse(json['price'].toString())
        : null;
    id = json['id'];
    salonServiceId = json['salonServiceId'];
    service = json['service'] != null
        ? SalonTransactionService.fromJson(json['service'])
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

class SalonTransactionService {
  String? id;
  String? name;

  SalonTransactionService({this.id, this.name});

  SalonTransactionService.fromJson(Map<String, dynamic> json) {
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