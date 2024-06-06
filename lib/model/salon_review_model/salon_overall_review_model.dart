class OverallReviewListModel {
  int? statusCode;
  bool? success;
  Data? data;
  String? message;

  OverallReviewListModel(
      {this.statusCode, this.success, this.data, this.message});

  OverallReviewListModel.fromJson(Map<String, dynamic> json) {
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
  List<OverAllArtists>? artists;
  List<OverAllProducts>? products;
  List<OverAllServices>? services;

  Data({this.artists, this.products, this.services});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['artists'] != null) {
      artists = <OverAllArtists>[];
      json['artists'].forEach((v) {
        artists!.add(OverAllArtists.fromJson(v));
      });
    }
    if (json['products'] != null) {
      products = <OverAllProducts>[];
      json['products'].forEach((v) {
        products!.add(OverAllProducts.fromJson(v));
      });
    }
    if (json['services'] != null) {
      services = <OverAllServices>[];
      json['services'].forEach((v) {
        services!.add(OverAllServices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (artists != null) {
      data['artists'] = artists!.map((v) => v.toJson()).toList();
    }
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    if (services != null) {
      data['services'] = services!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OverAllArtists {
  Artist? artist;
  String? bookingOrderId;
  String? createdAt;
  String? id;
  double? rating;
  String? review;
  Salon? salon;
  String? salonArtistId;
  String? status;
  String? updatedAt;
  String? salonId;
  String? userId;

  OverAllArtists(
      {this.artist,
      this.bookingOrderId,
      this.createdAt,
      this.id,
      this.rating,
      this.review,
      this.salon,
      this.salonArtistId,
      this.status,
      this.updatedAt,
      this.salonId,
      this.userId});

  OverAllArtists.fromJson(Map<String, dynamic> json) {
    artist = json['artist'] != null ? Artist.fromJson(json['artist']) : null;
    bookingOrderId = json['bookingOrderId'];
    createdAt = json['createdAt'];
    id = json['id'];
    rating = double.parse(json['rating'].toString());
    review = json['review'];
    salon = json['salon'] != null ? Salon.fromJson(json['salon']) : null;
    salonArtistId = json['salonArtistId'];
    status = json['status'];
    updatedAt = json['updatedAt'];
    salonId = json['salonId'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (artist != null) {
      data['artist'] = artist!.toJson();
    }
    data['bookingOrderId'] = bookingOrderId;
    data['createdAt'] = createdAt;
    data['id'] = id;
    data['rating'] = rating;
    data['review'] = review;
    if (salon != null) {
      data['salon'] = salon!.toJson();
    }
    data['salonArtistId'] = salonArtistId;
    data['status'] = status;
    data['updatedAt'] = updatedAt;
    data['salonId'] = salonId;
    data['userId'] = userId;
    return data;
  }
}

class Artist {
  String? id;
  String? name;
  String? profileImage;

  Artist({this.id, this.name, this.profileImage});

  Artist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    profileImage = json['profileImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['profileImage'] = profileImage;
    return data;
  }
}

class Salon {
  String? id;
  String? name;
  String? image;

  Salon({this.id, this.name, this.image});

  Salon.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    return data;
  }
}

class OverAllProducts {
  String? bookingOrderId;
  String? createdAt;
  String? id;
  Salon? product;
  double? rating;
  String? review;
  Salon? salon;
  String? salonId;
  String? salonProductId;
  String? status;
  String? updatedAt;
  String? userId;

  OverAllProducts(
      {this.bookingOrderId,
      this.createdAt,
      this.id,
      this.product,
      this.rating,
      this.review,
      this.salon,
      this.salonId,
      this.salonProductId,
      this.status,
      this.updatedAt,
      this.userId});

  OverAllProducts.fromJson(Map<String, dynamic> json) {
    bookingOrderId = json['bookingOrderId'];
    createdAt = json['createdAt'];
    id = json['id'];
    product = json['product'] != null ? Salon.fromJson(json['product']) : null;
    rating = double.parse(json['rating'].toString());
    review = json['review'];
    salon = json['salon'] != null ? Salon.fromJson(json['salon']) : null;
    salonId = json['salonId'];
    salonProductId = json['salonProductId'];
    status = json['status'];
    updatedAt = json['updatedAt'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bookingOrderId'] = bookingOrderId;
    data['createdAt'] = createdAt;
    data['id'] = id;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    data['rating'] = rating;
    data['review'] = review;
    if (salon != null) {
      data['salon'] = salon!.toJson();
    }
    data['salonId'] = salonId;
    data['salonProductId'] = salonProductId;
    data['status'] = status;
    data['updatedAt'] = updatedAt;
    data['userId'] = userId;
    return data;
  }
}

class OverAllServices {
  String? bookingOrderId;
  String? createdAt;
  String? id;
  double? rating;
  String? review;
  Salon? salon;
  String? salonId;
  String? salonServiceId;
  Salon? service;
  String? status;
  String? updatedAt;
  String? userId;

  OverAllServices(
      {this.bookingOrderId,
      this.createdAt,
      this.id,
      this.rating,
      this.review,
      this.salon,
      this.salonId,
      this.salonServiceId,
      this.service,
      this.status,
      this.updatedAt,
      this.userId});

  OverAllServices.fromJson(Map<String, dynamic> json) {
    bookingOrderId = json['bookingOrderId'];
    createdAt = json['createdAt'];
    id = json['id'];
    rating = double.parse(json['rating'].toString());
    review = json['review'];
    salon = json['salon'] != null ? Salon.fromJson(json['salon']) : null;
    salonId = json['salonId'];
    salonServiceId = json['salonServiceId'];
    service = json['service'] != null ? Salon.fromJson(json['service']) : null;
    status = json['status'];
    updatedAt = json['updatedAt'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bookingOrderId'] = bookingOrderId;
    data['createdAt'] = createdAt;
    data['id'] = id;
    data['rating'] = rating;
    data['review'] = review;
    if (salon != null) {
      data['salon'] = salon!.toJson();
    }
    data['salonId'] = salonId;
    data['salonServiceId'] = salonServiceId;
    if (service != null) {
      data['service'] = service!.toJson();
    }
    data['status'] = status;
    data['updatedAt'] = updatedAt;
    data['userId'] = userId;
    return data;
  }
}
