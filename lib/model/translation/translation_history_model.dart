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
  int? orderAmount;
  String? bookingOrderId;
  String? idx;
  String? createdAt;
  String? orderStatus;
  User? user;

  TransactionData(
      {this.orderAmount,
        this.bookingOrderId,
        this.idx,
        this.createdAt,
        this.orderStatus,
        this.user});

  TransactionData.fromJson(Map<String, dynamic> json) {
    orderAmount = json['orderAmount'];
    bookingOrderId = json['bookingOrderId'];
    idx = json['idx'];
    createdAt = json['createdAt'];
    orderStatus = json['orderStatus'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
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
    return data;
  }
}

class User {
  String? id;
  String? name;

  User({this.id, this.name});

  User.fromJson(Map<String, dynamic> json) {
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