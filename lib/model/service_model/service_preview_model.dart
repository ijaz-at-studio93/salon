class ServicePreviewModel {
  int? statusCode;
  bool? success;
  Data? data;
  String? message;

  ServicePreviewModel({this.statusCode, this.success, this.data, this.message});

  ServicePreviewModel.fromJson(Map<String, dynamic> json) {
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
  List<Categories>? categories;
  List<Products>? products;

  Data(
      {this.id,
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
        this.products});

  Data.fromJson(Map<String, dynamic> json) {
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
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
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
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
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

class Products {
  String? id;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? salonId;
  String? serviceCategoryId;
  String? name;
  String? description;
  String? image;
  int? price;

  Products(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.salonId,
        this.serviceCategoryId,
        this.name,
        this.description,
        this.image,
        this.price});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    salonId = json['salonId'];
    serviceCategoryId = json['serviceCategoryId'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['deletedAt'] = deletedAt;
    data['salonId'] = salonId;
    data['serviceCategoryId'] = serviceCategoryId;
    data['name'] = name;
    data['description'] = description;
    data['image'] = image;
    data['price'] = price;
    return data;
  }
}