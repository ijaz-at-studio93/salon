class AllSalonStaffModel {
  int? statusCode;
  bool? success;
  List<StaffData>? data;
  String? message;

  AllSalonStaffModel({this.statusCode, this.success, this.data, this.message});

  AllSalonStaffModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    if (json['data'] != null) {
      data = <StaffData>[];
      json['data'].forEach((v) {
        data!.add(StaffData.fromJson(v));
      });
    }
    message = json['message'];
  }
}

class StaffData {
  String? id;
  String? name;
  String? sId;
  String? phone;
  String? profileImage;
  String? salonId;

  StaffData(
      {this.id,
      this.name,
      this.sId,
      this.phone,
      this.profileImage,
      this.salonId});

  StaffData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    sId = json['sId'];
    phone = json['phone'];
    profileImage = json['profileImage'];
    salonId = json['salonId'];
  }
}
