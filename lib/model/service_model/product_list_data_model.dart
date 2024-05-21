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
  bool? isSelectedProduct;

  Product({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.salonId,
    this.serviceCategoryId,
    this.name,
    this.description,
    this.image,
    this.price,
    this.isSelectedProduct,
  });

  Product.fromJson(Map<String, dynamic> json) {
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
