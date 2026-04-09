class SalonReviewByArtiestModel {
  int? statusCode;
  bool? success;
  List<SalonArtiestReviewOverall>? data;
  String? message;

  SalonReviewByArtiestModel(
      {this.statusCode, this.success, this.data, this.message});

  SalonReviewByArtiestModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    if (json['data'] != null) {
      data = <SalonArtiestReviewOverall>[];
      json['data'].forEach((v) {
        data!.add(SalonArtiestReviewOverall.fromJson(v));
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

class SalonArtiestReviewOverall {
  String? name;
  String? profileImage;
  double? rating;
  List<Reviews>? reviews;

  SalonArtiestReviewOverall({this.name, this.profileImage, this.rating, this.reviews});

  SalonArtiestReviewOverall.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    profileImage = json['profileImage'];
    rating = double.parse(json['rating'].toString());
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(Reviews.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['profileImage'] = profileImage;
    data['rating'] = rating;
    if (reviews != null) {
      data['reviews'] = reviews!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Reviews {
  String? bookingOrderId;
  String? createdAt;
  String? id;
  String? review;
  String? salonArtistId;
  String? salonId;
  String? status;
  String? updatedAt;
  String? userId;
  User? user;

  Reviews(
      {this.bookingOrderId,
      this.createdAt,
      this.id,
      this.review,
      this.salonArtistId,
      this.salonId,
      this.status,
      this.updatedAt,
      this.userId,
      this.user});

  Reviews.fromJson(Map<String, dynamic> json) {
    bookingOrderId = json['bookingOrderId'];
    createdAt = json['createdAt'];
    id = json['id'];
    review = json['review'];
    salonArtistId = json['salonArtistId'];
    salonId = json['salonId'];
    status = json['status'];
    updatedAt = json['updatedAt'];
    userId = json['userId'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bookingOrderId'] = bookingOrderId;
    data['createdAt'] = createdAt;
    data['id'] = id;
    data['review'] = review;
    data['salonArtistId'] = salonArtistId;
    data['salonId'] = salonId;
    data['status'] = status;
    data['updatedAt'] = updatedAt;
    data['userId'] = userId;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  String? id;
  String? name;
  String? profileImage;

  User({this.id, this.name, this.profileImage});

  User.fromJson(Map<String, dynamic> json) {
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
