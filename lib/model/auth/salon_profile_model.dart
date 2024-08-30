class GetSalonProfile {
  int? statusCode;
  bool? success;
  Data? data;
  String? message;

  GetSalonProfile({this.statusCode, this.success, this.data, this.message});

  GetSalonProfile.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? image;
  String? address;
  GeoLocationPoint? geoLocationPoint;
  String? description;
  String? homeService;
  String? mobile;
  String? countryCode;
  String? ownerMobile;
  String? ownerCountryCode;
  String? email;

  Data(
      {this.id,
        this.name,
        this.image,
        this.address,
        this.geoLocationPoint,
        this.description,
        this.homeService,
        this.mobile,
        this.countryCode,
        this.ownerMobile,
        this.ownerCountryCode,
        this.email});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    address = json['address'];
    geoLocationPoint = json['geoLocationPoint'] != null
        ? GeoLocationPoint.fromJson(json['geoLocationPoint'])
        : null;
    description = json['description'];
    homeService = json['homeService'];
    mobile = json['mobile'];
    countryCode = json['countryCode'];
    ownerMobile = json['ownerMobile'];
    ownerCountryCode = json['ownerCountryCode'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['address'] = address;
    if (geoLocationPoint != null) {
      data['geoLocationPoint'] = geoLocationPoint!.toJson();
    }
    data['description'] = description;
    data['homeService'] = homeService;
    data['mobile'] = mobile;
    data['countryCode'] = countryCode;
    data['ownerMobile'] = ownerMobile;
    data['ownerCountryCode'] = ownerCountryCode;
    data['email'] = email;
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