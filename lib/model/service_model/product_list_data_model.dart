class ProductListModel {
  int? statusCode;
  bool? success;
  List<Product>? productList;
  String? message;

  ProductListModel(
      {this.statusCode, this.success, this.productList, this.message});

  ProductListModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    if (json['data'] != null) {
      productList = <Product>[];
      json['data'].forEach((v) {
        productList!.add(Product.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['success'] = success;
    if (productList != null) {
      data['data'] = productList!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class Product {
  int? price;
  double? rating;
  String? id;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? salonId;
  String? serviceCategoryId;
  String? salonCategory;
  String? name;
  String? description;
  String? image;
  int? reviewCount;
  bool? isSelectedProduct;

  Product(
      {this.price,
      this.rating,
      this.id,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.salonId,
      this.serviceCategoryId,
        this.salonCategory,
      this.name,
      this.description,
      this.image,
      this.reviewCount,
      this.isSelectedProduct});

  Product.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    rating = double.parse(json['rating'].toString());
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    salonId = json['salonId'];
    serviceCategoryId = json['serviceCategoryId'];
    salonCategory = json['salonCategory'];
    name = json['name'];
    description = json['description'];
    image = json['image'];
    reviewCount = json['reviewCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    data['rating'] = rating;
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['deletedAt'] = deletedAt;
    data['salonId'] = salonId;
    data['serviceCategoryId'] = serviceCategoryId;
    data['salonCategory'] = salonCategory;
    data['name'] = name;
    data['description'] = description;
    data['image'] = image;
    data['reviewCount'] = reviewCount;
    return data;
  }
}

