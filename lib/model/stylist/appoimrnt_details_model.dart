class AppointmentsDetailsModel {
  int? statusCode;
  bool? success;
  Data? data;
  String? message;

  AppointmentsDetailsModel(
      {this.statusCode, this.success, this.data, this.message});

  AppointmentsDetailsModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
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

class Data {
  String? appointmentId;
  String? startsAt;
  String? endsAt;
  String? status;
  String? salonId;
  String? finalizedAt;
  String? salonServiceId;
  Service? service;
  User? user;

  Data(
      {this.appointmentId,
        this.startsAt,
        this.endsAt,
        this.status,
        this.salonId,
        this.finalizedAt,
        this.salonServiceId,
        this.service,
        this.user});

  Data.fromJson(Map<String, dynamic> json) {
    appointmentId = json['appointmentId'];
    startsAt = json['startsAt'];
    endsAt = json['endsAt'];
    status = json['status'];
    salonId = json['salonId'];
    finalizedAt = json['finalizedAt'];
    salonServiceId = json['salonServiceId'];
    service =
    json['service'] != null ? Service.fromJson(json['service']) : null;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
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
    if (service != null) {
      data['service'] = service!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class Service {
  String? id;
  String? name;
  int? price;
  int? duration;
  String? image;
  List<Categories>? categories;
  List<Products>? products;

  Service(
      {this.id,
        this.name,
        this.price,
        this.duration,
        this.image,
        this.categories,
        this.products});

  Service.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    duration = json['duration'];
    image = json['image'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['duration'] = duration;
    data['image'] = image;
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  String? name;

  Categories({this.name});

  Categories.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }
}

class Products {
  String? name;
  int? price;
  String? image;

  Products({this.name, this.price, this.image});

  Products.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['price'] = price;
    data['image'] = image;
    return data;
  }
}

class User {
  String? id;
  String? name;
  String? profileImage;
  String? mobile;
  String? countryCode;

  User({this.id, this.name, this.profileImage, this.mobile, this.countryCode});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    profileImage = json['profileImage'];
    mobile = json['mobile'];
    countryCode = json['countryCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['profileImage'] = profileImage;
    data['mobile'] = mobile;
    data['countryCode'] = countryCode;
    return data;
  }
}