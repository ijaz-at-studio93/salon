class SalonDashboardModel {
  int? statusCode;
  bool? success;
  Data? data;
  String? message;

  SalonDashboardModel({this.statusCode, this.success, this.data, this.message});

  SalonDashboardModel.fromJson(Map<String, dynamic> json) {
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

// class Data {
//   int? totalEarnings;
//   RatingReview? ratingReview;
//   DistributedRevenue? distributedRevenue;
//   List<DistributedArtistAnalytics>? distributedArtistAnalytics;
//
//   Data(
//       {this.totalEarnings,
//       this.ratingReview,
//       this.distributedRevenue,
//       this.distributedArtistAnalytics});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     totalEarnings = json['totalEarnings'];
//     ratingReview = json['ratingReview'] != null
//         ? RatingReview.fromJson(json['ratingReview'])
//         : null;
//     distributedRevenue = json['distributedRevenue'] != null
//         ? DistributedRevenue.fromJson(json['distributedRevenue'])
//         : null;
//     if (json['distributedArtistAnalytics'] != null) {
//       distributedArtistAnalytics = <DistributedArtistAnalytics>[];
//       json['distributedArtistAnalytics'].forEach((v) {
//         distributedArtistAnalytics!.add(DistributedArtistAnalytics.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['totalEarnings'] = totalEarnings;
//     if (ratingReview != null) {
//       data['ratingReview'] = ratingReview!.toJson();
//     }
//     if (distributedRevenue != null) {
//       data['distributedRevenue'] = distributedRevenue!.toJson();
//     }
//     if (distributedArtistAnalytics != null) {
//       data['distributedArtistAnalytics'] =
//           distributedArtistAnalytics!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

class Data {
  int? totalEarnings;
  double? walletBalance; // ✅ NEW
  bool? isUpfront; // ✅ NEW
  bool? isRequestRecharge; // ✅ NEW
  bool? isGSTRegistered;
  int? rechargeCount;
  double? defaultRechange;
  RatingReview? ratingReview;
  DistributedRevenue? distributedRevenue;
  List<DistributedArtistAnalytics>? distributedArtistAnalytics;

  Data({
    this.totalEarnings,
    this.walletBalance,
    this.isUpfront,
    this.isRequestRecharge,
    this.ratingReview,
    this.distributedRevenue,
    this.distributedArtistAnalytics,
  });

  Data.fromJson(Map<String, dynamic> json) {
    totalEarnings = json['totalEarnings'];
    // ✅ NEW
    walletBalance = json['walletBalance'] != null
        ? double.parse(json['walletBalance'].toString())
        : 0;
    isUpfront = json['isUpfront'] ?? false;
    isRequestRecharge = json['isRequestRecharge'] ?? false;
    isGSTRegistered = json['isGSTRegistered'] ?? false;
    rechargeCount = json['rechargeCount'] ?? 0;
    defaultRechange = json['defaultRechange'] != null
        ? double.parse(json['defaultRechange'].toString())
        : 0;
    ratingReview = json['ratingReview'] != null
        ? RatingReview.fromJson(json['ratingReview'])
        : null;
    distributedRevenue = json['distributedRevenue'] != null
        ? DistributedRevenue.fromJson(json['distributedRevenue'])
        : null;
    if (json['distributedArtistAnalytics'] != null) {
      distributedArtistAnalytics = <DistributedArtistAnalytics>[];
      json['distributedArtistAnalytics'].forEach((v) {
        distributedArtistAnalytics!
            .add(DistributedArtistAnalytics.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalEarnings'] = totalEarnings;
    // ✅ NEW
    data['walletBalance'] = walletBalance;
    data['isUpfront'] = isUpfront;
    data['isRequestRecharge'] = isRequestRecharge;
    data['isGSTRegistered'] = isGSTRegistered;
    data['rechargeCount'] = rechargeCount;
    data['defaultRechange'] = defaultRechange;
    if (ratingReview != null) {
      data['ratingReview'] = ratingReview!.toJson();
    }
    if (distributedRevenue != null) {
      data['distributedRevenue'] = distributedRevenue!.toJson();
    }
    if (distributedArtistAnalytics != null) {
      data['distributedArtistAnalytics'] =
          distributedArtistAnalytics!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RatingReview {
  double? rating;
  int? reviewCount;

  RatingReview({this.rating, this.reviewCount});

  RatingReview.fromJson(Map<String, dynamic> json) {
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

class DistributedRevenue {
  int? bookingCount;
  int? bookingRevenue;

  DistributedRevenue({this.bookingCount, this.bookingRevenue});

  DistributedRevenue.fromJson(Map<String, dynamic> json) {
    bookingCount = json['bookingCount'];
    bookingRevenue = json['bookingRevenue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bookingCount'] = bookingCount;
    data['bookingRevenue'] = bookingRevenue;
    return data;
  }
}

class DistributedArtistAnalytics {
  String? id;
  String? name;
  double? rating;
  int? reviewCount;
  int? serviceDone;

  DistributedArtistAnalytics(
      {this.id, this.name, this.rating, this.reviewCount, this.serviceDone});

  DistributedArtistAnalytics.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    rating = double.parse(json['rating'].toString());
    reviewCount = json['reviewCount'];
    serviceDone = json['serviceDone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['rating'] = rating;
    data['reviewCount'] = reviewCount;
    data['serviceDone'] = serviceDone;
    return data;
  }
}
