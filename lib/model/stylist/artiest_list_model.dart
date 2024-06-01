class SalonArtistListModel {
  int? statusCode;
  bool? success;
  List<Data>? data;
  String? message;

  SalonArtistListModel(
      {this.statusCode, this.success, this.data, this.message});

  SalonArtistListModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
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

class Data {
  String? id;
  String? name;
  String? countryCode;
  String? profileImage;
  int? status;
  String? gender;
  bool? homeService;

  Data(
      {this.id,
      this.name,
      this.countryCode,
      this.profileImage,
      this.status,
      this.gender,
      this.homeService});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    countryCode = json['countryCode'];
    profileImage = json['profileImage'];
    status = json['status'];
    gender = json['gender'];
    homeService = json['homeService'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['countryCode'] = countryCode;
    data['profileImage'] = profileImage;
    data['status'] = status;
    data['gender'] = gender;
    data['homeService'] = homeService;
    return data;
  }
}
