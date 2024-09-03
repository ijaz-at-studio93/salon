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
  double? orderAmount;
  String? bookingId;
  String? idx;
  String? finalizedAt;
  String? appointmentId;
  String? orderStatus;
  bool? allowPortfolioUpload;
  bool? isHomeService;
  TaxDetails? taxDetails;
  Address? address;
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
      this.isHomeService,
      this.taxDetails,
      this.address,
      this.user,
      this.salon,
      this.appointment,
      this.items});

  Data.fromJson(Map<String, dynamic> json) {
    orderAmount = double.parse(json['orderAmount'].toString());
    bookingId = json['bookingId'];
    idx = json['idx'];
    finalizedAt = json['finalizedAt'];
    appointmentId = json['appointmentId'];
    orderStatus = json['orderStatus'];
    allowPortfolioUpload = json['allowPortfolioUpload'];
    isHomeService = json['isHomeService'];
    taxDetails = json['taxDetails'] != null
        ? TaxDetails.fromJson(json['taxDetails'])
        : null;
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
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
    data['isHomeService'] = isHomeService;
    if (address != null) {
      data['address'] = address!.toJson();
    }
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

class Address {
  String? id;
  String? bookingOrderId;
  String? address;
  GeoLocationPoint? geoLocationPoint;
  String? addressLabel;
  String? addressType;
  String? description;
  String? house;

  Address(
      {this.id,
      this.bookingOrderId,
      this.address,
      this.geoLocationPoint,
      this.addressLabel,
      this.addressType,
      this.description,
      this.house});

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingOrderId = json['bookingOrderId'];
    address = json['address'];
    geoLocationPoint = json['geoLocationPoint'] != null
        ? GeoLocationPoint.fromJson(json['geoLocationPoint'])
        : null;
    addressLabel = json['addressLabel'];
    addressType = json['addressType'];
    description = json['description'];
    house = json['house'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['bookingOrderId'] = bookingOrderId;
    data['address'] = address;
    if (geoLocationPoint != null) {
      data['geoLocationPoint'] = geoLocationPoint!.toJson();
    }
    data['addressLabel'] = addressLabel;
    data['addressType'] = addressType;
    data['description'] = description;
    data['house'] = house;
    return data;
  }
}

class GeoLocationPoint {
  Crs? crs;
  String? type;
  List<double>? coordinates;

  GeoLocationPoint({this.crs, this.type, this.coordinates});

  GeoLocationPoint.fromJson(Map<String, dynamic> json) {
    crs = json['crs'] != null ? Crs.fromJson(json['crs']) : null;
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (crs != null) {
      data['crs'] = crs!.toJson();
    }
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
  }
}

class TaxDetails {
  List<AllTaxDetails>? allTaxDetails;
  double? totalTaxAmount;

  TaxDetails({this.allTaxDetails, this.totalTaxAmount});

  TaxDetails.fromJson(Map<String, dynamic> json) {
    if (json['allTaxDetails'] != null) {
      allTaxDetails = <AllTaxDetails>[];
      json['allTaxDetails'].forEach((v) {
        allTaxDetails!.add(AllTaxDetails.fromJson(v));
      });
    }
    totalTaxAmount = double.parse(json['totalTaxAmount'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (allTaxDetails != null) {
      data['allTaxDetails'] = allTaxDetails!.map((v) => v.toJson()).toList();
    }
    data['totalTaxAmount'] = totalTaxAmount;
    return data;
  }
}

class AllTaxDetails {
  String? code;
  String? name;
  double? amount;
  int? percentage;

  AllTaxDetails({this.code, this.name, this.amount, this.percentage});

  AllTaxDetails.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    amount = json['amount'];
    percentage = json['percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['name'] = name;
    data['amount'] = amount;
    data['percentage'] = percentage;
    return data;
  }
}

class Crs {
  String? type;
  Properties? properties;

  Crs({this.type, this.properties});

  Crs.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    properties = json['properties'] != null
        ? Properties.fromJson(json['properties'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    if (properties != null) {
      data['properties'] = properties!.toJson();
    }
    return data;
  }
}

class Properties {
  String? name;

  Properties({this.name});

  Properties.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
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
    data['product'] = product;
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

  Product({this.price, this.id, this.name});

  Product.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
