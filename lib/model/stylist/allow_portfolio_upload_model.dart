class AllowPortfolioUploadModel {
  int? statusCode;
  bool? success;
  Data? data;
  String? message;

  AllowPortfolioUploadModel(
      {this.statusCode, this.success, this.data, this.message});

  AllowPortfolioUploadModel.fromJson(Map<String, dynamic> json) {
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
  int? orderAmount;
  String? bookingId;
  String? idx;
  String? finalizedAt;
  String? appointmentId;
  String? orderStatus;
  bool? allowPortfolioUpload;
  User? user;
  Salon? salon;
  Appointment? appointment;
  List<Items>? items;

  Data(
      {this.orderAmount,
        this.bookingId,
        this.idx,
        this.finalizedAt,
        this.appointmentId,
        this.orderStatus,
        this.allowPortfolioUpload,
        this.user,
        this.salon,
        this.appointment,
        this.items});

  Data.fromJson(Map<String, dynamic> json) {
    orderAmount = json['orderAmount'];
    bookingId = json['bookingId'];
    idx = json['idx'];
    finalizedAt = json['finalizedAt'];
    appointmentId = json['appointmentId'];
    orderStatus = json['orderStatus'];
    allowPortfolioUpload = json['allowPortfolioUpload'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    salon = json['salon'] != null ? Salon.fromJson(json['salon']) : null;
    appointment = json['appointment'] != null
        ? Appointment.fromJson(json['appointment'])
        : null;
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orderAmount'] = orderAmount;
    data['bookingId'] = bookingId;
    data['idx'] = idx;
    data['finalizedAt'] = finalizedAt;
    data['appointmentId'] = appointmentId;
    data['orderStatus'] = orderStatus;
    data['allowPortfolioUpload'] = allowPortfolioUpload;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (salon != null) {
      data['salon'] = salon!.toJson();
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

class Salon {
  String? id;
  String? name;
  String? image;

  Salon({this.id, this.name, this.image});

  Salon.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    return data;
  }
}

class Appointment {
  String? startsAt;
  String? endsAt;

  Appointment({this.startsAt, this.endsAt});

  Appointment.fromJson(Map<String, dynamic> json) {
    startsAt = json['startsAt'];
    endsAt = json['endsAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['startsAt'] = startsAt;
    data['endsAt'] = endsAt;
    return data;
  }
}

class Items {
  String? id;
  bool? isService;
  Service? service;
  Product? product;

  Items({this.id, this.isService, this.service, this.product});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isService = json['isService'];
    service =
    json['service'] != null ? Service.fromJson(json['service']) : null;
    product =
    json['product'] != null ? Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['isService'] = isService;
    if (service != null) {
      data['service'] = service!.toJson();
    }
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }
}

class Service {
  int? price;
  String? id;
  String? name;
  int? duration;
  String? image;
  List<Categories>? categories;

  Service(
      {this.price,
        this.id,
        this.name,
        this.duration,
        this.image,
        this.categories});

  Service.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    id = json['id'];
    name = json['name'];
    duration = json['duration'];
    image = json['image'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    data['id'] = id;
    data['name'] = name;
    data['duration'] = duration;
    data['image'] = image;
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
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

class Product {
  int? price;
  String? id;
  String? name;
  String? image;
  String? description;
  Categories? serviceCategory;

  Product(
      {this.price,
        this.id,
        this.name,
        this.image,
        this.description,
        this.serviceCategory});

  Product.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    id = json['id'];
    name = json['name'];
    image = json['image'];
    description = json['description'];
    serviceCategory = json['serviceCategory'] != null
        ? Categories.fromJson(json['serviceCategory'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['description'] = description;
    if (serviceCategory != null) {
      data['serviceCategory'] = serviceCategory!.toJson();
    }
    return data;
  }
}