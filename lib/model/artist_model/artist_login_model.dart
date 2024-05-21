class SalonArtistResponseModel {
  int? statusCode;
  bool? success;
  Data? data;
  String? message;

  SalonArtistResponseModel(
      {this.statusCode, this.success, this.data, this.message});

  SalonArtistResponseModel.fromJson(Map<String, dynamic> json) {
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
  SalonArtistData? salonArtistData;

  Data(
      {this.id,
      this.accessToken,
      this.accessTokenValidTill,
      this.refreshToken,
      this.refreshTokenValidTill,
      this.salonArtistData});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    accessToken = json['accessToken'];
    accessTokenValidTill = json['accessTokenValidTill'];
    refreshToken = json['refreshToken'];
    refreshTokenValidTill = json['refreshTokenValidTill'];
    salonArtistData = json['salonArtistData'] != null
        ? SalonArtistData.fromJson(json['salonArtistData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['accessToken'] = accessToken;
    data['accessTokenValidTill'] = accessTokenValidTill;
    data['refreshToken'] = refreshToken;
    data['refreshTokenValidTill'] = refreshTokenValidTill;
    if (salonArtistData != null) {
      data['salonArtistData'] = salonArtistData!.toJson();
    }
    return data;
  }
}

class SalonArtistData {
  String? id;
  String? name;
  String? email;
  String? dob;
  String? countryCode;
  String? mobile;
  String? profileImage;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? address;
  int? experience;
  String? gender;
  bool? homeService;
  String? panCard;
  String? whatsapp;
  String? salonId;
  WorkingPlan? workingPlan;

  SalonArtistData({
    this.id,
    this.name,
    this.email,
    this.dob,
    this.countryCode,
    this.mobile,
    this.profileImage,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.address,
    this.experience,
    this.gender,
    this.homeService,
    this.panCard,
    this.whatsapp,
    this.salonId,
    this.workingPlan,
  });

  SalonArtistData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    dob = json['dob'];
    countryCode = json['countryCode'];
    mobile = json['mobile'];
    profileImage = json['profileImage'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    address = json['address'];
    experience = json['experience'];
    gender = json['gender'];
    homeService = json['homeService'];
    panCard = json['panCard'];
    whatsapp = json['whatsapp'];
    salonId = json['salonId'];
    workingPlan = json['workingPlan'] != null
        ? WorkingPlan.fromJson(json['workingPlan'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['dob'] = dob;
    data['countryCode'] = countryCode;
    data['mobile'] = mobile;
    data['profileImage'] = profileImage;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['deletedAt'] = deletedAt;
    data['address'] = address;
    data['experience'] = experience;
    data['gender'] = gender;
    data['homeService'] = homeService;
    data['panCard'] = panCard;
    data['whatsapp'] = whatsapp;
    data['salonId'] = salonId;
    if (workingPlan != null) {
      data['workingPlan'] = workingPlan!.toJson();
    }

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
