class ArtiestDashboardModel {
  int? statusCode;
  bool? success;
  Data? data;
  String? message;

  ArtiestDashboardModel(
      {this.statusCode, this.success, this.data, this.message});

  ArtiestDashboardModel.fromJson(Map<String, dynamic> json) {
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
  RatingData? ratingData;
  ServiceCountData? serviceCountData;
  List<ServiceWithReviewCount>? serviceWithReviewCount;

  Data({this.ratingData, this.serviceCountData, this.serviceWithReviewCount});

  Data.fromJson(Map<String, dynamic> json) {
    ratingData = json['ratingData'] != null
        ? RatingData.fromJson(json['ratingData'])
        : null;
    serviceCountData = json['serviceCountData'] != null
        ? ServiceCountData.fromJson(json['serviceCountData'])
        : null;
    if (json['serviceWithReviewCount'] != null) {
      serviceWithReviewCount = <ServiceWithReviewCount>[];
      json['serviceWithReviewCount'].forEach((v) {
        serviceWithReviewCount!.add(ServiceWithReviewCount.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (ratingData != null) {
      data['ratingData'] = ratingData!.toJson();
    }
    if (serviceCountData != null) {
      data['serviceCountData'] = serviceCountData!.toJson();
    }
    if (serviceWithReviewCount != null) {
      data['serviceWithReviewCount'] =
          serviceWithReviewCount!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RatingData {
  double? rating;
  int? reviewCount;

  RatingData({this.rating, this.reviewCount});

  RatingData.fromJson(Map<String, dynamic> json) {
    rating = double.parse(json['rating'].toString());
    reviewCount = json['reviewCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rating'] = rating;
    data['reviewCount'] = reviewCount;

    return data;
  }
}

class ServiceCountData {
  int? totalServiceCount;
  List<ServiceBreakdown>? serviceBreakdown;

  ServiceCountData({this.totalServiceCount, this.serviceBreakdown});

  ServiceCountData.fromJson(Map<String, dynamic> json) {
    totalServiceCount = json['totalServiceCount'];
    if (json['serviceBreakdown'] != null) {
      serviceBreakdown = <ServiceBreakdown>[];
      json['serviceBreakdown'].forEach((v) {
        serviceBreakdown!.add(ServiceBreakdown.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalServiceCount'] = totalServiceCount;
    if (serviceBreakdown != null) {
      data['serviceBreakdown'] =
          serviceBreakdown!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServiceBreakdown {
  String? id;
  String? name;
  int? count;

  ServiceBreakdown({this.id, this.name, this.count});

  ServiceBreakdown.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['count'] = count;
    return data;
  }
}

class ServiceWithReviewCount {
  String? id;
  String? name;
  int? count;
  double? rating;
  int? reviewCount;

  ServiceWithReviewCount(
      {this.id, this.name, this.count, this.rating, this.reviewCount});

  ServiceWithReviewCount.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    count = json['count'];
    rating = double.parse(json['rating'].toString());
    reviewCount = json['reviewCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['count'] = count;
    data['rating'] = rating;
    data['reviewCount'] = reviewCount;
    return data;
  }
}
