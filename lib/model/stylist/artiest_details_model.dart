class ArtiestDetailsModel {
  int? statusCode;
  bool? success;
  Data? data;
  String? message;

  ArtiestDetailsModel({this.statusCode, this.success, this.data, this.message});

  ArtiestDetailsModel.fromJson(Map<String, dynamic> json) {
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
  String? email;
  String? dob;
  String? countryCode;
  String? mobile;
  String? profileImage;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? address;
  int? experience;
  String? gender;
  bool? homeService;
  String? panCard;
  String? whatsapp;
  String? salonId;
  String? sId;
  String? profession;
  List<String>? languagesKnown;
  List<String>? portfolioImages;
  List<Services>? services;

  Data(
      {this.id,
      this.name,
      this.email,
      this.dob,
      this.countryCode,
      this.mobile,
      this.profileImage,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.address,
      this.experience,
      this.gender,
      this.homeService,
      this.panCard,
      this.whatsapp,
      this.salonId,
      this.sId,
      this.profession,
      this.languagesKnown,
      this.portfolioImages,
      this.services});

  Data.fromJson(Map<String, dynamic> json) {
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
    address = json['address'];
    experience = json['experience'];
    gender = json['gender'];
    homeService = json['homeService'];
    panCard = json['panCard'];
    whatsapp = json['whatsapp'];
    salonId = json['salonId'];
    sId = json['sId'];
    profession = json['profession'];
    languagesKnown = (json['languagesKnown'] as List?)
        ?.map((e) => e.toString())
        .toList();
    portfolioImages = (json['portfolioImages'] as List?)
        ?.map((e) => e.toString())
        .toList();
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(Services.fromJson(v));
      });
    }
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
    data['address'] = address;
    data['experience'] = experience;
    data['gender'] = gender;
    data['homeService'] = homeService;
    data['panCard'] = panCard;
    data['whatsapp'] = whatsapp;
    data['salonId'] = salonId;
    data['sId'] = sId;
    data['profession'] = profession;
    data['languagesKnown'] = languagesKnown;
    data['portfolioImages'] = portfolioImages;
    if (services != null) {
      data['services'] = services!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Services {
  int? price;
  String? id;
  String? name;
  String? description;
  String? image;
  Details? details;

  Services(
      {this.price,
      this.id,
      this.name,
      this.description,
      this.image,
      this.details});

  Services.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    id = json['id'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
    details =
        json['details'] != null ? Details.fromJson(json['details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['image'] = image;
    if (details != null) {
      data['details'] = details!.toJson();
    }
    return data;
  }
}

class Details {
  String? serviceableGender;

  Details({this.serviceableGender});

  Details.fromJson(Map<String, dynamic> json) {
    serviceableGender = json['serviceableGender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['serviceableGender'] = serviceableGender;
    return data;
  }
}
