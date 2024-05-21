class SalonServiceListModel {
  int? statusCode;
  bool? success;
  List<SalonService>? data;
  String? message;

  SalonServiceListModel(
      {this.statusCode, this.success, this.data, this.message});

  SalonServiceListModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    if (json['data'] != null) {
      data = <SalonService>[];
      json['data'].forEach((v) {
        data!.add(SalonService.fromJson(v));
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

class SalonService {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? description;
  int? duration;
  String? gender;
  String? image;
  String? name;
  int? price;
  String? salonId;
  String? status;
  bool? homeService;
  bool? isSelectService;
  int? selectGender;
  List<Categories>? categories;

  SalonService({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.description,
    this.duration,
    this.gender,
    this.image,
    this.name,
    this.price,
    this.salonId,
    this.status,
    this.homeService,
    this.categories,
    this.isSelectService,
    this.selectGender = 1,
  });

  SalonService.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    description = json['description'];
    duration = json['duration'];
    gender = json['gender'];
    image = json['image'];
    name = json['name'];
    price = json['price'];
    salonId = json['salonId'];
    status = json['status'];
    homeService = json['homeService'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
    selectGender = 1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['deletedAt'] = deletedAt;
    data['description'] = description;
    data['duration'] = duration;
    data['gender'] = gender;
    data['image'] = image;
    data['name'] = name;
    data['price'] = price;
    data['salonId'] = salonId;
    data['status'] = status;
    data['homeService'] = homeService;
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  String? id;
  String? name;
  String? description;
  String? serviceableGender;
  String? imageMale;
  String? imageFemale;

  Categories(
      {this.id,
      this.name,
      this.description,
      this.serviceableGender,
      this.imageMale,
      this.imageFemale});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    serviceableGender = json['serviceableGender'];
    imageMale = json['imageMale'];
    imageFemale = json['imageFemale'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['serviceableGender'] = serviceableGender;
    data['imageMale'] = imageMale;
    data['imageFemale'] = imageFemale;
    return data;
  }
}
