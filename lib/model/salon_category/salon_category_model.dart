class SalonCategoryListModel {
  int? statusCode;
  bool? success;
  List<Data>? data;
  String? message;

  SalonCategoryListModel(
      {this.statusCode, this.success, this.data, this.message});

  SalonCategoryListModel.fromJson(Map<String, dynamic> json) {
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
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? name;
  String? description;
  String? serviceableGender;
  String? imageFemale;
  String? imageMale;
  String? createdSalonId;

  Data(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.name,
      this.description,
      this.serviceableGender,
      this.imageFemale,
      this.imageMale,
      this.createdSalonId});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    name = json['name'];
    description = json['description'];
    serviceableGender = json['serviceableGender'];
    imageFemale = json['imageFemale'];
    imageMale = json['imageMale'];
    createdSalonId = json['createdSalonId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['deletedAt'] = deletedAt;
    data['name'] = name;
    data['description'] = description;
    data['serviceableGender'] = serviceableGender;
    data['imageFemale'] = imageFemale;
    data['imageMale'] = imageMale;
    data['createdSalonId'] = createdSalonId;
    return data;
  }
}
