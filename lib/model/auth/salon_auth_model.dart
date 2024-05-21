class SalonResponseModel {
  int? statusCode;
  bool? success;
  Data? data;
  String? message;

  SalonResponseModel({this.statusCode, this.success, this.data, this.message});

  SalonResponseModel.fromJson(Map<String, dynamic> json) {
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
  String? id;
  String? accessToken;
  String? accessTokenValidTill;
  String? refreshToken;
  String? refreshTokenValidTill;
  SalonData? salonData;

  Data(
      {this.id,
      this.accessToken,
      this.accessTokenValidTill,
      this.refreshToken,
      this.refreshTokenValidTill,
      this.salonData});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    accessToken = json['accessToken'];
    accessTokenValidTill = json['accessTokenValidTill'];
    refreshToken = json['refreshToken'];
    refreshTokenValidTill = json['refreshTokenValidTill'];
    salonData = json['salonData'] != null
        ? SalonData.fromJson(json['salonData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['accessToken'] = accessToken;
    data['accessTokenValidTill'] = accessTokenValidTill;
    data['refreshToken'] = refreshToken;
    data['refreshTokenValidTill'] = refreshTokenValidTill;
    if (salonData != null) {
      data['salonData'] = salonData!.toJson();
    }
    return data;
  }
}

class SalonData {
  String? id;
  String? name;
  String? description;
  String? email;
  String? countryCode;
  String? mobile;
  String? address;
  String? employeeSlab;
  String? serviceOfferSlab;
  String? ownerName;
  String? ownerMobile;
  String? ownerCountryCode;
  String? image;
  bool? isApproved;
  int? status;
  GeoLocationPoint? geoLocationPoint;
  WorkingPlan? workingPlan;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  SalonData(
      {this.id,
      this.name,
      this.description,
      this.email,
      this.countryCode,
      this.mobile,
      this.address,
      this.employeeSlab,
      this.serviceOfferSlab,
      this.ownerName,
      this.ownerMobile,
      this.ownerCountryCode,
      this.image,
      this.isApproved,
      this.status,
      this.geoLocationPoint,
      this.workingPlan,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  SalonData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    email = json['email'];
    countryCode = json['countryCode'];
    mobile = json['mobile'];
    address = json['address'];
    employeeSlab = json['employeeSlab'];
    serviceOfferSlab = json['serviceOfferSlab'];
    ownerName = json['ownerName'];
    ownerMobile = json['ownerMobile'];
    ownerCountryCode = json['ownerCountryCode'];
    image = json['image'];
    isApproved = json['isApproved'];
    status = json['status'];
    geoLocationPoint = json['geoLocationPoint'] != null
        ? GeoLocationPoint.fromJson(json['geoLocationPoint'])
        : null;
    workingPlan = json['workingPlan'] != null
        ? WorkingPlan.fromJson(json['workingPlan'])
        : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['email'] = email;
    data['countryCode'] = countryCode;
    data['mobile'] = mobile;
    data['address'] = address;
    data['employeeSlab'] = employeeSlab;
    data['serviceOfferSlab'] = serviceOfferSlab;
    data['ownerName'] = ownerName;
    data['ownerMobile'] = ownerMobile;
    data['ownerCountryCode'] = ownerCountryCode;
    data['image'] = image;
    data['isApproved'] = isApproved;
    data['status'] = status;
    if (geoLocationPoint != null) {
      data['geoLocationPoint'] = geoLocationPoint!.toJson();
    }
    if (workingPlan != null) {
      data['workingPlan'] = workingPlan!.toJson();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['deletedAt'] = deletedAt;
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

class WorkingPlan {
  Sunday? sunday;
  Sunday? monday;
  Sunday? tuesday;
  Sunday? wednesday;
  Sunday? thursday;
  Sunday? friday;
  Sunday? saturday;

  WorkingPlan(
      {this.sunday,
      this.monday,
      this.tuesday,
      this.wednesday,
      this.thursday,
      this.friday,
      this.saturday});

  WorkingPlan.fromJson(Map<String, dynamic> json) {
    sunday = json['sunday'] != null ? Sunday.fromJson(json['sunday']) : null;
    monday = json['monday'] != null ? Sunday.fromJson(json['monday']) : null;
    tuesday = json['tuesday'] != null ? Sunday.fromJson(json['tuesday']) : null;
    wednesday =
        json['wednesday'] != null ? Sunday.fromJson(json['wednesday']) : null;
    thursday =
        json['thursday'] != null ? Sunday.fromJson(json['thursday']) : null;
    friday = json['friday'] != null ? Sunday.fromJson(json['friday']) : null;
    saturday =
        json['saturday'] != null ? Sunday.fromJson(json['saturday']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (sunday != null) {
      data['sunday'] = sunday!.toJson();
    }
    if (monday != null) {
      data['monday'] = monday!.toJson();
    }
    if (tuesday != null) {
      data['tuesday'] = tuesday!.toJson();
    }
    if (wednesday != null) {
      data['wednesday'] = wednesday!.toJson();
    }
    if (thursday != null) {
      data['thursday'] = thursday!.toJson();
    }
    if (friday != null) {
      data['friday'] = friday!.toJson();
    }
    if (saturday != null) {
      data['saturday'] = saturday!.toJson();
    }
    return data;
  }
}

class Sunday {
  String? start;
  String? end;
  List<Breaks>? breaks;

  Sunday({this.start, this.end, this.breaks});

  Sunday.fromJson(Map<String, dynamic> json) {
    start = json['start'];
    end = json['end'];
    if (json['breaks'] != null) {
      breaks = <Breaks>[];
      json['breaks'].forEach((v) {
        breaks!.add(Breaks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start'] = start;
    data['end'] = end;
    if (breaks != null) {
      data['breaks'] = breaks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Breaks {
  String? start;
  String? end;

  Breaks({this.start, this.end});

  Breaks.fromJson(Map<String, dynamic> json) {
    start = json['start'];
    end = json['end'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start'] = start;
    data['end'] = end;
    return data;
  }
}
