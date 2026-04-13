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
      // Note: The example response appears to be one OrderData object,
      // but the model's 'data' is a List, so we assume 'data' is a list in the main response.
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
  double? orderAmount;
  String? bookingOrderId;
  String? idx;
  String? orderStatus;
  String? createdAt;
  String? updatedAt;
  String? finalizedAt;
  String? paymentStatus;
  // New fields
  bool? isHomeService;
  int? serviceCount;
  List<ServiceItem>? items;

  Appointment? appointment;
  User? user;

  OrderData({
    this.orderAmount,
    this.bookingOrderId,
    this.idx,
    this.orderStatus,
    this.createdAt,
    this.updatedAt,
    this.finalizedAt,
    this.paymentStatus,
    this.isHomeService, // Added
    this.serviceCount, // Added
    this.items, // Added
    this.appointment,
    this.user});

  OrderData.fromJson(Map<String, dynamic> json) {
    orderAmount = double.parse(json['orderAmount'].toString());
    bookingOrderId = json['bookingOrderId'];
    idx = json['idx'];
    orderStatus = json['orderStatus'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    finalizedAt = json['finalizedAt'];
    paymentStatus = json['paymentStatus'];
    isHomeService = json['isHomeService']; // Parsed
    serviceCount = json['serviceCount']; // Parsed
    appointment = json['appointment'] != null
        ? Appointment.fromJson(json['appointment'])
        : null;
    // user and items may be at root level (old API) or inside appointment (new API)
    user = json['user'] != null ? User.fromJson(json['user']) : appointment?.user;
    if (json['items'] != null) {
      items = <ServiceItem>[];
      (json['items'] as List).forEach((v) {
        items!.add(ServiceItem.fromJson(v));
      });
    } else {
      items = appointment?.items;
    }
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
    data['isHomeService'] = isHomeService; // Added
    data['serviceCount'] = serviceCount; // Added
    if (appointment != null) {
      data['appointment'] = appointment!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    } // Added
    return data;
  }
}

class Appointment {
  String? id;
  String? startsAt;
  String? endsAt;
  Artist? artist;
  List<String>? stylistIds;
  List<String>? selectedSlots;
  List<StylistDetail>? stylistDetails;
  User? user;
  List<ServiceItem>? items;

  Appointment({
    this.id,
    this.startsAt,
    this.endsAt,
    this.artist,
    this.stylistIds,
    this.selectedSlots,
    this.stylistDetails,
    this.user,
    this.items,
  });

  Appointment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startsAt = json['startsAt'];
    endsAt = json['endsAt'];
    artist = json['artist'] != null ? Artist.fromJson(json['artist']) : null;
    stylistIds = (json['stylistIds'] as List?)?.map((e) => e.toString()).toList();
    selectedSlots = (json['selectedSlots'] as List?)?.map((e) => e.toString()).toList();
    if (json['stylistDetails'] != null) {
      stylistDetails = <StylistDetail>[];
      (json['stylistDetails'] as List).forEach((v) {
        stylistDetails!.add(StylistDetail.fromJson(v));
      });
    }
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    if (json['items'] != null) {
      items = <ServiceItem>[];
      (json['items'] as List).forEach((v) {
        items!.add(ServiceItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['startsAt'] = startsAt;
    data['endsAt'] = endsAt;
    if (artist != null) data['artist'] = artist!.toJson();
    if (stylistIds != null) data['stylistIds'] = stylistIds;
    if (selectedSlots != null) data['selectedSlots'] = selectedSlots;
    if (stylistDetails != null) data['stylistDetails'] = stylistDetails!.map((v) => v.toJson()).toList();
    if (user != null) data['user'] = user!.toJson();
    if (items != null) data['items'] = items!.map((v) => v.toJson()).toList();
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

class StylistDetail {
  String? id;
  String? name;
  String? profileImage;

  StylistDetail({this.id, this.name, this.profileImage});

  StylistDetail.fromJson(Map<String, dynamic> json) {
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

class User {
  String? id;
  String? name;
  String? profileImage;
  String? gender; // New field

  User({this.id, this.name, this.profileImage, this.gender}); // Added gender

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    profileImage = json['profileImage'];
    gender = json['gender']; // Parsed
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['profileImage'] = profileImage;
    data['gender'] = gender; // Added
    return data;
  }
}

// New class for items list in OrderData
class ServiceItem {
  String? id;
  String? salonServiceId;
  Service? service;

  ServiceItem({this.id, this.salonServiceId, this.service});

  ServiceItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    salonServiceId = json['salonServiceId'];
    service =
    json['service'] != null ? Service.fromJson(json['service']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['salonServiceId'] = salonServiceId;
    if (service != null) {
      data['service'] = service!.toJson();
    }
    return data;
  }
}

// New class for service details inside ServiceItem
class Service {
  double? price;
  String? id;
  String? name;

  Service({this.price, this.id, this.name});

  Service.fromJson(Map<String, dynamic> json) {
    // Note: price can be double or int, so safely parse to double
    price = double.parse(json['price'].toString());
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