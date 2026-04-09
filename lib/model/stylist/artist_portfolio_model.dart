class ArtistPortfolioModel {
  int? statusCode;
  bool? success;
  Data? data;
  String? message;

  ArtistPortfolioModel(
      {this.statusCode, this.success, this.data, this.message});

  ArtistPortfolioModel.fromJson(Map<String, dynamic> json) {
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
  double? rating;
  String? id;
  String? name;
  String? email;
  String? dob;
  String? countryCode;
  String? mobile;
  String? profileImage;
  String? createdAt;
  int? experience;
  String? gender;
  bool? homeService;
  int? reviewCount;
  Salon? salon;
  List<Services>? services;
  List<Portfolio>? portfolio;

  Data(
      {this.rating,
      this.id,
      this.name,
      this.email,
      this.dob,
      this.countryCode,
      this.mobile,
      this.profileImage,
      this.createdAt,
      this.experience,
      this.gender,
      this.homeService,
      this.reviewCount,
      this.salon,
      this.services,
      this.portfolio});

  Data.fromJson(Map<String, dynamic> json) {
    rating = double.parse(json['rating'].toString());
    id = json['id'];
    name = json['name'];
    email = json['email'];
    dob = json['dob'];
    countryCode = json['countryCode'];
    mobile = json['mobile'];
    profileImage = json['profileImage'];
    createdAt = json['createdAt'];
    experience = json['experience'];
    gender = json['gender'];
    homeService = json['homeService'];
    reviewCount = json['reviewCount'];
    salon = json['salon'] != null ? Salon.fromJson(json['salon']) : null;
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(Services.fromJson(v));
      });
    }
    if (json['portfolio'] != null) {
      portfolio = <Portfolio>[];
      json['portfolio'].forEach((v) {
        portfolio!.add(Portfolio.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rating'] = rating;
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['dob'] = dob;
    data['countryCode'] = countryCode;
    data['mobile'] = mobile;
    data['profileImage'] = profileImage;
    data['createdAt'] = createdAt;
    data['experience'] = experience;
    data['gender'] = gender;
    data['homeService'] = homeService;
    data['reviewCount'] = reviewCount;
    if (salon != null) {
      data['salon'] = salon!.toJson();
    }
    if (services != null) {
      data['services'] = services!.map((v) => v.toJson()).toList();
    }
    if (portfolio != null) {
      data['portfolio'] = portfolio!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Salon {
  String? id;
  String? image;
  String? name;
  String? address;

  Salon({this.id, this.image, this.name, this.address});

  Salon.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    name = json['name'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['name'] = name;
    data['address'] = address;
    return data;
  }
}

class Services {
  int? price;
  double? rating;
  String? id;
  String? name;
  String? description;
  String? image;
  int? duration;
  String? gender;
  bool? homeService;
  int? reviewCount;
  List<Categories>? categories;

  Services(
      {this.price,
      this.rating,
      this.id,
      this.name,
      this.description,
      this.image,
      this.duration,
      this.gender,
      this.homeService,
      this.reviewCount,
      this.categories});

  Services.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    rating = double.parse(json['rating'].toString());
    id = json['id'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
    duration = json['duration'];
    gender = json['gender'];
    homeService = json['homeService'];
    reviewCount = json['reviewCount'];
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
    data['rating'] = rating;
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['image'] = image;
    data['duration'] = duration;
    data['gender'] = gender;
    data['homeService'] = homeService;
    data['reviewCount'] = reviewCount;
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  String? id;
  String? name;
  String? serviceableGender;

  Categories({this.id, this.name, this.serviceableGender});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    serviceableGender = json['serviceableGender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['serviceableGender'] = serviceableGender;
    return data;
  }
}

class Portfolio {
  String? id;
  String? image;
  String? video;
  String? bookingOrderId;
  bool? isVideo;

  Portfolio(
      {this.id, this.image, this.video, this.bookingOrderId, this.isVideo});

  Portfolio.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    video = json['video'];
    bookingOrderId = json['bookingOrderId'];
    isVideo = json['isVideo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['video'] = video;
    data['bookingOrderId'] = bookingOrderId;
    data['isVideo'] = isVideo;
    return data;
  }
}
