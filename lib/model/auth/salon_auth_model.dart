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
    id = json['id']?.toString();
    accessToken = json['accessToken'];
    accessTokenValidTill = json['accessTokenValidTill'];
    refreshToken = json['refreshToken'];
    refreshTokenValidTill = json['refreshTokenValidTill'];
    salonData = json['salonData'] != null
        ? SalonData.fromJson(json['salonData'])
        : null;
  }

  Data copyWith({
    String? id,
    String? accessToken,
    String? accessTokenValidTill,
    String? refreshToken,
    String? refreshTokenValidTill,
    SalonData? salonData,
  }) {
    return Data(
      id: id ?? this.id,
      accessToken: accessToken ?? this.accessToken,
      accessTokenValidTill: accessTokenValidTill ?? this.accessTokenValidTill,
      refreshToken: refreshToken ?? this.refreshToken,
      refreshTokenValidTill:
          refreshTokenValidTill ?? this.refreshTokenValidTill,
      salonData: salonData ?? this.salonData,
    );
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
  double? rating;
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
  String? createdAt;
  String? updatedAt;
  int? reviewCount;
  String? homeService;

  SalonData(
      {this.rating,
      this.id,
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
      this.createdAt,
      this.updatedAt,
      this.reviewCount,
      this.homeService});

  SalonData.fromJson(Map<String, dynamic> json) {
    rating = double.parse(
        json['rating'] == null ? "0.0" : json['rating'].toString());
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
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    reviewCount = json['reviewCount'];
    homeService = json['homeService'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rating'] = rating;
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
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['reviewCount'] = reviewCount;
    data['homeService'] = homeService;
    return data;
  }
}

class GeoLocationPoint {
  String? type;
  List<double>? coordinates;

  GeoLocationPoint({this.type, this.coordinates});

  GeoLocationPoint.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['coordinates'] = coordinates;
    return data;
  }
}
